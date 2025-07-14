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
    var spaceSlider = document.querySelectorAll('.space-slider');
    var roomSlider = document.querySelectorAll('.room-slider');
    var imgPropertySlider = document.querySelectorAll('.img-property-slide');
    var testimonialSlider = document.querySelectorAll('.testimonial-slider');
    
    const slider = tns({
      container: '.hero-slider',
  items: 1,
  slideBy: 'page',
  autoplay: true,
  autoplayTimeout: 7000,   // ← 5초
  speed: 600,
  controls: false,
  nav:     false,
  loop:    true,
  autoplayButtonOutput: false
  });

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

	 if (roomSlider.length > 0) {
      tns({
        container: '.room-slider',
        mode: 'carousel',
        speed: 700,
        gutter: 30,
        items: 3,
        autoplay: true,
        autoplayButtonOutput: false,
        controlsContainer: '#room-nav',
        responsive: {
          0: { items: 1 },
          700: { items: 2 },
          900: { items: 3 }
        }
      });
      }
      
      if (spaceSlider.length > 0) {
      tns({
        container: '.space-slider',
        mode: 'carousel',
        speed: 700,
        gutter: 30,
        items: 3,
        autoplay: true,
        autoplayButtonOutput: false,
        controlsContainer: '#space-nav',
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


