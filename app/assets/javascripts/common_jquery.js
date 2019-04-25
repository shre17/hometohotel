if ((window.gon != null) && gon.mobile_request) {
  $('#mobile-nav a').click(function(){
    $('#mobile-nav a').toggleClass('active-menu ');
    $('.toggle-menu-list').slideToggle(300);
  })
}

$(document).on('click','#hamburger',function(){
  $('#experience-tab').hide();
});

$(document).on('click','#sidebar-toogle-btn',function(){
  $('#experience-tab').show();
})

$(document).ready(function(){
  $('.datepicker').datepicker({
    format: 'yyyy-mm-dd',
    startDate:'+0d',
    autoclose: true
  });

  $(document).on("click", ".icon_calendar", function(){
    $(this).siblings("input").datepicker("show");    
  });
});

$(document).ready(function(){
  setTimeout(function(){
    if($('body').height()<700){
      $('footer').addClass('fixed-footer');
    }
  }, 300);  
})
