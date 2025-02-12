#!/bin/bash

# Exit on error
set -e

# Site name and theme name
SITE_NAME="blog-bwnyasse-net-2"
THEME_NAME="bwnyasse-theme"

# Create new Hugo site
hugo new site $SITE_NAME
cd $SITE_NAME

# Create theme
hugo new theme $THEME_NAME

# Setup config.toml
cat > config.toml << EOF
baseURL = 'http://localhost:1313/'
languageCode = 'en-us'
title = 'My Blog'
theme = 'bwnyasse-theme'

[menu]
  [[menu.main]]
    name = 'Home'
    url = '/'
    weight = 1
  [[menu.main]]
    name = 'Posts'
    url = '/posts/'
    weight = 2
EOF

# Create theme structure
THEME_DIR="themes/$THEME_NAME"

# Create baseof.html
cat > $THEME_DIR/layouts/_default/baseof.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ .Site.Title }}{{ with .Title }} | {{ . }}{{ end }}</title>
    {{ partial "head.html" . }}
</head>
<body>
    {{ partial "header.html" . }}
    <main>
        {{ block "main" . }}{{ end }}
    </main>
    {{ partial "footer.html" . }}
</body>
</html>
EOF

# Create index.html (home)
cat > $THEME_DIR/layouts/index.html << EOF
{{ define "main" }}
<div class="home">
    <h1>Welcome to {{ .Site.Title }}</h1>
    <div class="posts-list">
        {{ range where .Site.RegularPages "Type" "posts" }}
        <article>
            <h2><a href="{{ .Permalink }}">{{ .Title }}</a></h2>
            <time>{{ .Date.Format "2006-01-02" }}</time>
            <div class="summary">
                {{ .Summary }}
            </div>
        </article>
        {{ end }}
    </div>
</div>
{{ end }}
EOF

# Create single.html
cat > $THEME_DIR/layouts/_default/single.html << EOF
{{ define "main" }}
<article class="post">
    <h1>{{ .Title }}</h1>
    <time>{{ .Date.Format "2006-01-02" }}</time>
    <div class="content">
        {{ .Content }}
    </div>
</article>
{{ end }}
EOF

# Create list.html
cat > $THEME_DIR/layouts/_default/list.html << EOF
{{ define "main" }}
<div class="list-page">
    <h1>{{ .Title }}</h1>
    {{ range .Pages }}
    <article>
        <h2><a href="{{ .Permalink }}">{{ .Title }}</a></h2>
        <time>{{ .Date.Format "2006-01-02" }}</time>
        <div class="summary">
            {{ .Summary }}
        </div>
    </article>
    {{ end }}
</div>
{{ end }}
EOF

# Create taxonomy.html
cat > $THEME_DIR/layouts/_default/taxonomy.html << EOF
{{ define "main" }}
<div class="taxonomy-page">
    <h1>{{ .Title }}</h1>
    <ul>
        {{ range .Pages }}
        <li>
            <a href="{{ .Permalink }}">{{ .Title }}</a>
            <time>({{ .Date.Format "2006-01-02" }})</time>
        </li>
        {{ end }}
    </ul>
</div>
{{ end }}
EOF

# Create section.html
cat > $THEME_DIR/layouts/_default/section.html << EOF
{{ define "main" }}
<div class="section-page">
    <h1>{{ .Title }}</h1>
    {{ range .Pages }}
    <article>
        <h2><a href="{{ .Permalink }}">{{ .Title }}</a></h2>
        <time>{{ .Date.Format "2006-01-02" }}</time>
        <div class="summary">
            {{ .Summary }}
        </div>
    </article>
    {{ end }}
</div>
{{ end }}
EOF

# Create partials
mkdir -p $THEME_DIR/layouts/partials

# Create header partial
cat > $THEME_DIR/layouts/partials/header.html << EOF
<header>
    <nav>
        <a href="{{ .Site.BaseURL }}">Home</a>
        {{ range .Site.Menus.main }}
        <a href="{{ .URL }}">{{ .Name }}</a>
        {{ end }}
    </nav>
</header>
EOF

# Create footer partial
cat > $THEME_DIR/layouts/partials/footer.html << EOF
<footer>
    <p>&copy; {{ now.Format "2006" }} {{ .Site.Title }}</p>
</footer>
EOF

# Create head partial
cat > $THEME_DIR/layouts/partials/head.html << EOF
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
EOF

# Create basic CSS
mkdir -p $THEME_DIR/static/css
cat > $THEME_DIR/static/css/style.css << EOF
/* Basic styles */
:root {
    --primary-color: #333;
    --background-color: #fff;
    --text-color: #333;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    color: var(--text-color);
    background: var(--background-color);
}

main {
    max-width: 800px;
    margin: 0 auto;
    padding: 2rem;
}

header {
    background: var(--primary-color);
    color: white;
    padding: 1rem;
}

header nav a {
    color: white;
    text-decoration: none;
    margin-right: 1rem;
}

footer {
    text-align: center;
    padding: 2rem;
    background: #f5f5f5;
}

article {
    margin-bottom: 2rem;
}

h1, h2, h3 {
    color: var(--primary-color);
}

time {
    color: #666;
    font-size: 0.9rem;
}

.home, .list-page, .taxonomy-page, .section-page {
    margin-bottom: 2rem;
}
EOF

# Create sample content
mkdir -p content/posts

# Create first post
cat > content/posts/first-post.md << EOF
---
title: "My First Post"
date: $(date +"%Y-%m-%d")
draft: false
---

Welcome to my first blog post! This is a sample post created during the site setup.

## What to expect

In this blog, I'll be sharing my thoughts on various topics including:

1. Technology
2. Programming
3. Personal experiences

Stay tuned for more content!
EOF

# Create _index.md for posts section
cat > content/posts/_index.md << EOF
---
title: "Posts"
date: $(date +"%Y-%m-%d")
---

Welcome to my blog posts section.
EOF

echo "Hugo site '$SITE_NAME' has been created successfully with a custom theme '$THEME_NAME'!"
echo "To start the Hugo server, run:"
echo "cd $SITE_NAME && hugo server -D"