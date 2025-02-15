import Alpine from 'alpinejs'
import collapse from '@alpinejs/collapse'
import Fuse from 'fuse.js'

Alpine.plugin(collapse)

window.Alpine = Alpine
window.Fuse = Fuse

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

Alpine.start()