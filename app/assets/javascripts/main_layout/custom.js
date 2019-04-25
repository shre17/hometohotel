$(document).ready(function(){
    $('.promo-slider').slick({
        slidesToShow: 5,
        prevArrow: '<i class="flaticon-right-arrow prev"></i>',
        nextArrow: '<i class="flaticon-right-arrow"></i>',
        responsive: [{
                breakpoint: 992,
                settings: {
                    slidesToShow: 3
                }
            }, {
                breakpoint: 768,
                settings: {
                    slidesToShow: 3
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 2
                }
            }
        ]
    });


    $('.property-slider').slick({
        slidesToShow: 4,
        prevArrow: '<i class="flaticon-right-arrow prev"></i>',
        nextArrow: '<i class="flaticon-right-arrow"></i>',
        responsive: [{
                breakpoint: 992,
                settings: {
                    slidesToShow: 4
                }
            }, {
                breakpoint: 768,
                settings: {
                    slidesToShow: 2
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1
                }
            }
        ]
    });


    $('.step-slider').slick({
        dots: true,
        infinite: true,
        speed: 500,
        fade: true,
        cssEase: 'linear',
        // arrows: false,
        draggable: false,
        prevArrow: $('.prev-step'),
        nextArrow: $('.next-step')
    });


    $(function() {
        $("#sidebar").stick_in_parent({
            offset_top: 100
        });
    });
});    