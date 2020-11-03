$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $region = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        $eventSubName = "racktelemetry-adl"
        $rg = "spkl-adl-rt-$env-$region-0"
        $storName = "spkladlrt$env$region"+"x0"
        $destQueueName = $eventSubName
        $prefix = "/blobServices/default/containers/racktelemetry/blobs/racktelemetry/"
        $suffix = ".snappy.parquet"

        .\NewStorageToQueueEventGridSub.ps1 -EventSubscriptionName $eventSubName -SubscriptionId $SubId -SourceResourceGroup $rg -SourceStorageAccountName $storName -DestStorageQueueName $destQueueName -PrefixFilter $prefix -SuffixFilter $suffix
    }
    catch{
        Write-Debug $SubId
    }
}