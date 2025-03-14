#!/bin/bash

# documentation_generator.sh
# Generate comprehensive project documentation for AI analysis

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output file
OUTPUT_FILE="project_documentation.md"

# Create or clear the output file
echo "# Project Analysis Document" > "$OUTPUT_FILE"
echo "Generated on $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to escape markdown special characters
escape_markdown() {
    echo "$1" | sed 's/[_*]/\\&/g'
}

# Function to create markdown header based on level
create_header() {
    level=$1
    text=$2
    printf -v header "%${level}s" ""
    header="${header// /#}"
    echo "$header $text"
}

# Project Overview (README.md)
echo "## Project Overview" >> "$OUTPUT_FILE"
if [ -f "README.md" ]; then
    echo "### Original README.md Content" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    cat README.md >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
else
    echo "⚠️ README.md not found. Please create a README.md to describe project objectives and features." >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Project Structure Analysis
echo "## Project Structure Analysis" >> "$OUTPUT_FILE"
echo "### Directory Tree" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
tree -I 'build|.dart_tool|.idea|.git|.metadata|android|ios|macos|windows|linux|web|*.iml|*.lock|*.g.dart|*.freezed.dart|generated|test' >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Dependencies Analysis
echo "### Project Dependencies" >> "$OUTPUT_FILE"
if [ -f "pubspec.yaml" ]; then
    echo "Analysis of dependencies from pubspec.yaml:" >> "$OUTPUT_FILE"
    echo '```yaml' >> "$OUTPUT_FILE"
    cat pubspec.yaml >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
else
    echo "⚠️ pubspec.yaml not found!" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Code Implementation Analysis
echo "## Code Implementation" >> "$OUTPUT_FILE"
echo "### Source Code Analysis" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find all dart files, excluding generated ones
find . -name "*.dart" \
    ! -path "*/build/*" \
    ! -path "*/.dart_tool/*" \
    ! -path "*/generated/*" \
    ! -name "*.g.dart" \
    ! -name "*.freezed.dart" \
    | sort | while read -r file; do
    
    # Get relative path
    rel_path="${file#./}"
    
    # Create section header based on directory structure
    dir_path=$(dirname "$rel_path")
    if [ "$dir_path" != "." ]; then
        IFS='/' read -ra DIRS <<< "$dir_path"
        header_level=3
        for dir in "${DIRS[@]}"; do
            if [[ ! "$current_path" == *"$dir"* ]]; then
                echo "$(create_header $header_level "$(escape_markdown "$dir")")" >> "$OUTPUT_FILE"
                current_path="$current_path/$dir"
                ((header_level++))
            fi
        done
    fi
    
    # File header
    echo "$(create_header 4 "$(escape_markdown "$(basename "$file")")")" >> "$OUTPUT_FILE"
    
    # Add file path and purpose comment
    echo "**File Path:** \`$rel_path\`" >> "$OUTPUT_FILE"
    
    # Extract and add file description from first comment block if available
    first_comment=$(head -n 20 "$file" | grep -A 1 "^//" | head -n 1)
    if [ ! -z "$first_comment" ]; then
        echo "**Purpose:** ${first_comment#// }" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
    
    # Add code block
    echo '```dart' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    echo -e "${GREEN}Processed:${NC} $rel_path"
done


# Project Statistics
echo "## Project Statistics" >> "$OUTPUT_FILE"
echo "- Total Dart files: $(find . -name "*.dart" ! -path "*/build/*" ! -path "*/.dart_tool/*" ! -path "*/generated/*" ! -name "*.g.dart" ! -name "*.freezed.dart" | wc -l)" >> "$OUTPUT_FILE"
echo "- Total lines of code: $(find . -name "*.dart" ! -path "*/build/*" ! -path "*/.dart_tool/*" ! -path "*/generated/*" ! -name "*.g.dart" ! -name "*.freezed.dart" -exec cat {} \; | wc -l)" >> "$OUTPUT_FILE"
echo "- Number of directories: $(find . -type d ! -path "*/build/*" ! -path "*/.dart_tool/*" ! -path "*/generated/*" ! -path "*/.git/*" | wc -l)" >> "$OUTPUT_FILE"

echo -e "${BLUE}Comprehensive documentation generated:${NC} $OUTPUT_FILE"