$(document).on('click', '#change-offer .close', function(){
  $("#manage-offer").modal('show');
});

$(document).on('click', '.add-place-btn', function() {
  $('.add-new-place-record-for-offer').toggle('show');
});

$(document).on('click', '.add-experience-btn', function() {
  $('.add-new-experience-record-for-offer').toggle('show');
});

$(document).on('click', '#manage-offer .close', function() {
  $("#manage-offer .modal-dialog").addClass('small');
});
