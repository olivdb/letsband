$(document).ready(function(){
	var retina = window.devicePixelRatio && window.devicePixelRatio >= 2;
	if (retina)
	{
		$('img').each(function(){
			$(this).attr("src", $(this).attr('src').replace(/\/(medium|thumb)\//, "/$1_2x/"));
		});
	}
});