using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace MvcMusicStore
{
    public class RestRoute : RouteBase
    {
        List<Route> _internalRoutes = new List<Route>();

        public string Resource { get; private set; }

        public RestRoute(string resource)
        {
            this.Resource = resource;
            MapRoute(resource, "index", "GET", null);
            MapRoute(resource, "create", "POST", null);
            MapRoute(resource + "/new", "new", "GET", null);
            MapRoute(resource + "/{id}", "show", "GET", new { id = @"\d+" });
            MapRoute(resource + "/{id}", "update", "PUT", new { id = @"\d+" });
            MapRoute(resource + "/{id}", "delete", "DELETE", new { id = @"\d+" });
            MapRoute(resource + "/{id}/edit", "edit", "GET", new { id = @"\d+" });
        }

        public void MapRoute(string url, string actionName, string httpMethod,
                     object constraints)
        {
            RouteValueDictionary constraintsDictionary;
            if (constraints != null)
            {
                constraintsDictionary = new RouteValueDictionary(constraints);
            }
            else
            {
                constraintsDictionary = new RouteValueDictionary();
            }
            constraintsDictionary.Add("httpMethod", new HttpMethodConstraint(httpMethod));

            _internalRoutes.Add(new Route(url, new MvcRouteHandler())
            {
                Defaults = new RouteValueDictionary(new { controller = Resource, action = actionName }),
                Constraints = constraintsDictionary
            });
        }

        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            foreach (var route in this._internalRoutes)
            {
                var rvd = route.GetRouteData(httpContext);
                if (rvd != null) return rvd;
            }
            return null;
        }

        public override VirtualPathData GetVirtualPath(RequestContext requestContext,
               RouteValueDictionary values)
        {
            foreach (var route in this._internalRoutes)
            {
                VirtualPathData vpd = route.GetVirtualPath(requestContext, values);
                if (vpd != null) return vpd;
            }
            return null;
        }
    }
}
