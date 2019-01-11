$('#modal-request-emergency-access').html("<%= escape_javascript(render 'form_request_emergency_access') %>");
if(!$("#modal-request-emergency-access").hasClass('in'))
  $("#modal-request-emergency-access").modal("show");