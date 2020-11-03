#%%
import pandas as pd
import math
df = pd.read_csv('query_data.csv')
limitDict = {}
limitDict['IncomingMessages'] = 1000 * 60
limitDict['IncomingBytes'] = 1000000 * 60
limitDict['OutgoingMessages'] = 4096 * 60
limitDict['OutgoingBytes'] = 2000000 * 60

def calculateThroughput(row):
    metric = row['MetricName']
    value = row['avg_Total']
    limit = limitDict[metric]
    return math.ceil(value / limit)

df['ThroughputUnit'] = df.apply(calculateThroughput,axis = 1)

#%%
df2 = df.groupby(['ResourceGroup']).max()
# df2 = df.groupby(['ResourceGroup']).agg(max_throughputunits = pd.NameAgg(column='ThroughputUnit',aggfunc=max))
# %%
df2.to_csv('scale.csv')
# %%
df.to_csv('clean.csv')
# %%
