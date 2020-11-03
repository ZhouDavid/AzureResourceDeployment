param(
    [Parameter(Mandatory=$True)]
    [string]
    $DeployingRegion = "all"
)

$jsonObj = Get-Content -Raw -Path '.\SparkJobRegionSpec.json' | ConvertFrom-Json
# $whiteList = "uks","frc","krc"
foreach($regionSpec in $jsonObj.RegionSpecs){
    $adbToken = $regionSpec.databricks_token
    $existingClusterId = $regionSpec.existing_cluster_id
    $env = $regionSpec.env
    $regionAlias = $regionSpec.region_alias
    $region = $regionSpec.region
    $adbHost = "https://$region.azuredatabricks.net"

    if($env -eq "int"){
        continue
    }
    if($DeployingRegion -ne "all"){
        if($DeployingRegion -ne $regionAlias){
            continue
        }
    }
    # if($whiteList -contains $regionAlias){
    #     continue
    # }

    Write-Host "Deploying $env-$regionAlias-1"
    .\DeployDatabricksJob.ps1 -AdbHost $adbHost -AdbToken $adbToken -JobDefFilePath "RackTelemetryJobTemplate.json" -CodePath "..\..\CSI-HHS\src\Streaming\SparkStreaming\Code\streaming\" -NotebookPathRoot "/Users/zhouj@ame.gbl/streaming" -Env $env -Region $regionAlias -ClusterId $existingClusterId
}