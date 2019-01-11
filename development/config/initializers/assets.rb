Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf|otf)$/
Rails.application.config.assets.precompile += %w( *.eot *.woff *.ttf *.svg *.otf *.png *.jpg *.jpeg *.gif )
Rails.application.config.assets.precompile += %w( bootstrap/bootstrap.min.css bootstrap/bootstrap.min.js )
Rails.application.config.assets.precompile += %w(
                                                  bootstrap-datepicker-custom/bootstrap-datepicker-custom.js
                                                  bootstrap-datepicker-custom/bootstrap-datepicker-custom.css
                                                )
Rails.application.config.assets.precompile += %w( font-awesome/font-awesome.css )
Rails.application.config.assets.precompile += %w( animate/animate.css )
Rails.application.config.assets.precompile += %w( moment/moment.js )
Rails.application.config.assets.precompile += %w(
                                                  nprogress-custom/nprogress-custom.js
                                                  nprogress-custom/nprogress-custom.css
                                                )
Rails.application.config.assets.precompile += %w(
                                                  jquery-inputmask/jquery.inputmask.bundle-custom.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  jquery-validation/jquery.validate.min.js
                                                  jquery-validation/additional-methods.min.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  color-picker/color-picker.js
                                                  color-picker/tinycolor-0.9.15.min.js
                                                  color-picker/color-picker-theme.css
                                                  color-picker/color-picker.css
                                                )
Rails.application.config.assets.precompile += %w(
                                                  fullcalendar/fullcalendar.js
                                                  fullcalendar/fullcalendar.css
                                                )
Rails.application.config.assets.precompile += %w( jquery-ui/jquery-ui-without-datepicker.min.js )
Rails.application.config.assets.precompile += %w(
                                                  jquery-slimscroll-custom/jquery.slimscroll-custom.js
                                                  jquery-slimscroll-custom/jquery-slimscroll-custom.css
                                                  jquery-slimscroll-custom/themes/green-light.css
                                                  jquery-slimscroll-custom/themes/green-lighter.css
                                                )
Rails.application.config.assets.precompile += %w(
                                                  select2-custom/select2-custom.js
                                                  select2-custom/select2-custom.css
                                                  select2-custom/themes/classic.css
                                                  select2-custom/themes/default.css
                                                  select2-custom/themes/white-light.css
                                                  select2-custom/themes/green-light.css
                                                  select2-custom/themes/green-dark.css
                                                  select2-custom/themes/gray-light.css
                                                  select2-custom/themes/gray-lighter.css
                                                  select2-custom/themes/gray-dark.css
                                                  select2-custom/themes/green-white-light.css
                                                )
Rails.application.config.assets.precompile += %w(
                                                  bootstrap-dropdowns-enhancement/dropdowns-enhancement.js
                                                  bootstrap-dropdowns-enhancement/dropdowns-enhancement.min.css
                                                )
Rails.application.config.assets.precompile += %w(
                                                  authy-form/form.authy.css
                                                  authy-form/form.authy.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  any-login/any-login.css
                                                  any-login/any-login.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                landing.css
                                                landing.js
                                              )
Rails.application.config.assets.precompile += %w(
                                                  error.css
                                                  error.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  dashboard.css
                                                  dashboard.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  authorization.css
                                                  authorization.js
                                                )
Rails.application.config.assets.precompile += %w( mailer.css )
Rails.application.config.assets.precompile += %w( controls.css )
Rails.application.config.assets.precompile += %w( devise_authy.js )
Rails.application.config.assets.precompile += %w(
                                                  providers.css
                                                  providers.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  providers/patients.css
                                                  providers/patients.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  providers/settings.css
                                                  providers/settings.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  patients.css
                                                  patients/patients.js
                                                )
Rails.application.config.assets.precompile += %w( 
                                                  tables.css 
                                                  tables.js 
                                                )
Rails.application.config.assets.precompile += %w( 
                                                  full_calendar/calendars.js 
                                                  full_calendar/full_calendar.css 
                                                )
Rails.application.config.assets.precompile += %w(
                                                  patient_treatments/main.css
                                                  patient_treatments/main.js
                                                )
Rails.application.config.assets.precompile += %w(
                                                  email_messages/main.css
                                                  email_messages/main.js
                                                )
Rails.application.config.assets.precompile += %w( appointments.css )
Rails.application.config.assets.precompile += %w( dosespot.css )
# Admin Dashboard
Rails.application.config.assets.precompile += %w( admin/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js )
Rails.application.config.assets.precompile += %w( admin/simple-line-icons/simple-line-icons.css )
Rails.application.config.assets.precompile += %w( admin/jquery-slimscroll/jquery.slimscroll.min.js )
Rails.application.config.assets.precompile += %w( admin/jquery-blockui/jquery.blockUI.js )
Rails.application.config.assets.precompile += %w(
                                                  admin/jquery-flot/jquery.flot.min.js
                                                  admin/jquery-flot/excanvas.min.js
                                                  admin/jquery-flot/jquery.colorhelpers.min.js
                                                  admin/jquery-flot/jquery.flot.canvas.min.js
                                                  admin/jquery-flot/jquery.flot.categories.min.js
                                                  admin/jquery-flot/jquery.flot.crosshair.min.js
                                                  admin/jquery-flot/jquery.flot.errorbars.min.js
                                                  admin/jquery-flot/jquery.flot.fillbetween.min.js
                                                  admin/jquery-flot/jquery.flot.image.min.js
                                                  admin/jquery-flot/jquery.flot.navigate.min.js
                                                  admin/jquery-flot/jquery.flot.pie.min.js
                                                  admin/jquery-flot/jquery.flot.resize.min.js
                                                  admin/jquery-flot/jquery.flot.selection.min.js
                                                  admin/jquery-flot/jquery.flot.stack.min.js
                                                  admin/jquery-flot/jquery.flot.symbol.min.js
                                                  admin/jquery-flot/jquery.flot.threshold.min.js
                                                  admin/jquery-flot/jquery.flot.time.min.js
                                                )
Rails.application.config.assets.precompile += %w( admin/jquery-easypiechart/jquery.easypiechart.min.js )
Rails.application.config.assets.precompile += %w(
                                                  admin/jquery-uniform/jquery.uniform.min.js
                                                  admin/jquery-uniform/jquery.uniform.min.css
                                                )
Rails.application.config.assets.precompile += %w( admin/jquery-sparkline/jquery.sparkline.min.js )
Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( admin/demo.js )
Rails.application.config.assets.precompile += %w( admin/index.js )
Rails.application.config.assets.precompile += %w( admin/layout.js )
Rails.application.config.assets.precompile += %w( admin/metronic.js )
Rails.application.config.assets.precompile += %w( admin/quick-sidebar.js )
Rails.application.config.assets.precompile += %w( admin/tasks.js )
Rails.application.config.assets.precompile += %w( admin/components.css )
Rails.application.config.assets.precompile += %w( admin/custom.css )
Rails.application.config.assets.precompile += %w( admin/layout.css )
Rails.application.config.assets.precompile += %w( admin/plugins.css )
Rails.application.config.assets.precompile += %w( admin/tasks.css )
Rails.application.config.assets.precompile += %w( admin/theme/darkblue.css )
Rails.application.config.assets.precompile += %w(
                                                  admin/jquery.vmap/jquery.vmap.sampledata.js
                                                  admin/jquery.vmap/maps/jquery.vmap.europe.js
                                                  admin/jquery.vmap/maps/jquery.vmap.germany.js
                                                  dmin/jquery.vmap/maps/jquery.vmap.russia.js
                                                  admin/jquery.vmap/maps/jquery.vmap.usa.js
                                                  admin/jquery.vmap/maps/jquery.vmap.world.js
                                                )
