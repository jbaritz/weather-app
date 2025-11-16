// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


$(document).ready(function(){

  $.ajaxSetup({
		headers: {
			'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		}
	});

  $('#submit').on('click', function(){
    const location = $('#location').val();
     $('#forecast').hide();
     $('#cached').hide();
     $('#error').hide();
     $('#loading').show();
    $.post('/get_forecast',{location: location}).done(function (resp) {
       $('#loading').hide();
      if(resp.error != ""){
         $('#error').show();
      } else {
        $('#temp #num').text(resp.forecast.temperature);
        $('#details').text(resp.forecast.details);
        if(resp.forecast.from_cache === true){ $('#cached').show() }
        $('#forecast').show();
      }
    })
  })
  
})