(function () {
  'use strict'

  AOS.init({
    duration: 800,
    easing: 'slide',
    once: true
  });

  var preloader = function () {
    var loader = document.querySelector('.loader');
    var overlay = document.getElementById('overlayer');

    function fadeOut(el) {
      if (!el) return;
      el.style.opacity = 1;
      (function fade() {
        if ((el.style.opacity -= 0.1) < 0) {
          el.style.display = "none";
        } else {
          requestAnimationFrame(fade);
        }
      })();
    }

    setTimeout(function () {
      fadeOut(loader);
      fadeOut(overlay);
    }, 200);
  };
  preloader();

  // ✅ 오타 수정: tinySdlier → tinySlider
  var tinySlider = function () {
    var heroSlider = document.querySelectorAll('.hero-slide');
    var propertySlider = document.querySelectorAll('.property-slider');
    var imgPropertySlider = document.querySelectorAll('.img-property-slide');
    var testimonialSlider = document.querySelectorAll('.testimonial-slider');

    if (heroSlider.length > 0) {
      tns({
        container: '.hero-slide',
        mode: 'carousel',
        speed: 700,
        autoplay: true,
        controls: false,
        nav: false,
        autoplayButtonOutput: false,
        controlsContainer: '#hero-nav',
      });
    }

    if (imgPropertySlider.length > 0) {
      tns({
        container: '.img-property-slide',
        mode: 'carousel',
        speed: 700,
        items: 1,
        gutter: 30,
        autoplay: true,
        controls: false,
        nav: true,
        autoplayButtonOutput: false
      });
    }

    if (propertySlider.length > 0) {
      tns({
        container: '.property-slider',
        mode: 'carousel',
        speed: 700,
        gutter: 30,
        items: 3,
        autoplay: true,
        autoplayButtonOutput: false,
        controlsContainer: '#property-nav',
        responsive: {
          0: { items: 1 },
          700: { items: 2 },
          900: { items: 3 }
        }
      });
    }

    if (testimonialSlider.length > 0) {
      tns({
        container: '.testimonial-slider',
        mode: 'carousel',
        speed: 700,
        items: 3,
        gutter: 50,
        autoplay: true,
        autoplayButtonOutput: false,
        controlsContainer: '#testimonial-nav',
        responsive: {
          0: { items: 1 },
          700: { items: 2 },
          900: { items: 3 }
        }
      });
    }
  }

  // ✅ 함수명도 맞게 실행
  tinySlider();

})();
