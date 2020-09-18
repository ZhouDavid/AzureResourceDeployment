# .\NewStorageToQueueEventGridSub.ps1 -EventSubscriptionName "racktelemetry-test" -SubscriptionId "a0ca3577-9ba2-494e-a538-a695f0363623" -SourceResourceGroup "spkl-adl-rt-int-eus-0" -SourceStorageAccountName "spkladlrtinteusx0" -DestStorageQueueName "racktelemetry" -PrefixFilter "/blobServices/default/containers/racktelemetry/blobs/eventname=racktelemetry-all" -SuffixFilter ".snappy.parquet"

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
    $DestStorageQueueName,

    [Parameter(Mandatory=$False)]
    [string]
    $DestResourceGroup = $SourceResourceGroup,

    [Parameter(Mandatory=$False)]
    [string]
    $DestStorageAccountName=$SourceStorageAccountName,

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

$DestQueueResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$DestResourceGroup/providers/Microsoft.Storage/storageAccounts/$DestStorageAccountName/queueservices/default/queues/$DestStorageQueueName"

New-AzEventGridSubscription -ResourceId $SourceResourceId -EventSubscriptionName $EventSubscriptionName -EndpointType "storagequeue" -Endpoint $DestQueueResourceId -IncludedEventType $IncludeEventTypes -SubjectBeginsWith $PrefixFilter -SubjectEndsWith $SuffixFilter -EventTtl 1440 -MaxDeliveryAttempt 30