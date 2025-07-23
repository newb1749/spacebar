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

  // tinySlider 함수 정의 시작
  var tinySlider = function () {
    // 슬라이더 컨테이너 요소들을 올바르게 선택
    var heroSliderContainer = document.querySelector('.hero-slider');
    var spaceSliderContainer = document.querySelector('.space-slider');
    var roomSliderContainer = document.querySelector('.room-slider');
    var imgPropertySliderContainer = document.querySelector('.img-property-slide'); // 이 클래스가 HTML에 있는지 다시 확인해주세요
    var testimonialSliderContainer = document.querySelector('.testimonial-slider');

    // Hero Slider 초기화
    if (heroSliderContainer) {
      tns({
        container: heroSliderContainer,
        items: 1,
        slideBy: 'page',
        autoplay: true,
        autoplayTimeout: 7000, // 7초
        speed: 600,
        controls: false,
        nav: false,
        loop: true,
        autoplayButtonOutput: false
      });
    }

    // imgPropertySlider 초기화 (이 슬라이더가 실제로 사용되는지 HTML에서 확인 필요)
    if (imgPropertySliderContainer) {
      tns({
        container: imgPropertySliderContainer,
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

    // Room Slider 초기화
    if (roomSliderContainer) {
      tns({
        container: roomSliderContainer,
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

    // Space Slider 초기화
    if (spaceSliderContainer) {
      tns({
        container: spaceSliderContainer,
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

    // Testimonial Slider 초기화
    if (testimonialSliderContainer) {
      tns({
        container: testimonialSliderContainer,
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
  } // tinySlider 함수 정의 끝

  // tinySlider 함수 호출
  tinySlider();

})();

  document.addEventListener('DOMContentLoaded', function () {

    // tiny-slider init
    const promo = tns({
      container: '#promoSlider',
      items: 1,
      slideBy: 1,
      autoplay: true,
      autoplayButtonOutput: false,
      controls: false,   // 기본 화살표 안 씀
      nav: false,        // 하단 도트 안 씀
      speed: 400,
      autoplayTimeout: 5000
    });

    document.querySelector('.promo-prev').addEventListener('click', () => promo.goTo('prev'));
    document.querySelector('.promo-next').addEventListener('click', () => promo.goTo('next'));
  });