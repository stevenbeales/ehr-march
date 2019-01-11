//= require application

$(document).ajaxStart(function(e) {
  NProgress.start();
});

$(document).ajaxStop(function() {
  NProgress.done();
});

$(document).ready(function(e) {
  initModalFadeInOut('.tables-container');
  initModalsReposition();
});