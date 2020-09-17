param(
    [Parameter(Mandatory=$True)]
    [string]
    $Token
)
$env:DATABRICKS_TOKEN = $Token
databricks workspace import_dir "D:\\Microsoft Work\\repo\\CSI-HHS\\src\\Streaming\\SparkStreaming\\Code\\streaming" /pkg -o