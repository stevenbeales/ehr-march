//= require application
//= require any-login/any-login.js
//= require select2-custom/select2-custom.js

$(document).ready(function(){
	initSelect2('#any_login_form');

	var provider_acc = $('.landing-wrapper .provider-acc');
	var patient_acc = $('.landing-wrapper .patient-acc');
	var change_text = $('.registration .change-text');
	var change_button = $('.registration .change-button');
	var change_text_secondary = $('.registration .change-text-secondary');

	provider_acc.click(function(){
		if($.trim(change_text.text()) == "Don\'t have a client account yet?"){
			change_text.text('Don\'t have a practitioner account yet?');
		}
		if($.trim(change_text_secondary.text()) == "Contact you Doctor\'s Office and request an invite email to setup your Patient Account today!"){
			change_text_secondary.text('Register today to receive all the befits');
		}
		if(change_button.css('display')=='none') {
			change_button.css('display','block');
		}
		$(this).addClass('active');
		patient_acc.removeClass('active');
	});
	patient_acc.click(function(){
		if($.trim(change_text.text()) == "Don't have a practitioner account yet?"){
			change_text.text('Don\'t have a client account yet?');
			if($.trim(change_text_secondary.text()) == "Register today to receive all the befits"){
				change_text_secondary.text('Contact you Doctor\'s Office and request an invite email to setup your Patient Account today!');
			}
			if(change_button.css('display')!='none') {
				change_button.css('display','none');
			}
			$(this).addClass('active');
			provider_acc.removeClass('active');
		}
		else{
			change_text.text('Don\'t have a client account yet?');
		}
	});
});
