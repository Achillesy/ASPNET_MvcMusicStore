/// <reference path="jquery-1.6.2.js" />
/// <reference path="jquery.validate.js" />
/// <reference path="jquery.validate.unobtrusive.js" />

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
