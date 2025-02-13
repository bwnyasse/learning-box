// Sticky header
document.addEventListener('DOMContentLoaded', function() {
    const header = document.querySelector('.js-header');
    let lastScrollY = window.scrollY;

    window.addEventListener('scroll', () => {
        const currentScrollY = window.scrollY;
        
        if (currentScrollY > lastScrollY) {
            header.classList.add('header-hidden');
        } else {
            header.classList.remove('header-hidden');
        }

        if (currentScrollY > 100) {
            header.classList.add('header-sticky');
        } else {
            header.classList.remove('header-sticky');
        }

        lastScrollY = currentScrollY;
    });
});