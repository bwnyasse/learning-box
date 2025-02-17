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
                (dict "title" "Google Developer Expert" "description" "Experienced Google technology experts, influencers, and thought leaders." "image" "/images/project1.jpg" "link" "https://developers.google.com/community/experts/directory/profile/profile-boriswilfried_nyasse")
                (dict "title" "Oloodi" "description" "Empowering Communities Through Innovation" "image" "/images/project2.jpg" "link" "https://oloodi.com/")
                (dict "title" "Engineer Manager" "description" "Senior Director of Software Development @Datavalet" "image" "/images/project3.jpg" "link" "https://www.linkedin.com/in/bwnyasse")
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
                <a href="{{ .link }}" target="_blank" 
  class="absolute inset-0" aria-label="View {{ .title }}"></a>
            </div>
            {{ end }}
        </div>
    </div>
</section>
{{ end }}```

## File: layouts/posts/list.html
```
{{ define "main" }}

<div class="bg-gray-100 dark:bg-gray-900 min-h-screen">
    
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pt-20">
        <div class="p-3"></div>
        <!-- Header -->
        <div class="text-center mb-16">
            <h1 class="text-4xl font-bold text-gray-900 dark:text-white">Articles</h1>
            <p class="mt-4 text-lg text-gray-600 dark:text-gray-400">
                {{ len .Pages }} published posts
            </p>
            <div class="p-3"></div>
        </div>

        <!-- Posts List -->
        <div class="space-y-8">  <!-- Increased space between cards -->
            {{ range .Pages.ByDate.Reverse }}
            <article class="bg-white dark:bg-gray-800 rounded-xl 
                          shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] 
                          dark:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.2)] 
                          hover:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.1),0_10px_20px_-2px_rgba(0,0,0,0.06)] 
                          dark:hover:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.3)] 
                          transition-all duration-300 
                          p-8">  <!-- Increased padding -->
                <!-- Metadata (Date and Reading Time) -->
                <div class="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 mb-3">
                    <time>{{ .Date.Format "January 2, 2006" }}</time>
                    <span>•</span>
                    <span>{{ .ReadingTime }} min read</span>
                </div>

                <!-- Title -->
                <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
                    <a href="{{ .Permalink }}" class="hover:text-primary transition-colors">{{ .Title }}</a>
                </h2>

                <!-- Description -->
                <p class="text-gray-600 dark:text-gray-300 mb-6">  <!-- Increased margin -->
                    {{ with .Description }}
                        {{ . }}
                    {{ else }}
                        {{ .Summary | plainify | truncate 160 }}
                    {{ end }}
                </p>
            
                <!-- Categories and Tags -->
                <div class="flex flex-wrap gap-3 items-center mt-6 pt-6 border-t border-gray-200 dark:border-gray-700">
                    {{ with .Params.categories }}
                        {{ range . }}
                        <a href="{{ "/categories/" | relLangURL }}{{ . | urlize }}" 
                           class="bg-secondary/20 text-dark dark:text-white px-4 py-1.5 rounded-md text-sm 
                                  hover:bg-secondary/30 transition-colors">
                            {{ . }}
                        </a>
                        {{ end }}
                    {{ end }}

                    {{ with .Params.tags }}
                        {{ range . }}
                        <a href="{{ "/tags/" | relLangURL }}{{ . | urlize }}" 
                           class="text-sm text-gray-500 dark:text-gray-400 hover:text-primary transition-colors">
                            #{{ . }}
                        </a>
                        {{ end }}
                    {{ end }}
                </div>
            </article>
            {{ end }}
        </div>

        <!-- Bottom Spacing -->
        <div class="h-24"></div>
    </div>
    <div class="p-3"></div>
</div>
{{ end }}```

## File: layouts/privacy/single.html
```
{{ define "main" }}
<div class="bg-white dark:bg-gray-900 min-h-screen">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16">
        <!-- Page Header -->
        <div class="p-3"></div>
        <div class="text-center mb-12">
            <h1 class="text-4xl font-bold text-gray-900 dark:text-white">{{ .Title }}</h1>
        </div>

        <!-- Page Content -->
        <div class="prose prose-lg dark:prose-invert max-w-none">
            {{ .Content }}
        </div>
    </div>
</div>
{{ end }}```

## File: layouts/privacy/list.html
```
<!-- themes/oloodi-hugo-clean/layouts/privacy/list.html -->
{{ define "main" }}
{{ .Content }}
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
            <div class="p-3"></div>
        </div>
        <!-- Sidebar -->
        {{ partial "sidebar.html" . }}
    </div>
</div>
{{ end }}```

## File: layouts/tags/terms.html
```
{{ define "main" }}

<div class="bg-gray-100 dark:bg-gray-900 min-h-screen">
    
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pt-20">
        <div class="p-3"></div>
        <!-- Header -->
        <div class="text-center mb-16">
            <h1 class="text-4xl font-bold text-gray-900 dark:text-white">Tags</h1>
            <p class="mt-4 text-lg text-gray-600 dark:text-gray-400">
                Browse articles by topic
            </p>
            <div class="p-3"></div>
        </div>

        <!-- Tags Cloud -->
        <div class="max-w-4xl mx-auto mb-16">
            <div class="flex flex-wrap justify-center gap-4">
                {{ range .Data.Terms.Alphabetical }}
                <a href="{{ .Page.Permalink }}" 
                   class="group relative inline-flex items-center px-6 py-3 bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-md transition-all duration-200">
                    <span class="text-gray-900 dark:text-white font-medium group-hover:text-primary transition-colors">
                        #{{ .Page.Title }}
                    </span>
                    <span class="ml-2 px-2 py-1 text-sm bg-gray-100 dark:bg-gray-700 rounded-full">
                        {{ .Count }}
                    </span>
                </a>
                {{ end }}
            </div>
        </div>

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
                <div class="prose prose-lg dark:prose-invert prose-pre:p-0 prose-pre:bg-transparent max-w-none">
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

## File: layouts/_default/taxonomy.html
```
{{ define "main" }}
<div class="bg-gray-100 dark:bg-gray-900 min-h-screen">
    
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pt-20">
        <div class="p-3"></div>
        <!-- Tag Header -->
        <div class="text-center mb-16">
            <h1 class="text-primary text-4xl font-bold text-gray-900 dark:text-white">#{{ .Title }}</h1>
            <p class="mt-4 text-lg text-gray-600 dark:text-gray-400">
                {{ len .Pages }} {{ if eq (len .Pages) 1 }}Post{{ else }}Posts{{ end }} tagged with "{{ .Title }}"
            </p>
            <div class="p-3"></div>
        </div>
        <!-- Posts with this tag -->
        <div class="space-y-8"> 
            {{ range .Pages.ByDate.Reverse }}
            <article class="bg-white dark:bg-gray-800 rounded-xl 
                          shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] 
                          dark:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.2)] 
                          hover:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.1),0_10px_20px_-2px_rgba(0,0,0,0.06)] 
                          dark:hover:shadow-[0_2px_15px_-3px_rgba(0,0,0,0.3)] 
                          transition-all duration-300 
                          p-8">  <!-- Increased padding -->
                <!-- Metadata (Date and Reading Time) -->
                <div class="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 mb-3">
                    <time>{{ .Date.Format "January 2, 2006" }}</time>
                    <span>•</span>
                    <span>{{ .ReadingTime }} min read</span>
                </div>

                <!-- Title -->
                <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
                    <a href="{{ .Permalink }}" class="hover:text-primary transition-colors">{{ .Title }}</a>
                </h2>

                <!-- Description -->
                <p class="text-gray-600 dark:text-gray-300 mb-6">  <!-- Increased margin -->
                    {{ with .Description }}
                        {{ . }}
                    {{ else }}
                        {{ .Summary | plainify | truncate 160 }}
                    {{ end }}
                </p>
            
                <!-- Categories and Tags -->
                <div class="flex flex-wrap gap-3 items-center mt-6 pt-6 border-t border-gray-200 dark:border-gray-700">
                    {{ with .Params.categories }}
                        {{ range . }}
                        <a href="{{ "/categories/" | relLangURL }}{{ . | urlize }}" 
                           class="bg-secondary/20 text-dark dark:text-white px-4 py-1.5 rounded-md text-sm 
                                  hover:bg-secondary/30 transition-colors">
                            {{ . }}
                        </a>
                        {{ end }}
                    {{ end }}

                    {{ with .Params.tags }}
                        {{ range . }}
                        <a href="{{ "/tags/" | relLangURL }}{{ . | urlize }}" 
                           class="text-sm text-gray-500 dark:text-gray-400 hover:text-primary transition-colors">
                            #{{ . }}
                        </a>
                        {{ end }}
                    {{ end }}
                </div>
            </article>
            {{ end }}
        </div>

        <!-- Bottom Spacing -->
        <div class="h-24"></div>
    </div>
    <div class="p-3"></div>
</div>
{{ end }}```

## File: layouts/_default/baseof.html
```
<!DOCTYPE html>
<html lang="{{ .Site.LanguageCode | default " en" }}">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- SEO Meta Tags -->
    <title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
    <meta name="description" content="{{ with .Description }}{{ . }}{{ else }}{{ if .IsHome }}{{ .Site.Params.description }}{{ else }}{{ with .Summary }}{{ . }}{{ end }}{{ end }}{{ end }}">
    <meta name="author" content="{{ .Site.Params.author }}">
    <link rel="canonical" href="{{ .Permalink }}">
    <link rel="icon" type="image/x-icon" href="/images/favicon.png">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="{{ if .IsPage }}article{{ else }}website{{ end }}">
    <meta property="og:url" content="{{ .Permalink }}">
    <meta property="og:title" content="{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}">
    <meta property="og:description" content="{{ with .Description }}{{ . }}{{ else }}{{ if .IsHome }}{{ .Site.Params.description }}{{ else }}{{ with .Summary }}{{ . }}{{ end }}{{ end }}{{ end }}">
    {{ with .Params.socialImage }}
    <meta property="og:image" content="{{ . | absURL }}">
    {{ else }}
    {{ with .Params.image }}
    <meta property="og:image" content="{{ . | absURL }}">
    {{ else }}
    <meta property="og:image" content="{{ .Site.Params.defaultSocialImage | absURL }}">
    {{ end }}
    {{ end }}
    
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="{{ .Permalink }}">
    <meta name="twitter:title" content="{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}">
    <meta name="twitter:description" content="{{ with .Description }}{{ . }}{{ else }}{{ if .IsHome }}{{ .Site.Params.description }}{{ else }}{{ with .Summary }}{{ . }}{{ end }}{{ end }}{{ end }}">
    {{ with .Params.socialImage }}
    <meta name="twitter:image" content="{{ . | absURL }}">
    {{ else }}
    {{ with .Params.image }}
    <meta name="twitter:image" content="{{ . | absURL }}">
    {{ else }}
    <meta name="twitter:image" content="{{ .Site.Params.defaultSocialImage | absURL }}">
    {{ end }}
    {{ end }}
    {{ with .Site.Params.twitter }}
    <meta name="twitter:creator" content="@{{ . }}">
    <meta name="twitter:site" content="@{{ . }}">
    {{ end }}
    
    <!-- Schema.org -->
    <!-- Include structured data -->
    {{ partial "structured-data.html" . }}

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family={{ site.Data.theme.theme.font_primary }}:wght@{{ site.Data.theme.theme.font_weights }}&family={{ site.Data.theme.theme.font_secondary }}:wght@400,500,600,700&display=swap" rel="stylesheet">

    <!-- Styles -->
    <link rel="stylesheet" href="{{ "css/style.css" | relURL }}">

    <!-- Scripts -->
    <script defer src="{{ "js/main.js" | relURL }}"></script>
   
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

## File: layouts/partials/structured-data.html
```
{{ if .IsPage }}
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    "headline": "{{ .Title }}",
    "image": {{ with .Params.socialImage }}["{{ . | absURL }}"]{{ else }}{{ with .Params.image }}["{{ . | absURL }}"]{{ else }}["{{ .Site.Params.defaultSocialImage | absURL }}"]{{ end }}{{ end }},
    "datePublished": "{{ .Date.Format "2006-01-02" }}",
    "dateModified": "{{ .Lastmod.Format "2006-01-02" }}",
    "author": {
        "@type": "Person",
        "name": "{{ .Site.Params.author }}"
    },
    "publisher": {
        "@type": "Organization",
        "name": "{{ .Site.Title }}",
        "logo": {
            "@type": "ImageObject",
            "url": "{{ .Site.Params.logo | absURL }}"
        }
    },
    "description": "{{ with .Description }}{{ . }}{{ else }}{{ .Summary }}{{ end }}",
    "keywords": {{ .Params.tags | jsonify }},
    "url": "{{ .Permalink }}"
}
</script>
{{ end }}```

## File: layouts/partials/head.html
```
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
```

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
                <a href="/privacy" class="text-white/80 hover:text-white transition">Privacy Policy</a>
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
        <h3 class="text-xl font-semibold mb-2 dark:text-white">Boris-Wilfried Doe</h3>
        <p class="text-text-secondary dark:text-gray-300 mb-4">Tech enthusiast & Developer ...</p>
        <a href="/" class="inline-block bg-primary text-white px-6 py-2 rounded-lg hover:bg-primary/90 transition">
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
<header class="fixed top-0 left-0 right-0 bg-white dark:bg-gray-900 z-50 shadow-sm transition-all duration-300"
        x-data="{ 
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
        }"
        :class="{ 'shadow-md': isScrolled }">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16 md:h-20">
            <!-- Logo -->
            <a href="{{ .Site.BaseURL }}" 
               class="text-xl font-bold text-dark dark:text-white hover:text-primary transition">
                {{ .Site.Title }}
            </a>

            <!-- Mobile Menu Button -->
            <button @click="isOpen = !isOpen" 
                    class="md:hidden inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 focus:outline-none"
                    aria-expanded="false">
                <span class="sr-only">Open main menu</span>
                <!-- Icon when menu is closed -->
                <svg x-show="!isOpen" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                </svg>
                <!-- Icon when menu is open -->
                <svg x-show="isOpen" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>

            <!-- Desktop Navigation -->
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
            <div class="hidden md:flex items-center gap-4">
                <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)"
                        class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition">
                    <svg x-show="!darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                    </svg>
                    <svg x-show="darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707"/>
                    </svg>
                </button>

                <a href="/search" class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    <span class="hidden sm:inline">Search</span>
                </a>
            </div>
        </div>

        <!-- Mobile Menu -->
        <div x-show="isOpen" 
             x-transition:enter="transition ease-out duration-200"
             x-transition:enter-start="opacity-0 -translate-y-1"
             x-transition:enter-end="opacity-100 translate-y-0"
             x-transition:leave="transition ease-in duration-150"
             x-transition:leave-start="opacity-100 translate-y-0"
             x-transition:leave-end="opacity-0 -translate-y-1"
             class="md:hidden">
            <div class="px-2 pt-2 pb-3 space-y-1">
                {{ range .Site.Menus.main }}
                <a href="{{ .URL }}" 
                   class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:text-primary dark:hover:text-primary hover:bg-gray-50 dark:hover:bg-gray-800">
                    {{ .Name }}
                </a>
                {{ end }}
                <!-- Mobile Dark Mode and Search -->
                <div class="flex items-center justify-start gap-4 px-3 py-2">
                    <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)"
                            class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition">
                        <svg x-show="!darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                        </svg>
                        <svg x-show="darkMode" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707"/>
                        </svg>
                    </button>
                    <a href="/search" class="flex items-center gap-2 text-gray-700 dark:text-gray-300">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                        Search
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>```

# Static CSS Files
## File: static/css/style.css
```
*, ::before, ::after {
  --tw-border-spacing-x: 0;
  --tw-border-spacing-y: 0;
  --tw-translate-x: 0;
  --tw-translate-y: 0;
  --tw-rotate: 0;
  --tw-skew-x: 0;
  --tw-skew-y: 0;
  --tw-scale-x: 1;
  --tw-scale-y: 1;
  --tw-pan-x:  ;
  --tw-pan-y:  ;
  --tw-pinch-zoom:  ;
  --tw-scroll-snap-strictness: proximity;
  --tw-gradient-from-position:  ;
  --tw-gradient-via-position:  ;
  --tw-gradient-to-position:  ;
  --tw-ordinal:  ;
  --tw-slashed-zero:  ;
  --tw-numeric-figure:  ;
  --tw-numeric-spacing:  ;
  --tw-numeric-fraction:  ;
  --tw-ring-inset:  ;
  --tw-ring-offset-width: 0px;
  --tw-ring-offset-color: #fff;
  --tw-ring-color: rgb(59 130 246 / 0.5);
  --tw-ring-offset-shadow: 0 0 #0000;
  --tw-ring-shadow: 0 0 #0000;
  --tw-shadow: 0 0 #0000;
  --tw-shadow-colored: 0 0 #0000;
  --tw-blur:  ;
  --tw-brightness:  ;
  --tw-contrast:  ;
  --tw-grayscale:  ;
  --tw-hue-rotate:  ;
  --tw-invert:  ;
  --tw-saturate:  ;
  --tw-sepia:  ;
  --tw-drop-shadow:  ;
  --tw-backdrop-blur:  ;
  --tw-backdrop-brightness:  ;
  --tw-backdrop-contrast:  ;
  --tw-backdrop-grayscale:  ;
  --tw-backdrop-hue-rotate:  ;
  --tw-backdrop-invert:  ;
  --tw-backdrop-opacity:  ;
  --tw-backdrop-saturate:  ;
  --tw-backdrop-sepia:  ;
  --tw-contain-size:  ;
  --tw-contain-layout:  ;
  --tw-contain-paint:  ;
  --tw-contain-style:  ;
}

::backdrop {
  --tw-border-spacing-x: 0;
  --tw-border-spacing-y: 0;
  --tw-translate-x: 0;
  --tw-translate-y: 0;
  --tw-rotate: 0;
  --tw-skew-x: 0;
  --tw-skew-y: 0;
  --tw-scale-x: 1;
  --tw-scale-y: 1;
  --tw-pan-x:  ;
  --tw-pan-y:  ;
  --tw-pinch-zoom:  ;
  --tw-scroll-snap-strictness: proximity;
  --tw-gradient-from-position:  ;
  --tw-gradient-via-position:  ;
  --tw-gradient-to-position:  ;
  --tw-ordinal:  ;
  --tw-slashed-zero:  ;
  --tw-numeric-figure:  ;
  --tw-numeric-spacing:  ;
  --tw-numeric-fraction:  ;
  --tw-ring-inset:  ;
  --tw-ring-offset-width: 0px;
  --tw-ring-offset-color: #fff;
  --tw-ring-color: rgb(59 130 246 / 0.5);
  --tw-ring-offset-shadow: 0 0 #0000;
  --tw-ring-shadow: 0 0 #0000;
  --tw-shadow: 0 0 #0000;
  --tw-shadow-colored: 0 0 #0000;
  --tw-blur:  ;
  --tw-brightness:  ;
  --tw-contrast:  ;
  --tw-grayscale:  ;
  --tw-hue-rotate:  ;
  --tw-invert:  ;
  --tw-saturate:  ;
  --tw-sepia:  ;
  --tw-drop-shadow:  ;
  --tw-backdrop-blur:  ;
  --tw-backdrop-brightness:  ;
  --tw-backdrop-contrast:  ;
  --tw-backdrop-grayscale:  ;
  --tw-backdrop-hue-rotate:  ;
  --tw-backdrop-invert:  ;
  --tw-backdrop-opacity:  ;
  --tw-backdrop-saturate:  ;
  --tw-backdrop-sepia:  ;
  --tw-contain-size:  ;
  --tw-contain-layout:  ;
  --tw-contain-paint:  ;
  --tw-contain-style:  ;
}

/*
! tailwindcss v3.4.17 | MIT License | https://tailwindcss.com
*/

/*
1. Prevent padding and border from affecting element width. (https://github.com/mozdevs/cssremedy/issues/4)
2. Allow adding a border to an element by just adding a border-width. (https://github.com/tailwindcss/tailwindcss/pull/116)
*/

*,
::before,
::after {
  box-sizing: border-box;
  /* 1 */
  border-width: 0;
  /* 2 */
  border-style: solid;
  /* 2 */
  border-color: #e5e7eb;
  /* 2 */
}

::before,
::after {
  --tw-content: '';
}

/*
1. Use a consistent sensible line-height in all browsers.
2. Prevent adjustments of font size after orientation changes in iOS.
3. Use a more readable tab size.
4. Use the user's configured `sans` font-family by default.
5. Use the user's configured `sans` font-feature-settings by default.
6. Use the user's configured `sans` font-variation-settings by default.
7. Disable tap highlights on iOS
*/

html,
:host {
  line-height: 1.5;
  /* 1 */
  -webkit-text-size-adjust: 100%;
  /* 2 */
  -moz-tab-size: 4;
  /* 3 */
  -o-tab-size: 4;
     tab-size: 4;
  /* 3 */
  font-family: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  /* 4 */
  font-feature-settings: normal;
  /* 5 */
  font-variation-settings: normal;
  /* 6 */
  -webkit-tap-highlight-color: transparent;
  /* 7 */
}

/*
1. Remove the margin in all browsers.
2. Inherit line-height from `html` so users can set them as a class directly on the `html` element.
*/

body {
  margin: 0;
  /* 1 */
  line-height: inherit;
  /* 2 */
}

/*
1. Add the correct height in Firefox.
2. Correct the inheritance of border color in Firefox. (https://bugzilla.mozilla.org/show_bug.cgi?id=190655)
3. Ensure horizontal rules are visible by default.
*/

hr {
  height: 0;
  /* 1 */
  color: inherit;
  /* 2 */
  border-top-width: 1px;
  /* 3 */
}

/*
Add the correct text decoration in Chrome, Edge, and Safari.
*/

abbr:where([title]) {
  -webkit-text-decoration: underline dotted;
          text-decoration: underline dotted;
}

/*
Remove the default font size and weight for headings.
*/

h1,
h2,
h3,
h4,
h5,
h6 {
  font-size: inherit;
  font-weight: inherit;
}

/*
Reset links to optimize for opt-in styling instead of opt-out.
*/

a {
  color: inherit;
  text-decoration: inherit;
}

/*
Add the correct font weight in Edge and Safari.
*/

b,
strong {
  font-weight: bolder;
}

/*
1. Use the user's configured `mono` font-family by default.
2. Use the user's configured `mono` font-feature-settings by default.
3. Use the user's configured `mono` font-variation-settings by default.
4. Correct the odd `em` font sizing in all browsers.
*/

code,
kbd,
samp,
pre {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  /* 1 */
  font-feature-settings: normal;
  /* 2 */
  font-variation-settings: normal;
  /* 3 */
  font-size: 1em;
  /* 4 */
}

/*
Add the correct font size in all browsers.
*/

small {
  font-size: 80%;
}

/*
Prevent `sub` and `sup` elements from affecting the line height in all browsers.
*/

sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
  vertical-align: baseline;
}

sub {
  bottom: -0.25em;
}

sup {
  top: -0.5em;
}

/*
1. Remove text indentation from table contents in Chrome and Safari. (https://bugs.chromium.org/p/chromium/issues/detail?id=999088, https://bugs.webkit.org/show_bug.cgi?id=201297)
2. Correct table border color inheritance in all Chrome and Safari. (https://bugs.chromium.org/p/chromium/issues/detail?id=935729, https://bugs.webkit.org/show_bug.cgi?id=195016)
3. Remove gaps between table borders by default.
*/

table {
  text-indent: 0;
  /* 1 */
  border-color: inherit;
  /* 2 */
  border-collapse: collapse;
  /* 3 */
}

/*
1. Change the font styles in all browsers.
2. Remove the margin in Firefox and Safari.
3. Remove default padding in all browsers.
*/

button,
input,
optgroup,
select,
textarea {
  font-family: inherit;
  /* 1 */
  font-feature-settings: inherit;
  /* 1 */
  font-variation-settings: inherit;
  /* 1 */
  font-size: 100%;
  /* 1 */
  font-weight: inherit;
  /* 1 */
  line-height: inherit;
  /* 1 */
  letter-spacing: inherit;
  /* 1 */
  color: inherit;
  /* 1 */
  margin: 0;
  /* 2 */
  padding: 0;
  /* 3 */
}

/*
Remove the inheritance of text transform in Edge and Firefox.
*/

button,
select {
  text-transform: none;
}

/*
1. Correct the inability to style clickable types in iOS and Safari.
2. Remove default button styles.
*/

button,
input:where([type='button']),
input:where([type='reset']),
input:where([type='submit']) {
  -webkit-appearance: button;
  /* 1 */
  background-color: transparent;
  /* 2 */
  background-image: none;
  /* 2 */
}

/*
Use the modern Firefox focus style for all focusable elements.
*/

:-moz-focusring {
  outline: auto;
}

/*
Remove the additional `:invalid` styles in Firefox. (https://github.com/mozilla/gecko-dev/blob/2f9eacd9d3d995c937b4251a5557d95d494c9be1/layout/style/res/forms.css#L728-L737)
*/

:-moz-ui-invalid {
  box-shadow: none;
}

/*
Add the correct vertical alignment in Chrome and Firefox.
*/

progress {
  vertical-align: baseline;
}

/*
Correct the cursor style of increment and decrement buttons in Safari.
*/

::-webkit-inner-spin-button,
::-webkit-outer-spin-button {
  height: auto;
}

/*
1. Correct the odd appearance in Chrome and Safari.
2. Correct the outline style in Safari.
*/

[type='search'] {
  -webkit-appearance: textfield;
  /* 1 */
  outline-offset: -2px;
  /* 2 */
}

/*
Remove the inner padding in Chrome and Safari on macOS.
*/

::-webkit-search-decoration {
  -webkit-appearance: none;
}

/*
1. Correct the inability to style clickable types in iOS and Safari.
2. Change font properties to `inherit` in Safari.
*/

::-webkit-file-upload-button {
  -webkit-appearance: button;
  /* 1 */
  font: inherit;
  /* 2 */
}

/*
Add the correct display in Chrome and Safari.
*/

summary {
  display: list-item;
}

/*
Removes the default spacing and border for appropriate elements.
*/

blockquote,
dl,
dd,
h1,
h2,
h3,
h4,
h5,
h6,
hr,
figure,
p,
pre {
  margin: 0;
}

fieldset {
  margin: 0;
  padding: 0;
}

legend {
  padding: 0;
}

ol,
ul,
menu {
  list-style: none;
  margin: 0;
  padding: 0;
}

/*
Reset default styling for dialogs.
*/

dialog {
  padding: 0;
}

/*
Prevent resizing textareas horizontally by default.
*/

textarea {
  resize: vertical;
}

/*
1. Reset the default placeholder opacity in Firefox. (https://github.com/tailwindlabs/tailwindcss/issues/3300)
2. Set the default placeholder color to the user's configured gray 400 color.
*/

input::-moz-placeholder, textarea::-moz-placeholder {
  opacity: 1;
  /* 1 */
  color: #9ca3af;
  /* 2 */
}

input::placeholder,
textarea::placeholder {
  opacity: 1;
  /* 1 */
  color: #9ca3af;
  /* 2 */
}

/*
Set the default cursor for buttons.
*/

button,
[role="button"] {
  cursor: pointer;
}

/*
Make sure disabled buttons don't get the pointer cursor.
*/

:disabled {
  cursor: default;
}

/*
1. Make replaced elements `display: block` by default. (https://github.com/mozdevs/cssremedy/issues/14)
2. Add `vertical-align: middle` to align replaced elements more sensibly by default. (https://github.com/jensimmons/cssremedy/issues/14#issuecomment-634934210)
   This can trigger a poorly considered lint error in some tools but is included by design.
*/

img,
svg,
video,
canvas,
audio,
iframe,
embed,
object {
  display: block;
  /* 1 */
  vertical-align: middle;
  /* 2 */
}

/*
Constrain images and videos to the parent width and preserve their intrinsic aspect ratio. (https://github.com/mozdevs/cssremedy/issues/14)
*/

img,
video {
  max-width: 100%;
  height: auto;
}

/* Make elements with the HTML hidden attribute stay hidden by default */

[hidden]:where(:not([hidden="until-found"])) {
  display: none;
}

.container {
  width: 100%;
}

@media (min-width: 640px) {
  .container {
    max-width: 640px;
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 768px;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 1024px;
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 1280px;
  }
}

@media (min-width: 1536px) {
  .container {
    max-width: 1536px;
  }
}

.prose {
  color: #111827;
  max-width: 65ch;
}

.prose :where(p):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.25em;
  margin-bottom: 1.25em;
}

.prose :where([class~="lead"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-lead);
  font-size: 1.25em;
  line-height: 1.6;
  margin-top: 1.2em;
  margin-bottom: 1.2em;
}

.prose :where(a):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #00c38e;
  text-decoration: underline;
  font-weight: 500;
}

.prose :where(a):not(:where([class~="not-prose"],[class~="not-prose"] *)):hover {
  color: rgb(0 195 142 / 80);
}

.prose :where(strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-bold);
  font-weight: 600;
}

.prose :where(a strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(blockquote strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(thead th strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(ol):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: decimal;
  margin-top: 1.25em;
  margin-bottom: 1.25em;
  padding-inline-start: 1.625em;
}

.prose :where(ol[type="A"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: upper-alpha;
}

.prose :where(ol[type="a"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: lower-alpha;
}

.prose :where(ol[type="A" s]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: upper-alpha;
}

.prose :where(ol[type="a" s]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: lower-alpha;
}

.prose :where(ol[type="I"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: upper-roman;
}

.prose :where(ol[type="i"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: lower-roman;
}

.prose :where(ol[type="I" s]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: upper-roman;
}

.prose :where(ol[type="i" s]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: lower-roman;
}

.prose :where(ol[type="1"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: decimal;
}

.prose :where(ul):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  list-style-type: disc;
  margin-top: 1.25em;
  margin-bottom: 1.25em;
  padding-inline-start: 1.625em;
}

.prose :where(ol > li):not(:where([class~="not-prose"],[class~="not-prose"] *))::marker {
  font-weight: 400;
  color: var(--tw-prose-counters);
}

.prose :where(ul > li):not(:where([class~="not-prose"],[class~="not-prose"] *))::marker {
  color: var(--tw-prose-bullets);
}

.prose :where(dt):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 600;
  margin-top: 1.25em;
}

.prose :where(hr):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  border-color: var(--tw-prose-hr);
  border-top-width: 1px;
  margin-top: 3em;
  margin-bottom: 3em;
}

.prose :where(blockquote):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 500;
  font-style: italic;
  color: var(--tw-prose-quotes);
  border-inline-start-width: 0.25rem;
  border-inline-start-color: var(--tw-prose-quote-borders);
  quotes: "\201C""\201D""\2018""\2019";
  margin-top: 1.6em;
  margin-bottom: 1.6em;
  padding-inline-start: 1em;
}

.prose :where(blockquote p:first-of-type):not(:where([class~="not-prose"],[class~="not-prose"] *))::before {
  content: open-quote;
}

.prose :where(blockquote p:last-of-type):not(:where([class~="not-prose"],[class~="not-prose"] *))::after {
  content: close-quote;
}

.prose :where(h1):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 800;
  font-size: 2.25em;
  margin-top: 0;
  margin-bottom: 0.8888889em;
  line-height: 1.1111111;
}

.prose :where(h1 strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 900;
  color: inherit;
}

.prose :where(h2):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 700;
  font-size: 1.5em;
  margin-top: 2em;
  margin-bottom: 1em;
  line-height: 1.3333333;
}

.prose :where(h2 strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 800;
  color: inherit;
}

.prose :where(h3):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 600;
  font-size: 1.25em;
  margin-top: 1.6em;
  margin-bottom: 0.6em;
  line-height: 1.6;
}

.prose :where(h3 strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 700;
  color: inherit;
}

.prose :where(h4):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 600;
  margin-top: 1.5em;
  margin-bottom: 0.5em;
  line-height: 1.5;
}

.prose :where(h4 strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 700;
  color: inherit;
}

.prose :where(img):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 2em;
  margin-bottom: 2em;
}

.prose :where(picture):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  display: block;
  margin-top: 2em;
  margin-bottom: 2em;
}

.prose :where(video):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 2em;
  margin-bottom: 2em;
}

.prose :where(kbd):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-weight: 500;
  font-family: inherit;
  color: var(--tw-prose-kbd);
  box-shadow: 0 0 0 1px rgb(var(--tw-prose-kbd-shadows) / 10%), 0 3px 0 rgb(var(--tw-prose-kbd-shadows) / 10%);
  font-size: 0.875em;
  border-radius: 0.3125rem;
  padding-top: 0.1875em;
  padding-inline-end: 0.375em;
  padding-bottom: 0.1875em;
  padding-inline-start: 0.375em;
}

.prose :where(code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #db2777;
  font-weight: 400;
  font-size: 0.875em;
  background-color: #f3f4f6;
  border-radius: 0.25rem;
  padding: 0.2em 0.4em;
}

.prose :where(code):not(:where([class~="not-prose"],[class~="not-prose"] *))::before {
  content: "";
}

.prose :where(code):not(:where([class~="not-prose"],[class~="not-prose"] *))::after {
  content: "";
}

.prose :where(a code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(h1 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(h2 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
  font-size: 0.875em;
}

.prose :where(h3 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
  font-size: 0.9em;
}

.prose :where(h4 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(blockquote code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(thead th code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: inherit;
}

.prose :where(pre):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
  background-color: #111827;
  overflow-x: auto;
  font-weight: 400;
  font-size: 0.875em;
  line-height: 1.7142857;
  margin-top: 1.7142857em;
  margin-bottom: 1.7142857em;
  border-radius: 0.5rem;
  padding-top: 0.8571429em;
  padding-inline-end: 1.1428571em;
  padding-bottom: 0.8571429em;
  padding-inline-start: 1.1428571em;
  padding: 1rem;
  overflow: auto;
}

.prose :where(pre code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  background-color: transparent;
  border-width: 0;
  border-radius: 0;
  padding: 0;
  font-weight: 400;
  color: inherit;
  font-size: 0.875em;
  font-family: inherit;
  line-height: inherit;
}

.prose :where(pre code):not(:where([class~="not-prose"],[class~="not-prose"] *))::before {
  content: none;
}

.prose :where(pre code):not(:where([class~="not-prose"],[class~="not-prose"] *))::after {
  content: none;
}

.prose :where(table):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  width: 100%;
  table-layout: auto;
  margin-top: 2em;
  margin-bottom: 2em;
  font-size: 0.875em;
  line-height: 1.7142857;
}

.prose :where(thead):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  border-bottom-width: 1px;
  border-bottom-color: var(--tw-prose-th-borders);
}

.prose :where(thead th):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-headings);
  font-weight: 600;
  vertical-align: bottom;
  padding-inline-end: 0.5714286em;
  padding-bottom: 0.5714286em;
  padding-inline-start: 0.5714286em;
}

.prose :where(tbody tr):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  border-bottom-width: 1px;
  border-bottom-color: var(--tw-prose-td-borders);
}

.prose :where(tbody tr:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  border-bottom-width: 0;
}

.prose :where(tbody td):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  vertical-align: baseline;
}

.prose :where(tfoot):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  border-top-width: 1px;
  border-top-color: var(--tw-prose-th-borders);
}

.prose :where(tfoot td):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  vertical-align: top;
}

.prose :where(th, td):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  text-align: start;
}

.prose :where(figure > *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
  margin-bottom: 0;
}

.prose :where(figcaption):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: var(--tw-prose-captions);
  font-size: 0.875em;
  line-height: 1.4285714;
  margin-top: 0.8571429em;
}

.prose {
  --tw-prose-body: #374151;
  --tw-prose-headings: #111827;
  --tw-prose-lead: #4b5563;
  --tw-prose-links: #111827;
  --tw-prose-bold: #111827;
  --tw-prose-counters: #6b7280;
  --tw-prose-bullets: #d1d5db;
  --tw-prose-hr: #e5e7eb;
  --tw-prose-quotes: #111827;
  --tw-prose-quote-borders: #e5e7eb;
  --tw-prose-captions: #6b7280;
  --tw-prose-kbd: #111827;
  --tw-prose-kbd-shadows: 17 24 39;
  --tw-prose-code: #111827;
  --tw-prose-pre-code: #e5e7eb;
  --tw-prose-pre-bg: #1f2937;
  --tw-prose-th-borders: #d1d5db;
  --tw-prose-td-borders: #e5e7eb;
  --tw-prose-invert-body: #d1d5db;
  --tw-prose-invert-headings: #fff;
  --tw-prose-invert-lead: #9ca3af;
  --tw-prose-invert-links: #fff;
  --tw-prose-invert-bold: #fff;
  --tw-prose-invert-counters: #9ca3af;
  --tw-prose-invert-bullets: #4b5563;
  --tw-prose-invert-hr: #374151;
  --tw-prose-invert-quotes: #f3f4f6;
  --tw-prose-invert-quote-borders: #374151;
  --tw-prose-invert-captions: #9ca3af;
  --tw-prose-invert-kbd: #fff;
  --tw-prose-invert-kbd-shadows: 255 255 255;
  --tw-prose-invert-code: #fff;
  --tw-prose-invert-pre-code: #d1d5db;
  --tw-prose-invert-pre-bg: rgb(0 0 0 / 50%);
  --tw-prose-invert-th-borders: #4b5563;
  --tw-prose-invert-td-borders: #374151;
  font-size: 1rem;
  line-height: 1.75;
}

.prose :where(picture > img):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
  margin-bottom: 0;
}

.prose :where(li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}

.prose :where(ol > li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0.375em;
}

.prose :where(ul > li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0.375em;
}

.prose :where(.prose > ul > li p):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.75em;
  margin-bottom: 0.75em;
}

.prose :where(.prose > ul > li > p:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.25em;
}

.prose :where(.prose > ul > li > p:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 1.25em;
}

.prose :where(.prose > ol > li > p:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.25em;
}

.prose :where(.prose > ol > li > p:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 1.25em;
}

.prose :where(ul ul, ul ol, ol ul, ol ol):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.75em;
  margin-bottom: 0.75em;
}

.prose :where(dl):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.25em;
  margin-bottom: 1.25em;
}

.prose :where(dd):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.5em;
  padding-inline-start: 1.625em;
}

.prose :where(hr + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose :where(h2 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose :where(h3 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose :where(h4 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose :where(thead th:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0;
}

.prose :where(thead th:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-end: 0;
}

.prose :where(tbody td, tfoot td):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-top: 0.5714286em;
  padding-inline-end: 0.5714286em;
  padding-bottom: 0.5714286em;
  padding-inline-start: 0.5714286em;
}

.prose :where(tbody td:first-child, tfoot td:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0;
}

.prose :where(tbody td:last-child, tfoot td:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-end: 0;
}

.prose :where(figure):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 2em;
  margin-bottom: 2em;
}

.prose :where(.prose > :first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose :where(.prose > :last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 0;
}

.prose-lg {
  font-size: 1.125rem;
  line-height: 1.7777778;
}

.prose-lg :where(p):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
  margin-bottom: 1.3333333em;
}

.prose-lg :where([class~="lead"]):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 1.2222222em;
  line-height: 1.4545455;
  margin-top: 1.0909091em;
  margin-bottom: 1.0909091em;
}

.prose-lg :where(blockquote):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.6666667em;
  margin-bottom: 1.6666667em;
  padding-inline-start: 1em;
}

.prose-lg :where(h1):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 2.6666667em;
  margin-top: 0;
  margin-bottom: 0.8333333em;
  line-height: 1;
}

.prose-lg :where(h2):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 1.6666667em;
  margin-top: 1.8666667em;
  margin-bottom: 1.0666667em;
  line-height: 1.3333333;
}

.prose-lg :where(h3):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 1.3333333em;
  margin-top: 1.6666667em;
  margin-bottom: 0.6666667em;
  line-height: 1.5;
}

.prose-lg :where(h4):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.7777778em;
  margin-bottom: 0.4444444em;
  line-height: 1.5555556;
}

.prose-lg :where(img):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.7777778em;
  margin-bottom: 1.7777778em;
}

.prose-lg :where(picture):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.7777778em;
  margin-bottom: 1.7777778em;
}

.prose-lg :where(picture > img):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
  margin-bottom: 0;
}

.prose-lg :where(video):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.7777778em;
  margin-bottom: 1.7777778em;
}

.prose-lg :where(kbd):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8888889em;
  border-radius: 0.3125rem;
  padding-top: 0.2222222em;
  padding-inline-end: 0.4444444em;
  padding-bottom: 0.2222222em;
  padding-inline-start: 0.4444444em;
}

.prose-lg :where(code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8888889em;
}

.prose-lg :where(h2 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8666667em;
}

.prose-lg :where(h3 code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.875em;
}

.prose-lg :where(pre):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8888889em;
  line-height: 1.75;
  margin-top: 2em;
  margin-bottom: 2em;
  border-radius: 0.375rem;
  padding-top: 1em;
  padding-inline-end: 1.5em;
  padding-bottom: 1em;
  padding-inline-start: 1.5em;
}

.prose-lg :where(ol):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
  margin-bottom: 1.3333333em;
  padding-inline-start: 1.5555556em;
}

.prose-lg :where(ul):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
  margin-bottom: 1.3333333em;
  padding-inline-start: 1.5555556em;
}

.prose-lg :where(li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.6666667em;
  margin-bottom: 0.6666667em;
}

.prose-lg :where(ol > li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0.4444444em;
}

.prose-lg :where(ul > li):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0.4444444em;
}

.prose-lg :where(.prose-lg > ul > li p):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.8888889em;
  margin-bottom: 0.8888889em;
}

.prose-lg :where(.prose-lg > ul > li > p:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
}

.prose-lg :where(.prose-lg > ul > li > p:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 1.3333333em;
}

.prose-lg :where(.prose-lg > ol > li > p:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
}

.prose-lg :where(.prose-lg > ol > li > p:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 1.3333333em;
}

.prose-lg :where(ul ul, ul ol, ol ul, ol ol):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.8888889em;
  margin-bottom: 0.8888889em;
}

.prose-lg :where(dl):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
  margin-bottom: 1.3333333em;
}

.prose-lg :where(dt):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.3333333em;
}

.prose-lg :where(dd):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0.6666667em;
  padding-inline-start: 1.5555556em;
}

.prose-lg :where(hr):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 3.1111111em;
  margin-bottom: 3.1111111em;
}

.prose-lg :where(hr + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose-lg :where(h2 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose-lg :where(h3 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose-lg :where(h4 + *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose-lg :where(table):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8888889em;
  line-height: 1.5;
}

.prose-lg :where(thead th):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-end: 0.75em;
  padding-bottom: 0.75em;
  padding-inline-start: 0.75em;
}

.prose-lg :where(thead th:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0;
}

.prose-lg :where(thead th:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-end: 0;
}

.prose-lg :where(tbody td, tfoot td):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-top: 0.75em;
  padding-inline-end: 0.75em;
  padding-bottom: 0.75em;
  padding-inline-start: 0.75em;
}

.prose-lg :where(tbody td:first-child, tfoot td:first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-start: 0;
}

.prose-lg :where(tbody td:last-child, tfoot td:last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  padding-inline-end: 0;
}

.prose-lg :where(figure):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 1.7777778em;
  margin-bottom: 1.7777778em;
}

.prose-lg :where(figure > *):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
  margin-bottom: 0;
}

.prose-lg :where(figcaption):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  font-size: 0.8888889em;
  line-height: 1.5;
  margin-top: 1em;
}

.prose-lg :where(.prose-lg > :first-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-top: 0;
}

.prose-lg :where(.prose-lg > :last-child):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  margin-bottom: 0;
}

.prose pre {
  --tw-bg-opacity: 1;
  background-color: rgb(17 24 39 / var(--tw-bg-opacity, 1));
  --tw-text-opacity: 1;
  color: rgb(255 255 255 / var(--tw-text-opacity, 1));
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.fixed {
  position: fixed;
}

.absolute {
  position: absolute;
}

.relative {
  position: relative;
}

.inset-0 {
  inset: 0px;
}

.inset-y-0 {
  top: 0px;
  bottom: 0px;
}

.bottom-0 {
  bottom: 0px;
}

.left-0 {
  left: 0px;
}

.left-4 {
  left: 1rem;
}

.right-0 {
  right: 0px;
}

.right-4 {
  right: 1rem;
}

.top-0 {
  top: 0px;
}

.top-1\/2 {
  top: 50%;
}

.top-4 {
  top: 1rem;
}

.z-50 {
  z-index: 50;
}

.mx-auto {
  margin-left: auto;
  margin-right: auto;
}

.mb-12 {
  margin-bottom: 3rem;
}

.mb-16 {
  margin-bottom: 4rem;
}

.mb-2 {
  margin-bottom: 0.5rem;
}

.mb-3 {
  margin-bottom: 0.75rem;
}

.mb-4 {
  margin-bottom: 1rem;
}

.mb-6 {
  margin-bottom: 1.5rem;
}

.mb-8 {
  margin-bottom: 2rem;
}

.ml-2 {
  margin-left: 0.5rem;
}

.mr-3 {
  margin-right: 0.75rem;
}

.mt-12 {
  margin-top: 3rem;
}

.mt-16 {
  margin-top: 4rem;
}

.mt-2 {
  margin-top: 0.5rem;
}

.mt-4 {
  margin-top: 1rem;
}

.mt-6 {
  margin-top: 1.5rem;
}

.mt-8 {
  margin-top: 2rem;
}

.block {
  display: block;
}

.inline-block {
  display: inline-block;
}

.flex {
  display: flex;
}

.inline-flex {
  display: inline-flex;
}

.grid {
  display: grid;
}

.hidden {
  display: none;
}

.aspect-square {
  aspect-ratio: 1 / 1;
}

.aspect-video {
  aspect-ratio: 16 / 9;
}

.h-1 {
  height: 0.25rem;
}

.h-10 {
  height: 2.5rem;
}

.h-12 {
  height: 3rem;
}

.h-16 {
  height: 4rem;
}

.h-20 {
  height: 5rem;
}

.h-24 {
  height: 6rem;
}

.h-32 {
  height: 8rem;
}

.h-4 {
  height: 1rem;
}

.h-5 {
  height: 1.25rem;
}

.h-96 {
  height: 24rem;
}

.h-\[30vh\] {
  height: 30vh;
}

.h-\[600px\] {
  height: 600px;
}

.h-full {
  height: 100%;
}

.max-h-72 {
  max-height: 18rem;
}

.min-h-screen {
  min-height: 100vh;
}

.w-10 {
  width: 2.5rem;
}

.w-20 {
  width: 5rem;
}

.w-32 {
  width: 8rem;
}

.w-4 {
  width: 1rem;
}

.w-48 {
  width: 12rem;
}

.w-5 {
  width: 1.25rem;
}

.w-full {
  width: 100%;
}

.max-w-2xl {
  max-width: 42rem;
}

.max-w-3xl {
  max-width: 48rem;
}

.max-w-4xl {
  max-width: 56rem;
}

.max-w-7xl {
  max-width: 80rem;
}

.max-w-none {
  max-width: none;
}

.flex-\[1_1_200px\] {
  flex: 1 1 200px;
}

.-translate-y-1\/2 {
  --tw-translate-y: -50%;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.rotate-180 {
  --tw-rotate: 180deg;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.transform {
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

@keyframes pulse {
  50% {
    opacity: .5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

.scroll-py-2 {
  scroll-padding-top: 0.5rem;
  scroll-padding-bottom: 0.5rem;
}

.grid-cols-1 {
  grid-template-columns: repeat(1, minmax(0, 1fr));
}

.flex-col {
  flex-direction: column;
}

.flex-wrap {
  flex-wrap: wrap;
}

.items-end {
  align-items: flex-end;
}

.items-center {
  align-items: center;
}

.justify-center {
  justify-content: center;
}

.justify-between {
  justify-content: space-between;
}

.gap-1 {
  gap: 0.25rem;
}

.gap-12 {
  gap: 3rem;
}

.gap-2 {
  gap: 0.5rem;
}

.gap-3 {
  gap: 0.75rem;
}

.gap-4 {
  gap: 1rem;
}

.gap-6 {
  gap: 1.5rem;
}

.gap-8 {
  gap: 2rem;
}

.space-x-8 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-x-reverse: 0;
  margin-right: calc(2rem * var(--tw-space-x-reverse));
  margin-left: calc(2rem * calc(1 - var(--tw-space-x-reverse)));
}

.space-y-1 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-y-reverse: 0;
  margin-top: calc(0.25rem * calc(1 - var(--tw-space-y-reverse)));
  margin-bottom: calc(0.25rem * var(--tw-space-y-reverse));
}

.space-y-2 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-y-reverse: 0;
  margin-top: calc(0.5rem * calc(1 - var(--tw-space-y-reverse)));
  margin-bottom: calc(0.5rem * var(--tw-space-y-reverse));
}

.space-y-4 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-y-reverse: 0;
  margin-top: calc(1rem * calc(1 - var(--tw-space-y-reverse)));
  margin-bottom: calc(1rem * var(--tw-space-y-reverse));
}

.space-y-8 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-y-reverse: 0;
  margin-top: calc(2rem * calc(1 - var(--tw-space-y-reverse)));
  margin-bottom: calc(2rem * var(--tw-space-y-reverse));
}

.divide-y > :not([hidden]) ~ :not([hidden]) {
  --tw-divide-y-reverse: 0;
  border-top-width: calc(1px * calc(1 - var(--tw-divide-y-reverse)));
  border-bottom-width: calc(1px * var(--tw-divide-y-reverse));
}

.divide-gray-100 > :not([hidden]) ~ :not([hidden]) {
  --tw-divide-opacity: 1;
  border-color: rgb(243 244 246 / var(--tw-divide-opacity, 1));
}

.overflow-hidden {
  overflow: hidden;
}

.overflow-y-auto {
  overflow-y: auto;
}

.truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.rounded {
  border-radius: 0.25rem;
}

.rounded-full {
  border-radius: 9999px;
}

.rounded-lg {
  border-radius: 0.5rem;
}

.rounded-md {
  border-radius: 0.375rem;
}

.rounded-xl {
  border-radius: 0.75rem;
}

.border {
  border-width: 1px;
}

.border-0 {
  border-width: 0px;
}

.border-y {
  border-top-width: 1px;
  border-bottom-width: 1px;
}

.border-b {
  border-bottom-width: 1px;
}

.border-r {
  border-right-width: 1px;
}

.border-t {
  border-top-width: 1px;
}

.border-gray-200 {
  --tw-border-opacity: 1;
  border-color: rgb(229 231 235 / var(--tw-border-opacity, 1));
}

.border-gray-300 {
  --tw-border-opacity: 1;
  border-color: rgb(209 213 219 / var(--tw-border-opacity, 1));
}

.border-primary {
  --tw-border-opacity: 1;
  border-color: rgb(0 195 142 / var(--tw-border-opacity, 1));
}

.border-white\/10 {
  border-color: rgb(255 255 255 / 0.1);
}

.bg-black {
  --tw-bg-opacity: 1;
  background-color: rgb(0 0 0 / var(--tw-bg-opacity, 1));
}

.bg-black\/50 {
  background-color: rgb(0 0 0 / 0.5);
}

.bg-black\/60 {
  background-color: rgb(0 0 0 / 0.6);
}

.bg-gray-100 {
  --tw-bg-opacity: 1;
  background-color: rgb(243 244 246 / var(--tw-bg-opacity, 1));
}

.bg-gray-200 {
  --tw-bg-opacity: 1;
  background-color: rgb(229 231 235 / var(--tw-bg-opacity, 1));
}

.bg-gray-500 {
  --tw-bg-opacity: 1;
  background-color: rgb(107 114 128 / var(--tw-bg-opacity, 1));
}

.bg-gray-900\/50 {
  background-color: rgb(17 24 39 / 0.5);
}

.bg-green-100 {
  --tw-bg-opacity: 1;
  background-color: rgb(220 252 231 / var(--tw-bg-opacity, 1));
}

.bg-primary {
  --tw-bg-opacity: 1;
  background-color: rgb(0 195 142 / var(--tw-bg-opacity, 1));
}

.bg-red-100 {
  --tw-bg-opacity: 1;
  background-color: rgb(254 226 226 / var(--tw-bg-opacity, 1));
}

.bg-secondary {
  --tw-bg-opacity: 1;
  background-color: rgb(159 255 36 / var(--tw-bg-opacity, 1));
}

.bg-secondary\/20 {
  background-color: rgb(159 255 36 / 0.2);
}

.bg-transparent {
  background-color: transparent;
}

.bg-white {
  --tw-bg-opacity: 1;
  background-color: rgb(255 255 255 / var(--tw-bg-opacity, 1));
}

.bg-opacity-25 {
  --tw-bg-opacity: 0.25;
}

.bg-gradient-to-t {
  background-image: linear-gradient(to top, var(--tw-gradient-stops));
}

.bg-gradient-to-tr {
  background-image: linear-gradient(to top right, var(--tw-gradient-stops));
}

.from-black\/30 {
  --tw-gradient-from: rgb(0 0 0 / 0.3) var(--tw-gradient-from-position);
  --tw-gradient-to: rgb(0 0 0 / 0) var(--tw-gradient-to-position);
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
}

.from-black\/60 {
  --tw-gradient-from: rgb(0 0 0 / 0.6) var(--tw-gradient-from-position);
  --tw-gradient-to: rgb(0 0 0 / 0) var(--tw-gradient-to-position);
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
}

.from-black\/70 {
  --tw-gradient-from: rgb(0 0 0 / 0.7) var(--tw-gradient-from-position);
  --tw-gradient-to: rgb(0 0 0 / 0) var(--tw-gradient-to-position);
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
}

.from-black\/80 {
  --tw-gradient-from: rgb(0 0 0 / 0.8) var(--tw-gradient-from-position);
  --tw-gradient-to: rgb(0 0 0 / 0) var(--tw-gradient-to-position);
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
}

.via-black\/20 {
  --tw-gradient-to: rgb(0 0 0 / 0)  var(--tw-gradient-to-position);
  --tw-gradient-stops: var(--tw-gradient-from), rgb(0 0 0 / 0.2) var(--tw-gradient-via-position), var(--tw-gradient-to);
}

.to-transparent {
  --tw-gradient-to: transparent var(--tw-gradient-to-position);
}

.object-cover {
  -o-object-fit: cover;
     object-fit: cover;
}

.p-1 {
  padding: 0.25rem;
}

.p-2 {
  padding: 0.5rem;
}

.p-3 {
  padding: 0.75rem;
}

.p-4 {
  padding: 1rem;
}

.p-6 {
  padding: 1.5rem;
}

.p-8 {
  padding: 2rem;
}

.px-2 {
  padding-left: 0.5rem;
  padding-right: 0.5rem;
}

.px-3 {
  padding-left: 0.75rem;
  padding-right: 0.75rem;
}

.px-4 {
  padding-left: 1rem;
  padding-right: 1rem;
}

.px-6 {
  padding-left: 1.5rem;
  padding-right: 1.5rem;
}

.py-1 {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
}

.py-1\.5 {
  padding-top: 0.375rem;
  padding-bottom: 0.375rem;
}

.py-12 {
  padding-top: 3rem;
  padding-bottom: 3rem;
}

.py-2 {
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
}

.py-20 {
  padding-top: 5rem;
  padding-bottom: 5rem;
}

.py-3 {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
}

.py-8 {
  padding-top: 2rem;
  padding-bottom: 2rem;
}

.pb-2 {
  padding-bottom: 0.5rem;
}

.pl-11 {
  padding-left: 2.75rem;
}

.pl-12 {
  padding-left: 3rem;
}

.pl-3 {
  padding-left: 0.75rem;
}

.pr-4 {
  padding-right: 1rem;
}

.pt-20 {
  padding-top: 5rem;
}

.pt-6 {
  padding-top: 1.5rem;
}

.pt-8 {
  padding-top: 2rem;
}

.text-center {
  text-align: center;
}

.text-justify {
  text-align: justify;
}

.font-poppins {
  font-family: Poppins, sans-serif;
}

.text-2xl {
  font-size: 1.5rem;
  line-height: 2rem;
}

.text-3xl {
  font-size: 1.875rem;
  line-height: 2.25rem;
}

.text-4xl {
  font-size: 2.25rem;
  line-height: 2.5rem;
}

.text-lg {
  font-size: 1.125rem;
  line-height: 1.75rem;
}

.text-sm {
  font-size: 0.875rem;
  line-height: 1.25rem;
}

.text-xl {
  font-size: 1.25rem;
  line-height: 1.75rem;
}

.text-xs {
  font-size: 0.75rem;
  line-height: 1rem;
}

.font-bold {
  font-weight: 700;
}

.font-light {
  font-weight: 300;
}

.font-medium {
  font-weight: 500;
}

.font-semibold {
  font-weight: 600;
}

.leading-snug {
  line-height: 1.375;
}

.leading-tight {
  line-height: 1.25;
}

.text-\[\#0A66C2\] {
  --tw-text-opacity: 1;
  color: rgb(10 102 194 / var(--tw-text-opacity, 1));
}

.text-\[\#1877F2\] {
  --tw-text-opacity: 1;
  color: rgb(24 119 242 / var(--tw-text-opacity, 1));
}

.text-\[\#1DA1F2\] {
  --tw-text-opacity: 1;
  color: rgb(29 161 242 / var(--tw-text-opacity, 1));
}

.text-black {
  --tw-text-opacity: 1;
  color: rgb(0 0 0 / var(--tw-text-opacity, 1));
}

.text-dark {
  --tw-text-opacity: 1;
  color: rgb(45 52 54 / var(--tw-text-opacity, 1));
}

.text-gray-300 {
  --tw-text-opacity: 1;
  color: rgb(209 213 219 / var(--tw-text-opacity, 1));
}

.text-gray-400 {
  --tw-text-opacity: 1;
  color: rgb(156 163 175 / var(--tw-text-opacity, 1));
}

.text-gray-500 {
  --tw-text-opacity: 1;
  color: rgb(107 114 128 / var(--tw-text-opacity, 1));
}

.text-gray-600 {
  --tw-text-opacity: 1;
  color: rgb(75 85 99 / var(--tw-text-opacity, 1));
}

.text-gray-900 {
  --tw-text-opacity: 1;
  color: rgb(17 24 39 / var(--tw-text-opacity, 1));
}

.text-green-700 {
  --tw-text-opacity: 1;
  color: rgb(21 128 61 / var(--tw-text-opacity, 1));
}

.text-primary {
  --tw-text-opacity: 1;
  color: rgb(0 195 142 / var(--tw-text-opacity, 1));
}

.text-red-700 {
  --tw-text-opacity: 1;
  color: rgb(185 28 28 / var(--tw-text-opacity, 1));
}

.text-secondary {
  --tw-text-opacity: 1;
  color: rgb(159 255 36 / var(--tw-text-opacity, 1));
}

.text-text-secondary {
  --tw-text-opacity: 1;
  color: rgb(99 110 114 / var(--tw-text-opacity, 1));
}

.text-white {
  --tw-text-opacity: 1;
  color: rgb(255 255 255 / var(--tw-text-opacity, 1));
}

.text-white\/80 {
  color: rgb(255 255 255 / 0.8);
}

.opacity-0 {
  opacity: 0;
}

.opacity-100 {
  opacity: 1;
}

.opacity-80 {
  opacity: 0.8;
}

.shadow-2xl {
  --tw-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25);
  --tw-shadow-colored: 0 25px 50px -12px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.shadow-\[0_2px_15px_-3px_rgba\(0\2c 0\2c 0\2c 0\.07\)\2c 0_10px_20px_-2px_rgba\(0\2c 0\2c 0\2c 0\.04\)\] {
  --tw-shadow: 0 2px 15px -3px rgba(0,0,0,0.07),0 10px 20px -2px rgba(0,0,0,0.04);
  --tw-shadow-colored: 0 2px 15px -3px var(--tw-shadow-color), 0 10px 20px -2px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.shadow-lg {
  --tw-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
  --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color), 0 4px 6px -4px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.shadow-md {
  --tw-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --tw-shadow-colored: 0 4px 6px -1px var(--tw-shadow-color), 0 2px 4px -2px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.shadow-sm {
  --tw-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --tw-shadow-colored: 0 1px 2px 0 var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.ring-1 {
  --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color);
  box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
}

.ring-black {
  --tw-ring-opacity: 1;
  --tw-ring-color: rgb(0 0 0 / var(--tw-ring-opacity, 1));
}

.ring-opacity-5 {
  --tw-ring-opacity: 0.05;
}

.transition {
  transition-property: color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter, -webkit-backdrop-filter;
  transition-property: color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter;
  transition-property: color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter, backdrop-filter, -webkit-backdrop-filter;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.transition-colors {
  transition-property: color, background-color, border-color, text-decoration-color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.transition-opacity {
  transition-property: opacity;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.transition-transform {
  transition-property: transform;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

.duration-200 {
  transition-duration: 200ms;
}

.duration-300 {
  transition-duration: 300ms;
}

.duration-500 {
  transition-duration: 500ms;
}

.duration-700 {
  transition-duration: 700ms;
}

.ease-in {
  transition-timing-function: cubic-bezier(0.4, 0, 1, 1);
}

.ease-out {
  transition-timing-function: cubic-bezier(0, 0, 0.2, 1);
}

/* Custom styles */

.dark\:prose-invert:is(.dark *) {
  --tw-prose-body: var(--tw-prose-invert-body);
  --tw-prose-headings: var(--tw-prose-invert-headings);
  --tw-prose-lead: var(--tw-prose-invert-lead);
  --tw-prose-links: var(--tw-prose-invert-links);
  --tw-prose-bold: var(--tw-prose-invert-bold);
  --tw-prose-counters: var(--tw-prose-invert-counters);
  --tw-prose-bullets: var(--tw-prose-invert-bullets);
  --tw-prose-hr: var(--tw-prose-invert-hr);
  --tw-prose-quotes: var(--tw-prose-invert-quotes);
  --tw-prose-quote-borders: var(--tw-prose-invert-quote-borders);
  --tw-prose-captions: var(--tw-prose-invert-captions);
  --tw-prose-kbd: var(--tw-prose-invert-kbd);
  --tw-prose-kbd-shadows: var(--tw-prose-invert-kbd-shadows);
  --tw-prose-code: var(--tw-prose-invert-code);
  --tw-prose-pre-code: var(--tw-prose-invert-pre-code);
  --tw-prose-pre-bg: var(--tw-prose-invert-pre-bg);
  --tw-prose-th-borders: var(--tw-prose-invert-th-borders);
  --tw-prose-td-borders: var(--tw-prose-invert-td-borders);
}

.dark\:prose-dark:is(.dark *) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(a):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #00c38e;
}

.dark\:prose-dark:is(.dark *) :where(h1):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(h2):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(h3):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(h4):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(p):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #d1d5db;
}

.dark\:prose-dark:is(.dark *) :where(strong):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(blockquote):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #d1d5db;
}

.dark\:prose-dark:is(.dark *) :where(code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  color: #f472b6;
  background-color: #1f2937;
}

.dark\:prose-dark:is(.dark *) :where(pre):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  background-color: #111827;
  color: #f3f4f6;
}

.dark\:prose-dark:is(.dark *) :where(pre code):not(:where([class~="not-prose"],[class~="not-prose"] *)) {
  background-color: transparent;
  color: inherit;
}

.placeholder\:text-gray-400::-moz-placeholder {
  --tw-text-opacity: 1;
  color: rgb(156 163 175 / var(--tw-text-opacity, 1));
}

.placeholder\:text-gray-400::placeholder {
  --tw-text-opacity: 1;
  color: rgb(156 163 175 / var(--tw-text-opacity, 1));
}

.last\:border-r-0:last-child {
  border-right-width: 0px;
}

.hover\:translate-x-1:hover {
  --tw-translate-x: 0.25rem;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.hover\:border-primary:hover {
  --tw-border-opacity: 1;
  border-color: rgb(0 195 142 / var(--tw-border-opacity, 1));
}

.hover\:bg-gray-100:hover {
  --tw-bg-opacity: 1;
  background-color: rgb(243 244 246 / var(--tw-bg-opacity, 1));
}

.hover\:bg-gray-200:hover {
  --tw-bg-opacity: 1;
  background-color: rgb(229 231 235 / var(--tw-bg-opacity, 1));
}

.hover\:bg-gray-50:hover {
  --tw-bg-opacity: 1;
  background-color: rgb(249 250 251 / var(--tw-bg-opacity, 1));
}

.hover\:bg-primary\/90:hover {
  background-color: rgb(0 195 142 / 0.9);
}

.hover\:bg-secondary\/30:hover {
  background-color: rgb(159 255 36 / 0.3);
}

.hover\:bg-white\/5:hover {
  background-color: rgb(255 255 255 / 0.05);
}

.hover\:text-primary:hover {
  --tw-text-opacity: 1;
  color: rgb(0 195 142 / var(--tw-text-opacity, 1));
}

.hover\:text-primary\/80:hover {
  color: rgb(0 195 142 / 0.8);
}

.hover\:text-white:hover {
  --tw-text-opacity: 1;
  color: rgb(255 255 255 / var(--tw-text-opacity, 1));
}

.hover\:shadow-\[0_2px_15px_-3px_rgba\(0\2c 0\2c 0\2c 0\.1\)\2c 0_10px_20px_-2px_rgba\(0\2c 0\2c 0\2c 0\.06\)\]:hover {
  --tw-shadow: 0 2px 15px -3px rgba(0,0,0,0.1),0 10px 20px -2px rgba(0,0,0,0.06);
  --tw-shadow-colored: 0 2px 15px -3px var(--tw-shadow-color), 0 10px 20px -2px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.hover\:shadow-md:hover {
  --tw-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --tw-shadow-colored: 0 4px 6px -1px var(--tw-shadow-color), 0 2px 4px -2px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.focus\:outline-none:focus {
  outline: 2px solid transparent;
  outline-offset: 2px;
}

.focus\:ring-0:focus {
  --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(0px + var(--tw-ring-offset-width)) var(--tw-ring-color);
  box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
}

.focus\:ring-2:focus {
  --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color);
  box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
}

.focus\:ring-primary:focus {
  --tw-ring-opacity: 1;
  --tw-ring-color: rgb(0 195 142 / var(--tw-ring-opacity, 1));
}

.disabled\:opacity-50:disabled {
  opacity: 0.5;
}

.group:hover .group-hover\:translate-x-2 {
  --tw-translate-x: 0.5rem;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.group:hover .group-hover\:scale-105 {
  --tw-scale-x: 1.05;
  --tw-scale-y: 1.05;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.group:hover .group-hover\:scale-110 {
  --tw-scale-x: 1.1;
  --tw-scale-y: 1.1;
  transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
}

.group:hover .group-hover\:text-primary {
  --tw-text-opacity: 1;
  color: rgb(0 195 142 / var(--tw-text-opacity, 1));
}

.prose-pre\:bg-transparent :is(:where(pre):not(:where([class~="not-prose"],[class~="not-prose"] *))) {
  background-color: transparent;
}

.prose-pre\:p-0 :is(:where(pre):not(:where([class~="not-prose"],[class~="not-prose"] *))) {
  padding: 0px;
}

.dark\:border-gray-600:is(.dark *) {
  --tw-border-opacity: 1;
  border-color: rgb(75 85 99 / var(--tw-border-opacity, 1));
}

.dark\:border-gray-700:is(.dark *) {
  --tw-border-opacity: 1;
  border-color: rgb(55 65 81 / var(--tw-border-opacity, 1));
}

.dark\:bg-gray-700:is(.dark *) {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity, 1));
}

.dark\:bg-gray-800:is(.dark *) {
  --tw-bg-opacity: 1;
  background-color: rgb(31 41 55 / var(--tw-bg-opacity, 1));
}

.dark\:bg-gray-900:is(.dark *) {
  --tw-bg-opacity: 1;
  background-color: rgb(17 24 39 / var(--tw-bg-opacity, 1));
}

.dark\:text-gray-100:is(.dark *) {
  --tw-text-opacity: 1;
  color: rgb(243 244 246 / var(--tw-text-opacity, 1));
}

.dark\:text-gray-300:is(.dark *) {
  --tw-text-opacity: 1;
  color: rgb(209 213 219 / var(--tw-text-opacity, 1));
}

.dark\:text-gray-400:is(.dark *) {
  --tw-text-opacity: 1;
  color: rgb(156 163 175 / var(--tw-text-opacity, 1));
}

.dark\:text-white:is(.dark *) {
  --tw-text-opacity: 1;
  color: rgb(255 255 255 / var(--tw-text-opacity, 1));
}

.dark\:shadow-\[0_2px_15px_-3px_rgba\(0\2c 0\2c 0\2c 0\.2\)\]:is(.dark *) {
  --tw-shadow: 0 2px 15px -3px rgba(0,0,0,0.2);
  --tw-shadow-colored: 0 2px 15px -3px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

.dark\:hover\:bg-gray-700:hover:is(.dark *) {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity, 1));
}

.dark\:hover\:bg-gray-800:hover:is(.dark *) {
  --tw-bg-opacity: 1;
  background-color: rgb(31 41 55 / var(--tw-bg-opacity, 1));
}

.dark\:hover\:text-primary:hover:is(.dark *) {
  --tw-text-opacity: 1;
  color: rgb(0 195 142 / var(--tw-text-opacity, 1));
}

.dark\:hover\:shadow-\[0_2px_15px_-3px_rgba\(0\2c 0\2c 0\2c 0\.3\)\]:hover:is(.dark *) {
  --tw-shadow: 0 2px 15px -3px rgba(0,0,0,0.3);
  --tw-shadow-colored: 0 2px 15px -3px var(--tw-shadow-color);
  box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

@media (min-width: 640px) {
  .sm\:inline {
    display: inline;
  }

  .sm\:p-6 {
    padding: 1.5rem;
  }

  .sm\:px-6 {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .sm\:text-sm {
    font-size: 0.875rem;
    line-height: 1.25rem;
  }
}

@media (min-width: 768px) {
  .md\:flex {
    display: flex;
  }

  .md\:h-20 {
    height: 5rem;
  }

  .md\:grid-cols-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .md\:flex-row {
    flex-direction: row;
  }

  .md\:justify-start {
    justify-content: flex-start;
  }

  .md\:justify-end {
    justify-content: flex-end;
  }

  .md\:p-20 {
    padding: 5rem;
  }

  .md\:text-5xl {
    font-size: 3rem;
    line-height: 1;
  }
}

@media (min-width: 1024px) {
  .lg\:h-\[700px\] {
    height: 700px;
  }

  .lg\:grid-cols-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .lg\:grid-cols-3 {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .lg\:grid-cols-\[1fr\2c 300px\] {
    grid-template-columns: 1fr 300px;
  }

  .lg\:px-8 {
    padding-left: 2rem;
    padding-right: 2rem;
  }

  .lg\:text-6xl {
    font-size: 3.75rem;
    line-height: 1;
  }
}```

## File: hugo.toml
```
```

## File: theme.toml
```
# This is a required Hugo theme metadata file
# It provides information about your theme for the Hugo themes gallery
# It contains theme metadata for the Hugo ecosystem
# Used by Hugo for theme validation
# Required for publishing the theme to the Hugo themes website
# ------------------------------------------------

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

```

