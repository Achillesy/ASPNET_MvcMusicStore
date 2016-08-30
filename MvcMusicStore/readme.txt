You will need to make one manual change after installing this package, since NuGet doesn't allow for
overwriting existing files.

Update \App_Start\RouteConfig.cs to replace (or add) the 
RouteTable.Routes.RegisterRoutes("~/App_Start/Routes.cs") call as shown below:

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using RouteMagic;

public class RouteConfig
{
    public static void RegisterRoutes(RouteCollection routes)
    {
        RouteTable.Routes.RegisterRoutes("~/App_Start/Routes.cs");
    }
}