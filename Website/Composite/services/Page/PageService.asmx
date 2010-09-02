﻿<%@ WebService Language="C#" Class="PageService" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.Services.Protocols;

using Composite;
using Composite.C1Console.Users;
using Composite.Core.WebClient;
using Composite.Data;
using Composite.Data.Types;


[WebService(Namespace = "http://www.composite.net/ns/management")]
[SoapDocumentService(RoutingStyle = SoapServiceRoutingStyle.RequestElement)]
public class PageService : System.Web.Services.WebService
{
    [WebMethod]
    public string GetPageBrowserDefaultUrl(bool dummy)
    {
#warning Remove outer using when bug fixing allow it
        using (DataScope dc = new DataScope(UserSettings.ActiveLocaleCultureInfo))
        {
            using (DataConnection dataConnection = new DataConnection(PublicationScope.Unpublished, UserSettings.ActiveLocaleCultureInfo))
            {
                SitemapNavigator sitemapNavigator = new SitemapNavigator(dataConnection);
                PageNode homePageNode = sitemapNavigator.GetPageNodeByHostname(this.Context.Request.Url.Host);

                if (homePageNode != null)
                {
                    return homePageNode.Url;
                }
                else
                {
                    return "/";
                }
            }
        }
    }



    [WebMethod]
    public string TranslateToInternalUrl(string url)
    {
        if (PageUrlHelper.IsInternalUrl(url))
        {
            return url;
        }

        var pageUrlOptions = PageUrl.Parse(url);

        if (pageUrlOptions == null)
        {
            return string.Empty;
        }

        return pageUrlOptions.Build(PageUrlType.Unpublished);
    }
}

