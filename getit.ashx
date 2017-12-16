<%@ WebHandler Language="C#" Class="getit" %>

using System;
using System.Web;

public class getit : IHttpHandler {

    public string MD5String(string text1) //MD5对字符串进行加密
    {
        string result = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(text1, "MD5");
        return result;
    }

    public void ProcessRequest (HttpContext context) {

        string pwd = context.Request.QueryString["pwd"].ToString();
        string result = MD5String(pwd);

        context.Response.ContentType = "text/plain";
        context.Response.Write("After MD5:"+result);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}