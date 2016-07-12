# Reverse Proxy Example

Use nginx in frontal as reverse-proxy of services launched with docker-compose.

## Use case
Assuming services are running in localhost

- http://localhost : it is the reverse proxy app
- http://localhost:8082 : Microservice1
- http://localhost:8083 : Microservice2

Reverse proxy magic !
- http://localhost/microservice1 => redirect to Microservice1 URL
- http://localhost/microservice2 => redirect to Microservice2 URL

