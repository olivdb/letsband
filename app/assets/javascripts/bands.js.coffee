# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('#band_city_name').autocomplete
		source: $('#band_city_name').data('autocomplete-source')
		select: (event,ui) -> 
			$("#band_city_id").val(ui.item.id)
			$("#band_city_has_been_selected").val(1)