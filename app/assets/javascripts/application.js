// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function() {

  $(document).on("keypress", "input:not([type=submit]):not(#keyword)", function(event) {
    return event.which !== 13;
  });

  $(document).on("click", ".messages a", function() {
	$(this).parents(".messages").next().toggle();
	$.post("/messages/read", {id : $(this).attr("id")});
	return false;
  });

  $(document).on("click", "#member_agreement", function() {
	  if($(this).prop('checked')) {
		  $(this).parents("form").find("input[type=submit]").attr("disabled", false);
	  } else {
		  $(this).parents("form").find("input[type=submit]").attr("disabled", true);
	  }
  });
});
