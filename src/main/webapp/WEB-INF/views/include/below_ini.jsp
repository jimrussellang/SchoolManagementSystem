<script type="text/javascript"
	src="<c:url value="/resources/assets/js/vendor.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/assets/js/app.js" />"></script>

<!-- <script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
<script src="<c:url value="/resources/assets/js/notify.js" />"></script>
<script src="<c:url value="/resources/assets/js/nanobar.js" />"></script>
<script src="<c:url value="/resources/assets/js/bootstrap-switch.js" />"></script>

<script>
	var nanobar = new Nanobar({
		target : document.getElementById('nanobar-container')
	});
	nanobar.go(10);
	$(window).on('load', function() {
		nanobar.go(100);
	});
	$('a').click(function() {
		try {
			if ($(this).attr('href').indexOf("#") == -1) {
				loadPage();
			}
		} catch (e) {
			
		}
		return true;
	});
	function loadPage() {
		nanobar.go(10);
	}

	if ('${notify_msg}' != '') {
		$.notify("${notify_msg}", '${notify_msg_state}');
	}
	if ('${param.notify_msg}' != '') {
		$.notify("${param.notify_msg}", '${param.notify_msg_state}');
	}
	
	//Jquery functions for ReplaceTag
	$.extend({
	    replaceTag: function (currentElem, newTagObj, keepProps) {
	        var $currentElem = $(currentElem);
	        var i, $newTag = $(newTagObj).clone();
	        if (keepProps) {//{{{
	            newTag = $newTag[0];
	            newTag.className = currentElem.className;
	            $.extend(newTag.classList, currentElem.classList);
	            $.extend(newTag.attributes, currentElem.attributes);
	        }//}}}
	        $currentElem.wrapAll($newTag);
	        $currentElem.contents().unwrap();
	        // return node; (Error spotted by Frank van Luijn)
	        return this; // Suggested by ColeLawrence
	    }
	});

	$.fn.extend({
	    replaceTag: function (newTagObj, keepProps) {
	        // "return" suggested by ColeLawrence
	        return this.each(function() {
	            jQuery.replaceTag(this, newTagObj, keepProps);
	        });
	    }
	});
</script>