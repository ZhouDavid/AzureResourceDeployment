$jsonObj = Get-Content -Raw -Path '..\\RegionSpec.json' | ConvertFrom-Json
foreach ($regionSpec in $jsonObj.RegionSpecs){
    $SubId = $regionSpec.SubscriptionId
    try{
        Set-AzContext -SubscriptionId $SubId
        Write-Debug $SubId
        $regionAlias = $regionSpec.RegionAlias
        $location = $regionSpec.RegionShortName
        $env = $regionSpec.Environment
        
        $msiName = "spkl-msi-sf-$env-$regionAlias-0"
        $objectId = (Get-AzUserAssignedIdentity -ResourceGroupName $msiName).PrincipalId
        
        # set rt eventhub role assignment
        for($i = 0;$i -lt 10;$i++){
            $ehNamespaceName = "spkl-ehn-ri-$env-$regionAlias-$i"
            Write-Host $ehNamespaceName
            $rgName = $ehNamespaceName
            $resourceId = "/subscriptions/$SubId/resourceGroups/$rgName/providers/Microsoft.EventHub/namespaces/$ehNamespaceName"
            $RoleDetinitionName = "Azure Event Hubs Data Owner"
            New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDetinitionName -Scope $resourceId
        }

        # set adl role assignment
        $storName = "spkladlrt$env$regionAlias"+"x0"
        $storRg = "spkl-adl-rt-$env-$regionAlias-0"
        $roleDetinitionName = "Storage Blob Data Owner"
        $resourceId = "/subscriptions/$SubId/resourceGroups/$storRg/providers/Microsoft.Storage/storageAccounts/$storName"
        New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName $RoleDetinitionName -Scope $resourceId

        # set sa role assignment
        $storName = "spklsasf$env$regionAlias"+"x0"
        $storRg = "spkl-sa-sf-$env-$regionAlias-0"
        $resourceId = "/subscriptions/$SubId/resourceGroups/$storRg/providers/Microsoft.Storage/storageAccounts/$storName"
        New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName $RoleDetinitionName -Scope $resourceId
        
        # set adl queue role assignment
        $storName = "spkladlrt$env$regionAlias"+"x0"
        $storRg = "spkl-adl-rt-$env-$regionAlias-0"
        $roleDetinitionName = "Storage Queue Data Contributor"
        $resourceId = "/subscriptions/$SubId/resourceGroups/$storRg/providers/Microsoft.Storage/storageAccounts/$storName"
        New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName $RoleDetinitionName -Scope $resourceId
    }
    catch{
        Write-Debug $SubId
    }
}