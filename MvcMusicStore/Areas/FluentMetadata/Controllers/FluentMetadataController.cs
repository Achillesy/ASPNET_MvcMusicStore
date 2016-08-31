using System.Web.Mvc;
using MvcMusicStore.Areas.FluentMetadata.Models;

namespace MvcMusicStore.Areas.FluentMetadata.Controllers
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
