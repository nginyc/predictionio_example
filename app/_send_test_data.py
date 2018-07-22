import predictionio
from dotenv import load_dotenv
import os

if __name__ == '__main__':
  load_dotenv()
  
  client = predictionio.EventClient(
    access_key=os.environ['EVENT_SERVER_ACCESS_KEY'],
    url='http://{}:{}'.format(os.environ['EVENT_SERVER_HOST'], os.environ['EVENT_SERVER_PORT']),
    threads=5,
    qsize=500
  )

  client.create_event(
    event='$set',
    entity_type='user',
    entity_id='a',
    properties= {
      'x1': 0,
      'x2': 1,
      'y': 1
    }
  )

  client.create_event(
    event='$set',
    entity_type='user',
    entity_id='a',
    properties= {
      'x1': 1,
      'x2': 0,
      'y': 0
    }
  )

  client.create_event(
    event='$set',
    entity_type='user',
    entity_id='a',
    properties= {
      'x1': 0,
      'x2': 0,
      'y': 0
    }
  )
  
  client.create_event(
    event='$set',
    entity_type='user',
    entity_id='a',
    properties= {
      'x1': 1,
      'x2': 0,
      'y': 0
    }
  )

  client.create_event(
    event='$set',
    entity_type='user',
    entity_id='a',
    properties= {
        'x1': 0,
        'x2': 1,
        'y': 1
    }
  )

  print('Events:\n\n', client.get_events())
