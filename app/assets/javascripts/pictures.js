function updateCropper()
{
    cropBoxData = $('#image').cropper('getCropBoxData');
    canvasData = $('#image').cropper('getCanvasData');
    var x = cropBoxData.left;
    var y = cropBoxData.top;
    var factor = 1 / parseFloat($('#factor').val());
    console.log(x);
    var offsetX = ($('.modal-body').width() - $('.cropper-canvas').width()) / 2.0;
    var offsetY =  ($('.modal-body').height() - $('.cropper-canvas').height()) / 2.0;
    $('#x').val(x - offsetX);
    $('#y').val(y - offsetY);
    $('#width').val(cropBoxData.width * factor);
    $('#height').val(cropBoxData.height * factor);
}



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
	evaluateSubmit();
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
	    evaluateSubmit();
        }
      });
    }
  });

    var $image = $('#image');
    var factor = parseFloat($('#factor').val());
    var cropBoxData = { width: 800 * factor, height: 800 * factor};
    var canvasData;

    if ($('.modal-body').width() > $(window).width())
    {
	var size = $(window).width().toString() * .8;
	$('.modal-body').css('width', size);
	$('.modal-body').css('height', size);
	$('#size_of_crop').val($('.modal-body').width().toString());
	var thing = parseFloat($('#factor').val());
	var newFactor = thing / 600.0 * $('.modal-body').width();
	$('#factor').val(newFactor.toString());
	factor = parseFloat($('#factor').val());
    }
    
    $image.cropper({
	zoomable: false,
	toggleDragModeOnDblClick: false,
	cropBoxResizable: true,
	rotatable: true,
	aspectRatio: 1.00,
	movable: false,
	minCropBoxWidth: 300 * factor,
	built: function () {
	    
	    $image.cropper('setCanvasData', canvasData);
	    $image.cropper('setCropBoxData', cropBoxData);
	    cropBoxData = $image.cropper('getCropBoxData');
	    canvasData = $image.cropper('getCanvasData');
	    var x = cropBoxData.left;
	    var y = cropBoxData.top;
	    var thing = parseFloat($('#factor').val());
	    var factor = 1 / parseFloat($('#factor').val());
	    console.log($('.modal-body').width());
	    var offsetX = ($('.modal-body').width() - $('.cropper-canvas').width()) / 2.0;
	    var offsetY =  ($('.modal-body').height() - $('.cropper-canvas').height()) / 2.0;
	    $('#x').val(x - offsetX);
	    $('#y').val(y - offsetY);
	    $('#width').val(cropBoxData.width * factor);
	    $('#height').val(cropBoxData.height * factor);
	}

    });
    
    //$('#image').cropper('rotate', -90)
    
    $('.modal-body').mouseup(function () {
	updateCropper();
    });

    $(document).on('touchend', '.modal-body', function() {
	updateCropper();
    });
    
    $('#rotate_ccw').click(function() {
	$('#image').cropper('rotate', -90);
	var angle = parseInt($('#rotate').val()) - 90;
	$('#rotate').val(angle);
    });

    $('#rotate_cw').click(function() {
	$('#image').cropper('rotate', 90);
	var angle =  parseInt($('#rotate').val()) + 90;
	$('#rotate').val(angle);
    })

    $('.choose_picture').click(function() {
	var id = $(this).siblings('.choose_picture_id').val();
	var url = window.location.href;
	if (url.indexOf("?") == -1)
	{
	    var str = "?picture_id=" + id;
	}
	else
	{
	    var str = "&picture_id=" + id;
	}
	
	var loc = url + str;// + " .inner_pan_cropper";
	window.location.href = loc;
	//$('.pan_cropper').load(loc, function() {
	//});
    });

    $('.choose_picture_return').click(function() {
	var str = window.location.href;
	var index = str.indexOf("picture_id");
	var loc = str.substring(0, index - 1);
	window.location.href = loc;
    });

});
