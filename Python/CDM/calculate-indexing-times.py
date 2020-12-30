import json
from datetime import datetime

# SAVE THE OUTPUT AS index.json and give the path to the file
indexJson = '/Users/mtellin/Desktop/index.json'

# DONT TOUCH ANYTHING BELOW
with open(indexJson) as f:
  results = json.load(f)

format = '%Y-%m-%dT%H:%M:%S+0000'

for result in results:
    if result['status'] == 'SUCCEEDED':
        indexTime = datetime.strptime(result['endTime'], format) - datetime.strptime(result['startTime'], format)
        if indexTime.seconds > 120: # Anything under 60 seconds is an index job running but not actually doing anything
            print(indexTime)

