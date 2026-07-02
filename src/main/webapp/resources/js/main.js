/* PetCare - main.js */
document.addEventListener('DOMContentLoaded', () => {

    /* =============================================
       HERO SLIDER
       ============================================= */
    const slides   = document.querySelectorAll('.hero-slide');
    const dots     = document.querySelectorAll('.slide-dot');
    const indicator = document.querySelector('.slide-indicator');
    let current = 0;
    let autoTimer = null;

    function goTo(idx) {
        slides[current].classList.remove('active');
        dots[current]?.classList.remove('active');
        current = (idx + slides.length) % slides.length;
        slides[current].classList.add('active');
        dots[current]?.classList.add('active');
        if (indicator) indicator.textContent = `${current + 1} / ${slides.length}`;
    }

    function startAuto() {
        autoTimer = setInterval(() => goTo(current + 1), 4500);
    }
    function stopAuto() {
        clearInterval(autoTimer);
    }

    if (slides.length) {
        document.querySelector('.btn-prev')?.addEventListener('click', () => { stopAuto(); goTo(current - 1); startAuto(); });
        document.querySelector('.btn-next')?.addEventListener('click', () => { stopAuto(); goTo(current + 1); startAuto(); });
        document.querySelector('.btn-pause')?.addEventListener('click', function () {
            this.textContent === '❚❚' ? (stopAuto(), this.textContent = '▶') : (startAuto(), this.textContent = '❚❚');
        });
        dots.forEach((d, i) => d.addEventListener('click', () => { stopAuto(); goTo(i); startAuto(); }));
        startAuto();
    }

    /* =============================================
       LAZY IMAGE FALLBACK
       ============================================= */
    document.querySelectorAll('img').forEach(img => {
        img.addEventListener('error', () => {
            img.src = 'https://placehold.co/400x300/EAF7F2/2BAB82?text=PetCare';
        });
    });
});
