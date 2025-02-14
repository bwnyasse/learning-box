#!/bin/bash

# Arrays for titles, content ideas, categories, and tags
titles=("The Importance of Code Reviews" "Choosing the Right Programming Language" "The Benefits of Agile Development" "Introduction to DevOps" "The Importance of Software Testing" "Getting Started with Cloud Computing" "Introduction to Artificial Intelligence" "The Future of Software Engineering" "Building a Successful Software Development Team" "The Importance of Communication" "Introduction to Cybersecurity" "Understanding Design Patterns")

content_ideas=("Code reviews are essential for quality." "Consider project needs when choosing a language." "Agile promotes flexibility and collaboration." "DevOps bridges development and operations." "Testing ensures software reliability." "Cloud computing offers scalable resources." "AI is transforming software development." "Software engineering is constantly evolving." "Teamwork is crucial for software success." "Effective communication prevents misunderstandings." "Cybersecurity protects against threats." "Design patterns provide reusable solutions.")

categories=("Software Development" "Project Management" "Cloud Computing" "Testing" "AI/ML" "Security" "Best Practices" "Programming" "Web Development" "Mobile Development" "Databases" "Architecture")

# More comprehensive tag lists (expand as needed) - ONE WORD TAGS
tag_lists=(
  "codereview"
  "programming"
  "agile"
  "devops"
  "testing"
  "cloud"
  "ai"
  "future"
  "team"
  "communication"
  "cybersecurity"
  "design"
)


# Loop from 1 to 12
for i in {1..12}; do
  # Create the markdown file
  filename="post-$i.md"
  touch "$filename"

  # Get random category and tag
  category_index=$((RANDOM % ${#categories[@]}))
  category="${categories[$category_index]}"

  tag_index=$((i - 1)) # Use the same index as titles and content
  tag="${tag_lists[$tag_index]}"


  # Write the content to the file
  cat <<EOF > "$filename"
+++
title = "${titles[$((i - 1))]}"
date = 2023-01-$(printf %02d $((15 + i)))T$(printf %02d $((9 + i))):00:00-07:00
draft = false
tags = ["$tag"] # Single tag in array
categories = ["$category"]
image = "/images/$i.jpg"
+++

${content_ideas[$((i - 1))]}

More details about ${titles[$((i - 1))]}. Add as much content as you need for testing.

EOF
done

echo "Markdown files post-1.md to post-12.md created."