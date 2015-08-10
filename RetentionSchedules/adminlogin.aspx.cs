using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace RetentionSchedules
{
    public partial class adminlogin : System.Web.UI.Page
    {
        string strPass = "86it";
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpContext.Current.Session["pass"] = strPass;
            if (Page.IsPostBack)
            { 
                if (txtPass.Text != strPass)
                {
                    lblMessage.Text = "You did not enter the proper credentials to view this page..";
                }
                else
                {
                    Response.Redirect("/retention/admin.aspx");
                }
            }
        }
    }
}