# Set-AzContext -SubscriptionId ""
# Install-Module -Name "Az.ManagedServiceIdentity"
param(
    [Parameter(Mandatory=$True)]
    [string]
    $ObjectId,

    [Parameter(Mandatory=$False)]
    [string]
    $RoleDetinitionName = "Storage Blob Data Owner",

    [Parameter(Mandatory=$True)]
    [string]
    $ResourceId
)
New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName $RoleDetinitionName -Scope $ResourceId