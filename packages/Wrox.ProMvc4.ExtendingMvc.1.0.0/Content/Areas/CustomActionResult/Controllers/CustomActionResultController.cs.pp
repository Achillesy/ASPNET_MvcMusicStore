using System.Web.Mvc;
using $rootnamespace$.Areas.CustomActionResult.Models;
using $rootnamespace$.Areas.CustomActionResult.Utility;

namespace $rootnamespace$.Areas.CustomActionResult.Controllers
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
