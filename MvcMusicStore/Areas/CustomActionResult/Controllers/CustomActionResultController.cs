using System.Web.Mvc;
using MvcMusicStore.Areas.CustomActionResult.Models;
using MvcMusicStore.Areas.CustomActionResult.Utility;

namespace MvcMusicStore.Areas.CustomActionResult.Controllers
{
    public class CustomActionResultController : Controller
    {
        public ActionResult Index()
        {
            var model = new Person
            {
                FirstName = "Brad",
                LastName = "Wilson",
                Blog = "http://bradwilson.typepad.com"
            };

            return new XmlResult(model);
        }
    }
}
