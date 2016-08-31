using System.Web.Routing;
using MvcMusicStore;

[assembly: WebActivator.PreApplicationStartMethod(typeof(AppStart_RestRouteRegistration), "Start")]
namespace MvcMusicStore
{
    public static class AppStart_RestRouteRegistration
    {
        public static void Start() {
            RouteTable.Routes.Add(new RestRoute("Products"));
        }
    }
}
