// import Swiper bundle with all modules installed
import Swiper from "swiper/bundle";

// init Swiper:
document.addEventListener("turbolinks:load", function () {
  const mySwiper1 = new Swiper(".swiper1", {
    // Optional parameters
    loop: true,
    mousewheel: true,
    centeredSlides: true,
    slidesPerView: 1.5,
    // autoHeight: true,
    autoplay: {
      delay: 2000,
      disableOnInteraction: true,
    },
    effect: "coverflow",
    // If we need pagination
    pagination: {
      el: ".page1",
    },

    // Navigation arrows
    // navigation: {
    //   nextEl: '.swiper-button-next',
    //   prevEl: '.swiper-button-prev',
    // },

    // And if we need scrollbar
    // scrollbar: {
    //   el: '.swiper-scrollbar',
    // },
  });

  const mySwiper2 = new Swiper(".swiper2", {
    // Optional parameters
    loop: true,
    mousewheel: true,
    centeredSlides: true,
    slidesPerView: 1.5,
    // autoHeight: true,
    autoplay: {
      delay: 2000,
      disableOnInteraction: true,
    },
    effect: "coverflow",
    // If we need pagination
    pagination: {
      el: ".page2",
    },
  });
});
