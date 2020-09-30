# Add-AzureAccount
# Set-AzContext -SubscriptionId ""
# .\RemoveContainer.ps1 -ResourceGroup "" -StorageAccountName "" -ContainerName "" 
param(
    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory=$True)]
    [string]
    $StorageAccountName,
    [Parameter(Mandatory=$True)]
    [string]
    $ContainerName
)

$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccountName
$ctx = $storageAccount.Context
Remove-AzStorageContainer -Container $ContainerName -Context $ctx