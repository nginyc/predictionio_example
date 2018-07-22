source .env

MODULE_NAME=pio_engine

docker rm -f $MODULE_NAME
docker build $PWD/engine -t $MODULE_NAME
docker run --name $MODULE_NAME \
  -it \
  -v "/$PWD/engine/":"/root/app/engine" \
  -v "/$PWD/data/":"/root/app/data" \
  -e POSTGRES_HOST=$POSTGRES_HOST \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p 8000:8000 \
  $MODULE_NAME