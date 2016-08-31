using System;
using System.Drawing;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.ModelBinder.Controllers
{
    public class ModelBinderController : Controller
    {
        public ActionResult Index()
        {
            return View(new Point(0, 0));
        }

        [HttpPost]
        public ActionResult Index(Point pt)
        {
            // Client-side validation is turned off by default in this sample so that you
            // can step into the code performing server-side validation more easily. You
            // can comment out the line in the view that disables client-side validation
            // to show that client-side validation also works with this example.

            if (ModelState.IsValid)
                TempData["Flash"] = String.Format("Bind success! X = {0}, Y = {1}", pt.X, pt.Y);

            return View(pt);
        }
    }
}
