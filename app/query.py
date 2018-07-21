import predictionio
from dotenv import load_dotenv
import os

if __name__ == '__main__':
  load_dotenv()

  engine_client = predictionio.EngineClient(
    url='http://{}:{}'.format(os.environ['ENGINE_HOST'], os.environ['ENGINE_PORT'])
  )

  print(engine_client.send_query({"attr0":54, "attr1":39, "attr2":34}))  
