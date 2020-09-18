param(
    [Parameter(Mandatory=$True)]
    [string]
    $EventSubscriptionName,

    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $SourceResourceGroup,

    [Parameter(Mandatory=$True)]
    [string]
    $SourceStorageAccountName,
    
    [Parameter(Mandatory=$True)]
    [string]
    $DestEhNamespaceName,

    [Parameter(Mandatory=$True)]
    [string]
    $DestEhName,

    [Parameter(Mandatory=$True)]
    [string]
    $DestResourceGroup,

    [Parameter(Mandatory=$False)]
    [string]
    $IncludeEventTypes="Microsoft.Storage.BlobCreated",
    
    [Parameter(Mandatory=$False)]
    [string]
    $PrefixFilter,

    [Parameter(Mandatory=$False)]
    [string]
    $SuffixFilter
)
$SourceResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$SourceResourceGroup/providers/Microsoft.Storage/storageAccounts/$SourceStorageAccountName"

$DestEhResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$DestResourceGroup/providers/Microsoft.EventHub/namespaces/$DestEhNamespaceName/eventhubs/$DestEhName"

New-AzEventGridSubscription -ResourceId $SourceResourceId -EventSubscriptionName $EventSubscriptionName -EndpointType "eventhub" -Endpoint $DestEhResourceId -IncludedEventType $IncludeEventTypes -SubjectBeginsWith $PrefixFilter -SubjectEndsWith $SuffixFilter -EventTtl 1440 -MaxDeliveryAttempt 30