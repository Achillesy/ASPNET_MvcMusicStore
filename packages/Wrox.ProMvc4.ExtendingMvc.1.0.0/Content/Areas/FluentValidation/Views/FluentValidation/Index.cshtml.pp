@model $rootnamespace$.Areas.FluentValidation.Models.Contact
@{ ViewBag.Title = "Fluent Validation Sample"; }
@{ Html.EnableClientValidation(false); } @* Remove/comment this line to show client-side validation still works *@
@using (Html.BeginForm()) {
    <p>@Html.ValidationSummary(excludePropertyErrors: true)</p>
    
    <p>
        @Html.LabelFor(m => m.FirstName)
        @Html.EditorFor(m => m.FirstName)
        @Html.ValidationMessageFor(m => m.FirstName)
    </p>
    <p>
        @Html.LabelFor(m => m.LastName)
        @Html.EditorFor(m => m.LastName)
        @Html.ValidationMessageFor(m => m.LastName)
    </p>
    <p>
        @Html.LabelFor(m => m.EmailAddress)
        @Html.EditorFor(m => m.EmailAddress)
        @Html.ValidationMessageFor(m => m.EmailAddress)
    </p>

    <p><input type="submit" /></p>
}
