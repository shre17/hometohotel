var dropdown = '.setting-menu li:has(ul)',
    dropdown_ul = '.setting-menu li ul',
    nav_ul = '.setting-menu > ul',
    nav_toggle = '.setting-menu .nav-toggle',
    open_class = 'open',
    desktop_class = 'desktop',
    breakpoint = 640,
    anim_delay = 200;


function isDesktop() {
  return ($(window).width() > breakpoint);
}


$(function() {
  $(document).click(function(e) {
    e.stopImmediatePropagation()
    var target = $(e.target).parent();
    var target_ul = target.children('ul');

    if (!isDesktop()) {
      $(dropdown).not(target).removeClass(open_class);
      $(dropdown_ul).not(target_ul).slideUp(anim_delay);

      if (target.is(dropdown)) {
        target.toggleClass(open_class);
        target_ul.slideToggle(anim_delay);
      }

      if (target.is(nav_toggle)) {
        target.toggleClass(open_class);
        $(nav_ul).slideToggle(anim_delay);
      }
    }
  })

  $(window).resize(function() {
    $('body').toggleClass(desktop_class, isDesktop());

    if (isDesktop()) {
      $(dropdown).removeClass(open_class);
      $(dropdown_ul).hide();
      $(nav_toggle).addClass(open_class);
      $(nav_ul).show();
    }
    else{
      $(nav_toggle).addClass(open_class);
      $(dropdown_ul).hide();
      $(nav_ul).hide();
    }
  });

  $(window).resize();
});