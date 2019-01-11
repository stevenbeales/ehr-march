Element.prototype.hasClass = function (className) {
  return new RegExp(' ' + className + ' ').test(' ' + this.className + ' ');
};

Element.prototype.addClass = function (className) {
  if (!this.hasClass(className)) {
    this.className += ' ' + className;
  }
};

Element.prototype.removeClass = function (className) {
  var newClass = ' ' + this.className.replace(/[\t\r\n]/g, ' ') + ' '
  if (this.hasClass(className)) {
    while (newClass.indexOf( ' ' + className + ' ') >= 0) {
      newClass = newClass.replace(' ' + className + ' ', ' ');
    }
    this.className = newClass.replace(/^\s+|\s+$/g, ' ');
  }
};
Element.prototype.toggleClass = function (className) {
  var newClass = ' ' + this.className.replace(/[\t\r\n]/g, " ") + ' ';
  if (this.hasClass(className)) {
    while (newClass.indexOf(" " + className + " ") >= 0) {
      newClass = newClass.replace(" " + className + " ", " ");
    }
    this.className = newClass.replace(/^\s+|\s+$/g, ' ');
  } else {
    this.className += ' ' + className;
  }
};

var AnyLogin = {};
AnyLogin.on_image_click = function() {
  var elem = document.getElementById('any_login_box');
  elem.toggleClass("hidden_box");
  elem.toggleClass("visible_box");
  var parent = document.getElementById('any_login');
  parent.toggleClass("any_login_visible");
};
AnyLogin.on_select_change = function() {
  document.getElementById('any_login_form').submit();
};

$(document).mousedown(function(e) {
  if($('#any_login').length > 0) {
    if($(e.target).closest('.any-login').length == 0) {
      if(document.getElementById('any_login').hasClass('any_login_visible')) {
        var elem = document.getElementById('any_login_box');
        elem.toggleClass("hidden_box");
        elem.toggleClass("visible_box");
        var parent = document.getElementById('any_login');
        parent.toggleClass("any_login_visible");
      }
    }
  }
})