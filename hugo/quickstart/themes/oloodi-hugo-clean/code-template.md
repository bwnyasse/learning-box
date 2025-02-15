# Archetypes Files
## File: archetypes/default.md
```
+++
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
date = {{ .Date }}
draft = true
+++
```

# Layout Files
## File: layouts/index.html
```
{{ define "main" }}
<!-- Hero Section -->
<section class="min-h-screen bg-black text-white flex items-center">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div class="max-w-2xl">
                <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight">
                    <span class="text-primary">Technology Leader,</span> Google Developer Expert,
                    <span class="text-primary">Speaker.</span>
                </h1>
                <p class="mt-6 text-xl text-gray-300">
                    With over a decade in software development, I focus on innovative tech solutions
                    and am passionate about mentoring aspiring developers.
                </p>
                <div class="mt-8">
                    <a href="/blog" 
                       class="inline-flex items-center bg-secondary text-black px-6 py-3 rounded-lg font-medium hover:translate-x-1 transition">
                        Read My Blog
                        <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"/>
                        </svg>
                    </a>
                </div>
            </div>
            <div class="relative h-[600px] lg:h-[700px]">
                <img src="/images/author-profile.jpg" alt="Author Profile" 
                     class="w-full h-full object-cover rounded-lg">
                <div class="absolute inset-0 bg-gradient-to-tr from-black/30 to-transparent rounded-lg"></div>
            </div>
        </div>
    </div>
</section>

<!-- Projects Grid -->
<section class="bg-black py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-1 bg-gray-900/50">
            {{ range $index, $project := slice 
                (dict "title" "Google Developer Expert" "description" "Project description goes here" "image" "/images/project1.jpg")
                (dict "title" "Oloodi Dialogues" "description" "Another description here" "image" "/images/project2.jpg")
                (dict "title" "Engineer Manager @Datavalet" "description" "Another description here" "image" "/images/project3.jpg")
            }}
            <div class="group relative aspect-square overflow-hidden bg-black">
                <img src="{{ .image }}" alt="{{ .title }}" 
                     class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
                <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-80">
                </div>
                <div class="absolute bottom-0 left-0 right-0 p-8 flex justify-between items-end">
                    <div>
                        <h3 class="text-xl font-semibold text-white">{{ .title }}</h3>
                        <p class="text-gray-300 mt-2">{{ .description }}</p>
                    </div>
                    <span class="text-secondary text-3xl font-light group-hover:translate-x-2 transition-transform">→</span>
                </div>
                <a href="#" class="absolute inset-0" aria-label="View {{ .title }}"></a>
            </div>
            {{ end }}
        </div>
    </div>
</section>
{{ end }}```

## File: layouts/blog/list.html
```
{{ define "main" }}
<div class="bg-white  p-3"></div>
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20">
    <div class="grid grid-cols-1 lg:grid-cols-[1fr,300px] gap-12">
        <!-- Main Content -->
        <div>
            <!-- Featured Article -->
            {{ range first 1 (where (where .Site.RegularPages "Type" "posts") "Params.featured" true) }}
            <article class="bg-white rounded-lg shadow-lg overflow-hidden mb-12">
                {{ if .Params.image }}
                <div class="relative h-96">
                    <img src="{{ .Params.image }}" alt="{{ .Title }}" class="w-full h-full object-cover">
                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                    <div class="absolute bottom-0 left-0 p-6 text-white">
                        {{ with .Params.categories }}
                        <div class="flex gap-2 mb-4">
                            {{ range . }}
                            <span class="bg-secondary text-dark px-3 py-1 rounded-md text-sm font-medium">
                                {{ . }}
                            </span>
                            {{ end }}
                        </div>
                        {{ end }}
                        <h2 class="text-3xl font-bold mb-2">
                            <a href="{{ .Permalink }}" class="hover:text-primary transition">{{ .Title }}</a>
                        </h2>
                        <div class="flex items-center gap-4 text-sm">
                            <span class="bg-black/60 px-3 py-1">{{ .ReadingTime }} MIN READ</span>
                            <span class="bg-black/60 px-3 py-1">{{ .Date.Format "02 JAN 2006" }}</span>
                        </div>
                    </div>
                </div>
                {{ end }}
            </article>
            {{ end }}

            <!-- Blog Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
                {{ $paginator := .Paginate (where .Site.RegularPages "Type" "posts") }}
                {{ range $paginator.Pages }}
                <article class="bg-white rounded-lg shadow-lg overflow-hidden group">
                    {{ if .Params.image }}
                    <div class="relative aspect-video">
                        <img src="{{ .Params.image }}" alt="{{ .Title }}"
                            class="w-full h-full object-cover group-hover:scale-105 transition duration-300">
                        <div class="absolute top-4 right-4 flex flex-col gap-2">
                            <span class="bg-black/60 text-white px-3 py-1 text-sm">
                                {{ .ReadingTime }} MIN READ
                            </span>
                            <span class="bg-black/60 text-white px-3 py-1 text-sm">
                                {{ .Date.Format "02 JAN 2006" }}
                            </span>
                        </div>
                    </div>
                    {{ end }}
                    <div class="p-6">
                        {{ with .Params.categories }}
                        <div class="flex gap-2 mb-4">
                            {{ range . }}
                            <span class="bg-secondary/20 text-dark px-3 py-1 rounded-md text-sm">
                                {{ . }}
                            </span>
                            {{ end }}
                        </div>
                        {{ end }}
                        <h2 class="text-xl font-semibold mb-4">
                            <a href="{{ .Permalink }}" class="hover:text-primary transition">{{ .Title }}</a>
                        </h2>
                        <p class="text-text-secondary mb-4 text-justify">
                            {{ with .Description }}
                            {{ . | truncate 160 }}
                            {{ else }}
                            {{ .Summary | plainify | truncate 160 }}
                            {{ end }}
                        </p>
                        <a href="{{ .Permalink }}"
                            class="inline-flex items-center text-dark hover:text-primary transition">
                            Read More
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-2" viewBox="0 0 20 20"
                                fill="currentColor">
                                <path fill-rule="evenodd"
                                    d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
                                    clip-rule="evenodd" />
                            </svg>
                        </a>
                    </div>
                </article>
                {{ end }}
            </div>

            <!-- Pagination -->
            {{ partial "pagination.html" . }}
            <div class="bg-white  p-3"></div>
        </div>
        <!-- Sidebar -->
        {{ partial "sidebar.html" . }}
    </div>
</div>
{{ end }}```

## File: layouts/_default/single.html
```
{{ define "main" }}
<article class="min-h-screen dark:bg-gray-900">
    <!-- Hero Section -->
    <div class="relative h-[30vh] mt-16">
        {{ if .Params.image }}
        <img src="{{ .Params.image }}" alt="{{ .Title }}" class="w-full h-full object-cover">
        <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
        <div class="absolute bottom-0 left-0 right-0 p-8 max-w-4xl mx-auto">
            {{ with .Params.categories }}
            <div class="flex gap-2 mb-4">
                {{ range . }}
                <span class="bg-secondary text-dark px-3 py-1 text-sm font-medium">{{ . }}</span>
                {{ end }}
            </div>
            {{ end }}
            <h1 class="text-4xl md:text-5xl font-bold text-white mb-4">{{ .Title }}</h1>
            <div class="flex items-center gap-4 text-white/80 text-sm">
                <span class="bg-black/60 px-3 py-1">{{ .Date.Format "January 2, 2006" }}</span>
                <span class="bg-black/60 px-3 py-1">{{ .ReadingTime }} min read</span>
            </div>
        </div>
        {{ end }}
    </div>

    <!-- Content Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-[1fr,300px] gap-12">
            <!-- Main Content Column -->
            <div>
                <!-- Typography Content -->
                <div class="prose prose-lg dark:prose-dark max-w-none">
                    {{ .Content }}
                </div>

                <!-- Share Buttons -->
                <div class="mt-8 border-t dark:border-gray-700 pt-8">
                    {{ partial "share-buttons.html" . }}
                </div>

                <!-- Related Posts -->
                {{ $related := .Site.RegularPages.Related . | first 2 }}
                {{ with $related }}
                <div class="mt-12 border-t dark:border-gray-700 pt-8">
                    <h2 class="text-2xl font-bold mb-6">Related Posts</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {{ range . }}
                        <a href="{{ .RelPermalink }}"
                            class="group block bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-md transition-all duration-200">
                            <div class="p-6">
                                {{ with .Params.categories }}
                                <div class="flex gap-2 mb-3">
                                    {{ range . }}
                                    <span class="text-xs bg-secondary/20 text-dark dark:text-white px-2 py-1 rounded">
                                        {{ . }}
                                    </span>
                                    {{ end }}
                                </div>
                                {{ end }}
                                <h3 class="text-lg font-semibold group-hover:text-primary transition-colors">
                                    {{ .Title }}
                                </h3>
                                <div class="mt-2 flex items-center gap-4 text-sm text-gray-600 dark:text-gray-400">
                                    <span>{{ .Date.Format "Jan 2, 2006" }}</span>
                                    <span>{{ .ReadingTime }} min read</span>
                                </div>
                            </div>
                        </a>
                        {{ end }}
                    </div>
                </div>
                {{ end }}
            </div>

            <!-- Sidebar -->
            {{ partial "sidebar.html" . }}
        </div>
    </div>
</article>

<!-- Progress Bar -->
<div x-data="{ scrollProgress: '0%' }"
    @scroll.window="scrollProgress = Math.round((window.pageYOffset / (document.documentElement.scrollHeight - window.innerHeight)) * 100) + '%'"
    class="fixed top-0 left-0 right-0 z-50">
    <div class="h-1 bg-gray-200 dark:bg-gray-700">
        <div class="h-full bg-primary transition-all duration-200 ease-out" :style="`width: ${scrollProgress}`">
        </div>
    </div>
</div>
{{ end }}```

## File: layouts/_default/home.html
```
{{ define "main" }}
  {{ .Content }}
  {{ range site.RegularPages }}
    <h2><a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a></h2>
    {{ .Summary }}
  {{ end }}
{{ end }}
```

## File: layouts/_default/list.html
```
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
```

## File: layouts/_default/taxonomy.html
```
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
```

## File: layouts/_default/baseof.html
```
<!DOCTYPE html>
<html lang="{{ .Site.LanguageCode | default " en" }}">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Raleway:wght@400;500;600;700&display=swap"
        rel="stylesheet">

    <!-- Prism.js for syntax highlighting -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css"
        x-show="$store.theme.isDark">
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-bash.min.js"></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-go.min.js"></script>

    <!-- Alpine.js Plugins -->
    <script defer src="https://unpkg.com/@alpinejs/collapse@3.x.x/dist/cdn.min.js"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <!-- Tailwind CSS with Typography plugin -->
    <script src="https://cdn.tailwindcss.com?plugins=typography"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: '#00c38e',
                        secondary: '#9fff24',
                        dark: '#2d3436',
                        'text-secondary': '#636e72',
                    },
                    fontFamily: {
                        poppins: ['Poppins', 'sans-serif'],
                        raleway: ['Raleway', 'sans-serif'],
                    },
                    typography: (theme) => ({
                        DEFAULT: {
                            css: {
                                color: theme('colors.gray.900'),
                                a: {
                                    color: theme('colors.primary'),
                                    '&:hover': {
                                        color: theme('colors.primary/80'),
                                    },
                                },
                            },
                        },
                        dark: {
                            css: {
                                color: theme('colors.gray.100'),
                                a: {
                                    color: theme('colors.primary'),
                                },
                                h1: { color: theme('colors.gray.100') },
                                h2: { color: theme('colors.gray.100') },
                                h3: { color: theme('colors.gray.100') },
                                h4: { color: theme('colors.gray.100') },
                                p: { color: theme('colors.gray.300') },
                                strong: { color: theme('colors.gray.100') },
                                blockquote: { color: theme('colors.gray.300') },
                            },
                        },
                    }),
                },
            },
        }
    </script>
    <script>
        document.addEventListener('alpine:init', () => {
            Alpine.store('theme', {
                isDark: localStorage.getItem('theme') === 'dark',
                toggle() {
                    this.isDark = !this.isDark;
                    localStorage.setItem('theme', this.isDark ? 'dark' : 'light');
                },
                init() {
                    this.$nextTick(() => {
                        if (this.isDark) {
                            document.documentElement.classList.add('dark');
                        }
                    });
                }
            });

            Alpine.data('navigation', () => ({
                isOpen: false,
                isScrolled: false,
                lastScrollPosition: 0,
                init() {
                    this.handleScroll();
                    window.addEventListener('scroll', () => this.handleScroll());
                },
                handleScroll() {
                    this.isScrolled = window.pageYOffset > 0;
                    const position = window.pageYOffset;
                    if (position > this.lastScrollPosition && position > 80) {
                        this.$el.style.transform = 'translateY(-100%)';
                    } else {
                        this.$el.style.transform = 'translateY(0)';
                    }
                    this.lastScrollPosition = position;
                }
            }));
        });
    </script>
</head>

<body class="font-poppins" x-data="{ darkMode: localStorage.getItem('darkMode') === 'true' }"
    :class="{ 'dark': darkMode }">
    {{ partial "header.html" . }}
    <main>
        {{ block "main" . }}{{ end }}
    </main>
    {{ partial "footer.html" . }}
</body>

</html>```

## File: layouts/_default/section.html
```
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
```

## File: layouts/_default/search.html
```
{{ define "main" }}
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 mt-16"
     x-data="search()"
     x-init="init()">
    <!-- Search Input -->
    <div class="max-w-2xl mx-auto mb-12">
        <div class="relative">
            <input type="text" 
                   x-model="searchQuery"
                   @input.debounce.300ms="performSearch()"
                   placeholder="Search posts..."
                   class="w-full px-4 py-3 pl-12 rounded-lg bg-gray-100 dark:bg-gray-800 border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary">
            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" 
                 fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
        </div>
    </div>

    <!-- Results -->
    <div class="max-w-4xl mx-auto">
        <!-- No results message -->
        <template x-if="!searchResults.length && searchQuery">
            <p class="text-center text-gray-500 dark:text-gray-400 py-8">
                No results found for "<span x-text="searchQuery"></span>"
            </p>
        </template>

        <!-- Results list -->
        <div class="space-y-8">
            <template x-for="result in searchResults" :key="result.permalink">
                <article class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                    <div class="flex gap-2 mb-3">
                        <template x-for="category in result.categories" :key="category">
                            <span class="text-xs bg-secondary/20 text-dark dark:text-white px-2 py-1 rounded"
                                  x-text="category"></span>
                        </template>
                    </div>
                    <h2 class="text-xl font-semibold mb-2">
                        <a :href="result.permalink" 
                           x-text="result.title"
                           class="hover:text-primary transition-colors"></a>
                    </h2>
                    <p class="text-gray-600 dark:text-gray-300 mb-4" x-text="result.summary"></p>
                    <div class="flex items-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                        <span x-text="result.date"></span>
                    </div>
                </article>
            </template>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2"></script>
<script>
function search() {
    return {
        searchQuery: '',
        searchResults: [],
        fuse: null,
        searchIndex: [],
        
        async init() {
            // Get search query from URL if present
            const urlParams = new URLSearchParams(window.location.search);
            this.searchQuery = urlParams.get('q') || '';
            
            // Fetch search index
            const response = await fetch('/index.json');
            this.searchIndex = await response.json();
            
            // Initialize Fuse.js
            this.fuse = new Fuse(this.searchIndex, {
                keys: ['title', 'content', 'categories', 'tags'],
                includeScore: true,
                threshold: 0.4,
            });
            
            // Perform initial search if query exists
            if (this.searchQuery) {
                this.performSearch();
            }
        },
        
        performSearch() {
            if (!this.searchQuery) {
                this.searchResults = [];
                return;
            }
            
            const results = this.fuse.search(this.searchQuery);
            this.searchResults = results.map(result => result.item);
            
            // Update URL with search query
            const url = new URL(window.location);
            url.searchParams.set('q', this.searchQuery);
            window.history.pushState({}, '', url);
        }
    }
}
</script>
{{ end }}```

## File: layouts/_default/index.json
```
{{- $.Scratch.Add "index" slice -}}
{{- range where .Site.RegularPages "Type" "posts" -}}
    {{- $.Scratch.Add "index" (dict 
        "title" .Title 
        "content" (.Plain | htmlUnescape) 
        "permalink" .Permalink 
        "summary" (.Summary | plainify | htmlUnescape) 
        "categories" .Params.categories 
        "tags" .Params.tags 
        "date" (.Date.Format "January 2, 2006")
    ) -}}
{{- end -}}
{{- $.Scratch.Get "index" | jsonify -}}```

## File: layouts/partials/hero.html
```
<section class="hero">
    <div class="container">
        {{ if .IsHome }}
            <h1 class="hero-title">Latest Articles</h1>
        {{ else }}
            <h1 class="hero-title">{{ .Title }}</h1>
            {{ with .Description }}
                <p class="hero-description">{{ . }}</p>
            {{ end }}
        {{ end }}
    </div>
</section>```

## File: layouts/partials/post-hero.html
```
<div class="post-hero">
    {{ if .Params.image }}
    <div class="post-hero-image">
        <img src="{{ .Params.image }}" alt="{{ .Title }}">
    </div>
    {{ end }}
    <div class="post-hero-overlay"></div>
    <div class="container">
        <div class="post-hero-content">
            {{ range .Params.categories }}
                <span class="category-tag">{{ . }}</span>
            {{ end }}
            <h1 class="post-hero-title">{{ .Title }}</h1>
            {{ with .Description }}
                <p class="post-hero-description">{{ . }}</p>
            {{ end }}
            <div class="post-meta">
                <span class="post-date">{{ .Date.Format "January 2, 2006" }}</span>
                <span class="reading-time">{{ .ReadingTime }} min read</span>
            </div>
        </div>
    </div>
</div>```

## File: layouts/partials/image.html
```
{{ $img := . }}
<div class="relative overflow-hidden"
     x-data="{ loaded: false }"
     x-intersect:enter="$el.querySelector('img').loading = 'eager'">
    <img src="{{ $img }}" 
         loading="lazy"
         decoding="async"
         class="w-full h-full object-cover transition duration-700 ease-out"
         x-ref="image"
         @load="loaded = true"
         :class="{ 'opacity-0': !loaded, 'opacity-100': loaded }">
    
    <!-- Loading placeholder -->
    <div x-show="!loaded" 
         class="absolute inset-0 bg-gray-200 dark:bg-gray-700 animate-pulse">
    </div>
</div>```

## File: layouts/partials/pagination.html
```
{{ if gt .Paginator.TotalPages 1 }}
<nav class="flex justify-center items-center gap-2 mt-12">
    {{ if .Paginator.HasPrev }}
    <a href="{{ .Paginator.Prev.URL }}" class="w-10 h-10 flex items-center justify-center rounded border border-gray-200 hover:border-primary hover:text-primary transition">←</a>
    {{ end }}
    
    {{ range .Paginator.Pagers }}
    <a href="{{ .URL }}" class="w-10 h-10 flex items-center justify-center rounded {{ if eq . $.Paginator }}bg-primary text-white{{ else }}border border-gray-200 hover:border-primary hover:text-primary{{ end }} transition">
        {{ .PageNumber }}
    </a>
    {{ end }}
    
    {{ if .Paginator.HasNext }}
    <a href="{{ .Paginator.Next.URL }}" class="w-10 h-10 flex items-center justify-center rounded border border-gray-200 hover:border-primary hover:text-primary transition">→</a>
    {{ end }}
</nav>
{{ end }}```

## File: layouts/partials/toc.html
```
{{ if and (gt .WordCount 400) (.TableOfContents) }}
<div x-data="{ isOpen: true }" class="toc-wrapper mb-8">
    <button @click="isOpen = !isOpen" 
            class="flex items-center justify-between w-full p-4 bg-gray-100 dark:bg-gray-800 rounded-lg">
        <span class="font-medium">Table of Contents</span>
        <svg :class="{'rotate-180': !isOpen}" 
             class="w-5 h-5 transform transition-transform" 
             fill="none" 
             stroke="currentColor" 
             viewBox="0 0 24 24">
            <path stroke-linecap="round" 
                  stroke-linejoin="round" 
                  stroke-width="2" 
                  d="M19 9l-7 7-7-7" />
        </svg>
    </button>
    
    <div x-show="isOpen"
         x-collapse
         class="mt-4 prose dark:prose-dark max-w-none">
        {{ .TableOfContents }}
    </div>
</div>
{{ end }}```

## File: layouts/partials/share-buttons.html
```
<div x-data="{ showShare: false }" class="relative">
    <button @click="showShare = !showShare"
            class="flex items-center gap-2 text-gray-500 hover:text-primary transition-colors">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                  d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"/>
        </svg>
        <span>Share</span>
    </button>
    
    <div x-show="showShare"
         @click.away="showShare = false"
         x-transition
         class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 p-2 space-y-1">
        {{ $url := .Permalink }}
        {{ $title := .Title }}
        
        <!-- Twitter -->
        <a href="https://twitter.com/intent/tweet?url={{ $url }}&text={{ $title }}"
           target="_blank"
           class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
            <svg class="w-5 h-5 text-[#1DA1F2]"><path
                d="M18.244 2.25h3.308l-7.227 8.26l8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" /></svg>
            Twitter
        </a>
        
        <!-- LinkedIn -->
        <a href="https://www.linkedin.com/shareArticle?mini=true&url={{ $url }}&title={{ $title }}"
           target="_blank"
           class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
            <svg class="w-5 h-5 text-[#0A66C2]"><path
                d="M6.94 5a2 2 0 1 1-4-.002a2 2 0 0 1 4 .002zM7 8.48H3V21h4V8.48zm6.32 0H9.34V21h3.94v-6.57c0-3.66 4.77-4 4.77 0V21H22v-7.93c0-6.17-7.06-5.94-8.72-2.91l.04-1.68z" /></svg>
            LinkedIn
        </a>
        
        <!-- Facebook -->
        <a href="https://www.facebook.com/sharer/sharer.php?u={{ $url }}"
           target="_blank"
           class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
            <svg class="w-5 h-5 text-[#1877F2]"><path
                d="M9.198 21.5h4v-8.01h3.604l.396-3.98h-4V7.5a1 1 0 0 1 1-1h3v-4h-3a5 5 0 0 0-5 5v2.01h-2l-.396 3.98h2.396v8.01Z" /></svg>
            Facebook
        </a>
        
        <!-- Copy Link -->
        <button @click="navigator.clipboard.writeText('{{ $url }}');
                       $el.querySelector('span').textContent = 'Copied!';
                       setTimeout(() => $el.querySelector('span').textContent = 'Copy Link', 2000)"
                class="flex items-center gap-3 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors w-full">
            <svg class="w-5 h-5"><path
                d="M9.198 21.5h4v-8.01h3.604l.396-3.98h-4V7.5a1 1 0 0 1 1-1h3v-4h-3a5 5 0 0 0-5 5v2.01h-2l-.396 3.98h2.396v8.01Z" /></svg>
            <span>Copy Link</span>
        </button>
    </div>
</div>```

## File: layouts/partials/terms.html
```
{{- /*
For a given taxonomy, renders a list of terms assigned to the page.

@context {page} page The current page.
@context {string} taxonomy The taxonomy.

@example: {{ partial "terms.html" (dict "taxonomy" "tags" "page" .) }}
*/}}

{{- $page := .page }}
{{- $taxonomy := .taxonomy }}

{{- with $page.GetTerms $taxonomy }}
  {{- $label := (index . 0).Parent.LinkTitle }}
  <div>
    <div>{{ $label }}:</div>
    <ul>
      {{- range . }}
        <li><a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a></li>
      {{- end }}
    </ul>
  </div>
{{- end }}
```

## File: layouts/partials/newsletter.html
```
<div x-data="newsletter()" 
     class="bg-gray-100 dark:bg-gray-800 rounded-lg p-6">
    <h3 class="text-xl font-semibold mb-4">Subscribe to Newsletter</h3>
    
    <form @submit.prevent="subscribe" class="space-y-4">
        <div>
            <label for="email" class="sr-only">Email address</label>
            <input type="email" 
                   id="email" 
                   x-model="email"
                   :disabled="status === 'loading'"
                   class="w-full px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 dark:bg-gray-700 focus:ring-2 focus:ring-primary"
                   placeholder="Enter your email"
                   required>
        </div>
        
        <button type="submit" 
                :disabled="status === 'loading'"
                class="w-full bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary/90 transition-colors disabled:opacity-50">
            <span x-show="status === 'idle'">Subscribe</span>
            <span x-show="status === 'loading'" class="flex items-center justify-center">
                <svg class="animate-spin h-5 w-5 mr-3" viewBox="0 0 24 24"><!-- Loading spinner SVG --></svg>
                Processing...
            </span>
            <span x-show="status === 'success'">✓ Subscribed!</span>
        </button>
        
        <!-- Alert Messages -->
        <div x-show="message" 
             :class="status === 'error' ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'"
             class="p-4 rounded-lg text-sm"
             x-text="message">
        </div>
    </form>
</div>

<script>
function newsletter() {
    return {
        email: '',
        status: 'idle',
        message: '',
        async subscribe() {
            this.status = 'loading';
            
            try {
                // Implement your newsletter subscription logic here
                await new Promise(resolve => setTimeout(resolve, 1000)); // Simulated delay
                
                this.status = 'success';
                this.message = 'Successfully subscribed to the newsletter!';
                
                setTimeout(() => {
                    this.message = '';
                    this.email = '';
                    this.status = 'idle';
                }, 3000);
            } catch (error) {
                this.status = 'error';
                this.message = 'An error occurred. Please try again.';
            }
        }
    }
}
</script>```

## File: layouts/partials/menu.html
```
{{- /*
Renders a menu for the given menu ID.

@context {page} page The current page.
@context {string} menuID The menu ID.

@example: {{ partial "menu.html" (dict "menuID" "main" "page" .) }}
*/}}

{{- $page := .page }}
{{- $menuID := .menuID }}

{{- with index site.Menus $menuID }}
  <nav>
    <ul>
      {{- partial "inline/menu/walk.html" (dict "page" $page "menuEntries" .) }}
    </ul>
  </nav>
{{- end }}

{{- define "partials/inline/menu/walk.html" }}
  {{- $page := .page }}
  {{- range .menuEntries }}
    {{- $attrs := dict "href" .URL }}
    {{- if $page.IsMenuCurrent .Menu . }}
      {{- $attrs = merge $attrs (dict "class" "active" "aria-current" "page") }}
    {{- else if $page.HasMenuCurrent .Menu .}}
      {{- $attrs = merge $attrs (dict "class" "ancestor" "aria-current" "true") }}
    {{- end }}
    {{- $name := .Name }}
    {{- with .Identifier }}
      {{- with T . }}
        {{- $name = . }}
      {{- end }}
    {{- end }}
    <li>
      <a
        {{- range $k, $v := $attrs }}
          {{- with $v }}
            {{- printf " %s=%q" $k $v | safeHTMLAttr }}
          {{- end }}
        {{- end -}}
      >{{ $name }}</a>
      {{- with .Children }}
        <ul>
          {{- partial "inline/menu/walk.html" (dict "page" $page "menuEntries" .) }}
        </ul>
      {{- end }}
    </li>
  {{- end }}
{{- end }}
```

## File: layouts/partials/search-modal.html
```
<div x-data="search()" 
     x-init="init()"
     @keydown.window.prevent.ctrl.k="toggleSearch()"
     @keydown.window.prevent.cmd.k="toggleSearch()">
    <!-- Search Trigger -->
    <button @click="toggleSearch()" 
            class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg flex items-center gap-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
        <span class="hidden sm:inline">Search</span>
        <span class="hidden sm:inline text-sm text-gray-400">(Ctrl + K)</span>
    </button>

    <!-- Search Modal -->
    <div x-show="isOpen" 
         x-transition
         class="fixed inset-0 z-50 overflow-y-auto p-4 sm:p-6 md:p-20"
         role="dialog"
         aria-modal="true">
        <!-- Overlay -->
        <div class="fixed inset-0 bg-gray-500 bg-opacity-25 transition-opacity" 
             @click="isOpen = false">
        </div>

        <!-- Modal -->
        <div class="mx-auto max-w-2xl transform divide-y divide-gray-100 overflow-hidden rounded-xl bg-white dark:bg-gray-800 shadow-2xl ring-1 ring-black ring-opacity-5 transition-all">
            <div class="relative">
                <!-- Search input -->
                <input type="text" 
                       x-model="searchQuery"
                       @input.debounce.300ms="performSearch()"
                       class="h-12 w-full border-0 bg-transparent pl-11 pr-4 text-gray-900 dark:text-gray-100 placeholder:text-gray-400 focus:ring-0 sm:text-sm"
                       placeholder="Search..."
                       @keydown.escape="isOpen = false">

                <!-- Search icon -->
                <div class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </div>
            </div>

            <!-- Results -->
            <div x-show="searchResults.length > 0" 
                 class="max-h-72 scroll-py-2 overflow-y-auto py-2">
                <template x-for="result in searchResults" :key="result.url">
                    <a :href="result.url" 
                       class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <h3 x-text="result.title" class="font-medium"></h3>
                        <p x-text="result.excerpt" class="text-sm text-gray-500 dark:text-gray-400"></p>
                    </a>
                </template>
            </div>

            <!-- No results -->
            <div x-show="searchQuery && searchResults.length === 0" 
                 class="p-4 text-center text-sm text-gray-500 dark:text-gray-400">
                No results found for "<span x-text="searchQuery"></span>"
            </div>
        </div>
    </div>
</div>

<script>
function search() {
    return {
        isOpen: false,
        searchQuery: '',
        searchResults: [],
        toggleSearch() {
            this.isOpen = !this.isOpen;
            if (this.isOpen) {
                this.$nextTick(() => {
                    this.$refs.searchInput.focus();
                });
            }
        },
        performSearch() {
            // Implement your search logic here
            // This is a placeholder that you'll need to customize
            this.searchResults = [
                // Your search results
            ];
        }
    }
}
</script>```

## File: layouts/partials/head/css.html
```
{{- with resources.Get "css/main.css" }}
  {{- if eq hugo.Environment "development" }}
    <link rel="stylesheet" href="{{ .RelPermalink }}">
  {{- else }}
    {{- with . | minify | fingerprint }}
      <link rel="stylesheet" href="{{ .RelPermalink }}" integrity="{{ .Data.Integrity }}" crossorigin="anonymous">
    {{- end }}
  {{- end }}
{{- end }}
```

## File: layouts/partials/head/js.html
```
{{- with resources.Get "js/main.js" }}
  {{- if eq hugo.Environment "development" }}
    {{- with . | js.Build }}
      <script src="{{ .RelPermalink }}"></script>
    {{- end }}
  {{- else }}
    {{- $opts := dict "minify" true }}
    {{- with . | js.Build $opts | fingerprint }}
      <script src="{{ .RelPermalink }}" integrity="{{- .Data.Integrity }}" crossorigin="anonymous"></script>
    {{- end }}
  {{- end }}
{{- end }}
```

## File: layouts/partials/head.html
```
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
```

## File: layouts/partials/search.html
```
<div x-data="search()" @keydown.window.prevent.cmd.k.exact="showSearch()"
    @keydown.window.prevent.ctrl.k.exact="showSearch()">
    <!-- Search Trigger Button -->
    <button @click="showSearch()"
        class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg flex items-center gap-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <span class="hidden sm:inline">Search</span>
        <span class="hidden sm:inline text-sm text-gray-400">(Ctrl K)</span>
    </button>

    <!-- Search Modal -->
    <div x-show="isOpen" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100" x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
        class="fixed inset-0 z-50 overflow-y-auto" style="display: none;">

        <!-- Overlay -->
        <div class="fixed inset-0 bg-black/50" @click="hideSearch()"></div>

        <!-- Modal -->
        <div class="relative min-h-screen flex items-center justify-center p-4">
            <div class="relative bg-white dark:bg-gray-800 w-full max-w-2xl rounded-xl shadow-2xl"
                @click.away="hideSearch()">

                <!-- Search Input -->
                <div class="p-4 border-b dark:border-gray-700">
                    <div class="relative">
                        <input type="text" x-ref="searchInput" x-model="searchQuery"
                            @input.debounce.300ms="performSearch()" placeholder="Search posts..."
                            class="w-full px-4 py-3 pl-12 rounded-lg bg-gray-100 dark:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-primary">
                        <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none"
                            stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                </div>

                <!-- Results list -->
                <div class="space-y-8">
                    <template x-for="result in searchResults" :key="result.permalink">
                        <article class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                            <div class="flex gap-2 mb-3">
                                <template x-for="category in result.categories" :key="category">
                                    <span class="text-xs bg-secondary/20 text-dark dark:text-white px-2 py-1 rounded"
                                        x-text="category"></span>
                                </template>
                            </div>
                            <h2 class="text-xl font-semibold mb-2">
                                <a :href="result.permalink" x-text="result.title"
                                    class="hover:text-primary transition-colors"></a>
                            </h2>
                            <!-- Use textContent to properly display formatted text -->
                            <p class="text-gray-600 dark:text-gray-300 mb-4"
                                x-text="result.summary.length > 200 ? result.summary.substring(0, 200) + '...' : result.summary">
                            </p>
                            <div class="flex items-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                                <span x-text="result.date"></span>
                                <a :href="result.permalink"
                                    class="text-primary hover:text-primary/80 transition-colors">
                                    Read More →
                                </a>
                            </div>
                        </article>
                    </template>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2"></script>
<script>
    function search() {
        return {
            searchQuery: '',
            searchResults: [],
            fuse: null,
            searchIndex: [],

            async init() {
                const urlParams = new URLSearchParams(window.location.search);
                this.searchQuery = urlParams.get('q') || '';

                try {
                    const response = await fetch('/index.json');
                    this.searchIndex = await response.json();

                    // Initialize Fuse.js with better content handling
                    this.fuse = new Fuse(this.searchIndex, {
                        keys: [
                            {
                                name: 'title',
                                weight: 0.8
                            },
                            {
                                name: 'content',
                                weight: 0.5
                            },
                            {
                                name: 'summary',
                                weight: 0.7
                            },
                            {
                                name: 'categories',
                                weight: 0.3
                            },
                            {
                                name: 'tags',
                                weight: 0.3
                            }
                        ],
                        includeScore: true,
                        threshold: 0.4,
                        ignoreLocation: true,
                        useExtendedSearch: true
                    });

                    if (this.searchQuery) {
                        this.performSearch();
                    }
                } catch (error) {
                    console.error('Error loading search index:', error);
                }
            },

            performSearch() {
                if (!this.searchQuery) {
                    this.searchResults = [];
                    return;
                }

                const results = this.fuse.search(this.searchQuery);
                this.searchResults = results.map(result => {
                    return {
                        ...result.item,
                        // Clean up the summary
                        summary: result.item.summary
                            .replace(/(<([^>]+)>)/gi, '') // Remove HTML tags
                            .replace(/&nbsp;/g, ' ')      // Replace &nbsp; with spaces
                            .replace(/\s+/g, ' ')         // Normalize whitespace
                            .trim()
                    };
                });

                const url = new URL(window.location);
                url.searchParams.set('q', this.searchQuery);
                window.history.pushState({}, '', url);
            }
        }
    }
</script>```

## File: layouts/partials/footer.html
```
<footer class="bg-black text-white">
    <!-- Social Icons Grid -->
    <div class="flex flex-wrap justify-center border-y border-white/10">
        {{ with .Site.Params.social }}
        {{ with .facebook }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="Facebook">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M9.198 21.5h4v-8.01h3.604l.396-3.98h-4V7.5a1 1 0 0 1 1-1h3v-4h-3a5 5 0 0 0-5 5v2.01h-2l-.396 3.98h2.396v8.01Z" />
            </svg>
        </a>
        {{ end }}
        {{ with .linkedin }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="LinkedIn">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M6.94 5a2 2 0 1 1-4-.002a2 2 0 0 1 4 .002zM7 8.48H3V21h4V8.48zm6.32 0H9.34V21h3.94v-6.57c0-3.66 4.77-4 4.77 0V21H22v-7.93c0-6.17-7.06-5.94-8.72-2.91l.04-1.68z" />
            </svg>
        </a>
        {{ end }}
        {{ with .github }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="GitHub">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z" />
            </svg>
        </a>
        {{ end }}
        {{ with .tiktok }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="TikTok">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M19.321 5.562a5.124 5.124 0 0 1 .264 1.635V9.79h3.558V7.197A7.129 7.129 0 0 0 19.321 0h-2.563v14.027a3.792 3.792 0 0 1-7.58.08V7.197A7.129 7.129 0 0 0 5.356 0H2.793v14.027a6.363 6.363 0 0 0 12.722.16V7.197a7.129 7.129 0 0 0 3.806 5.537z" />
            </svg>
        </a>
        {{ end }}
        {{ with .twitter }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="Twitter">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M18.244 2.25h3.308l-7.227 8.26l8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
            </svg>
        </a>
        {{ end }}
        {{ with .medium }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="Medium">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M13.54 12a6.8 6.8 0 01-6.77 6.82A6.8 6.8 0 010 12a6.8 6.8 0 016.77-6.82A6.8 6.8 0 0113.54 12zM20.96 12c0 3.54-1.51 6.42-3.38 6.42-1.87 0-3.39-2.88-3.39-6.42s1.52-6.42 3.39-6.42 3.38 2.88 3.38 6.42M24 12c0 3.17-.53 5.75-1.19 5.75-.66 0-1.19-2.58-1.19-5.75s.53-5.75 1.19-5.75C23.47 6.25 24 8.83 24 12z" />
            </svg>
        </a>
        {{ end }}
        {{ with .instagram }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="Instagram">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M12 2c2.717 0 3.056.01 4.122.06c1.065.05 1.79.217 2.428.465c.66.254 1.216.598 1.772 1.153a4.908 4.908 0 0 1 1.153 1.772c.247.637.415 1.363.465 2.428c.047 1.066.06 1.405.06 4.122c0 2.717-.01 3.056-.06 4.122c-.05 1.065-.218 1.79-.465 2.428a4.883 4.883 0 0 1-1.153 1.772a4.915 4.915 0 0 1-1.772 1.153c-.637.247-1.363.415-2.428.465c-1.066.047-1.405.06-4.122.06c-2.717 0-3.056-.01-4.122-.06c-1.065-.05-1.79-.218-2.428-.465a4.89 4.89 0 0 1-1.772-1.153a4.904 4.904 0 0 1-1.153-1.772c-.248-.637-.415-1.363-.465-2.428C2.013 15.056 2 14.717 2 12c0-2.717.01-3.056.06-4.122c.05-1.066.217-1.79.465-2.428a4.88 4.88 0 0 1 1.153-1.772A4.897 4.897 0 0 1 5.45 2.525c.638-.248 1.362-.415 2.428-.465C8.944 2.013 9.283 2 12 2zm0 5a5 5 0 1 0 0 10a5 5 0 0 0 0-10zm6.5-.25a1.25 1.25 0 0 0-2.5 0a1.25 1.25 0 0 0 2.5 0zM12 9a3 3 0 1 1 0 6a3 3 0 0 1 0-6z" />
            </svg>
        </a>
        {{ end }}
        {{ with .youtube }}
        <a href="{{ . }}" class="flex-[1_1_200px] flex items-center justify-center p-8 border-r border-white/10 last:border-r-0 hover:bg-white/5 transition" aria-label="YouTube">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
            </svg>
        </a>
        {{ end }}

    </div>
    {{ end }}

    <!-- Bottom Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex flex-col md:flex-row justify-between items-center gap-4">
            <div class="flex flex-wrap justify-center md:justify-start gap-6">
                <a href="{{ .Site.BaseURL }}" class="text-white/80 hover:text-white transition">
                    © {{ now.Format "2006" }} {{ .Site.Title }}
                </a>
            </div>
            <div class="flex flex-wrap justify-center md:justify-end gap-6">
                <a href="/terms" class="text-white/80 hover:text-white transition">Terms & Conditions</a>
                <a href="/privacy" class="text-white/80 hover:text-white transition">Privacy Policy</a>
                <a href="/cookie" class="text-white/80 hover:text-white transition">Cookie Policy</a>
            </div>
        </div>
    </div>
</footer>```

## File: layouts/partials/sidebar.html
```
<aside class="space-y-8">
    <!-- Author Widget -->
    <div class="bg-white  rounded-lg shadow-lg p-6 text-center">
        <img src="/images/author.jpg" alt="Author" class="w-32 h-32 rounded-full mx-auto mb-4">
        <h3 class="text-xl font-semibold mb-2 dark:text-white">John Doe</h3>
        <p class="text-text-secondary dark:text-gray-300 mb-4">Tech enthusiast and frequent traveler...</p>
        <a href="/about" class="inline-block bg-primary text-white px-6 py-2 rounded-lg hover:bg-primary/90 transition">
            Know More
        </a>
    </div>

    <!-- Recent Posts -->
    <div class="bg-white  rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-semibold mb-4 pb-2 border-b border-primary">Recent Posts</h3>
        <div class="space-y-4">
            {{ range first 3 (where .Site.RegularPages "Type" "posts") }}
            <div class="flex gap-4">
                {{ if .Params.image }}
                <img src="{{ .Params.image }}" alt="{{ .Title }}" class="w-20 h-20 object-cover rounded">
                {{ end }}
                <div>
                    <h4 class="font-medium leading-snug">
                        <a href="{{ .Permalink }}" class="hover:text-primary transition">{{ .Title }}</a>
                    </h4>
                    <span class="text-sm text-text-secondary">{{ .Date.Format "Jan 2, 2006" }}</span>
                </div>
            </div>
            {{ end }}
        </div>
    </div>

    <!-- Categories -->
    <div class="bg-white  rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-semibold mb-4 pb-2 border-b border-primary">Categories</h3>
        <ul class="space-y-2">
            {{ range $name, $taxonomy := .Site.Taxonomies.categories }}
            <li>
                <a href="{{ " /categories/" | relLangURL }}{{ $name | urlize }}"
                    class="flex justify-between items-center py-2 px-3 rounded hover:bg-gray-50 transition">
                    {{ $name }}
                    <span class="bg-gray-100 text-text-secondary px-2 py-1 rounded-full text-sm">
                        {{ $taxonomy.Count }}
                    </span>
                </a>
            </li>
            {{ end }}
        </ul>
    </div>

    <!-- Tags Cloud -->
    <div class="bg-white  rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-semibold mb-4 pb-2 border-b border-primary">Tags</h3>
        <div class="flex flex-wrap gap-2">
            {{ range $name, $taxonomy := .Site.Taxonomies.tags }}
            <a href="{{ " /tags/" | relLangURL }}{{ $name | urlize }}"
                class="bg-gray-100 hover:bg-gray-200 text-text-secondary px-3 py-1 rounded-full text-sm transition">
                {{ $name }}
            </a>
            {{ end }}
        </div>
    </div>

    <!-- In sidebar.html -->
    <div class="bg-white  p-1"></div>
    <!--{{ partial "newsletter.html" . }}-->
</aside>```

## File: layouts/partials/header.html
```
<header class="fixed top-0 left-0 right-0 bg-white dark:bg-gray-900 z-50 shadow-sm transition-all duration-300" x-data="{ 
            isOpen: false,
            isScrolled: false,
            lastScrollPosition: 0,
            init() {
                window.addEventListener('scroll', () => {
                    this.isScrolled = window.pageYOffset > 0;
                    const position = window.pageYOffset;
                    if (position > this.lastScrollPosition && position > 80) {
                        this.$el.style.transform = 'translateY(-100%)';
                    } else {
                        this.$el.style.transform = 'translateY(0)';
                    }
                    this.lastScrollPosition = position;
                });
            }
        }" :class="{ 'shadow-md': isScrolled }">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16 md:h-20">
            <!-- Logo -->
            <a href="{{ .Site.BaseURL }}"
                class="text-xl font-bold text-dark dark:text-white hover:text-primary transition">
                {{ .Site.Title }}
            </a>

            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-8">
                {{ $currentPage := . }}
                {{ range .Site.Menus.main }}
                <a href="{{ .URL }}"
                    class="text-text-secondary dark:text-gray-300 hover:text-primary dark:hover:text-primary transition">
                    {{ .Name }}
                </a>
                {{ end }}
            </nav>

            <!-- Dark Mode Toggle & Search -->
            <div class="flex items-center gap-4">
                <!-- Dark Mode Toggle -->
                <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)"
                    class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition">
                    <svg x-show="!darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                    </svg>
                    <svg x-show="darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707" />
                    </svg>
                </button>

                <!-- Replace your search input in the header with this -->
                <a href="/search"
                    class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                    <span class="hidden sm:inline">Search</span>
                </a>
            </div>
        </div>
    </div>
</header>```

# Static CSS Files
## File: static/css/.keep
```
```

## File: hugo.toml
```
baseURL = 'https://example.org/'
languageCode = 'en-US'
title = 'My New Hugo Site'

[[menus.main]]
name = 'Home'
pageRef = '/'
weight = 10

[[menus.main]]
name = 'Posts'
pageRef = '/posts'
weight = 20

[[menus.main]]
name = 'Tags'
pageRef = '/tags'
weight = 30

[menu]
  [[menu.main]]
    name = "Home"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "Blog"
    url = "/blog/"
    weight = 2

[module]
  [module.hugoVersion]
    extended = false
    min = "0.116.0"

[related]
  includeNewer = true
  threshold = 80
  toLower = false

  [[related.indices]]
    name = "categories"
    weight = 100

  [[related.indices]]
    name = "tags"
    weight = 80

  [[related.indices]]
    name = "date"
    weight = 10

[outputs]
  home = ["HTML", "RSS", "JSON"]```

## File: theme.toml
```
name = "Oloodi Hugo Clean"
license = "MIT"
licenselink = "https://github.com/bwnyasse/oloodi-hugo-clean/blob/main/LICENSE"
description = "A simple, clean, modern Hugo theme with dark mode support and search functionality"
homepage = "https://github.com/bwnyasse/oloodi-hugo-clean"
demosite = "https://bwnyasse.net"
tags = ["blog", "responsive", "personal", "dark mode", "search"]
features = ["dark mode", "search", "responsive", "clean design"]
min_version = "0.80.0"

[author]
  name = "Boris-Wilfried"
  homepage = "https://bwnyasse.net"```

## File: README.md
```
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

# Credits

- Built with Hugo
- Styled with Tailwind CSS
- Search powered by Fuse.js
- Icons from Heroicons

# License

This theme is released under the MIT License. See the LICENSE file for details.

```

