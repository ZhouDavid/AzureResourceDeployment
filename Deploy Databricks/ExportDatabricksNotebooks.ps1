# .\ExportDatabricksNotebooks.ps1 -NotebookPath "/Users/zhouj@ame.gbl/blobstreaming/databricks_unittest"

param(
    [Parameter(Mandatory = $True)]
    [string]
    $NotebookPath,

    [Parameter(Mandatory = $False)]
    [string]
    $ExportPath = ".",

    [Parameter(Mandatory = $True)]
    [string]
    $DatabricksToken 
)

# setup access
$env:DATABRICKS_TOKEN = $DatabricksToken
databricks workspace export_dir $NotebookPath -o $ExportPath