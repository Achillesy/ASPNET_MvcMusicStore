/// <reference path="jquery-1.6.2.js" />
/// <reference path="jquery-ui-1.8.11.js" />

// short version
$(function () {

    $("[data-autocomplete-source]").each(function () {
        var target = $(this);
        target.autocomplete({ source: target.attr("data-autocomplete-source") });
    });

    $("#album-list img").mouseover(function () {
        $(this).effect("bounce", { time: 3, distance: 40 });
    });
});


function searchFailed() {
    $("#searchresults").html("Sorry, there was a problem with the search.");
}



