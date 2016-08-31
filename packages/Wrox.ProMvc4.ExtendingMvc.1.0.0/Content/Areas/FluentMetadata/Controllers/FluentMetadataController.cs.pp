using System.Web.Mvc;
using $rootnamespace$.Areas.FluentMetadata.Models;

namespace $rootnamespace$.Areas.FluentMetadata.Controllers
{
    public class FluentMetadataController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(Contact contact)
        {
            return View(contact);
        }
    }
}
