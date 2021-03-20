import json
import csv
import pandas as pd


def get_adsagents():
    client = boto3.client('discovery')
    response = client.describe_agents(

    ),
    return response


with open('agents.json') as f:
    data = f.read()
    # Load JSON file string to python dict.
    d = json.loads(data)

df = pd.DataFrame(data=d)
agents = df['agentsInfo']

data_file = open('data_file.csv', 'w')
csv_writer = csv.writer(data_file, delimiter=',')
count = 0

for a in agents:
    if count == 0:
        # Writing headers of CSV file
        header = a.keys()
        csv_writer.writerow(header)
        count += 1

    # Writing data of CSV file
    csv_writer.writerow(a.values())

data_file.close()
