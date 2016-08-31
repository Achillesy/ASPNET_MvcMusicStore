using System.Web.Mvc;

namespace $rootnamespace$.Areas.TimingFilter
{
    public class TimingFilterAreaRegistration : AreaRegistration
    {
        public override string AreaName { get { return "TimingFilter"; } }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "TimingFilter_default",
                "TimingFilter/{action}/{id}",
                new { controller = "TimingFilter", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
