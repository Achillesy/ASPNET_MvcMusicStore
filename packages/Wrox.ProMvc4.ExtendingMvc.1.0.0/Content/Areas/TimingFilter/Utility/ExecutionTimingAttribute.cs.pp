using System;
using System.Diagnostics;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class ExecutionTimingAttribute : ActionFilterAttribute
    {
        IStatefulStorage storage = StatefulStorage.PerRequest;

        Stopwatch GetStopwatch(string name)
        {
            return storage.GetOrAdd<Stopwatch>(name, () => new Stopwatch());
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            GetStopwatch("action").Start();
        }

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            GetStopwatch("action").Stop();
        }

        public override void OnResultExecuting(ResultExecutingContext filterContext)
        {
            GetStopwatch("result").Start();
        }

        public override void OnResultExecuted(ResultExecutedContext filterContext)
        {
            var resultStopwatch = GetStopwatch("result");
            resultStopwatch.Stop();

            var actionStopwatch = GetStopwatch("action");
            var response = filterContext.HttpContext.Response;

            if (!filterContext.IsChildAction && response.ContentType == "text/html")
                response.Write(
                    String.Format(
                        "<h5>Action '{0} :: {1}', Execute: {2}ms, Result: {3}ms.</h5>",
                        filterContext.RouteData.Values["controller"],
                        filterContext.RouteData.Values["action"],
                        actionStopwatch.ElapsedMilliseconds,
                        resultStopwatch.ElapsedMilliseconds
                    )
                );
        }
    }
}