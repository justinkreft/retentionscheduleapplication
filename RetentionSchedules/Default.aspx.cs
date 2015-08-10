using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace RetentionSchedules
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Construct Drop down lists
            if (!IsPostBack)
            {
                ddlQuery.SelectCommand = "SELECT DISTINCT DepartmentUID, DepartmentName FROM divisionlkup ORDER BY DepartmentName";
                //Response.Write("ddlDepartments ddlQuery.SelectCommand (PageLoad): " + ddlQuery.SelectCommand.ToString() + "<br>");
                SqlDataReader sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
                if (sqlReader.HasRows)
                {
                    while (sqlReader.Read())
                    {
                        ListItem item = new ListItem(sqlReader[1].ToString(), "= '" + sqlReader[0].ToString() + "'", true);
                        ddlDepartments.Items.Add(item);
                    }
                }
                ddlQuery.SelectCommand = "SELECT DISTINCT ScheduleUID, ScheduleName FROM schedule ORDER BY ScheduleName";
                //Response.Write("ddlScheduless ddlQuery.SelectCommand (PageLoad): " + ddlQuery.SelectCommand.ToString() + "<br>");
                sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
                if (sqlReader.HasRows)
                {
                    while (sqlReader.Read())
                    {
                        ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                        ddlSchedules.Items.Add(item);
                    }
                }
            }
        }

        protected void ddlDepartments_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlDivisions.Items.Clear();
            ddlDivisions.Items.Add(new ListItem("--Select Division--", ""));
            ddlQuery.SelectCommand = "SELECT DISTINCT DivisionUID, DivisionName FROM divisionlkup WHERE DepartmentUID " + ddlDepartments.SelectedValue.ToString() + " ORDER BY DivisionName";
            //Response.Write("ddlDivisions ddlQuery.SelectCommand (ddlDepartments_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= '" + sqlReader[0].ToString() + "'", true);
                    ddlDivisions.Items.Add(item);
                }
            }
        }

        protected void allsearchbutton_Click(object sender, EventArgs e)
        {
            TitleString.Value = "Displaying All Wake County Policy Records";
            ValueString.Value = "!= ''";
        }

        protected void policygroupbutton_Click(object sender, EventArgs e)
        {
            ddlQuery.SelectCommand = "SELECT DISTINCT PolicyGroupUID, PolicyGroupName FROM divisionlkup WHERE DivisionUID " + ddlDivisions.SelectedValue.ToString();
            //Response.Write("ddlDivisions ddlQuery.SelectCommand (ddlDivisions_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
            string policygroupname = "";
            string policygroupvalue = "";
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    policygroupname = sqlReader[1].ToString();
                    policygroupvalue = sqlReader[0].ToString();
                }
            }
            TitleString.Value = "Displaying Records for Policy Group " + policygroupname;
            //Response.Write(TitleString.Value.ToString());
            ValueString.Value = " = " + policygroupvalue;
            //Response.Write(ValueString.Value.ToString());
        }

        protected void schedulebutton_Click(object sender, EventArgs e)
        {
            if (ddlSchedules.SelectedItem.Text.ToString() == "All Schedules")
            {
                TitleString.Value = "Displaying Records for All Schedules ";
            }
            else
            {
                TitleString.Value = "Displaying Records for " + ddlSchedules.SelectedItem.Text.ToString() + " Schedule";
            }
            //Response.Write(TitleString.Value.ToString());
            ValueString.Value = ddlSchedules.SelectedValue.ToString();
            //Response.Write(ValueString.Value.ToString());
        }
    }
}