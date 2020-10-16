$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
# $whiteList = "eus","weu","wus2","cusc","eusc"
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
        # $dataConnection = "conn_racktelemetry"
        $dataConnection = "conn_racktelemetrysel"
        
        # if(-not ($whiteList -contains $regionAlias)){
        #     Write-Host $regionAlias
        #     continue
        # }
        # if($env -eq "dev"){
        #     continue
        # }
        # if($env -eq "int"){
        #     continue
        # }

        $ehNamespaceName = "spkl-ehn-adx-rt-$env-$regionAlias-0"
        $ehRg = $ehNamespaceName
        # $ehName = "eh-racktelemetry"
        $ehName = "eh-racktelemetrysel"
        $ehResourceId = "/subscriptions/$SubId/resourceGroups/$ehRg/providers/Microsoft.EventHub/namespaces/$ehNamespaceName/eventhubs/$ehName"

        $storRg = "spkl-adl-adx-$env-$regionAlias-0"
        $storName = "spkladladx$env$regionAlias"+"x0"
        $storResourceId = "/subscriptions/$SubId/resourceGroups/$storRg/providers/Microsoft.Storage/storageAccounts/$storName"

        # $table = "RackTelemetry"
        $table = "RackTelemetrySystemEventLog"
        .\NewKustoDataConnection.ps1 -ResourceGroup $rg -Cluster $cluster -Database "defaultdb" -DataConnection $dataConnection -Location $location -EventHubResourceId $ehResourceId -ConsumerGroup "cg-0" -StorageAccountResourceId $storResourceId -Table $table
        Write-Host ".\NewKustoDataConnection.ps1 -ResourceGroup $rg -Cluster $cluster -Database "defaultdb" -DataConnection $dataConnection -Location $location -EventHubResourceId $ehResourceId -ConsumerGroup cg-0 -StorageAccountResourceId $storResourceId -Table $table"
    }
    catch{
        Write-Debug $SubId
    }
}