using System.Web.Mvc;
using $rootnamespace$.Areas.ActionNameSelector.Utility;

namespace $rootnamespace$.Areas.ActionNameSelector.Controllers
{
    public class ActionNameController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [Product]
        public ActionResult Product(int productId)
        {
            return Content("You asked for product #" + productId);
        }
    }
}
