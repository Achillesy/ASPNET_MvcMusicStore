using System;
using System.Web.Mvc;
using System.Web.WebPages;

public abstract class CustomWebViewPage<T> : WebViewPage<T> 
{
    public HelperResult RenderSection(string name, Func<dynamic, HelperResult> defaultContents)
	{
        if (IsSectionDefined(name)) 
		{
            return RenderSection(name);
        }
        return defaultContents(null);
    }
}
