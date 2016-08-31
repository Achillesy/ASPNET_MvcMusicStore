@model IEnumerable<$rootnamespace$.Models.Album>

@{
    ViewBag.Title = "Index";
}

<h2>A Very Simple Store</h2>

<table>
    <tr>
        <th>
            Title
        </th>
        <th>
            Price
        </th>
        <th></th>
    </tr>

@foreach (var item in Model) {
    <tr>
        <td>
            @Html.DisplayFor(modelItem => item.Title)
        </td>
        <td>
            @Html.DisplayFor(modelItem => item.Price)
        </td>
        <td>
            @Html.ActionLink("Buy", "Buy", new { id=item.AlbumId })
        </td>
    </tr>
}

</table>
