param(
    [Parameter(Mandatory=$True)]
    [string]
    $Token,

    [Parameter(Mandatory=$True)]
    [string]
    $LocalDir,

    [Parameter(Mandatory=$True)]
    [string]
    $UploadDir
)
$env:DATABRICKS_TOKEN=$Token
databricks workspace import_dir -o $LocalDir $UploadDir