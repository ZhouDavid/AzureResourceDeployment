$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $location = $regionSpec.RegionShortName
        $env = $regionSpec.Environment
        $rg = "spkl-adx-$env-$regionAlias-0"
        $cluster = "spkladx$env$regionAlias"+"x0"
        for($i=0;$i -lt 10;$i++){
            for($j=0;$j -lt 5;$j++){
                $dataConnection = "spkl-ehn-ro-$env-$regionAlias-$i-eh-$j"
                Write-Host "removing $dataConnection"
                Remove-AzKustoDataConnection -ResourceGroupName $rg -ClusterName $cluster -DatabaseName "defaultdb" -DataConnectionName $dataConnection
            }
        }
    }
    catch{
        Write-Debug $SubId
    }
}

