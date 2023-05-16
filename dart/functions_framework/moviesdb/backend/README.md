# local Testing

curl -X POST -H "content-type: application/json" \
  -d '{ "isoCode": "CA" }' -i -w "\n" localhost:8080

curl -X POST -H "content-type: application/json" \
  -d '{ "isoCode": "CA" }' -i -w "\n" https://dart-functions-framework-moviesdb-backend-o2f4t6inaa-nn.a.run.app:8080