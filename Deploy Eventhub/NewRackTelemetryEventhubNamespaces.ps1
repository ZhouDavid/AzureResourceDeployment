$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $location = $regionSpec.RegionShortName
        $env = $regionSpec.Environment
        $rg = "spkl-ehn-adx-rt-$env-$regionAlias-0"
        $ehNamespace = $rg
        $ehName = "eh-racktelemetry-sel"
        $cg = "cg-0"
        .\NewEventhub.ps1 -ResourceGroup $rg -EhNamespace $ehNamespace -Location $location -EhName $ehName -ConsumerGroupName $cg
    }
    catch{
        Write-Debug $SubId
    }
}