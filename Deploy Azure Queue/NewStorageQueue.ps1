# Add-AzureAccount
# Set-AzContext -SubscriptionId ""
# .\NewStorageQueue.ps1 -ResourceGroup "" -StorageAccountName "" -QueueName ""
param(
    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroup,

    [Parameter(Mandatory=$True)]
    [string]
    $StorageAccountName,

    [Parameter(Mandatory=$True)]
    [string]
    $QueueName
)
$StorageAccountKey = $(Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName)[0].Value
Write-Host $StorageAccountKey
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
New-AzStorageQueue -Name $QueueName -Context $ctx

