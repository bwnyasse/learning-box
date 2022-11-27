# local Testing

curl -X POST -H "content-type: application/json" \
  -d '{ "isoCode": "CA" }' -i -w "\n" localhost:8080