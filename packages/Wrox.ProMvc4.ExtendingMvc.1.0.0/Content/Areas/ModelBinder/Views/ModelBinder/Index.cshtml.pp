@model System.Drawing.Point
@{ ViewBag.Title = "Model Binder Sample"; }
@{ Html.EnableClientValidation(false); } @* Remove/comment this line to show client-side validation still works *@
@using (Html.BeginForm()) {
    <p>@Html.ValidationSummary(excludePropertyErrors: true)</p>
    
    <p>
        @Html.LabelFor(m => m.X)
        @Html.EditorFor(m => m.X)
        @Html.ValidationMessageFor(m => m.X)
    </p>
    <p>
        @Html.LabelFor(m => m.Y)
        @Html.EditorFor(m => m.Y)
        @Html.ValidationMessageFor(m => m.Y)
    </p>

    <p><input type="submit" /></p>
}
