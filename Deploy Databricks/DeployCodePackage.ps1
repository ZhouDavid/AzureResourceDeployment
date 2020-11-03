param(
    [Parameter(Mandatory=$True)]
    [string]
    $DBHostRegion,

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
$env:DATABRICKS_HOST="https://$DBHostRegion.azuredatabricks.net"
$env:DATABRICKS_TOKEN=$Token
databricks workspace import_dir -o $LocalDir $UploadDir