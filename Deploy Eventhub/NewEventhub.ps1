param(
    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroup,

    [Parameter(Mandatory=$True)]
    [string]
    $EhNamespace,

    [Parameter(Mandatory=$True)]
    [string]
    $Location,

    [Parameter(Mandatory=$True)]
    [string]
    $EhName,

    [Parameter(Mandatory=$True)]
    [string]
    $ConsumerGroupName
)
try{
    #New-AzResourceGroup -Name $ResourceGroup -Location $Location
}catch{}
try{
    #New-AzEventHubNamespace -ResourceGroupName $ResourceGroup -NamespaceName $EhNamespace -Location $Location
}catch{}
try{
    New-AzEventHub -ResourceGroupName $ResourceGroup -NamespaceName $EhNamespace -EventhubName $EhName -PartitionCount 32 -MessageRetentionInDays 7
    # Remove-AzEventHub -ResourceGroupName $ResourceGroup -Namespace $EhNamespace -Name $EhName
}catch{}
try{
    New-AzEventHubConsumerGroup -ResourceGroupName $ResourceGroup -Namespace $EhNamespace -EventHub $EhName -Name $ConsumerGroupName
}catch{}

