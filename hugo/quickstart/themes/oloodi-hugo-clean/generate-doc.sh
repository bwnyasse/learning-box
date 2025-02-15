#!/bin/bash

# Define the output markdown file
OUTPUT_FILE="code-template.md"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Function to append file content to the markdown file
append_file_content() {
    local file_path="$1"
    echo "## File: $file_path" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    cat "$file_path" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Process archetypes directory and its subdirectories
echo "# Archetypes Files" >> "$OUTPUT_FILE"
find archetypes -type f | while read -r file; do
    append_file_content "$file"
done

# Process layout directory and its subdirectories
echo "# Layout Files" >> "$OUTPUT_FILE"
find layouts -type f | while read -r file; do
    append_file_content "$file"
done

# Process static/css directory
echo "# Static CSS Files" >> "$OUTPUT_FILE"
find static/css -type f | while read -r file; do
    append_file_content "$file"
done

# Hugo Toml 
append_file_content hugo.toml
append_file_content theme.toml
append_file_content README.md


echo "Documentation generated in $OUTPUT_FILE"