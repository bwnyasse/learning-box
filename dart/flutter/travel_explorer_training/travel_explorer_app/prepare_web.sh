#!/bin/bash
# scripts/prepare_web.sh

# Check if env.json file exists
if [ ! -f "keys/env.json" ]; then
  echo "Error: keys/env.json file not found"
  exit 1
fi

# Extract the API key from env.json
API_KEY=$(jq -r '.GOOGLE_MAPS_API_KEY' keys/env.json)

if [ -z "$API_KEY" ] || [ "$API_KEY" == "null" ]; then
  echo "Error: Could not extract GOOGLE_MAPS_API_KEY from env.json"
  exit 1
fi

# Create index.html from template
cp web/index.template.html web/index.html

# Replace placeholder with actual API key
sed -i "" "s/GOOGLE_MAPS_API_KEY_PLACEHOLDER/$API_KEY/g" web/index.html

echo "Successfully created web/index.html with API key"