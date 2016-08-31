using System.Reflection;
using System.Web.Mvc;

namespace MvcMusicStore.Areas.ActionMethodSelector.Utility
{
    public class AjaxOnlyAttribute : ActionMethodSelectorAttribute
    {
        public override bool IsValidForRequest(ControllerContext controllerContext,
                                               MethodInfo methodInfo)
        {
            return controllerContext.HttpContext.Request.IsAjaxRequest();
        }
    }
}
