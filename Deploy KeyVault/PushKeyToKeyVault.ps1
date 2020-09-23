param(
    [Parameter(Mandatory)]
    [string]
    $KeyVaultName,

    [Parameter(Mandatory)]
    [string]
    $StorageResourceGroup,

    [Parameter(Mandatory)]
    [string]
    $StorageAccountName
)

$storageAccountKey = $(Get-AzStorageAccountKey -ResourceGroupName $StorageResourceGroup -AccountName $StorageAccountName)[0].Value
$storageAccountKey = ConvertTo-SecureString $storageAccountKey -AsPlainText -Force
$secretName = "$StorageAccountName-AccessKey"
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $storageAccountKey