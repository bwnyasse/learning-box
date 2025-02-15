# Oloodi Hugo Clean

A clean, modern Hugo theme with dark mode support and search functionality.

## Features

- 🌓 Dark mode support with system preference detection
- 🔍 Built-in search functionality using Fuse.js
- 📱 Fully responsive design
- 🎨 Clean and modern aesthetic
- ⚡ Fast and optimized for performance
- 📝 Blog post support with categories and tags
- 💅 Tailwind CSS for styling
- 🔄 Smooth transitions and animations

## Installation

1. Create a new Hugo site:
```bash
hugo new site mysite
cd mysite
```

2. Add the theme as a git submodule:

```bash
git init
git submodule add https://github.com/bwnyasse/oloodi-hugo-clean.git themes/oloodi-hugo-clean
```

3. Configure your `config.toml`:

```toml
theme = "oloodi-hugo-clean"
[outputs]
  home = ["HTML", "RSS", "JSON"]  # Required for search functionality
```

## Configuration

### Basic Configuration

```toml
baseURL = 'https://example.com'
languageCode = 'en-us'
title = 'Your Site Title'

[params]
  description = "Your site description"
  # Social media links
  [params.social]
    twitter = "https://twitter.com/yourusername"
    github = "https://github.com/yourusername"
    linkedin = "https://linkedin.com/in/yourusername"
    medium = "https://mediun.com/yourusername"
    instagram = "https://instagram.com/yourusername"
```

### Menu Configuration

```toml
[menu]
  [[menu.main]]
    name = "Home"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "Blog"
    url = "/posts/"
    weight = 2
```

## Content Structure

### Blog Posts

Create a new blog post:

```bash
hugo new posts/my-first-post.md
```

```bash
Post front matter : 

---
title: "My First Post"
date: 2024-02-14
draft: false
categories: ["Technology"]
tags: ["hugo", "web"]
image: "/images/featured.jpg"  # Optional featured image
featured: true  # Optional, for featured posts
---
```

# Development
## Requirements

- Hugo Extended Version
- Node.js (for Tailwind CSS)
- npm or yarn

## Local Development

1. Clone the repository

2. Install dependencies:

```bash 
npm install
```

3. Run Hugo server :

```bash
hugo server -D
```

# Customization

## Colors

The theme uses CSS variables for colors. You can override them in your own CSS:

```css
:root {
    --primary-color: #00c38e;
    --secondary-color: #9fff24;
    /* Add other color variables */
}
```

## Fonts

The theme uses Google Fonts. You can change them by modifying the font imports in `layouts/_default/baseof.html`.

## Theme Configuration

You can customize the theme by creating a `data/theme.toml` file in your Hugo site:

```toml
[theme]
  primary_color = "#00c38e"
  enable_dark_mode = true
  
  [theme.sidebar]
    enable = true
    components = ["author", "recent_posts", "categories", "tags"]
```

Available options:

- `primary_color`: Main theme color
- `secondary_color`: Accent color
- `enable_dark_mode`: Enable/disable dark mode
- `enable_search`: Enable/disable search functionality...


## Development

### Requirements
- Node.js (v14 or later)
- npm or yarn

### Setup

1. Install dependencies:
```bash
npm install
```

2. Start development server:
```bash
npm run dev
```

3. Build for production:
```bash
npm run build
```

# Credits

- Built with Hugo
- Styled with Tailwind CSS
- Search powered by Fuse.js
- Icons from Heroicons

# License

This theme is released under the MIT License. See the LICENSE file for details.

