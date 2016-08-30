/// <reference path="jquery-1.8.2.js" />
/// <reference path="jquery-ui-1.8.24.min.js" />
/// <reference path="mustache.js" />

$(function () {

    $("#artistSearch").submit(function (event) {
        event.preventDefault();
        var form = $(this);
        $.ajax({
            url: form.attr("action"),
            data: form.serialize(),
            beforeSend: function () {
                $("#ajax-loader").show();
            },
            complete: function () {
                $("#ajax-loader").hide();
            },
            error: searchFailed,
            success: function (data) {
                var html = Mustache.to_html($("#artistTemplate").html(),
                                            { artists: data });
                $("#searchresults").empty().append(html);
            }
        });
    });

    $("[data-autocomplete-source]").each(function () {
        var target = $(this);
        target.autocomplete({ source: target.attr("data-autocomplete-source") });
    });

    $("#album-list img").mouseover(function () {
        $(this).effect("bounce", { times: 3, distance: 40 });
    });
});

function searchFailed() {
    $("#searchresults").html("Sorry, there was a problem with the search.");
}



