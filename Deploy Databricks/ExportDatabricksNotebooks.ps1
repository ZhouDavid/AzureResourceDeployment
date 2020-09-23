# .\ExportDatabricksNotebooks.ps1 -NotebookPath "/Users/zhouj@ame.gbl/blobstreaming/databricks_unittest"

param(
    [Parameter(Mandatory = $True)]
    [string]
    $NotebookPath,

    [Parameter(Mandatory = $False)]
    [string]
    $ExportPath = ".",

    [Parameter(Mandatory = $False)]
    [string]
    $DatabricksToken = "dapi31f8232db201869429b64a8615b49c86" 
)

# setup access
$env:DATABRICKS_TOKEN = $DatabricksToken
databricks workspace export_dir $NotebookPath -o $ExportPath