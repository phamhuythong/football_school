// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual
// application logic in a relevant structure within app/javascript and only use
// these pack files to reference that code so it'll be compiled.

require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('channels');

// Uncomment to copy all static images under ../images to the output folder and
// reference them with the image_pack_tag helper in views
// (e.g <%= image_pack_tag 'rails.png' %>) or the `imagePath`
// JavaScript helper below.

// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// require('@nathanvda/cocoon');
// require('./plugins/vanillaSelectBox');

var jQuery = require('jquery');

global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import 'bootstrap';

import '../stylesheets/application';
import "select2/dist/js/select2";
require('admin-lte');
import "@fortawesome/fontawesome-free/js/all";

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
  $('.select2').select2();
});
