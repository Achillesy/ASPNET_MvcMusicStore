using System.Web.Routing;
using $rootnamespace$;

[assembly: WebActivator.PreApplicationStartMethod(typeof(AppStart_RestRouteRegistration), "Start")]
namespace $rootnamespace$
{
    public static class AppStart_RestRouteRegistration
    {
        public static void Start() {
            RouteTable.Routes.Add(new RestRoute("Products"));
        }
    }
}
