# read region spec
$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        $storageAccountName = "spkladladx$env$regionAlias" + "x0"
        # $storageAccountName = "spklsasf$env$regionAlias"+"x0"
        $rg = "spkl-adl-adx-$env-$regionAlias-0"
        # $rg = "spkl-sa-sf-$env-$regionAlias-0"
        $containerName = "racktelemetry"
        # $containerName = "racktelemetry-checkpoint-0"
        .\NewContainer.ps1 -ResourceGroup $rg -StorageAccountName $storageAccountName -ContainerName $containerName 
        # .\RemoveContainer.ps1 -ResourceGroup $rg -StorageAccountName $storageAccountName -ContainerName $containerName 
    }
    catch{
        Write-Debug $SubId
    }
}