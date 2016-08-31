using System.Threading;
using System.Web.Mvc;
using $rootnamespace$.Areas.TimingFilter.Utility;

namespace $rootnamespace$.Areas.TimingFilter.Controllers
{
    public class TimingFilterController : Controller
    {
        [ExecutionTiming]
        public ActionResult Index()
        {
            Thread.Sleep(100);
            return View();
        }
    }
}
