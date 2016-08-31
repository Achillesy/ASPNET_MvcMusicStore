using System.Web.Mvc;

namespace $rootnamespace$.Controllers
{
    public class ProductsController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult New()
        {
            return View();
        }

        public ActionResult Show(int id)
        {
            return View();
        }

        public ActionResult Edit(int id)
        {
            return View();
        }

        public ActionResult Update(int id)
        {
            //Create Logic then...
            return RedirectToAction("Show", new { id = id });
        }

        public ActionResult Create()
        {
            //Create Logic then...
            return RedirectToAction("Index");
        }

        public ActionResult Destroy(int id)
        {
            //Delete it then...
            return RedirectToAction("Index");
        }
    }

}
