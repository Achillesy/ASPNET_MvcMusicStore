<!DOCTYPE html>
<html>
    <head>
        <title>@ViewBag.Title</title>
        <style type="text/css">
            body {
                font-family: "Segoe UI", "Trebuchet MS", Verdana, Helvetica, Sans-Serif;
                color: #232323;
                background-color: #fff;
                margin-left: 1em;
            }
            .flash {
                border: solid 1px #009;
                background-color: #ccf;
                padding: 0.5em 1em;
                display: inline-block;
            }
            .field-validation-error {
                color: #ff0000;
            }
            .field-validation-valid {
                display: none;
            }
            .input-validation-error {
                border: 1px solid #ff0000;
                background-color: #ffeeee;
            }
            .validation-summary-errors {
                font-weight: bold;
                color: #ff0000;
            }
            .validation-summary-valid {
                display: none;
            }
        </style>
    </head>
    <body>
        <h2>@ViewBag.Title</h2>
        @if (TempData["Flash"] != null) {
            <div class="flash">@TempData["Flash"]</div>
        }
        @RenderBody()
    </body>
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.5.1.min.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/mvc/3.0/jquery.unobtrusive-ajax.min.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.8/jquery.validate.min.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/mvc/3.0/jquery.validate.unobtrusive.min.js" type="text/javascript"></script>
</html>
