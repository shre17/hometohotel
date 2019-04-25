(function ($) {
	'use strict';

	/* Popular Post SLider Active */
	$('.polular-post-slider-active').slick({
		slidesToShow: 3,
		infinite: true,
		autoplay: true,
		autoplaySpeed: 5000,
		arrows: true,
		prevArrow: '<span class="cr-navigation cr-navigation-prev"><i class="fa fa-angle-left"></i></span>',
		nextArrow: '<span class="cr-navigation cr-navigation-next"><i class="fa fa-angle-right"></i></span>',
		dots: false,
		responsive: [{
			breakpoint: 991,
			settings: {
				slidesToShow: 2,
				slidesToScroll: 1
			}
		},
		{
			breakpoint: 576,
			settings: {
				slidesToShow: 1,
				slidesToScroll: 1
			}
		}
	]
	});
	
})(jQuery);
