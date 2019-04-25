// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery.slick
//= require popper
//= require bootstrap-sprockets
//= require activestorage
//= require turbolinks
//= require webcam.min
//= require cocoon
//= require bootstrap-datepicker
//= require gmaps/google
//= require moment
//= require fullcalendar
//= require fullcalendar/locale-all
//= require autocomplete_address
//= require carouseller
//= require common_scripts
//= require ion.rangeSlider.min
//= require jquery.easing.1.3
//= require jquery.flexisel
// require main
//= require markerclusterer.min
//= require places
//= require pw_strenght
//= require setting_menu
//= require skdslider.min
//= require thumbslider-active
//= require thumbslider-plugins
//= require underscore-min
//= require validate
//= require wow.min
//= require common_jquery
//= require dataTables/jquery.dataTables
//= require chosen-jquery
//= require host
//= require alertify
//= require lightbox-bootstrap
//= require lightbox_bootstraped
// require_tree .

$(document).ready(function(){
  setTimeout( function(){
    $('.alert').fadeOut( "slow");
  }, 3000 );
})

$(document).on("click", "div.qtyInc, div.qtyDec" , function(){
  var guest_count = $("input#filter_guest_adult").val();
  $("span.qtyTotal").text(guest_count);
});

$(document).ready(function(){
  var guest_count = $("input#filter_guest_adult").val();
  $("span.qtyTotal").text(guest_count);
});

$(document).ready(function(){
  var pass_fields = $('input[type=password]')
  $(document).on('click','#show_password',function(){
    if ($(this).is(':checked')) {
      $.each(pass_fields, function(){
        $(this).attr('type','text')
      })
    }
    else {
      $.each(pass_fields, function(){
        $(this).attr('type','password')
      })      
    }
  });
});