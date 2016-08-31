using System.Threading;
using System.Web.Mvc;
using MvcMusicStore.Areas.TimingFilter.Utility;

namespace MvcMusicStore.Areas.TimingFilter.Controllers
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
