$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $location = $regionSpec.RegionShortName
        $env = $regionSpec.Environment
        $rg = "spkl-adx-$env-$regionAlias-0"
        $cluster = "spkladx$env$regionAlias"+"x0"
        $dataConnection = "conn_racktelemetry"
        # $dataConnection = "conn_racktelemetry-sel"
        
        $ehNamespaceName = "spkl-ehn-adx-rt-$env-$regionAlias-0"
        $ehRg = $ehNamespaceName
        $ehName = "eh-racktelemetry"
        # $ehName = "eh-racktelemetry-sel"
        $ehResourceId = "/subscriptions/$SubId/resourceGroups/$ehRg/providers/Microsoft.EventHub/namespaces/$ehNamespaceName/eventhubs/$ehName"

        $storRg = "spkl-adl-adx-$env-$regionAlias-0"
        $storName = "spkladladx$env$regionAlias"+"x0"
        $storResourceId = "/subscriptions/$SubId/resourceGroups/$storRg/providers/Microsoft.Storage/storageAccounts/$storName"

        $table = "RackTelemetry"
        # $table = "RackTelemetrySystemEventLog"
        .\NewKustoDataConnection.ps1 -ResourceGroup $rg -Cluster $cluster -DataConnection $dataConnection -Location $location -EventHubResourceId $ehResourceId -StorageAccountResourceId $storResourceId -Table $table
    }
    catch{
        Write-Debug $SubId
    }
}