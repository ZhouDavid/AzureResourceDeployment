# read region spec
$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        $regionAlias = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        # push adl key to adb keyvault
        $keyVaultName = "spkl-kv-adb-$env-$regionAlias-0"
        $storRg = "spkl-adl-rt-$env-$regionAlias-0"
        $stor = "spkladlrt$env$regionAlias"+"x0"
        Write-Host $stor
        .\PushKeyToKeyVault.ps1 -KeyVaultName $keyVaultName -StorageResourceGroup $storRg -StorageAccountName $stor

        # push adladx key to adb keyvault
        # $storRg = "spkl-adl-adx-$env-$regionAlias-0"
        # $stor = "spkladladx$env$regionAlias"+"x0"
        # .\PushKeyToKeyVault.ps1 -KeyVaultName $keyVaultName -StorageResourceGroup $storRg -StorageAccountName $stor
    }
    catch{
        Write-Error $SubId
    }
}