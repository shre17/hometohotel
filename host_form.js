 $(document).on('change', '#place_category_id', function() {
    var id = $(this).val();
    $.ajax({
      type:"post",
      url: "#{get_property_categories_path}",
      data: {id: id},
      success: function(response) {
        $('#place_property_type_id').removeAttr('disabled');
        $('#place_property_type_id').html('');
        $.each(response.data, function(key, value) {   
          $('#place_property_type_id')
            .append($("<option></option>")
                    .attr("value",value[0])
                    .text(value[1])); 
        });
      }
    })
  });

  $(document).on('change', '#place_property_type_id', function() {
    $(".guests_have").show();
  });
  

  $(".allownumericwithdecimal").on("keypress keyup blur",function (event) {
    $(this).val($(this).val().replace(/[^0-9\.]/g,''));
      if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
      }
    });

  $('#bedrooms .links a').hide()
  $(".guests_have").hide();
  $('#place_property_type_id').attr('disabled','disabled');  


  $(document).on('change', "#place_number_of_bedrooms", function(){
    var required_bedrooms = parseInt($(this).val().split(' ')[0]);

    var current_bedrooms = $('#bedrooms .nested-fields').length;

    var required_bedrooms = required_bedrooms - current_bedrooms;
    
    if (required_bedrooms < 0) {
      fields = $('#bedrooms .nested-fields');
      for (i = required_bedrooms; i < 0; i++) {
        field = $(fields[current_bedrooms+i])
        field.find('.bedroom-links a.remove_fields').trigger('click');
      }
    } else {
      for (i = 0; i < required_bedrooms; i++) { 
        $('#bedrooms .add-bedroom-link').find('[data-association=bedroom]').last().trigger('click');
      }
    }
  });

 
  function readFile(input) {
    $("#status").html('Processing...');
    counter = input.files.length;
    for(x = 0; x<counter; x++){
      if (input.files && input.files[x]) {

        var reader = new FileReader();

        reader.onload = function (e) {
          $("#photos").append('<div class="col-md-3 col-sm-3 col-xs-3"><img src="'+e.target.result+'" class="img-thumbnail"></div><input name="place[image][description]" class="form-control" type="text">');
        };

        reader.readAsDataURL(input.files[x]);
      }
    }
    if(counter == x){$("#status").html('');}
  }

  $('.btn-number').click(function(e){
      e.preventDefault();
      
      fieldName = $(this).attr('data-field');
      type      = $(this).attr('data-type');
      var input = $("input[name='"+fieldName+"']");
      var currentVal = parseInt(input.val());
      if (!isNaN(currentVal)) {
          if(type == 'minus') {
              
              if(currentVal > input.attr('min')) {
                  input.val(currentVal - 1).change();
              } 
              if(parseInt(input.val()) == input.attr('min')) {
                  $(this).attr('disabled', true);
              }

          } else if(type == 'plus') {

              if(currentVal < input.attr('max')) {
                  input.val(currentVal + 1).change();
              }
              if(parseInt(input.val()) == input.attr('max')) {
                  $(this).attr('disabled', true);
              }

          }
      } else {
          input.val(0);
      }
  });
  $('.input-number').focusin(function(){
     $(this).data('oldValue', $(this).val());
  });
  $('.input-number').change(function() {
      
      minValue =  parseInt($(this).attr('min'));
      maxValue =  parseInt($(this).attr('max'));
      valueCurrent = parseInt($(this).val());
      
      name = $(this).attr('name');
      if(valueCurrent >= minValue) {
          $(".btn-number[data-type='minus'][data-field='"+name+"']").removeAttr('disabled')
      } else {
          alert('Sorry, the minimum value was reached');
          $(this).val($(this).data('oldValue'));
      }
      if(valueCurrent <= maxValue) {
          $(".btn-number[data-type='plus'][data-field='"+name+"']").removeAttr('disabled')
      } else {
          alert('Sorry, the maximum value was reached');
          $(this).val($(this).data('oldValue'));
      }
      
      
  });
  $(".input-number").keydown(function (e) {
          // Allow: backspace, delete, tab, escape, enter and .
          if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
               // Allow: Ctrl+A
              (e.keyCode == 65 && e.ctrlKey === true) || 
               // Allow: home, end, left, right
              (e.keyCode >= 35 && e.keyCode <= 39)) {
                   // let it happen, don't do anything
                   return;
          }
          // Ensure that it is a number and stop the keypress
          if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
              e.preventDefault();
          }
      });
/ plus-minus-jquery
  $(function () {
      $('[data-toggle="popover"]').popover()
  })