# .\DeployDatabricksJob -JobDefFilePath "D:\Microsoft Work\repo\CSI-HHS\src\SparkApplications\Jobs\blobstreaming\prod\blobstreaming-selraw-prod.json" -Env "prod" -Region "gbl"
param(
    [Parameter(Mandatory = $True)]
    [string]
    $ADBHost,

    [Parameter(Mandatory = $True)]
    [string]
    $AdbToken,

    [Parameter(Mandatory = $True)]
    [string]
    $JobDefFilePath,

    [Parameter(Mandatory = $True)]
    [string]
    $CodePath,

    [Parameter(Mandatory = $True)]
    [string]
    $NotebookPathRoot,

    [Parameter(Mandatory = $True)]
    [string]
    $Env,

    [Parameter(Mandatory = $True)]
    [string]
    $Region,

    [Parameter(Mandatory = $True)]
    [string]
    $ClusterId
)
function DeployJob([string] $AdbToken, [string] $JobDefFilePath, [string] $CodePath, [string] $NotebookPathRoot, [string]$Env, [string]$Region, [string] $ClusterId) {
    # upload/override notebooks to target/prod/dev databricks
    $env:DATABRICKS_HOST = $ADBHost
    $env:DATABRICKS_TOKEN = $AdbToken
    databricks workspace import_dir $CodePath $NotebookPathRoot -o
    Write-Host "notebooks imported`n"

    $jsonRoot = Get-Content -Raw -Path $JobDefFilePath | ConvertFrom-Json

    $jsonRoot.name = $jsonRoot.name.replace("__ENV__", $Env).replace("__REGION__", $Region)
    # Write-Host $jsonRoot.notebook_task.notebook_path
    $jsonRoot.existing_cluster_id = $jsonRoot.existing_cluster_id.replace("__EXISTING_CLUSTER_ID__",$ClusterId)
    $jsonRoot.notebook_task.notebook_path = $jsonRoot.notebook_task.notebook_path.replace("__ROOT__",$NotebookPathRoot)
    $jsonRoot.notebook_task.base_parameters.env = $jsonRoot.notebook_task.base_parameters.env.replace("__ENV__", $Env).replace("__REGION__", $Region)
    
    $tempPath = "$JobDefFilePath.temp.$Env.$Region.json"
    $jsonRoot | ConvertTo-Json -Depth 20 | Set-Content $tempPath
    $jobName = $jsonRoot.name
    $jobId = ""
    databricks jobs list | Select-String $jobName | foreach { $_.toString().Split(" ")[0] } | Tee-Object -variable jobId
    if ($jobId -ne "") {
        Write-Host "find job_id: $jobId, resetting $jobName job definition..."

        databricks jobs reset --job-id $jobId --json-file $tempPath
    }
    else {
        Write-Host "no existing job id, creating new job:$jobName..."
        # databricks jobs create --json-file $tempPath
        databricks jobs create --json-file $tempPath | ConvertFrom-Json | foreach { $_.job_id } | Tee-Object -variable jobId
    }
    $runId = ""
    Write-Host "jobName:$jobName"
    $res = databricks runs list | Select-String $jobName | Select-String "RUNNING"
    Write-Host $res
    databricks runs list | Select-String $jobName | Select-String "RUNNING" | foreach { $_.toString().Split(' ')[0] } | Tee-Object -variable runId
    if ($runId -ne "") {
        # stop the run and re-run the job
        databricks runs cancel --run-id $runId
        Write-Host "Stopping runId:$runId"
        Start-Sleep -s 30
    }
    databricks jobs run-now --job-id $jobId
    Remove-Item -Path $tempPath
}

# deploy databricks jobs for those notebooks
DeployJob -AdbToken $AdbToken -JobDefFilePath $JobDefFilePath -CodePath $CodePath -NotebookPathRoot $NotebookPathRoot -Env $Env -Region $Region -ClusterId $ClusterId
