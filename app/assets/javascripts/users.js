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
	    dropzone.on('queuecomplete', function() {
	    });
	}
    });
});
