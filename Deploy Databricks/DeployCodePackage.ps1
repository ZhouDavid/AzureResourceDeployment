# Set $env:DATABRICKS_TOKEN
param(
    [Parameter(Mandatory=$False)]
    [string]
    $Token = ""
)
if("" -ne $Token){
    $env:DATABRICKS_TOKEN = $Token
}
databricks workspace import_dir "D:\\Microsoft Work\\repo\\CSI-HHS\\src\\Streaming\\SparkStreaming\\Code\\streaming" /streaming -o