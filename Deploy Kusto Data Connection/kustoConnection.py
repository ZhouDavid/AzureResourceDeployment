#pip install azure-common
# pip install azure-mgmt-kusto

from azure.mgmt.kusto import KustoManagementClient
from azure.mgmt.kusto.models import Database, ReadWriteDatabase, EventGridDataConnection
from azure.common.credentials import ServicePrincipalCredentials

def create_credentials(client_id, client_secret, tenant_id):
  credentials = ServicePrincipalCredentials(
    client_id = client_id,
    secret = client_secret,
    tenant = tenant_id)
  return credentials

def create_kusto_management_client(credentials, subscription_id):
  kusto_management_client = KustoManagementClient(credentials, subscription_id)
  return kusto_management_client

def create_kusto_data_connection(
  kusto_management_client, 
  resource_group_name, 
  cluster_name, 
  database_name, 
  data_connection_name,
  source_storage_subscription_id,
  source_storage_resource_group_name,
  source_storage_name,
  dest_eventhub_subscription_id,
  dest_eventhub_resource_group_name,
  dest_eventhub_namespace_name,
  dest_eventhub_name,
  dest_eventhub_consumer_group_name,
  table_name,
  data_format
  ):
  consumer_group = dest_eventhub_consumer_group_name
  storage_account_resource_id = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Storage/storageAccounts/{2}".format(
    source_storage_subscription_id, source_storage_resource_group_name, source_storage_name)
  
  event_hub_resource_id = "/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.EventHub/namespaces/{2}/eventhubs/{3}".format(
    dest_eventhub_subscription_id, dest_eventhub_resource_group_name, dest_eventhub_namespace_name, dest_eventhub_name)
  
  cluster = kusto_management_client.clusters.get(resource_group_name, cluster_name)
  location = cluster.location
  
  poller = kusto_management_client.data_connections.create_or_update(
  resource_group_name=resource_group_name, 
  cluster_name=cluster_name, 
  database_name=database_name, 
  data_connection_name=data_connection_name,
  parameters=EventGridDataConnection(
    location=location,
    storage_account_resource_id=storage_account_resource_id, 
    event_hub_resource_id=event_hub_resource_id, 
    consumer_group=consumer_group,
    table_name=table_name,
    data_format=data_format))  
  
  return poller

client_id = ""
client_secret = ""
tenant_id = ""

create_credentials(client_id, client_secret, tenant_id)