$(document).on('click', 'a[id*=delete_micropost_]', function(event) {
  event.preventDefault();
  $.ajax({url: '/microposts/' + this.id.split("_")[2], type: 'DELETE', context: this, success: function() {    
    $(this).parent().parent().fadeOut(500, function() { $(this).remove(); });
  }});
});

$(document).on('click', 'a[id*=edit_micropost_]', function(event) {
  event.preventDefault();
  var old_text = $(this).siblings('#main_text').text().trim();
  var micropost_id = this.id.split("_")[2];
  $(this).siblings('#main_text').replaceWith($('#new_micropost').clone());
  $(this).siblings('form').children('fieldset').children('input[type=submit]').val("Save");
  $(this).siblings('form').children('fieldset').children('input[type=text]').val(old_text);
  $(this).siblings('form').bind("submit", function (event) {
    event.preventDefault();
    var new_text = $(this).children('fieldset').children('input[type=text]').val();
    $.ajax({url: '/microposts/' + micropost_id, type: 'PATCH', context: this, data: $(this).serialize(), success: function() {
      $(this).fadeOut(500, function() { $(this).replaceWith('<p id="main_text">' + new_text + '</p>'); });
    }});
  });
});
