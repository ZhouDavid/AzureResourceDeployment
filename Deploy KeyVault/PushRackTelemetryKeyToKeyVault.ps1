# read region spec
$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        $regionAlias = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        $keyVaultName = "spkl-kv-adb-$env-$regionAlias-1"
        # push adl key to adb keyvault
        $storRg = "spkl-adl-rt-$env-$regionAlias-0"
        $stor = "spkladlrt$env$regionAlias"+"x0"
        Write-Host $stor
        .\PushKeyToKeyVault.ps1 -KeyVaultName $keyVaultName -StorageResourceGroup $storRg -StorageAccountName $stor

        # push adladx key to adb keyvault
        $storRg = "spkl-adl-adx-$env-$regionAlias-0"
        $stor = "spkladladx$env$regionAlias"+"x0"
        Write-Host $stor
        .\PushKeyToKeyVault.ps1 -KeyVaultName $keyVaultName -StorageResourceGroup $storRg -StorageAccountName $stor
        
        # push global adl key to adb keyvault
        # .\PushKeyToKeyVault.ps1 -KeyVaultName $keyVaultName -StorageResourceGroup "spkl-adl-prod-gbl-0" -StorageAccountName "spkladlprodgblx0"
    }
    catch{
        Write-Error $SubId
    }
}