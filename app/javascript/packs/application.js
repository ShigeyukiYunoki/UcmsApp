// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
// require('jquery')
// config/webpack/environment.jsでrequire済のため不要
require("bootstrap"); // views/layouts/_flashにおいてbootstrapを適応させるのに必要だった

// import 'bootstrap'; // webpackは'require'と'import'のどちらでも対応可能なのでこちらでもok

// create.js.erb destroy.js.erbが動くのに必要
window.$ = $;
import "@fortawesome/fontawesome-free/js/all";
import "../stylesheets/application";
// import '../post/today';
import "../post/image_size";
import "../js/swiper";
import "../js/sweetalert";

// import '../js/timepicker';
// import '../js/afternotification';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context("../images", true);
const imagePath = (name) => images(name, true);
