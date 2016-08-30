@{ ViewBag.Title = "Action Method Selector Sample"; }

<h3>Dates go here for each submit...</h3>
<div id="dates"></div>

@using (Ajax.BeginForm(new AjaxOptions { InsertionMode = InsertionMode.InsertAfter, UpdateTargetId = "dates" }))
{
    <input type="submit" />
}
