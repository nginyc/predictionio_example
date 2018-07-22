import predictionio
import pandas as pd

KAGGLE_HOUSE_PRICES_CSV_FILE_PATH = '../../data/kaggle-house-prices/train.csv'
EXPORTED_EVENTS_JSON_FILE_NAME = 'events.json'

def get_row_id(row):
  return row['Id']

def row_to_example(row):
  # List of features for the example
  x = [] 
  
  # OverallQual
  x.append(row['OverallQual'])

  # Label
  y = row['SalePrice']

  return (x, y)

def add_event(exporter, id, x, y):
  # Build event properties
  props = {}
  for i, xi in enumerate(x):
    props['x' + str(i)] = xi
  props['y'] = y

  exporter.create_event(
    event="$set",
    entity_type="point",
    entity_id=id, 
    properties=props
  )

if __name__ == '__main__':
  exporter = predictionio.FileExporter(file_name=EXPORTED_EVENTS_JSON_FILE_NAME)
  train_df = pd.read_csv(KAGGLE_HOUSE_PRICES_CSV_FILE_PATH)

  for (_, row) in train_df.iterrows(): 
    id = get_row_id(row)
    (x, y) = row_to_example(row)
    add_event(exporter, id, x, y)

  print('Exported event data to {}'.format(EXPORTED_EVENTS_JSON_FILE_NAME))
  
  exporter.close()
