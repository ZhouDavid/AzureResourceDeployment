$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
$throughputUnits = Import-Csv -Path 'raw-scale.csv'
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        $regionAlias = $regionSpec.RegionAlias
        $location = $regionSpec.RegionShortName
        $env = $regionSpec.Environment
        if ($env -eq "dev"){
            continue
        }
        if ($env -eq "int"){
            continue
        }
        Write-Host $env $regionAlias
        for($i=0;$i -lt 15;$i++){
            $rg = "spkl-ehn-raw-$env-$regionAlias-$i"
            $ehNamespace = $rg
            Write-Host $rg.ToUpper()
            $tu = [math]::Min($throughputUnits.Where({$PSItem.ResourceGroup -eq $rg.ToUpper()}).ThroughputUnit -as [int],20)
            $maxTu = [math]::Min($tu*5,20)
            Write-Host $ehNamespace $tu $maxTu
            Set-AzEventHubNamespace -ResourceGroupName $rg -SkuCapacity $tu -SkuName "Standard" -Name $ehNamespace -Location $location -EnableAutoInflate -MaximumThroughputUnits $maxTu 
        }
    }
    catch{
        Write-Debug $SubId
    }
}