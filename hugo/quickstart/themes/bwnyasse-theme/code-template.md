# Layout Files
## File: layouts/index.html
```
{{ define "main" }}
<!-- Hero Section -->
<section class="author-hero">
    <div class="hero-container">
        <div class="hero-content">
            <h1>
                <span class="highlight">Technology Leader,</span> Google Developer Expert,
                <span class="highlight">Speaker.</span>
            </h1>
            <p class="hero-description">With over a decade in software development, I focus on innovative tech solutions
                and am passionate about mentoring aspiring developers.</p>
            <div class="hero-buttons">
                <a href="/blog" class="hero-button">
                    Read My Blog
                    <span class="button-arrow">→</span>
                </a>
            </div>
        </div>
        <div class="hero-image">
            <img src="/images/author-profile.jpg" alt="Author Profile">
        </div>
    </div>
</section>

<!-- Projects/Cards Section -->
<section class="projects-section">
    <div class="projects-grid">
        <!-- Repeat this block for each project (9 times for 3x3) -->
        <div class="project-card">
            <div class="project-image">
                <img src="/images/project1.jpg" alt="Project 1">
            </div>
            <div class="project-overlay">
                <div class="project-content">
                    <div class="project-text">
                        <h3>Google Developer Expert</h3>
                        <p>Project description goes here</p>
                    </div>
                    <span class="project-link">→</span>
                </div>
            </div>
            <a href="#" class="project-full-link" aria-label="View Project"></a>
        </div>

        <div class="project-card">
            <div class="project-image">
                <img src="/images/project2.jpg" alt="Project 2">
            </div>
            <div class="project-overlay">
                <div class="project-content">
                    <div class="project-text">
                        <h3>Oloodi Dialogues</h3>
                        <p>Another description here</p>
                    </div>
                    <span class="project-link">→</span>
                </div>
            </div>
            <a href="#" class="project-full-link" aria-label="View Project"></a>
        </div>

        <div class="project-card">
            <div class="project-image">
                <img src="/images/project3.jpg" alt="Project 2">
            </div>
            <div class="project-overlay">
                <div class="project-content">
                    <div class="project-text">
                        <h3>Engineer Manager @Datavalet</h3>
                        <p>Another description here</p>
                    </div>
                    <span class="project-link">→</span>
                </div>
            </div>
            <a href="#" class="project-full-link" aria-label="View Project"></a>
        </div>

    </div>
</section>

{{ end }}```

## File: layouts/blog/list.html
```
{{ define "main" }}
<div class="container">
    {{ partial "hero.html" . }}

    <div class="main-with-sidebar">
        <!-- Main Content -->
        <div class="main-content">

            <!-- Featured Article -->
            {{ range first 1 (where (where .Site.RegularPages "Type" "posts") "Params.featured" true) }}
            <article class="featured-article">
                <div class="featured-article-image">
                    {{ if .Params.image }}
                    <img src="{{ .Params.image }}" alt="{{ .Title }}">
                    {{ end }}
                </div>
                <div class="featured-article-content">
                    {{ with .Params.categories }}
                    <div class="categories">
                        {{ range . }}
                        <span class="category-tag">{{ . }}</span>
                        {{ end }}
                    </div>
                    {{ end }}
                    <h2 class="featured-article-title"><a href="{{ .Permalink }}">{{ .Title }}</a></h2>
                    <div class="featured-article-meta">
                        <span class="reading-time">{{ .ReadingTime }} MINUTES READ</span>
                        <span class="post-date">{{ .Date.Format "02 JAN 2006" }}</span>
                    </div>
                    <p class="featured-article-excerpt">
                        {{ with .Description }}
                        {{ . | truncate 160 }}
                        {{ else }}
                        {{ .Summary | plainify | truncate 160 }}
                        {{ end }}
                    </p>
                    <a href="{{ .Permalink }}" class="read-more">Read Full Article</a>
                </div>
            </article>
            {{ end }}

            <!-- Regular Articles Grid -->
            <div class="articles-grid">
                {{ $paginator := .Paginate (where .Site.RegularPages "Type" "posts") }}
                {{ range $paginator.Pages }}
                <article class="article-card">
                    {{ if .Params.image }}
                    <div class="article-image">
                        <img src="{{ .Params.image }}" alt="{{ .Title }}">
                        <div class="article-meta">
                            <span class="reading-time">{{ .ReadingTime }} MINUTES READ</span>
                            <span class="post-date">{{ .Date.Format "02 JAN 2006" }}</span>
                        </div>
                    </div>
                    {{ end }}
                    <div class="article-content">
                        {{ with .Params.categories }}
                        <div class="categories">
                            {{ range . }}
                            <span class="category-tag">{{ . }}</span>
                            {{ end }}
                        </div>
                        {{ end }}
                        <h2 class="article-title"><a href="{{ .Permalink }}">{{ .Title }}</a></h2>
                        <p class="article-excerpt">
                            {{ with .Description }}
                            {{ . | truncate 160 }}
                            {{ else }}
                            {{ .Summary | plainify | truncate 160 }}
                            {{ end }}
                        </p>
                        <a href="{{ .Permalink }}" class="read-more">Read Full Article</a>
                    </div>
                </article>
                {{ end }}
            </div>
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
    {{ partial "post-hero.html" . }}
    
    <div class="container">
        <div class="post-with-sidebar">
            <article class="post-content">
                {{ .Content }}
            </article>
            
            {{ partial "sidebar.html" . }}
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
<html lang="{{ .Site.LanguageCode | default "en" }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Raleway:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Styles -->
    <link rel="stylesheet" href="{{ "css/variables.css" | relURL }}">
    <link rel="stylesheet" href="{{ "css/main.css" | relURL }}">
</head>
<body>
    {{ partial "header.html" . }}
    <main class="site-main">
        {{ block "main" . }}{{ end }}
    </main>
    {{ partial "footer.html" . }}

    <!-- Scripts -->
    <script src="{{ "js/main.js" | relURL }}" defer></script>
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
<nav class="pagination">
    {{ $paginator := .Paginator }}
    
    <!-- Previous arrow (show only if not on first page) -->
    {{ if and (ne $paginator.PageNumber 1) }}
        <a class="page-item nav-arrow" href="{{ $paginator.Prev.URL }}" aria-label="Previous">←</a>
    {{ end }}
    
    <!-- Page numbers -->
    {{ range $paginator.Pagers }}
        {{ if eq . $paginator }}
            <span class="page-item active">{{ .PageNumber }}</span>
        {{ else }}
            <a class="page-item" href="{{ .URL }}">{{ .PageNumber }}</a>
        {{ end }}
    {{ end }}
    
    <!-- Next arrow (show only if not on last page) -->
    {{ if and (ne $paginator.PageNumber $paginator.TotalPages) }}
        <a class="page-item nav-arrow" href="{{ $paginator.Next.URL }}" aria-label="Next">→</a>
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
<footer class="site-footer">
    <!-- Social Icons Section -->
    <div class="social-icons-grid">
        {{ with .Site.Params.social }}
        {{ with .facebook }}
        <a href="{{ . }}" class="social-icon-box" aria-label="Facebook">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M9.198 21.5h4v-8.01h3.604l.396-3.98h-4V7.5a1 1 0 0 1 1-1h3v-4h-3a5 5 0 0 0-5 5v2.01h-2l-.396 3.98h2.396v8.01Z" />
            </svg>
        </a>
        {{ end }}
        {{ with .linkedin }}
        <a href="{{ . }}" class="social-icon-box" aria-label="LinkedIn">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M6.94 5a2 2 0 1 1-4-.002a2 2 0 0 1 4 .002zM7 8.48H3V21h4V8.48zm6.32 0H9.34V21h3.94v-6.57c0-3.66 4.77-4 4.77 0V21H22v-7.93c0-6.17-7.06-5.94-8.72-2.91l.04-1.68z" />
            </svg>
        </a>
        {{ end }}
        {{ with .github }}
        <a href="{{ . }}" class="social-icon-box" aria-label="GitHub">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z" />
            </svg>
        </a>
        {{ end }}
        {{ with .tiktok }}
        <a href="{{ . }}" class="social-icon-box" aria-label="TikTok">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M19.321 5.562a5.124 5.124 0 0 1 .264 1.635V9.79h3.558V7.197A7.129 7.129 0 0 0 19.321 0h-2.563v14.027a3.792 3.792 0 0 1-7.58.08V7.197A7.129 7.129 0 0 0 5.356 0H2.793v14.027a6.363 6.363 0 0 0 12.722.16V7.197a7.129 7.129 0 0 0 3.806 5.537z" />
            </svg>
        </a>
        {{ end }}
        {{ with .twitter }}
        <a href="{{ . }}" class="social-icon-box" aria-label="Twitter">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M18.244 2.25h3.308l-7.227 8.26l8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
            </svg>
        </a>
        {{ end }}
        {{ with .medium }}
        <a href="{{ . }}" class="social-icon-box" aria-label="Medium">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M13.54 12a6.8 6.8 0 01-6.77 6.82A6.8 6.8 0 010 12a6.8 6.8 0 016.77-6.82A6.8 6.8 0 0113.54 12zM20.96 12c0 3.54-1.51 6.42-3.38 6.42-1.87 0-3.39-2.88-3.39-6.42s1.52-6.42 3.39-6.42 3.38 2.88 3.38 6.42M24 12c0 3.17-.53 5.75-1.19 5.75-.66 0-1.19-2.58-1.19-5.75s.53-5.75 1.19-5.75C23.47 6.25 24 8.83 24 12z" />
            </svg>
        </a>
        {{ end }}
        {{ with .instagram }}
        <a href="{{ . }}" class="social-icon-box" aria-label="Instagram">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M12 2c2.717 0 3.056.01 4.122.06c1.065.05 1.79.217 2.428.465c.66.254 1.216.598 1.772 1.153a4.908 4.908 0 0 1 1.153 1.772c.247.637.415 1.363.465 2.428c.047 1.066.06 1.405.06 4.122c0 2.717-.01 3.056-.06 4.122c-.05 1.065-.218 1.79-.465 2.428a4.883 4.883 0 0 1-1.153 1.772a4.915 4.915 0 0 1-1.772 1.153c-.637.247-1.363.415-2.428.465c-1.066.047-1.405.06-4.122.06c-2.717 0-3.056-.01-4.122-.06c-1.065-.05-1.79-.218-2.428-.465a4.89 4.89 0 0 1-1.772-1.153a4.904 4.904 0 0 1-1.153-1.772c-.248-.637-.415-1.363-.465-2.428C2.013 15.056 2 14.717 2 12c0-2.717.01-3.056.06-4.122c.05-1.066.217-1.79.465-2.428a4.88 4.88 0 0 1 1.153-1.772A4.897 4.897 0 0 1 5.45 2.525c.638-.248 1.362-.415 2.428-.465C8.944 2.013 9.283 2 12 2zm0 5a5 5 0 1 0 0 10a5 5 0 0 0 0-10zm6.5-.25a1.25 1.25 0 0 0-2.5 0a1.25 1.25 0 0 0 2.5 0zM12 9a3 3 0 1 1 0 6a3 3 0 0 1 0-6z" />
            </svg>
        </a>
        {{ end }}
        {{ with .youtube }}
        <a href="{{ . }}" class="social-icon-box" aria-label="YouTube">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="white">
                <path
                    d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
            </svg>
        </a>
        {{ end }}

    </div>
    {{ end }}

    <!-- Bottom Section -->
    <div class="footer-bottom">
        <div class="footer-links">
            <a href="{{ .Site.BaseURL }}">© {{ now.Format "2006" }} {{ .Site.Title }}</a>

        </div>
        <div class="footer-credit footer-links">
            <a href="/terms">Terms & Conditions</a>
            <a href="/privacy">Privacy Policy</a>
            <a href="/cookie">Cookie Policy</a>
        </div>
    </div>
</footer>```

## File: layouts/partials/sidebar.html
```
<aside class="sidebar">
    <!-- Author Widget -->
    <div class="sidebar-widget author-widget">
        <div class="author-info">
            <img src="/images/author.jpg" alt="Author" class="author-avatar">
            <h3 class="author-name">John Doe</h3>
            <p class="author-bio">Tech enthusiast and frequent traveler. Writing about technology, travel, and life
                experiences.</p>
            <a href="/about" class="know-more-btn">Know More</a>
        </div>
    </div>

    <!-- Recent Posts Widget -->
    <div class="sidebar-widget">
        <h3 class="widget-title">Recent Posts</h3>
        <div class="recent-posts">
            {{ range first 3 (where .Site.RegularPages "Type" "posts") }}
            <div class="recent-post-item">
                {{ if .Params.image }}
                <div class="recent-post-image">
                    <img src="{{ .Params.image }}" alt="{{ .Title }}">
                </div>
                {{ end }}
                <div class="recent-post-content">
                    <h4><a href="{{ .Permalink }}">{{ .Title }}</a></h4>
                    <span class="post-date">{{ .Date.Format "Jan 2, 2006" }}</span>
                </div>
            </div>
            {{ end }}
        </div>
    </div>

    <!-- Categories Widget -->
    <div class="sidebar-widget">
        <h3 class="widget-title">Categories</h3>
        <ul class="category-list">
            {{ range $name, $taxonomy := .Site.Taxonomies.categories }}
            <li>
                <a href="{{ " /categories/" | relLangURL }}{{ $name | urlize }}">
                    {{ $name }}
                    <span class="category-count">{{ $taxonomy.Count }}</span>
                </a>
            </li>
            {{ end }}
        </ul>
    </div>

    <!-- Tags Cloud Widget -->
    <div class="sidebar-widget">
        <h3 class="widget-title">Popular Tags</h3>
        <div class="tags-cloud">
            {{ range $name, $taxonomy := .Site.Taxonomies.tags }}
            <a href="{{ " /tags/" | relLangURL }}{{ $name | urlize }}" class="tag-link">
                {{ $name }}
            </a>
            {{ end }}
        </div>
    </div>

</aside>```

## File: layouts/partials/header.html
```
<header class="site-header js-header">
    <div class="container">
        <div class="header-content">
            <a href="{{ .Site.BaseURL }}" class="site-logo">
                {{ with .Site.Params.logo }}
                    <img src="{{ . }}" alt="{{ $.Site.Title }}" class="logo-img">
                {{ else }}
                    <span class="logo-text">{{ .Site.Title }}</span>
                {{ end }}
            </a>

            <nav class="main-nav">
                {{ $currentPage := . }}
                {{ range .Site.Menus.main }}
                <a href="{{ .URL }}" class="nav-link {{ if $currentPage.IsMenuCurrent "main" . }}active{{ end }}">
                    {{ .Name }}
                </a>
                {{ end }}
            </nav>

            <div class="header-actions">
                <div class="search-box">
                    <input type="text" placeholder="Search..." aria-label="Search">
                    <button type="submit" aria-label="Submit search">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</header>```

# Static CSS Files
## File: static/css/variables.css
```
:root {
    /* Colors */
    --primary-color: #00c38e;
    --secondary-color: #9fff24;
    --text-primary: #2d3436;
    --text-secondary: #636e72;
    --background-light: #f5f5f5;
    --border-color: #dfe6e9;
    
    /* Typography */
    --font-primary: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    --font-secondary: 'Raleway', sans-serif;
    --font-size-base: 16px;
    --font-size-h1: 2.5rem;
    --font-size-h2: 2rem;
    --font-size-h3: 1.75rem;
    
    /* Spacing */
    --spacing-unit: 8px;
    --container-width: 1200px;
    --grid-gap: 2rem;

    --primary-color-dark: #00a57a;
    --background-light: #f5f5f5;
    --border-color: #e0e0e0;
}```

## File: static/css/main.css
```
@import 'variables.css';

/* Base styles */
html {
    font-size: var(--font-size-base);
}

body {
    font-family: var(--font-primary);
    color: var(--text-primary);
    line-height: 1.6;
    margin: 0;
}

/* Container */
.container {
    max-width: var(--container-width);
    margin: 0 auto;
    padding: 0 calc(var(--spacing-unit) * 2);
}

/* Header */
.site-header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    background: white;
    z-index: 1000;
    transition: transform 0.3s ease;
    border-bottom: 1px solid var(--border-color);
}

.header-hidden {
    transform: translateY(-100%);
}

.header-sticky {
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.header-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 80px;
}

.site-logo {
    text-decoration: none;
    color: var(--text-primary);
    font-weight: 700;
    font-size: 1.5rem;
}

.logo-img {
    height: 40px;
    width: auto;
}

.main-nav {
    display: flex;
    gap: calc(var(--spacing-unit) * 4);
}

.nav-link {
    text-decoration: none;
    color: var(--text-secondary);
    font-weight: 500;
    transition: color 0.2s ease;
    position: relative;
}

.nav-link:hover,
.nav-link.active {
    color: var(--text-primary);
}

.nav-link.active::after {
    content: '';
    position: absolute;
    bottom: -4px;
    left: 0;
    right: 0;
    height: 2px;
    background: var(--primary-color);
}

.header-actions {
    display: flex;
    align-items: center;
    gap: calc(var(--spacing-unit) * 2);
}

.search-box {
    display: flex;
    align-items: center;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: calc(var(--spacing-unit) * 0.75);
}

.search-box input {
    border: none;
    outline: none;
    padding: 0 var(--spacing-unit);
    font-family: var(--font-primary);
}

.search-box button {
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
    color: var(--text-secondary);
}

/* Responsive */
@media (max-width: 768px) {
    .header-content {
        height: 60px;
    }

    .main-nav {
        display: none;
    }
}

/* Hero Section */
.hero {
    padding: calc(var(--spacing-unit) * 8) 0 calc(var(--spacing-unit) * 4);
    margin-top: 80px;
}

.hero-title {
    font-size: var(--font-size-h1);
    font-weight: 700;
    color: var(--text-primary);
    margin: 0;
}

.hero-description {
    font-size: 1.125rem;
    color: var(--text-secondary);
    margin-top: var(--spacing-unit);
    max-width: 600px;
}

/* Articles Grid */
.articles-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: var(--grid-gap);
    padding: calc(var(--spacing-unit) * 4) 0;
}

.article-card {
    background: white;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.article-card {
    display: flex;
    flex-direction: column;
    height: 100%;
    /* Ensure all cards are same height */
}

.article-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.article-image {
    position: relative;
    padding-top: 60%;
}

.article-image img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.article-meta {
    position: absolute;
    right: 0;
    top: -5px;
    padding-top: 20px;
    padding-left: 20px;
    padding-right: 20px;
}

.article-meta>.reading-time {
    display: inline-block;
    line-height: 1.3;
    font-size: 12px;
    padding: 3px 8px;
    padding-top: 4px;
    background-color: rgba(0, 0, 0, .6);
    backdrop-filter: blur(10px);
    color: #fff;
    border-radius: 0;
    margin-top: 5px;
}

.article-meta>.post-date {
    display: inline-block;
    line-height: 1.3;
    font-size: 12px;
    padding: 3px 8px;
    padding-top: 4px;
    background-color: rgba(0, 0, 0, .6);
    backdrop-filter: blur(10px);
    color: #fff;
    border-radius: 0;
    margin-top: 5px;
}

.article-content {
    flex: 1;
    /* Allow content to fill available space */
    display: flex;
    flex-direction: column;
    padding: 1.25rem;
}

.article-categories {
    display: flex;
    gap: var(--spacing-unit);
    margin-bottom: var(--spacing-unit);
}

.category-tag {
    font-size: 0.75rem;
    padding: calc(var(--spacing-unit) * 0.5) calc(var(--spacing-unit) * 1);
    background: var(--secondary-color);
    border-radius: 4px;
    color: var(--text-secondary);
}

.article-title {
    font-size: 1.25rem;
    margin-bottom: 0;
    line-height: 1.4;
}

.article-title a {
    color: var(--text-primary);
    text-decoration: none;
}

.article-title a:hover {
    color: var(--primary-color);
}

.article-excerpt {
    color: var(--text-secondary);
    font-size: 0.875rem;
    margin: calc(var(--spacing-unit) * 1.5) 0;
    line-height: 1.6;
    text-align: justify;
    hyphens: auto;
    -webkit-hyphens: auto;
    -moz-hyphens: auto;
}

.read-more {
    display: inline-block;
    color: var(--text-primary);
    font-size: 0.875rem;
    font-weight: 500;
    margin-top: auto;
    text-decoration: underline;
    text-decoration-color: var(--secondary-color);
}

@media (max-width: 768px) {
    .main-content .articles-grid {
        grid-template-columns: 1fr;
        /* Single column on mobile */
    }
}

/* Pagination */
.pagination {
    display: flex;
    justify-content: center;
    gap: var(--spacing-unit);
    padding: calc(var(--spacing-unit) * 4) 0;
}

.pagination a {
    padding: calc(var(--spacing-unit) * 1) calc(var(--spacing-unit) * 2);
    border: 1px solid var(--border-color);
    border-radius: 4px;
    text-decoration: none;
    color: var(--text-secondary);
}

.pagination .active {
    background: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .hero {
        margin-top: 60px;
        padding: calc(var(--spacing-unit) * 4) 0;
    }

    .hero-title {
        font-size: 2rem;
    }

    .articles-grid {
        grid-template-columns: 1fr;
        gap: calc(var(--spacing-unit) * 2);
    }
}

/* Single Post */
.single-post {
    margin-top: 80px;
}

.post-hero {
    width: 100%;
    height: 400px;
    overflow: hidden;
    position: relative;
}

.post-hero img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.post-header {
    padding: calc(var(--spacing-unit) * 4) 0;
}

.post-meta {
    display: flex;
    align-items: center;
    gap: calc(var(--spacing-unit) * 2);
    margin-bottom: var(--spacing-unit);
}

.post-meta>.post-date {
    color: var(--text-secondary);
    font-size: 0.875rem;
    padding: calc(var(--spacing-unit)* 0.5) calc(var(--spacing-unit)* 1);
    background: var(--background-light);
    border-radius: 4px;
}

.post-meta>.reading-time {
    color: var(--text-secondary);
    font-size: 0.875rem;
    padding: calc(var(--spacing-unit)* 0.5) calc(var(--spacing-unit)* 1);
    background: var(--background-light);
    border-radius: 4px;
}

.post-title {
    font-size: var(--font-size-h1);
    margin: calc(var(--spacing-unit) * 2) 0;
}

.post-description {
    font-size: 1.25rem;
    color: var(--text-secondary);
    max-width: 700px;
}

.post-content {
    max-width: 700px;
    margin: 0 auto;
    padding: calc(var(--spacing-unit) * 4) 0;
    text-align: justify;
    hyphens: auto;
    -webkit-hyphens: auto;
    -moz-hyphens: auto;
}

.post-content h2 {
    font-size: var(--font-size-h2);
    margin: calc(var(--spacing-unit) * 4) 0 calc(var(--spacing-unit) * 2);
}

.post-content p {
    margin: calc(var(--spacing-unit) * 2) 0;
    text-align: justify;
    margin-bottom: 1.5rem;
}

.article-description, 
.post-description {
    text-align: justify;
    hyphens: auto;
    -webkit-hyphens: auto;
    -moz-hyphens: auto;
}

@media (max-width: 768px) {
    .post-hero {
        height: 300px;
    }

    .post-title {
        font-size: 2rem;
    }
}

/* Enhanced Post Hero */
.post-hero {
    position: relative;
    margin-top: 80px;
    color: white;
}

.post-hero-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}

.post-hero-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.post-hero-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(to bottom, rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.7));
}

.post-hero-content {
    position: relative;
    padding: calc(var(--spacing-unit) * 8) 0;
    max-width: 800px;
}

.post-hero-title {
    font-size: 3rem;
    margin: calc(var(--spacing-unit) * 2) 0;
}

.post-hero-description {
    font-size: 1.25rem;
    opacity: 0.9;
    margin: calc(var(--spacing-unit) * 2) 0;
}

/* Sidebar Styles */
.sidebar {
    position: sticky;
    top: 100px;
}

.sidebar-widget {
    background: white;
    border-radius: 8px;
    padding: calc(var(--spacing-unit) * 3);
    margin-bottom: calc(var(--spacing-unit) * 3);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.widget-title {
    font-size: 1.25rem;
    margin-bottom: calc(var(--spacing-unit) * 2);
    padding-bottom: var(--spacing-unit);
    border-bottom: 2px solid var(--primary-color);
}

.recent-post-item {
    display: flex;
    gap: var(--spacing-unit);
    margin-bottom: calc(var(--spacing-unit) * 2);
}

.recent-post-image {
    width: 80px;
    height: 80px;
    flex-shrink: 0;
}

.recent-post-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 4px;
}

.recent-post-content h4 {
    font-size: 0.875rem;
    margin: 0 0 4px 0;
}

.category-list {
    list-style: none;
    padding: 0;
}

.category-list li {
    margin-bottom: var(--spacing-unit);
}

.category-list a {
    display: flex;
    justify-content: space-between;
    color: var(--text-secondary);
    text-decoration: none;
}

.category-count {
    background: var(--background-light);
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 0.75rem;
}

/* Enhanced Footer */
.site-footer {
    background: var(--text-primary);
    color: white;
    /*padding: calc(var(--spacing-unit) * 8) 0 0;*/
    /*margin-top: calc(var(--spacing-unit) * 8);*/
}

.footer-content {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: calc(var(--spacing-unit) * 4);
    margin-bottom: calc(var(--spacing-unit) * 6);
}

.footer-title {
    font-size: 1.125rem;
    margin-bottom: calc(var(--spacing-unit) * 2);
}

.footer-links {
    list-style: none;
    padding: 0;
}

.footer-links li {
    margin-bottom: var(--spacing-unit);
}

.footer-links a {
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
}

.footer-bottom {
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    padding: calc(var(--spacing-unit) * 3) 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.footer-social {
    display: flex;
    gap: calc(var(--spacing-unit) * 2);
}

.social-link {
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
}

/* Responsive Adjustments */
@media (max-width: 1024px) {
    .footer-content {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .post-hero {
        height: 400px;
    }

    .post-hero-title {
        font-size: 2rem;
    }

    .sidebar {
        margin-top: calc(var(--spacing-unit) * 4);
        position: static;
    }

    .footer-content {
        grid-template-columns: 1fr;
    }

    .footer-bottom {
        flex-direction: column;
        gap: var(--spacing-unit);
        text-align: center;
    }
}

/* Post Layout with Sidebar */
.post-with-sidebar {
    display: grid;
    grid-template-columns: 1fr 300px;
    gap: 40px;
    margin-top: 40px;
}

/* Sidebar Styles */
.sidebar {
    position: sticky;
    top: 100px;
}

.sidebar-widget {
    background: white;
    border-radius: 8px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.widget-title {
    font-size: 1.25rem;
    margin-bottom: 16px;
    padding-bottom: 8px;
    border-bottom: 2px solid var(--primary-color);
    color: var(--text-primary);
}

/* Author Widget */
.author-widget {
    text-align: center;
}

.author-avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    margin-bottom: 16px;
}

.author-name {
    font-size: 1.2rem;
    margin-bottom: 8px;
    color: var(--text-primary);
}

.author-bio {
    font-size: 0.9rem;
    color: var(--text-secondary);
    line-height: 1.6;
}

/* Recent Posts Widget */
.recent-post-item {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border-color);
}

.recent-post-item:last-child {
    margin-bottom: 0;
    padding-bottom: 0;
    border-bottom: none;
}

.recent-post-image {
    width: 80px;
    height: 80px;
    flex-shrink: 0;
}

.recent-post-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 4px;
}

.recent-post-content h4 {
    font-size: 0.9rem;
    margin: 0 0 4px 0;
}

.recent-post-content h4 a {
    color: var(--text-primary);
    text-decoration: none;
}

.recent-post-content h4 a:hover {
    color: var(--primary-color);
}

.post-date {
    font-size: 0.8rem;
    color: var(--text-secondary);
}

/* Categories Widget */
.category-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.category-list li {
    margin-bottom: 8px;
}

.category-list a {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px;
    border-radius: 4px;
    text-decoration: none;
    color: var(--text-secondary);
    transition: background-color 0.2s;
}

.category-list a:hover {
    background-color: var(--background-light);
}

.category-count {
    background: var(--background-light);
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 0.75rem;
}

/* Tags Cloud */
.tags-cloud {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.tag-link {
    display: inline-block;
    padding: 4px 12px;
    background: var(--background-light);
    border-radius: 16px;
    font-size: 0.8rem;
    color: var(--text-secondary);
    text-decoration: none;
    transition: background-color 0.2s;
}

.tag-link:hover {
    background: var(--primary-color);
    color: white;
}


.form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-group input {
    padding: 8px 12px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-size: 0.9rem;
}

.form-group button {
    padding: 8px 16px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
}

.form-group button:hover {
    background-color: var(--primary-color-dark);
}

/* Responsive Design */
@media (max-width: 992px) {
    .post-with-sidebar {
        grid-template-columns: 1fr;
    }

    .sidebar {
        position: static;
        margin-top: 40px;
    }
}

@media (max-width: 768px) {
    .sidebar-widget {
        padding: 20px;
    }

    .author-avatar {
        width: 100px;
        height: 100px;
    }
}

@media (max-width: 1200px) {
    .main-with-sidebar {
        grid-template-columns: 1fr;
    }
}

/* Main page with sidebar layout */
.main-with-sidebar {
    display: grid;
    grid-template-columns: 1fr 300px;
    gap: 40px;
    margin-top: 40px;
}

/* Modify the articles grid styles */
.main-content .articles-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    /* Change to 2 columns */
    gap: 60px;
}

/* Responsive adjustments */
@media (max-width: 992px) {
    .main-with-sidebar {
        grid-template-columns: 1fr;
    }

    .main-content {
        order: 1;
    }

    .sidebar {
        order: 2;
    }
}

@media (max-width: 768px) {
    .main-with-sidebar {
        margin-top: 20px;
    }
}

/* Featured Article */
.featured-article {
    margin-bottom: 40px;
    background: white;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.featured-article-image {
    position: relative;
    height: 400px;
    overflow: hidden;
}

.featured-article-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.featured-article-content {
    padding: 24px;
}

.featured-article-title {
    font-size: 1.7rem;
    margin: 16px 0;
}

.featured-article-title a {
    color: var(--text-primary);
    text-decoration: none;
}

.featured-article-title a:hover {
    color: var(--primary-color);
}

.featured-article-meta {
    display: flex;
    gap: 16px;
    color: var(--text-secondary);
    font-size: 0.9rem;
    margin-bottom: 16px;
}

.featured-article-meta>.reading-time {
    display: inline-block;
    line-height: 1.3;
    font-size: 12px;
    padding: 3px 8px;
    padding-top: 4px;
    background-color: rgba(0, 0, 0, .6);
    backdrop-filter: blur(10px);
    color: #fff;
    border-radius: 0;
    margin-top: 5px;
}

.featured-article-meta>.post-date {
    display: inline-block;
    line-height: 1.3;
    font-size: 12px;
    padding: 3px 8px;
    padding-top: 4px;
    background-color: rgba(0, 0, 0, .6);
    backdrop-filter: blur(10px);
    color: #fff;
    border-radius: 0;
    margin-top: 5px;
}

.featured-article-excerpt {
    font-size: 1.1rem;
    color: var(--text-secondary);
    margin-bottom: 24px;
    line-height: 1.6;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .featured-article-image {
        height: 300px;
    }

    .featured-article-title {
        font-size: 1.5rem;
    }
}

/* Pagination */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    margin-top: 40px;
    margin-bottom: 40px;
}

.page-item {
    min-width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 12px;
    border-radius: 4px;
    background: white;
    color: var(--text-primary);
    text-decoration: none;
    font-weight: 500;
    border: 1px solid var(--border-color);
    transition: all 0.2s ease;
}

.page-item.nav-arrow {
    font-size: 1.2rem;
    padding: 0 8px;
}

.page-item:hover {
    background: var(--background-light);
    color: var(--primary-color);
}

.page-item.active {
    background: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
    cursor: default;
}

/* Footer Styles */
.site-footer {
    background: #000;
    color: white;
    width: 100%;
}

/* Social Icons Grid Container */
.social-icons-grid {
    display: flex;
    justify-content: center;
    /* Center the icons container */
    flex-wrap: wrap;
    max-width: 1400px;
    /* or your preferred max-width */
    margin: 0 auto;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.social-icon-box {
    flex: 0 0 200px;
    /* Fixed width for each box */
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 2rem;
    border-right: 1px solid rgba(255, 255, 255, 0.1);
    transition: background-color 0.3s ease;
}

.social-icon-box:last-child {
    border-right: none;
}

.social-icon-box:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

.social-icon-box svg {
    width: 32px;
    height: 32px;
}

/* Footer Bottom */
.footer-bottom {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* Responsive */
@media (max-width: 768px) {
    .social-icon-box {
        flex: 0 0 33.333%;
        /* Three icons per row on mobile */
        padding: 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }
}

/* Know More Button */
.know-more-btn {
    display: inline-block;
    color: white;
    font-size: 0.950rem;
    font-weight: 600;
    text-transform: capitalize;
    padding: 10px 25px;
    border-radius: 0;
    border: 1px solid;
    position: relative;
    z-index: 1;
    transition: .2sease;
    background: 0 0;
    border-color: var(--primary-color);
    text-decoration: underline !important;
    background-color: var(--primary-color);
}


.know-more-btn:hover {
    background: var(--primary-color-dark);
}

/* Hero Section */
.author-hero {
    min-height: 100vh;
    background: #000;
    color: white;
    display: flex;
    align-items: center;
    position: relative;
}

.hero-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 48px;
    align-items: center;
}

.hero-content {
    max-width: 600px;
}

.hero-content h1 {
    font-size: 3.5rem;
    line-height: 1.2;
    margin-bottom: 24px;
}

.highlight {
    color: var(--primary-color);
}

.hero-description {
    font-size: 1.5rem;
    line-height: 1.6;
}

.hero-image {
    position: relative;
    height: 600px;
}

.hero-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 8px;
}

/* Optional: Add a subtle overlay gradient */
.hero-image::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(45deg, rgba(0, 0, 0, 0.3), transparent);
    border-radius: 8px;
}

/* Responsive Adjustments */
@media (max-width: 1024px) {
    .hero-container {
        grid-template-columns: 1fr;
        text-align: center;
    }

    .hero-content {
        max-width: 100%;
    }

    .hero-content h1 {
        font-size: 2.5rem;
    }

    .hero-description {
        font-size: 1.2rem;
    }

    .hero-image {
        height: 400px;
        order: -1;
        /* Makes image appear above text on mobile */
    }
}

@media (max-width: 768px) {
    .hero-image {
        height: 300px;
    }
}

/* Projects Section */
.projects-section {
    width: 100%;
    background: #000;
    padding-bottom: 50px;
}

.projects-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1px;
    background: #111;
}

.project-card {
    position: relative;
    aspect-ratio: 1;
    background: #000;
    overflow: hidden;
}

.project-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}

.project-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.project-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0) 60%);
    opacity: 0.8;
    transition: opacity 0.3s ease;
}

.project-content {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 30px;
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
}

.project-text {
    max-width: 70%;
}

.project-text h3 {
    color: white;
    font-size: 1.5rem;
    margin-bottom: 8px;
    font-weight: 600;
}

.project-text p {
    color: rgba(255, 255, 255, 0.8);
    font-size: 0.9rem;
    margin: 0;
}

.project-link {
    color: var(--secondary-color);
    font-size: 2rem;
    font-weight: 300;
    transition: transform 0.3s ease;
}

.project-full-link {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
}

/* Hover Effects */
.project-card:hover .project-image img {
    transform: scale(1.05);
}

.project-card:hover .project-overlay {
    opacity: 1;
}

.project-card:hover .project-link {
    transform: translateX(5px);
}

/* Responsive Adjustments */
@media (max-width: 1024px) {
    .projects-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .projects-grid {
        grid-template-columns: 1fr;
    }

    .project-text h3 {
        font-size: 1.25rem;
    }

    .project-text p {
        font-size: 0.85rem;
    }
}

/* Hero Button Styles */
.hero-buttons {
    margin-top: 2rem;
}

.hero-button {
    display: inline-flex;
    align-items: center;
    background: var(--secondary-color);
    color: #000;
    padding: 1rem 2rem;
    border-radius: 4px;
    text-decoration: none;
    font-weight: 500;
    transition: transform 0.3s ease;
}

.hero-button:hover {
    transform: translateX(5px);
}

.button-arrow {
    margin-left: 0.5rem;
    font-size: 1.2em;
}

@media (max-width: 768px) {
    .hero-button {
        width: 100%;
        justify-content: center;
    }
}```

## File: static/css/style.css
```
```

