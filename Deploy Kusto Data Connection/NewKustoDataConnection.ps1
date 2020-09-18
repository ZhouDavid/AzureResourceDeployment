# Install-Module -Name Az.Kusto -RequiredVersion 0.1.4
# .\NewKustoDataConnection.ps1 -ResourceGroup "spkl-adx-prod-eus-0" -Cluster spkladxprodeusx0 -Database defaultdb -DataConnection testConnection -Location eastus -EventHubResourceId /subscriptions/6a22d9a3-34e4-48c4-8a76-fe88bf5aab9e/resourceGroups/spkl-ehn-adx-rt-prod-eus-0/providers/Microsoft.EventHub/namespaces/spkl-ehn-adx-rt-prod-eus-0/eventhubs/eh-racktelemetry -StorageAccountResourceId /subscriptions/6a22d9a3-34e4-48c4-8a76-fe88bf5aab9e/resourceGroups/spkl-adl-adx-prod-eus-0/providers/Microsoft.Storage/storageAccounts/spkladladxprodeusx0 -Table RackTelemetry
param(
    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroup,

    [Parameter(Mandatory=$True)]
    [string]
    $Cluster,

    [Parameter(Mandatory=$False)]
    [string]
    $Database = "defaultdb",

    [Parameter(Mandatory=$True)]
    [string]
    $DataConnection,

    [Parameter(Mandatory=$True)]
    [string]
    $Location,

    [Parameter(Mandatory=$False)]
    [string]
    $Kind = "EventGrid",

    [Parameter(Mandatory=$True)]
    [string]
    $EventHubResourceId,

    [Parameter(Mandatory=$True)]
    [string]
    $StorageAccountResourceId,

    [Parameter(Mandatory=$False)]
    [string]
    $DataFormat="PARQUET",

    [Parameter(Mandatory=$False)]
    [string]
    $ConsumerGroup = "cg-0",

    [Parameter(Mandatory=$True)]
    [string]
    $Table
)

New-AzKustoDataConnection -ResourceGroupName $ResourceGroup -ClusterName $Cluster -DatabaseName $Database -DataConnectionName $DataConnection -Location $Location -Kind $Kind -EventHubResourceId $EventHubResourceId -StorageAccountResourceId $StorageAccountResourceId -DataFormat $DataFormat -ConsumerGroup $ConsumerGroup -TableName $Table
