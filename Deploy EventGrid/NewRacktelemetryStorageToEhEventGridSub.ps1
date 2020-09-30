$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $region = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        $eventSubName = "adx-racktelemetry"
        $sourceRg = "spkl-adl-adx-$env-$region-0"
        $storName = "spkladladx$env$region"+"x0"
        $destEhNamespaceName = "spkl-ehn-adx-rt-$env-$region-0"
        $destEhName = "eh-racktelemetry"
        # $destEhName = "eh-racktelemetry-sel"
        $destRg = $destEhNamespaceName

        $prefix = "/blobServices/default/containers/default/blobs/delta_eg/tables/RackTelemetry" # for racktelemety-all
        # $prefix = "/blobServices/default/containers/racktelemetry/blobs/racktelemetry/table/SystemEventLog" # for racktelemetry-selraw
        $suffix = ".snappy.parquet"

        .\NewStorageToEventhubEventGridSub.ps1 -EventSubscriptionName $eventSubName -SubscriptionId $SubId -SourceResourceGroup $sourceRg -SourceStorageAccountName $storName -DestEhNamespaceName $destEhNamespaceName -DestEhName $destEhName -DestResourceGroup $destRg -PrefixFilter $prefix -SuffixFilter $suffix
    }
    catch{
        Write-Debug $SubId
    }
}