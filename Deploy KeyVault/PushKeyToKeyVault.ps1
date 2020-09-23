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

# $storageAccountKey = $(Get-AzStorageAccountKey -ResourceGroupName $StorageResourceGroup -AccountName $StorageAccountName)[0].Value
$storageAccountKey = "LyN6vv+HfJF7PZgJxOP9BQIINKV0QpZ0tGx4Ge5uQgffsdzYx8etoinBkt3Yyg4Cs8TJh0FKDP04v/gEPwKXsw=="
$storageAccountKey = ConvertTo-SecureString $storageAccountKey -AsPlainText -Force
$secretName = "$StorageAccountName-AccessKey"
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue $storageAccountKey