<%@ WebHandler Language="C#" Class="posit" %>

using System;
using System.Web;
using System.Data;
using System.Web.Script.Serialization;
using System.Collections;
using System.Text;
using System.Linq;
using System.Collections.Generic;

public class posit : IHttpHandler
{
    private string Dtb2Json(DataTable dtb) //将DataTable转换成JSON数据
    {
        JavaScriptSerializer jss = new JavaScriptSerializer();
        ArrayList dic = new ArrayList();
        foreach (DataRow row in dtb.Rows)
        {
            Dictionary<string, object> drow = new Dictionary<string, object>();
            foreach (DataColumn col in dtb.Columns)
            {
                drow.Add(col.ColumnName, row[col.ColumnName]);
            }
            dic.Add(drow);
        }
        return jss.Serialize(dic);
    }

    public void ProcessRequest(HttpContext context)
    {
        string username = context.Request.Form["username"].ToString();
        SqlHelper sqlHelper = new SqlHelper();
        DataTable dt = new DataTable();
        dt = sqlHelper.select(" birthday ", " [user] "," name='"+username+"'");
        if(context.Request.Form["pwd"] == null)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("请输入密码！");
        }
        else
        {
            if(dt.Rows.Count == 0)
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("该用户名不存在！");
            }
            else
            {
                string json = Dtb2Json(dt);
                string pwd = context.Request.Form["pwd"].ToString();
                dt = sqlHelper.select(" pwd ", " [user] ", " name='" + username + "'");
                context.Response.ContentType = "text/plain";

                if(dt.Rows[0][0].ToString() != pwd)
                {
                    context.Response.Write("密码错误！");
                }
                else
                {
                    context.Response.Write(json); //输出生日
                }
            }
        }


    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}