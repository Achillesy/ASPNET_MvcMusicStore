@model $rootnamespace$.Areas.FluentMetadata.Models.Contact
@{ ViewBag.Title = "Fluent Metadata Sample"; }
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
