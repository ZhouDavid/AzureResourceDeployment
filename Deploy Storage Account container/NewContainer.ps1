# Add-AzureAccount
# Set-AzContext -SubscriptionId ""
# .\NewContainer.ps1 -ResourceGroup "" -StorageAccountName "" -ContainerName "" 
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
$StorageAccountKey = $(Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName)[0].Value
Write-Host $StorageAccountKey
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
New-AzStorageContainer -Name $ContainerName -Context $ctx -Permission Off