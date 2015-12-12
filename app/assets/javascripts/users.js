// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {

  $('.admin-form select').change(function() {
    if ($('.admin-form select option:selected').val() === 'true') {
      $('.admin-hide').hide();
    } else {
      $('.admin-hide').show();
    }
  });

});
