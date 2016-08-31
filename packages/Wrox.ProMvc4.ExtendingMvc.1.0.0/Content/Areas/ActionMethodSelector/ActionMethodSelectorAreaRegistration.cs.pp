using System.Web.Mvc;

namespace $rootnamespace$.Areas.ActionMethodSelector
{
    public class ActionMethodSelectorAreaRegistration : AreaRegistration
    {
        public override string AreaName { get { return "ActionMethodSelector"; } }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "ActionMethodSelector_default",
                "ActionMethodSelector/{action}/{id}",
                new { controller = "ActionMethod", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
