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
    $.post('/get_forecast',{location: location}).done(function (resp) {
      if(resp.error != ""){

      } else {
        $('#temp').text(resp.forecast.temp);
        $('#details').text(resp.forecast.details);
      }
    })
  })
  
})