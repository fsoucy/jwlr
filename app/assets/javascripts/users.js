$(document).on('click', 'button[id*=follow_]', function(event) {
  $.ajax({url: '/users/' + this.id.split("_")[1] + '/follow', type: 'POST', context: this, success: function() { 
    if($(this).html().trim() != "Me")
    {
      if($(this).html().trim() == "Follow")
      {
        $(this).html('Unfollow');
      }
      else
      {
        $(this).html('Follow');
      }
    }
  }});
});

$(document).on('click', 'button[id*=save_product_]', function (event) {
  $.ajax({url: '/users/' + this.id.split("_")[3] + '/save_product', type: 'POST', data: {product_id: this.id.split("_")[2]}, context: this, success: function() {
    if($(this).text() == "Remove")
    {
      $(this).parent().fadeOut(500, function() { 
        $(this).parent().remove(); 
      });
    }
    else if($(this).text() == "Add to wishlist")
    {
      $(this).text("Remove from wishlist");
    }
    else
    {
      $(this).text("Add to wishlist");
    }
  }});
});

$(document).ready(function(){
  // disable auto discover
  Dropzone.autoDiscover = false;
  $("#new_user_picture").dropzone({
	  // restrict image size to a maximum 1MB
	  maxFilesize: 10,
	  // changed the passed param to one accepted by
	  // our rails app
	  paramName: "picture[photo]",
	  // show remove links on each image upload
	  autoProcessQueue: true,
	  dictDefaultMessage: "Upload here",
	  addRemoveLinks: false,
	  maxFiles: 8,
	  acceptedFiles: "image/*",
	  // if the upload was successful
	  success: function(file, response){
	    // find the remove button link of the uploaded file and give it an id
	    // based of the fileID response from the server
	    $(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
	    // add the dz-success class (the green tick sign)
	    $(file.previewElement).addClass("dz-success");
	  },
	  init: function() {
	    var dropzone = this;
	    dropzone.options.params = {post_type: "User"};
	  }
  });
});    
