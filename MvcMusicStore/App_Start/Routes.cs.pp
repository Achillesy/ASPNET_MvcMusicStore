using System.Web.Mvc;
using System.Web.Routing;
using $rootnamespace$.Wrox.Samples;

public class Routes : IRouteRegistrar {
    public void RegisterRoutes(RouteCollection routes) {
        routes.MapRoute(
          "about",
          "about",
          new { controller = "Home", action = "About", id = UrlParameter.Optional }
        );
    }
}