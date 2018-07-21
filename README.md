# Apache PredicionIO Example

## Installation

1. Install Docker

## Running the Stack

Create a .env at root of project:
```
POSTGRES_USER=pio
POSTGRES_PASSWORD=pio
POSTGRES_DB=pio
POSTGRES_HOST=<Docker host>
EVENT_SERVER_HOST=<Docker host>
EVENT_SERVER_PORT=7070
EVENT_SERVER_ACCESS_KEY=<Event Server Access Key>
ENGINE_HOST=<Docker host>
ENGINE_PORT=8000
```

Run:

```shell
bash start_db.sh
bash start_pio.sh
```

## Resources

- Instructions on installing Apache PredictionIO: https://predictionio.apache.org/install/install-sourcecode/#installing-dependencies

- Instructions on quick-starting with a simple Naive Bayes classifier:
https://predictionio.apache.org/templates/classification/quickstart/ 