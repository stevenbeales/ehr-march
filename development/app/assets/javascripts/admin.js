//= require jquery2
//= require jquery_ujs
//= require bootstrap/bootstrap.min.js
//= require jquery-ui
//= require jquery.cookie
//= require jquery.vmap
//= require jquery-migrate-min
//= require bootstrap-switch
//= require date
//= require moment/moment.js
//= require daterangepicker
//= require fullcalendar
//= require admin/jquery.vmap/jquery.vmap.sampledata.js
//= require admin/jquery.vmap/maps/jquery.vmap.europe.js
//= require admin/jquery.vmap/maps/jquery.vmap.germany.js
//= require admin/jquery.vmap/maps/jquery.vmap.russia.js
//= require admin/jquery.vmap/maps/jquery.vmap.usa.js
//= require admin/jquery.vmap/maps/jquery.vmap.world.js
//= require admin/jquery-slimscroll/jquery.slimscroll.min.js
//= require admin/jquery-blockui/jquery.blockUI.js
//= require admin/jquery-flot/jquery.flot.min.js
//= require admin/jquery-flot/jquery.flot.categories.min.js
//= require admin/jquery-flot/jquery.flot.resize.min.js
//= require admin/jquery-easypiechart/jquery.easypiechart.min.js
//= require admin/jquery-uniform/jquery.uniform.min.js
//= require admin/jquery-sparkline/jquery.sparkline.min.js
//= require admin/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js
//= require admin/metronic.js
//= require admin/demo.js
//= require admin/index.js
//= require admin/layout.js
//= require admin/quick-sidebar.js
//= require admin/tasks.js

$(document).ready(function() {
   Metronic.init(); // init metronic core componets
      Layout.init(); // init layout
      QuickSidebar.init(); // init quick sidebar
   Demo.init(); // init demo features
      Index.init();
      Index.initDashboardDaterange();
      Index.initJQVMAP(); // init index page's custom scripts
      Index.initCalendar(); // init index page's custom scripts
      Index.initCharts(); // init index page's custom scripts
      Index.initChat();
      Index.initMiniCharts();
      Tasks.initDashboardWidget();
});