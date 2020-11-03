$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    $region = $regionSpec.RegionAlias
    $env = $regionSpec.Environment
    # if($region -ne "brs"){
    #     continue
    # }
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $eventSubName = "adx-racktelemetry"
        # $eventSubName = "adx-racktelemetrysel"
        $sourceRg = "spkl-adl-adx-$env-$region-0"
        $storName = "spkladladx$env$region"+"x0"
        $destEhNamespaceName = "spkl-ehn-adx-rt-$env-$region-0"
        $destEhName = "eh-racktelemetry"
        # $destEhName = "eh-racktelemetrysel"
        $destRg = $destEhNamespaceName

        $prefix = "/blobServices/default/containers/default/blobs/delta_eg/tables/RackTelemetry/__event=AllEvents" # for racktelemety-all
        # $prefix = "/blobServices/default/containers/default/blobs/delta_eg/tables/RackTelemetry/__event=SystemEventLog" # for racktelemetry-selraw
        $suffix = ".snappy.parquet"

        .\NewStorageToEventhubEventGridSub.ps1 -EventSubscriptionName $eventSubName -SubscriptionId $SubId -SourceResourceGroup $sourceRg -SourceStorageAccountName $storName -DestEhNamespaceName $destEhNamespaceName -DestEhName $destEhName -DestResourceGroup $destRg -PrefixFilter $prefix -SuffixFilter $suffix
    }
    catch{
        Write-Debug $SubId
    }
}