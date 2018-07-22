# Apache PredicionIO Example (WIP)

**This is still Work In Progress!!**

## Installation

1. Install Docker

## Running the Stack

Create a .env at root of project:
```
POSTGRES_USER=pio
POSTGRES_PASSWORD=pio
POSTGRES_DB=pio
POSTGRES_HOST=<docker_host>
ENGINE_HOST=<docker_host>
ENGINE_PORT=8000
```

Run in terminal 1:

```shell
bash start_db.sh
```

Run in terminal 2:

```shell
bash start_engine.sh
```

On terminal 2, you'll be runing bash in the Docker container with Prediction.IO set up. Check its status by running:

```shell
pio status
```

If there are no errors, create the app & feed the training data to the app:

```shell
cd ./engine/kaggle-house-prices
pio app new kaggle-house-prices
python ./prepare-events.py
pio import --appid <app_id> --input ./events.json
```

Next, start building & training the engine:

```shell
cd ./engine
pio build --verbose
pio train -v ./linear-regression-engine.json
```

Lastly, deploy the trained engine:

```shell
pio deploy -v ./linear-regression-engine.json
```

You'll be able to make predictions like:

```shell
$ curl \
  -H "Content-Type: application/json" \
  -d '{ "x0": 0 }'
  http://<docker_host>:8000/queries.json
```

## TODO

- Unwrap full list of features for the Kaggle house prices dataset
- Write sample client-side Python code to make predictions
- Write sample code to do batch predictions
- Figure out how to componentize event server, engine & engine deployment

## Resources

- Instructions on installing Apache PredictionIO: https://predictionio.apache.org/install/install-sourcecode/#installing-dependencies

- Instructions on quick-starting with a simple Naive Bayes classifier:
https://predictionio.apache.org/templates/classification/quickstart/

- Explanation on how the default Naive Bayes classifier engine is written:
http://predictionio.apache.org/templates/classification/dase/

- Instructions on how to edit the Naive Bayes classifer engine to use another MLlib algorithm:
https://predictionio.apache.org/templates/classification/add-algorithm/ 
