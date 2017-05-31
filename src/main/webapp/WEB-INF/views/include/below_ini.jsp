<script type="text/javascript"
	src="<c:url value="/resources/assets/js/vendor.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/assets/js/app.js" />"></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="<c:url value="/resources/assets/js/notify.js" />"></script>
<script src="<c:url value="/resources/assets/js/nanobar.js" />"></script>

<script>
	var nanobar = new Nanobar({
		target : document.getElementById('nanobar-container')
	});
	nanobar.go(10);
	$(window).on('load', function() {
		nanobar.go(100);
	});
	$('a').click(function() {
		if ($(this).attr("href").indexOf("#") == -1) {
			loadPage();
		}
		return true;
	});
	function loadPage() {
		nanobar.go(10);
	}
</script>