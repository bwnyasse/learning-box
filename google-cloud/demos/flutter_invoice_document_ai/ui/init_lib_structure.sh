#!/bin/bash

LIB_DIR="lib"
DIRECTORIES=("models" "views" "views/login_page.dart" "views/home_page.dart" "views/details_page.dart" "views/chart_page.dart" "widgets" "services" "services/auth_service.dart" "services/api_service.dart" "utils")

echo "Initializing lib structure..."

# Create directories and files
for dir in "${DIRECTORIES[@]}"
do
  mkdir -p "$LIB_DIR/$dir"
  touch "$LIB_DIR/$dir/.gitkeep"
done

# Remove .gitkeep from files that should not be directories
rm "$LIB_DIR/views/login_page.dart/.gitkeep"
rm "$LIB_DIR/views/home_page.dart/.gitkeep"
rm "$LIB_DIR/views/details_page.dart/.gitkeep"
rm "$LIB_DIR/views/chart_page.dart/.gitkeep"
rm "$LIB_DIR/services/auth_service.dart/.gitkeep"
rm "$LIB_DIR/services/api_service.dart/.gitkeep"

echo "Lib folder structure initialized successfully."
