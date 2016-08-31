/// <reference path="../../Scripts/jquery-1.8.2.js" />
/// <reference path="../../Scripts/jquery-ui-1.8.24.js" />

// short version
/* �Զ���ɹ���δ�ܽ��
$(function () {

    $("[data-autocomplete-source]").each(function () {
        var target = $(this);
        target.autocomplete({ source: target.attr("data-autocomplete-source") });
    });

    $("#album-list img").mouseover(function () {
        $(this).effect("bounce", { time: 3, distance: 40 });
    });
});
*/

function searchFailed() {
    $("#searchresults").html("Sorry, there was a problem with the search.");
}



