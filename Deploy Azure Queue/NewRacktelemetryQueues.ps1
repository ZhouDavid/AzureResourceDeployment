$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        $storageAccountName = "spkladlrt$env$regionAlias"+"x0"
        $rg = "spkl-adl-rt-$env-$regionAlias-0"
        $queueName = "racktelemetry"
        .\NewStorageQueue.ps1 -ResourceGroup $rg -StorageAccountName $storageAccountName -QueueName $queueName
    }
    catch{
        Write-Debug $SubId
    }
}