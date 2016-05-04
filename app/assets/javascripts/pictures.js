
$(document).ready(function(){
  // disable auto discover
  Dropzone.autoDiscover = false;
  // grap our upload form by its id
  $("#new_picture").dropzone({
    // restrict image size to a maximum 1MB
    maxFilesize: 10,
    // changed the passed param to one accepted by
    // our rails app
    paramName: "picture[photo]",
      // show remove links on each image upload
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
	evaluatePicture();
    },
    //when the remove button is clicked
    removedfile: function(file){
      // grap the id of the uploaded file we set earlier
      var id = $(file.previewTemplate).find('.dz-remove').attr('id');

      // make a DELETE ajax request to delete the file
      $.ajax({
        type: 'DELETE',
        url: '/pictures/' + id,
        success: function(data){
            console.log(data.message);
	    evaluatePicture();
        }
      });
    }
  });

    var $image = $('#image');
    var factor = parseFloat($('#factor').val());
    var cropBoxData = { left: 0, top: 0, width: 800, height: 800};
    var canvasData = { left: 0, top: 0, width: 800, height: 800 } ;

    
    $image.cropper({
	zoomable: false,
	toggleDragModeOnDblClick: false,
	cropBoxResizable: true,
	aspectRatio: 1.00,
	built: function () {
	    $image.cropper('setCanvasData', canvasData);
	    $image.cropper('setCropBoxData', cropBoxData);
	}

    });
    debugger;
    
    if ($('#factor').length > 0)
    {
	debugger;
	cropBoxData = $image.cropper('getCropBoxData');
	canvasData = $image.cropper('getCanvasData');
	var x = cropBoxData.left;
	var y = cropBoxData.top;
	var factor = 1 / parseFloat($('#factor').val());
	console.log(x);
	var offsetX = (600.0 - $('.cropper-canvas').width()) / 2.0;
	var offsetY =  (600.0 - $('.cropper-canvas').height()) / 2.0;
	$('#x').val(x - offsetX);
	$('#y').val(y - offsetY);
	$('#width').val(cropBoxData.width * factor);
	$('#height').val(cropBoxData.height * factor);
    }
    
    $('.modal-body').mouseup(function () {
	debugger;
	cropBoxData = $image.cropper('getCropBoxData');
	canvasData = $image.cropper('getCanvasData');
	var x = cropBoxData.left;
	var y = cropBoxData.top;
	var factor = 1 / parseFloat($('#factor').val());
	console.log(x);
	var offsetX = (600.0 - $('.cropper-canvas').width()) / 2.0;
	var offsetY =  (600.0 - $('.cropper-canvas').height()) / 2.0;
	$('#x').val(x - offsetX);
	$('#y').val(y - offsetY);
	$('#width').val(cropBoxData.width * factor);
	$('#height').val(cropBoxData.height * factor);
    });


});
