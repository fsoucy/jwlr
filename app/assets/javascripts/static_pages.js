$(document).on('click', 'a[id*=delete_micropost_]', function(event) {
  event.preventDefault();
  $.ajax({url: '/microposts/' + this.id.split("_")[2], type: 'DELETE', context: this, success: function() {    
    $(this).parent().parent().fadeOut(500, function() { $(this).remove(); });
  }});
});

$(document).on('click', 'a[id*=edit_micropost_]', function(event) {
  event.preventDefault();
  var old_text = $(this).siblings('#main_text').text().trim();
  $(this).siblings('#main_text').replaceWith($('#new_micropost').clone());
  $(this).siblings('form').children('fieldset').children('input[type=submit]').val("Save");
  $(this).siblings('form').children('fieldset').children('input[type=text]').val(old_text);
  //$.ajax({url: '/microposts/' + this.id.split("_")[2], type: 'PATCH', context: this, succes$
  //  $(this).parent().parent().fadeOut(500, function() { $(this).remove(); });
  //}});
});

//      $(this).siblings('p').text(data.content);

