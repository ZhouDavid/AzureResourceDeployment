$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $env = $regionSpec.Environment
        for($i=0;$i -lt 10;$i++){
            $rg = "spkl-ehn-ro-$env-$regionAlias-$i"
            $ehNamespace = $rg
            Write-Host $ehNamespace
            Remove-AzEventHubNamespace -ResourceGroupName $rg -Name $ehNamespace
        }
    }
    catch{
        Write-Debug $SubId
    }
}