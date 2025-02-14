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
    <div class="relative h-[60vh] mt-16">
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
            <!-- Main Content with Typography -->
            <div class="prose prose-lg dark:prose-dark max-w-none">
                {{ .Content }}
            </div>

            <!-- Sidebar -->
            {{ partial "sidebar.html" . }}
        </div>
    </div>
</article>
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
<html lang="{{ .Site.LanguageCode | default "en" }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Raleway:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Alpine.js -->
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
</head>
<body class="font-poppins" 
      x-data="{ darkMode: localStorage.getItem('darkMode') === 'true' }" 
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
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 text-center">
        <img src="/images/author.jpg" alt="Author" class="w-32 h-32 rounded-full mx-auto mb-4">
        <h3 class="text-xl font-semibold mb-2 dark:text-white">John Doe</h3>
        <p class="text-text-secondary dark:text-gray-300 mb-4">Tech enthusiast and frequent traveler...</p>
        <a href="/about" 
           class="inline-block bg-primary text-white px-6 py-2 rounded-lg hover:bg-primary/90 transition">
            Know More
        </a>
    </div>

    <!-- Recent Posts -->
    <div class="bg-white rounded-lg shadow-lg p-6">
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
    <div class="bg-white rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-semibold mb-4 pb-2 border-b border-primary">Categories</h3>
        <ul class="space-y-2">
            {{ range $name, $taxonomy := .Site.Taxonomies.categories }}
            <li>
                <a href="{{ "/categories/" | relLangURL }}{{ $name | urlize }}" 
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
    <div class="bg-white rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-semibold mb-4 pb-2 border-b border-primary">Tags</h3>
        <div class="flex flex-wrap gap-2">
            {{ range $name, $taxonomy := .Site.Taxonomies.tags }}
            <a href="{{ "/tags/" | relLangURL }}{{ $name | urlize }}" 
               class="bg-gray-100 hover:bg-gray-200 text-text-secondary px-3 py-1 rounded-full text-sm transition">
                {{ $name }}
            </a>
            {{ end }}
        </div>
    </div>
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
            <a href="{{ .Site.BaseURL }}" class="text-xl font-bold text-dark dark:text-white hover:text-primary transition">
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
                <div class="relative">
                    <input type="text" placeholder="Search..." 
                           class="w-48 pl-4 pr-10 py-2 border rounded-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white focus:outline-none focus:border-primary dark:focus:border-primary">
                    <button class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-primary dark:hover:text-primary">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</header>```

# Static CSS Files
## File: static/css/.keep
```
```

