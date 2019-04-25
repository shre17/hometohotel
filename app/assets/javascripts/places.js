$(document).on('click','.input-number-increment',function() {
  var $input = $(this).parents('.input-number-group').find('.input-number');
  var max_val = parseInt($input.attr('max'), 10) || 5;
  var val = parseInt($input.val(), 10);
  if (val < max_val){
    $input.val(val + 1);
  }
  calculate_total(this);
});

$(document).on('click','.input-number-decrement',function() {
  var $input = $(this).parents('.input-number-group').find('.input-number');
  var val = parseInt($input.val(), 10);
  if (val > 0) {
    $input.val(val - 1);
  }
  calculate_total(this);
});

$(document).on('click','.input-number-decrement-guest',function() {
  var $input = $(this).parents('.input-number-group').find('.input-number');
  var val = parseInt($input.val(), 10);
  if (val > 1) {
    $input.val(val - 1);
  }
});

function calculate_total(that) {
  if($('#txtCheckIn').length > 0 && $('#txtCheckOut').length > 0){
    var $input = $(that).parents('.input-number-group').find('.input-number');
    var val = parseInt($input.val(), 10);
    var start_date = $('#txtCheckIn').datepicker('getDate');
    var end_date = $('#txtCheckOut').datepicker('getDate');
    // var room_price = $(".price").text().match(/\d+/)[0];
    var room_price = $(".price").data('price');

    var days = parseInt((end_date - start_date)/1000/60/60/24)
    if (val > 1) {
      var total = days * room_price * (val)
    }
    else{
      var total = days * room_price
    }
    $('#reservation_days').text(days);
    $('#hidden_reservation_days').text(days);
    $('#reservation_sum').text(total);
    $('#reservation_total').val(total);
    $('#final-reservation_sum').text(total);
    $('#final-reservation_total').val(total);
    document.getElementById('hidden_reservation_total').value = total;
    $('#btn_book').attr('disabled', false);
  }
}
