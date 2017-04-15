#!/bin/bash

# Run `sed` or edit `traefik.toml` yourself
sed -i 's/letsencrypt\@example\.com/contact@noelenwax.com/g' traefik.toml
sed -i 's/example\.com/noelenwax.com/g' traefik.toml

# Start the reverse proxy
docker-compose up -d
