/// <reference path="../../../Scripts/jquery-1.8.2.js" />
/// <reference path="../../../Scripts/jquery.validate.js" />
/// <reference path="../../../Scripts/jquery.validate.unobtrusive.js" />

if ($.validator && $.validator.unobtrusive) {

    $.validator.unobtrusive.adapters.addSingleVal("maxwords", "wordcount");

    $.validator.addMethod("maxwords", function (value, element, maxwords) {
        if (value) {
            if (value.split(' ').length > maxwords) {
                return false;
            }
        }
        return true;
    });

}
