//= require application
//= require authy-form/form.authy.js
//= require devise_authy
//= require authorization
//= require zipcode
//= require controls

$(document).ready(function() {
  var passwordLength = 5;
  $('#signup-personalinfo').collapse('show');
  var active = true;
  $('#collapse-parent .left-block').on('show.bs.collapse', function (e) {
    if (active&&(e.target.className).indexOf('left-block')>-1)
      $('#collapse-parent .left-block.in').collapse('hide');
  });
  $('#collapse-parent').on('shown.bs.collapse', function (e) {
    validateForm();
    formValidCheck($('.collapse.left-block.in input').first());
    var id = $('.collapse.left-block.in').attr('id').substring(7,$('.collapse.left-block.in').attr('id').length);
    $('.button-cat div').each(function() {
      $(this).removeClass('active');
    });
    $('#'+id+' div').addClass('active');
  });
  var practiceAddressIds = ['#user_provider_practice_street_address','#user_provider_practice_suit_apt_number','#user_provider_practice_city','#user_provider_practice_state','#user_provider_practice_zip']
  var mainAddressIds = ['#user_provider_street_address','#user_provider_suit_apt_number','#user_provider_city','#user_provider_state','#user_provider_zip']
  var mainVars = ['','','','AL','']
  $('.checkbox-same-as-practice input[type=checkbox]').bind('change', function() {
    if(($(this).is(":checked"))) {
      for(var i = 0; i < mainAddressIds.length; i++)
      {
        if(!$(mainAddressIds[i])[0].nodeName=='SELECT') {
          mainVars[i] = $(mainAddressIds[i]).val();
        }
        else {
          disableControl($(mainAddressIds[i]));
          mainVars[i] = $(mainAddressIds[i]).val();
        }
        $(mainAddressIds[i]).val($(practiceAddressIds[i]).val());
      }
    }
    else {
      for(var i = 0; i < mainAddressIds.length; i++)
      {
        if($(mainAddressIds[i])[0].nodeName=='SELECT'){
          $(mainAddressIds[i]).val(mainVars[i]);
        }
        else {
          enableControl($(mainAddressIds[i]));
          $(mainAddressIds[i]).val(mainVars[i]);
        }
      }
    }
  });

  function buttonNextStateChange(isEnable, button)
  {
    var parent = $(button).parents('.collapse.left-block.in');
    var id = $(parent).attr('id').substring(7,$(parent).attr('id').length);
    var rightCatButton = $(parent).parent().parent().find('.button-cat');
    if(!isEnable) {
      disableControl($(parent).find('.button-next'));
      $('#'+id+' div').removeClass('performed');
      $('#'+id+' div').addClass('active');
    }
    else {
      enableControl($(parent).find('.button-next'));
      $('#'+id+' div').removeClass('active');
      $('#'+id+' div').addClass('performed');
    }
  }

  function validateForm() {
    jQuery.validator.addMethod("notEqualTo", function(value, element, param) {
      return this.optional(element) || value != $(param).val();
    }, "This has to be different...");
    $('#new_user').validate({
      highlight: function(element) {
        buttonNextStateChange(false, element);
        $(element).addClass('unvalid');
        $(element).removeClass('valid');
      },
      unhighlight: function(element) {
        $(element).removeClass('unvalid');
        $(element).addClass('valid');
      },
      errorPlacement: function(error,element) {
        return true;
      },
      rules: {
        //Personal rules
        'title': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][first_name]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][last_name]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][middle_name]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'degree': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'speciality': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        //Contact info rules
        'user[provider][street_address]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][city]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][state]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][zip]': {
          number: true,
          minlength: 5,
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][practice_street_address]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][practice_city]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][provider][practice_state]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][practice_zip]': {
          number: true,
          minlength: 5,
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][primary_phone]': {
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][mobile_phone]': {
          notEqualTo: "#user_provider_primary_phone",
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        //Account info rules
        'user[provider][email]': {
          email: true,
          notEqualTo: "#user_alt_email",
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[provider][alt_email]': {
          email: true,
          notEqualTo: "#user_email",
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[password]': {
          minlength: passwordLength,
          required: {
            required: true,
            depends: function(element) {
            return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        },
        'user[password_confirmation]': {
            equalTo: "#user_password",
            minlength: passwordLength,
            required: {
              required: true,
              depends: function(element) {
              return $(($(element).parents('.left-block').hasClass('in'))==true);
            }
          }
        }
      }
    });
    $('#new_user').valid();
  }

  function formValidCheck(element) {
    if($('#new_user').valid()){
      buttonNextStateChange(true, element);
    };
  }

  function inputListeners() {
    $('#new_user .authorization-signup-wrapper input, #new_user .authorization-signup-wrapper select').bind('input change', function() {
      formValidCheck($(this));
      if($(this).attr('id')=='user_password'||$(this).attr('id')=='user_password_confirmation')
        passwordInputChangeSize($(this));
    });
    $('#new_user .authorization-signin-wrapper #user_password, #new_user .passwords-wrapper input[type="password"]').bind('input', function() {
      passwordInputChangeSize($(this));
    })
  }
  inputListeners();

  function passwordInputChangeSize(element)
  {
    if($(element).val().length>0)
      $(element).addClass('input-password');
    else
      $(element).removeClass('input-password');
  }

  function onInputContactInfoChanges() {
    for(var i = 0; i < practiceAddressIds.length; i++)
    {
      $(practiceAddressIds[i]).on('input', function() {
        if($('.checkbox-same-as-practice input[type=checkbox]').is(':checked'))
          $('#user_provider_'+$(this).attr('id').substring(23)).val($(this).val());
        formValidCheck($(this));
      });
    }
  }
  onInputContactInfoChanges();

  $('.button-switch').click(function()
  {
    $($(this).attr('data-target')).collapse('show');
  });

  $(document).ajaxStart(function(e) {
    NProgress.start();
  });

  $(document).ajaxStop(function() {
    NProgress.done();
  });

  initPickers();
  $('.input-phone').inputmask("(999)999-9999");
  initSelect2('.authorization-signup-wrapper');
  initModalsReposition();
  $('.modal-passwords').modal('show');

  $(function() {
    var zipcode_controller = new ZipcodeController();
    zipcode_controller.initialize('#user_provider_city', '#user_provider_state', '#user_provider_zip', '#city-list',  '#zip-list', true, '#user_provider_practice_city', '#user_provider_practice_state', '#user_provider_practice_zip', '#practice-city-list',  '#practice-zip-list');
  })
});
