import Alpine from 'alpinejs'
import collapse from '@alpinejs/collapse'
import Fuse from 'fuse.js'

// Register Alpine plugins
Alpine.plugin(collapse)

// Make Alpine and Fuse available globally
window.Alpine = Alpine
window.Fuse = Fuse

document.addEventListener('alpine:init', () => {
    // Theme Store
    Alpine.store('theme', {
        isDark: localStorage.getItem('theme') === 'dark',
        toggle() {
            this.isDark = !this.isDark;
            localStorage.setItem('theme', this.isDark ? 'dark' : 'light');
            if (this.isDark) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        },
        init() {
            if (this.isDark) {
                document.documentElement.classList.add('dark');
            }
        }
    });

    // Navigation Component
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

    // Search Component
    Alpine.data('search', () => ({
        isOpen: false,
        searchQuery: '',
        searchResults: [],
        
        init() {
            this.searchQuery = new URLSearchParams(window.location.search).get('q') || '';
            if (this.searchQuery) {
                this.performSearch();
            }
        },
        
        toggleSearch() {
            this.isOpen = !this.isOpen;
            if (this.isOpen) {
                setTimeout(() => {
                    this.$refs.searchInput?.focus();
                }, 50);
            }
        },
        
        async performSearch() {
            if (!this.searchQuery.trim()) {
                this.searchResults = [];
                return;
            }
            
            try {
                const response = await fetch('/index.json');
                const searchIndex = await response.json();
                
                const fuse = new Fuse(searchIndex, {
                    keys: ['title', 'content', 'categories', 'tags'],
                    includeScore: true,
                    threshold: 0.4,
                });
                
                const results = fuse.search(this.searchQuery);
                this.searchResults = results.map(result => result.item);
                
                // Update URL
                const url = new URL(window.location);
                url.searchParams.set('q', this.searchQuery);
                window.history.pushState({}, '', url);
            } catch (error) {
                console.error('Search error:', error);
                this.searchResults = [];
            }
        }
    }));
});

// Start Alpine
Alpine.start()