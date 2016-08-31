using System;
using System.Reflection;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.ActionNameSelector.Utility
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
    public class ProductAttribute : ActionNameSelectorAttribute
    {
        private const string PREFIX = "product-";

        public override bool IsValidName(ControllerContext controllerContext,
                                         string actionName,
                                         MethodInfo methodInfo)
        {
            if (!actionName.StartsWith(PREFIX, StringComparison.InvariantCultureIgnoreCase))
                return false;

            controllerContext.RequestContext.RouteData.Values.Add("productId", actionName.Substring(PREFIX.Length));
            return true;
        }
    }
}