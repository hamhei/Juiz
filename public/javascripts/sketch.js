window.addEventListener('load', function () {
	// alert('loaded');
	temp = null;
    var canvas = document.getElementById('canvas');
	// alert(canvas);
   // canvas.width = window.innerWidth - 30;
   // canvas.height = window.innerHeight - 30;

    var ctx = canvas.getContext('2d');
    ctx.lineWidth = 3;
    ctx.strokeStyle = '#333333';

    var down = false;
	canvas.addEventListener('mousedown', function (e) {
        down = true;
		x = 25;
		y = 75;
		ctx.beginPath();
	    ctx.moveTo(e.clientX - x, e.clientY - y);
	}, false);
	window.addEventListener('mousemove', function (e) {
		if (!down) return;
		console.log(e.clientX, e.clientY);
		ctx.lineTo(e.clientX - x, e.clientY - y);
	    ctx.stroke();
	}, false);
	window.addEventListener('mouseup', function (e) {
		if (!down) return;
		ctx.lineTo(e.clientX - x, e.clientY - y);
	    ctx.stroke();
	    ctx.closePath();
	    down = false;
	}, false);

	var colors = document.getElementById('colors').childNodes;
    // alert(colors);
	for (var i = 0, color; color = colors[i]; i++){
	  if (color.nodeName.toLowerCase() != 'div') continue;
	  color.addEventListener('click', function (e) {
	    // alert("selected color: " + i)
	    var style = e.target.getAttribute('style');
		// alert(style);
		try {
			var color = style.match(/background:(#......)/)[1];
		} catch (x) {
			alert("Oops!! You had already used that color!");
		}
		ctx.strokeStyle = color;

		// alert(temp);
		$(temp).css('border-style', 'none');
		$(temp).css('background-color', '#666');
		$(e.target).css('border-style', 'solid');
		temp = e.target;
	  }, false);
    }

	var eraser = document.getElementById('eraser');
	eraser.addEventListener('click', function (e) {
		ctx.strokeStyle = "#ffffff";

		// alert(temp);
		$(temp).css('border-style', 'none');
		$(temp).css('background-color', '#666');
		$(e.target).css('border-style', 'solid');
		temp = e.target;
	}, false);

    var pub_button = document.getElementById('public');
	pub_button.addEventListener('click', function (e) {
		$( "#dialog-form" ).dialog( "open" );
	}, false);

	var dl_button = document.getElementById('download');
	dl_button.addEventListener('click', function (e) {
		var img = canvas.toDataURL("image/jpeg");
		open(img);
	}, false);

    timer();

}, false);

function onClickRadio(x) {
	var canvas = document.getElementById('canvas');
	// alert(canvas);
	var ctx = canvas.getContext('2d');
	ctx.lineWidth = x;
}

var s = 1800;
function timer() {
	if(s < 600 && s >= 0) {
		$('#timer').html('<font color="ff0000">' + ~~(s/10) + "." + s%10 + "</font>");
	} else if (s < 0) {
		$( "#dialog-form" ).dialog( "open" );
		// publication();
		return;
	} else {
		$('#timer').html(~~(s/10) + "." + s%10);
	}
	s = s - 1;
	tid = setTimeout('timer()', 100);
}

function publication( message ) {
		var canvas = document.getElementById('canvas');
		var img = canvas.toDataURL("image/jpeg");
		img = img.replace('data:image/jpeg;base64,','');

	    $.ajax({
			type: "POST",
			url: "/putImage",
			data: {"img": img, "message": message},
			error: function () {
			  alert('error');
			},
			dataType: "json",
			success: function (data) {
			  try {
			    //open("../images/sketch/"+data.file_name);
				document.location = data.pic_url;
				// open(data.pic_url);
			  } catch (err) {
				alert(err);
			  }
		    }
		});
}

$(function() {
	  // a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
	  $( "#dialog:ui-dialog" ).dialog( "destroy" );

	  var name = $( "#name" ),
	  email = $( "#email" ),
	  password = $( "#password" ),
	  allFields = $( [] ).add( name ).add( email ).add( password ),
	  tips = $( ".validateTips" );

	  function updateTips( t ) {
		  tips
		  .text( t )
		  .addClass( "ui-state-highlight" );
		  setTimeout(function() {
						 tips.removeClass( "ui-state-highlight", 1500 );
					 }, 500 );
	  }

	  function checkLength( o, n, min, max ) {
		  if ( o.val().length > max || o.val().length < min ) {
			  o.addClass( "ui-state-error" );
			  updateTips( "Length of " + n + " must be between " +
						  min + " and " + max + "." );
			  return false;
		  } else {
			  return true;
		  }
	  }

	  function checkRegexp( o, regexp, n ) {
		  if ( !( regexp.test( o.val() ) ) ) {
			  o.addClass( "ui-state-error" );
			  updateTips( n );
			  return false;
		  } else {
			  return true;
		  }
	  }

	  $( "#dialog-form" ).dialog({
									 autoOpen: false,
									 height: 360,
									 width: 600,
									 modal: true,
									 buttons: {
										 "Share on the web": function() {
											 publication( $( "#email" ).val() );
											 // $( this ).dialog( "close" );
										 },
										 "Reset": function() {
											 // $( this ).dialog( "close" );
											  location.reload();
										 },
										// "Reset": function() {
										//	 location.reload();
										//  },
									 },
									 Cancel: function() {
										 $( this ).dialog( "close" );
									 },
									 close: function() {
										 allFields.val( "" ).removeClass( "ui-state-error" );
									 }
								 });

  });


