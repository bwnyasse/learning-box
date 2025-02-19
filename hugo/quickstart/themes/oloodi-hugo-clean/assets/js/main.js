import Alpine from 'alpinejs'
import collapse from '@alpinejs/collapse'
import Fuse from 'fuse.js'

// Helper functions
const throttle = (fn, delay) => {
    let lastCall = 0;
    return function (...args) {
        const now = new Date().getTime();
        if (now - lastCall < delay) return;
        lastCall = now;
        return fn(...args);
    }
};

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
            window.addEventListener('scroll', throttle(() => this.handleScroll(), 100));
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

    Alpine.data('analyticsTracker', () => ({
        init() {
            // Track initial page view
            this.trackPageView();

            // Track subsequent navigation events
            document.addEventListener('turbo:visit', () => this.trackPageView());

            // Track outbound links
            this.trackOutboundLinks();

            // Track scroll depth
            this.trackScrollDepth();
        },

        trackPageView() {
            if (typeof gtag !== 'function') return;

            // Get GA ID from data attribute or global variable
            const gaId = document.body.dataset.gaId || window.gaId;

            gtag('event', 'page_view', {
                page_title: document.title,
                page_location: window.location.href,
                page_path: window.location.pathname,
                ...(gaId && { send_to: gaId })
            });
        },

        trackOutboundLinks() {
            document.addEventListener('click', (event) => {
                const link = event.target.closest('a');
                if (!link) return;

                const href = link.getAttribute('href');
                if (!href || href.startsWith('#') || href.startsWith('/')) return;

                // Check if it's an external link
                if (link.hostname !== window.location.hostname && typeof gtag === 'function') {
                    gtag('event', 'click', {
                        event_category: 'outbound',
                        event_label: href,
                        transport_type: 'beacon'
                    });
                }
            });
        },

        trackScrollDepth() {
            if (typeof IntersectionObserver !== 'function' || typeof gtag !== 'function') return;

            const getScrollPercentage = () => {
                const scrollTop = window.pageYOffset;
                const winHeight = window.innerHeight;
                const docHeight = Math.max(
                    document.body.scrollHeight,
                    document.documentElement.scrollHeight,
                    document.body.offsetHeight,
                    document.documentElement.offsetHeight,
                    document.body.clientHeight,
                    document.documentElement.clientHeight
                );

                return scrollTop / (docHeight - winHeight) * 100;
            };

            // Track 25%, 50%, 75%, 90% scroll depth
            const scrollDepths = [25, 50, 75, 90];
            const trackedDepths = {};

            window.addEventListener('scroll', throttle(() => {
                const scrollPercentage = getScrollPercentage();

                scrollDepths.forEach(depth => {
                    if (scrollPercentage >= depth && !trackedDepths[depth]) {
                        trackedDepths[depth] = true;
                        gtag('event', 'scroll_depth', {
                            event_category: 'scroll',
                            event_label: `${depth}%`,
                            value: depth
                        });
                    }
                });
            }, 200), { passive: true });
        }
    }));
});

// Start Alpine
Alpine.start()


/**
 * Enhanced Google Analytics 4 Event Tracking Helper
 */
const GAEvents = {
    // Core navigation events
    trackNavigation: (target, label) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'navigate', {
            navigation_type: 'menu_click',
            destination: target,
            menu_item: label
        });
    },

    // Content engagement
    trackContentView: (contentType, contentId, contentName) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'view_item', {
            content_type: contentType,
            content_id: contentId,
            content_name: contentName
        });
    },

    // Form interactions
    trackFormStart: (formName, formId) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'form_start', {
            form_name: formName,
            form_id: formId
        });
    },

    trackFormSubmit: (formName, formId, success = true) => {
        if (typeof gtag !== 'function') return;
        gtag('event', success ? 'form_submit_success' : 'form_submit_failure', {
            form_name: formName,
            form_id: formId
        });
    },

    // Search events
    trackSearch: (searchTerm, resultsCount) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'search', {
            search_term: searchTerm,
            results_count: resultsCount
        });
    },

    // Social interactions
    trackSocialShare: (platform, contentId, contentType) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'share', {
            method: platform,
            content_id: contentId,
            content_type: contentType
        });
    },

    // File downloads
    trackDownload: (fileUrl, fileName, fileType) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'file_download', {
            file_url: fileUrl,
            file_name: fileName,
            file_extension: fileType
        });
    },

    // Custom video tracking
    trackVideoInteraction: (videoName, action, position) => {
        if (typeof gtag !== 'function') return;
        gtag('event', 'video_' + action, {
            video_name: videoName,
            video_current_time: position,
            video_provider: 'custom'
        });
    },

    // Initialize automatic event tracking
    initAutoTracking: () => {
        // Auto-track menu navigation
        document.querySelectorAll('nav a, .nav-link, .menu-item a').forEach(link => {
            link.addEventListener('click', () => {
                const label = link.textContent?.trim() || link.getAttribute('aria-label') || 'Unknown';
                const destination = link.getAttribute('href') || '#';
                GAEvents.trackNavigation(destination, label);
            });
        });

        // Auto-track form submissions
        document.querySelectorAll('form').forEach(form => {
            const formName = form.getAttribute('name') || form.getAttribute('id') || 'unknown-form';
            const formId = form.getAttribute('id') || 'form-' + Date.now();

            form.addEventListener('submit', (e) => {
                GAEvents.trackFormSubmit(formName, formId, true);
            });

            // Track form start (first interaction)
            const formFields = form.querySelectorAll('input, select, textarea');
            let formStarted = false;

            formFields.forEach(field => {
                field.addEventListener('focus', () => {
                    if (!formStarted) {
                        formStarted = true;
                        GAEvents.trackFormStart(formName, formId);
                    }
                });
            });
        });

        // Auto-track downloads
        const downloadExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'zip', 'rar', 'exe', 'dmg'];
        document.querySelectorAll('a').forEach(link => {
            const href = link.getAttribute('href');
            if (!href) return;

            const extension = href.split('.').pop()?.toLowerCase();
            if (downloadExtensions.includes(extension)) {
                link.addEventListener('click', () => {
                    const fileName = href.split('/').pop() || href;
                    GAEvents.trackDownload(href, fileName, extension);
                });
            }
        });

        // Auto-track social share buttons
        document.querySelectorAll('.social-share a, [data-share]').forEach(button => {
            button.addEventListener('click', () => {
                const platform = button.getAttribute('data-platform') ||
                    button.className.match(/(?:share-|social-)(twitter|facebook|linkedin|pinterest|email)/i)?.[1] ||
                    'unknown';
                const contentId = document.location.pathname;
                const contentType = document.querySelector('meta[property="og:type"]')?.getAttribute('content') || 'page';

                GAEvents.trackSocialShare(platform, contentId, contentType);
            });
        });
    }
};

// Initialize auto-tracking on DOM load
document.addEventListener('DOMContentLoaded', () => {
    GAEvents.initAutoTracking();
});

// Export for manual use
window.GAEvents = GAEvents;