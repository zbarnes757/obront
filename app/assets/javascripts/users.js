// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {

  $('.admin-form select').change(function() {
    if ($('.admin-form select option:selected').val() === 'true') {
      $('.looking-for-work-form').hide();
      $('.classification-form').hide();
    } else {
      $('.looking-for-work-form').show();
      $('.classification-form').show();
    }
  });

});
