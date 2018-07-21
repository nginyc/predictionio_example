source .env

docker rm -f pio
docker build $PWD/pio -t pio
docker run --name pio \
  -it \
  -e POSTGRES_HOST=$POSTGRES_HOST \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p 8000:8000 \
  pio