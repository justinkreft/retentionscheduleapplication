using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Collections;

namespace RetentionSchedules
{
    public partial class admin : System.Web.UI.Page
    {        
        //Set Global Variables
        Char[] andor = { ' ', 'A', 'N', 'D', 'O', 'R' };
        string selectstring = "SELECT (null) AS TermsFrequency, (null) AS AllTermsPresent, * FROM [compiledpolicies] WHERE ";
        string policygroupUIDclause = "";
        string scheduleUIDclause = "";
        string standardUIDclause = "";
        string valuestring = " != ''";



        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Establish Drop Down List Where clauses
            policygroupUIDclause = "PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString();
            scheduleUIDclause = "ScheduleUID " + ddlSchedulePolicy.SelectedValue.ToString();
            standardUIDclause = "StandardUID " + ddlStandardPolicy.SelectedValue.ToString();
            selectstring = selectstring + policygroupUIDclause + " AND " + scheduleUIDclause + " AND " + standardUIDclause + " AND ";
            // Establish querystrings
            string rankingstring = "(";
            string finalrankingcondition = "";
            string querystring = "";
            // Begin querystring builder with Hard filters always on
            querystring = querystring + "(";
            // Active Filter
            switch (activePolicy.SelectedValue)
            {
                case "yes":
                    querystring = querystring + "PolicyIsActive = 'Active'";
                    break;
                case "no":
                    querystring = querystring + "PolicyIsActive = 'Inactive'";
                    break;
                case "both":
                    querystring = querystring + "(PolicyIsActive = 'Active') OR (PolicyIsActive = 'Inactive')";
                    break;
            }
            querystring = querystring + ")";
            querystring = querystring + " AND ";
            // Flag Filter
            querystring = querystring + "(";
            switch (flagPolicy.SelectedValue)
            {
                case "yes":
                    querystring = querystring + "PolicyRevisionFlag IS NOT NULL";
                    break;
                case "no":
                    querystring = querystring + "PolicyRevisionFlag IS NULL";
                    break;
                case "both":
                    querystring = querystring + "(PolicyRevisionFlag IS NOT NULL) OR (PolicyRevisionFlag IS NULL)";
                    break;
            }
            querystring = querystring + ")";
            querystring = querystring + " AND ";
            // Date Filter
            if (activedatePolicy.Text != "")
            {
                string searchdate = activedatePolicy.Text.ToString();
                querystring = querystring + "(SeriesActiveFrom < '" + searchdate + "' AND SeriesActiveTo > '" + searchdate + "') AND ";
            }
            // Begin Search Term
            List<string> filtersearchterms = new List<string>();
            List<string> rankingterms = new List<string>();
            List<string> scopelist = new List<string>();
            scopelist.Add("SeriesName");
            scopelist.Add("SeriesDescription");
            scopelist.Add("SeriesDispositionInstructions");
            scopelist.Add("SeriesRelevantStatutes");
            scopelist.Add("PolicyDivisionNote");
            // Filter constructor
            if (filter1termPolicy.Text != "")
            {
                // Build Word Strings
                foreach (string term in filter1termPolicy.Text.Split(new Char[] { ' ' }))
                {
                    // Eliminate empty strings
                    if (term != "")
                    {
                        filtersearchterms.Add(term);
                    }
                }
                // Start Query String
                querystring = querystring + "(";
                // Check Whole option state - Build Phrase String
                if (filter1wholePolicy.Checked == true)
                {
                    foreach (string scope in scopelist)
                    {
                        querystring = querystring + scope + " LIKE '%" + filter1termPolicy.Text.ToString() + "%' OR ";
                    }
                }
                else
                {
                    // Control for one search term (i.e. no OR condition)
                    if (filtersearchterms.Count == 1)
                    {
                        foreach (string term in filtersearchterms)
                        {
                            foreach (string scope in scopelist)
                            {
                                querystring = querystring + scope + " LIKE '%" + term + "%' OR ";
                            }
                        }
                    }
                    // Process Multiple search terms (i.e. add Or Condition)
                    else
                    {
                        // Add conditions
                        foreach (string term in filtersearchterms)
                        {
                            querystring = querystring + '(';
                            foreach (string scope in scopelist)
                            {
                                querystring = querystring + scope + " LIKE '%" + term + "%' OR ";
                            }
                            querystring = querystring.Trim(andor);
                            querystring = querystring + ')';
                            querystring = querystring + " OR ";
                        }
                    }
                }
                querystring = querystring.Trim(andor);
                querystring = querystring + ")";
                // Build ranking string
                if (filtersearchterms.Count != 0)
                {
                    foreach (string term in filtersearchterms)
                    {
                        finalrankingcondition = finalrankingcondition + "(";
                        foreach (string scope in scopelist)
                        {
                            rankingstring = rankingstring + "CASE WHEN " + scope + " LIKE '%" + term + "%' THEN (LEN(" + scope + ") - LEN(REPLACE(" + scope + ", '" + term + "', '')))/LEN('" + term + "') ELSE 0 END + ";
                            finalrankingcondition = finalrankingcondition + scope + " LIKE '%" + term + "%' OR ";
                        }
                        finalrankingcondition = finalrankingcondition.Trim(andor);
                        finalrankingcondition = finalrankingcondition + ") AND ";
                    }
                }
            }
            // If empty remove AND/OR
            else
            {
                querystring = querystring.Trim(andor);
            }
            // Strip ending AND/OR if no search terms
            querystring = querystring.Trim(andor);
            // If rankingstring not empty, final case build and insert
            if (rankingstring != "(")
            {
                rankingstring = rankingstring.Trim('+', ' ');
                rankingstring = rankingstring + ") AS TermsFrequency, ";
                rankingstring = rankingstring + "(CASE WHEN " + finalrankingcondition.Trim(andor) + " THEN 1 ELSE 0 END";
                rankingstring = rankingstring + ") AS AllTermsPresent, *";
                selectstring = selectstring.Replace("(null) AS TermsFrequency, (null) AS AllTermsPresent, *", rankingstring);
                querystring = querystring + " ORDER BY AllTermsPresent DESC, TermsFrequency DESC";
            }
            // Set SelectCommand to build string
            SqlDataRecordsPolicy.SelectCommand = selectstring + querystring;
            //Response.Write("FINAL SELECT: SqlDataRecordsPolicy.SelectCommand: " + SqlDataRecordsPolicy.SelectCommand.ToString() + "<br>");
            //Response.Write(selectstring + querystring + "<br>"); // debuging only
            
            // Establish Drop Down List Where clauses
            scheduleUIDclause = "ScheduleUID " + ddlScheduleSeries.SelectedValue.ToString();
            standardUIDclause = "StandardUID " + ddlStandardSeries.SelectedValue.ToString();
            selectstring = selectstring + scheduleUIDclause + " AND " + standardUIDclause + " AND ";
            // Establish querystrings
            rankingstring = "(";
            finalrankingcondition = "";
            querystring = "";
            // Begin querystring builder with Hard filters always on
            querystring = querystring + "(";
            // Active Filter
            switch (activeSeries.SelectedValue)
            {
                case "yes":
                    querystring = querystring + "SeriesIsActive = 'Active'";
                    break;
                case "no":
                    querystring = querystring + "SeriesIsActive = 'Inactive'";
                    break;
                case "both":
                    querystring = querystring + "(SeriesIsActive = 'Active') OR (SeriesIsActive = 'Inactive')";
                    break;
            }
            querystring = querystring + ")";
            querystring = querystring + " AND ";
            // Flag Filter
            querystring = querystring + "(";
            switch (flagSeries.SelectedValue)
            {
                case "yes":
                    querystring = querystring + "SeriesRevisionFlag IS NOT NULL";
                    break;
                case "no":
                    querystring = querystring + "SeriesRevisionFlag IS NULL";
                    break;
                case "both":
                    querystring = querystring + "(SeriesRevisionFlag IS NOT NULL) OR (SeriesRevisionFlag IS NULL)";
                    break;
            }
            querystring = querystring + ")";
            querystring = querystring + " AND ";
            // Date Filter
            if (activedateSeries.Text != "")
            {
                string searchdate = activedateSeries.Text.ToString();
                querystring = querystring + "(SeriesActiveFrom < '" + searchdate + "' AND SeriesActiveTo > '" + searchdate + "') AND ";
            }
            // Begin Search Term
            filtersearchterms = new List<string>();
            rankingterms = new List<string>();
            scopelist = new List<string>();
            scopelist.Add("SeriesName");
            scopelist.Add("SeriesDescription");
            scopelist.Add("SeriesDispositionInstructions");
            scopelist.Add("SeriesRelevantStatutes");
            // Filter constructor
            if (filter1termSeries.Text != "")
            {
                // Build Word Strings
                foreach (string term in filter1termSeries.Text.Split(new Char[] { ' ' }))
                {
                    // Eliminate empty strings
                    if (term != "")
                    {
                        filtersearchterms.Add(term);
                    }
                }
                // Start Query String
                querystring = querystring + "(";
                // Check Whole option state - Build Phrase String
                if (filter1wholeSeries.Checked == true)
                {
                    foreach (string scope in scopelist)
                    {
                        querystring = querystring + scope + " LIKE '%" + filter1termSeries.Text.ToString() + "%' OR ";
                    }
                }
                else
                {
                    // Control for one search term (i.e. no OR condition)
                    if (filtersearchterms.Count == 1)
                    {
                        foreach (string term in filtersearchterms)
                        {
                            foreach (string scope in scopelist)
                            {
                                querystring = querystring + scope + " LIKE '%" + term + "%' OR ";
                            }
                        }
                    }
                    // Process Multiple search terms (i.e. add Or Condition)
                    else
                    {
                        // Add conditions
                        foreach (string term in filtersearchterms)
                        {
                            querystring = querystring + '(';
                            foreach (string scope in scopelist)
                            {
                                querystring = querystring + scope + " LIKE '%" + term + "%' OR ";
                            }
                            querystring = querystring.Trim(andor);
                            querystring = querystring + ')';
                            querystring = querystring + " OR ";
                        }
                    }
                }
                querystring = querystring.Trim(andor);
                querystring = querystring + ")";
                // Build ranking string
                if (filtersearchterms.Count != 0)
                {
                    foreach (string term in filtersearchterms)
                    {
                        finalrankingcondition = finalrankingcondition + "(";
                        foreach (string scope in scopelist)
                        {
                            rankingstring = rankingstring + "CASE WHEN " + scope + " LIKE '%" + term + "%' THEN (LEN(" + scope + ") - LEN(REPLACE(" + scope + ", '" + term + "', '')))/LEN('" + term + "') ELSE 0 END + ";
                            finalrankingcondition = finalrankingcondition + scope + " LIKE '%" + term + "%' OR ";
                        }
                        finalrankingcondition = finalrankingcondition.Trim(andor);
                        finalrankingcondition = finalrankingcondition + ") AND ";
                    }
                }
            }
            // If empty remove AND/OR
            else
            {
                querystring = querystring.Trim(andor);
            }
            // Strip ending AND/OR if no search terms
            querystring = querystring.Trim(andor);
            // If rankingstring not empty, final case build and insert
            if (rankingstring != "(")
            {
                rankingstring = rankingstring.Trim('+', ' ');
                rankingstring = rankingstring + ") AS TermsFrequency, ";
                rankingstring = rankingstring + "(CASE WHEN " + finalrankingcondition.Trim(andor) + " THEN 1 ELSE 0 END";
                rankingstring = rankingstring + ") AS AllTermsPresent, *";
                selectstring = selectstring.Replace("(null) AS TermsFrequency, (null) AS AllTermsPresent, *", rankingstring);
                querystring = querystring + " ORDER BY AllTermsPresent DESC, TermsFrequency DESC";
            }
            // Set SelectCommand to build string
            SqlDataRecords.SelectCommand = selectstring + querystring;
            //Response.Write("FINAL SELECT: SqlDataRecords.SelectCommand: " + SqlDataRecords.SelectCommand.ToString() + "<br>");
            //Response.Write(selectstring + querystring + "<br>"); // debuging only

        }
      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.Session["pass"] != null)
            { 
                hidPass.Value = System.Web.HttpContext.Current.Session["pass"].ToString();
            }
            if (hidPass.Value.ToString() != "86it")
            {
                Response.Redirect("Default.aspx");
            }
            else
            {
                DepartmentTableEdit.ChangeMode(DetailsViewMode.ReadOnly);
                PolicyGroupTableEdit.ChangeMode(DetailsViewMode.ReadOnly);
                DivisionTableEdit.ChangeMode(DetailsViewMode.ReadOnly);
                DetailsPolicyTableEdit.ChangeMode(DetailsViewMode.ReadOnly);
                DetailsSeriesTableEdit.ChangeMode(DetailsViewMode.ReadOnly);

                //Construct Drop down lists
                if (!IsPostBack)
                {
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT PolicyGroupUID, PolicyGroupName FROM divisionlkup WHERE PolicyGroupUID != '' ORDER BY PolicyGroupName";
                    //Response.Write("ddlPolicyGroupPolicy ddlQueryPolicy.SelectCommand (PageLoad): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
                    SqlDataReader sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                            ddlPolicyGroupPolicy.Items.Add(item);
                        }
                        ListItem policygroupall = new ListItem("Narrow results by schedule...", " != ''", true);
                        policygroupall.Selected = true;
                        ddlPolicyGroupPolicy.Items.Add(policygroupall);
                    }
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT ScheduleUID, ScheduleName FROM compiledpolicies WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString() + " ORDER BY ScheduleName";
                    //Response.Write("ddlSchedulePolicy ddlQueryPolicy.SelectCommand (ddlPolicyGroupPolicy_SelectedIndexChanged): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
                    sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                            ddlSchedulePolicy.Items.Add(item);
                        }
                        ListItem scheduleall = new ListItem("Narrow results by schedule...", " != ''", true);
                        scheduleall.Selected = true;
                        ddlSchedulePolicy.Items.Add(scheduleall);
                    }
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM compiledpolicies WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString() + " AND ScheduleUID " + ddlSchedulePolicy.SelectedValue.ToString() + " ORDER BY StandardName";
                    //Response.Write("ddlStandardPolicy ddlQueryPolicy.SelectCommand (ddlPolicyGroupPolicy_SelectedIndexChanged): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
                    sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                            ddlStandardPolicy.Items.Add(item);
                        }
                        ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
                        standardall.Selected = true;
                        ddlStandardPolicy.Items.Add(standardall);
                    }
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT DepartmentUID, DepartmentName FROM divisionlkup ORDER BY DepartmentName";
                    //Response.Write("ddlDepartmentNarrow ddlQueryPolicy.SelectCommand (PageLoad): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
                    sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), sqlReader[0].ToString(), true);
                            ddlDepartmentNarrow.Items.Add(item);
                        }
                    }
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT ScheduleUID, ScheduleName FROM schedule WHERE ScheduleUID " + valuestring + "ORDER BY ScheduleName";
                    //Response.Write("ddlSchedule ddlQuery.SelectCommand (ddlPolicyGroup_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
                    sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                            ddlScheduleSeries.Items.Add(item);
                        }
                        ListItem scheduleall = new ListItem("Narrow results by schedule...", " != ''", true);
                        scheduleall.Selected = true;
                        ddlScheduleSeries.Items.Add(scheduleall);
                    }
                    ddlQueryPolicy.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM combinedstatepolicies WHERE ScheduleUID " + ddlScheduleSeries.SelectedValue.ToString() + " ORDER BY StandardName";
                    //Response.Write("ddlStandard ddlQuery.SelectCommand (ddlPolicyGroup_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
                    sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        while (sqlReader.Read())
                        {
                            ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                            ddlStandardSeries.Items.Add(item);
                        }

                        ListItem scheduleall = new ListItem("Narrow results by schedule...", " != ''", true);
                        scheduleall.Selected = true;
                        ddlStandardSeries.Items.Add(scheduleall);
                    }
                }
                if (ddlPolicyGroupPolicy.SelectedValue.ToString() != " != ''")
                {
                    SqlDataScopePolicy.SelectCommand = "SELECT DISTINCT CONCAT(DepartmentName, ': ', DivisionName) FROM divisionlkup WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString();
                    SqlDataReader sqlReader = (SqlDataReader)SqlDataScopePolicy.Select(DataSourceSelectArguments.Empty);
                    if (sqlReader.HasRows)
                    {
                        string scopestring = "<b>This Policy Group includes: </b><br>";
                        while (sqlReader.Read())
                        {
                            scopestring = scopestring + sqlReader[0].ToString() + "<br>";
                        }
                        DataScopePolicy.Text = scopestring;
                    }
                    else
                    {
                        DataScopePolicy.Text = "";
                    }
                }
                else
                {
                    DataScopePolicy.Text = "";
                }
            }
        }

        protected void ddlPolicyGroupPolicy_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlSchedulePolicy.Items.Clear();
            ddlStandardPolicy.Items.Clear();
            ddlQueryPolicy.SelectCommand = "SELECT DISTINCT ScheduleUID, ScheduleName FROM compiledpolicies WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString() + " ORDER BY ScheduleName";
            //Response.Write("ddlSchedulePolicy ddlQueryPolicy.SelectCommand (ddlPolicyGroupPolicy_SelectedIndexChanged): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                    ddlSchedulePolicy.Items.Add(item);
                }
            }
            ListItem scheduleall = new ListItem("Narrow results by schedule...", " != ''", true);
            scheduleall.Selected = true;
            ddlSchedulePolicy.Items.Add(scheduleall);
            ddlQueryPolicy.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM compiledpolicies WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString() + " AND ScheduleUID " + ddlSchedulePolicy.SelectedValue.ToString() + " ORDER BY StandardName";
            //Response.Write("ddlStandardPolicy ddlQueryPolicy.SelectCommand (ddlPolicyGroupPolicy_SelectedIndexChanged): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
            sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                    ddlStandardPolicy.Items.Add(item);
                }
            }
            ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
            standardall.Selected = true;
            ddlStandardPolicy.Items.Add(standardall);
        }

        protected void ddlSchedulePolicy_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlStandardPolicy.Items.Clear();
            ddlQueryPolicy.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM compiledpolicies WHERE PolicyGroupUID " + ddlPolicyGroupPolicy.SelectedValue.ToString() + " AND ScheduleUID " + ddlSchedulePolicy.SelectedValue.ToString() + " ORDER BY StandardName";
            //Response.Write("ddlStandardPolicy ddlQueryPolicy.SelectCommand (ddlSchedulePolicy_SelectedIndexChanged): " + ddlQueryPolicy.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                    ddlStandardPolicy.Items.Add(item);
                }
            }
            ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
            standardall.Selected = true;
            ddlStandardPolicy.Items.Add(standardall);
        }

        protected void ddlScheduleSeries_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlStandardSeries.Items.Clear();
            ddlQueryPolicy.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM combinedstatepolicies WHERE ScheduleUID " + ddlScheduleSeries.SelectedValue.ToString() + " ORDER BY StandardName";
            //Response.Write("ddlStandard ddlQuery.SelectCommand (ddlSchedule_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQueryPolicy.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                    ddlStandardSeries.Items.Add(item);
                }
            }
            ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
            standardall.Selected = true;
            ddlStandardSeries.Items.Add(standardall);
        }
        
        protected void policiesGridPolicy_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[2].Text == "0")
                {
                    IEnumerable<int> range = Enumerable.Range(0, (e.Row.Cells.Count));
                    foreach (int num in range)
                    {
                        e.Row.Cells[num].BackColor = System.Drawing.Color.Gray;
                    }
                }
                if (e.Row.Cells[34].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    e.Row.Cells[34].Text = "Current";
                }
            }
        }

        protected void policiesGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[2].Text == "0")
                {
                    IEnumerable<int> range = Enumerable.Range(0, (e.Row.Cells.Count));
                    foreach (int num in range)
                    {
                        e.Row.Cells[num].BackColor = System.Drawing.Color.Gray;
                    }
                }
                if (e.Row.Cells[18].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    e.Row.Cells[18].Text = "Current";
                }
            }
        }

        protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnCommand")
            {
                DataGridViewSeries.Attributes["class"] = "Display";
                DataDetailView.Attributes["class"] = "DisplayNone";
                FilterControlSeries.Attributes["class"] = "Display";
                hidefiltersSeries.CssClass = "Display";
                revealfiltersSeries.CssClass = "DisplayNone";
                policiesGrid.SelectedIndex = -1;
            }
        }

        protected void DetailsView1Policy_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnCommand")
            {
                DataGridViewPolicy.Attributes["class"] = "Display";
                DataDetailViewPolicy.Attributes["class"] = "DisplayNone";
                FilterControlPolicy.Attributes["class"] = "Display";
                hidefiltersPolicy.CssClass = "Display";
                revealfiltersPolicy.CssClass = "DisplayNone";
                policiesGridPolicy.SelectedIndex = -1;
            }
        }

        protected void policiesGridPolicy_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataDetailViewPolicy.Attributes["class"] = "Display";
            DataGridViewPolicy.Attributes["class"] = "DisplayNone";
            FilterControlPolicy.Attributes["class"] = "DisplayNone";
            hidefiltersPolicy.CssClass = "DisplayNone";
            revealfiltersPolicy.CssClass = "Display";
        }
        
        protected void policiesGrid_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataDetailView.Attributes["class"] = "Display";
            DataGridViewSeries.Attributes["class"] = "DisplayNone";
            FilterControlSeries.Attributes["class"] = "DisplayNone";
            hidefiltersSeries.CssClass = "DisplayNone";
            revealfiltersSeries.CssClass = "Display";
        }

        protected void DetailsView1_DataBound(object sender, EventArgs e)
        {
            if (DetailsView1.Rows.Count > 0)
            {
                if (DetailsView1.Rows[20].Cells[1].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    DetailsView1.Rows[20].Cells[1].Text = "Current";
                }
            }   
        }

        protected void DetailsView1Policy_DataBound(object sender, EventArgs e)
        {
            if (DetailsView1Policy.Rows.Count > 0)
            {
                if (DetailsView1Policy.Rows[7].Cells[1].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    DetailsView1Policy.Rows[7].Cells[1].Text = "Current";
                }
                if (DetailsView1Policy.Rows[16].Cells[1].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    DetailsView1Policy.Rows[16].Cells[1].Text = "Current";
                }
                if (DetailsView1Policy.Rows[27].Cells[1].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    DetailsView1Policy.Rows[27].Cells[1].Text = "Current";
                }
                if (DetailsView1Policy.Rows[36].Cells[1].Text == DateTime.Today.ToString("yyyy-MM-dd"))
                {
                    DetailsView1Policy.Rows[36].Cells[1].Text = "Current";
                }
            }
        }

        protected void revealfiltersPolicy_Click(object sender, EventArgs e)
        {
            FilterControlPolicy.Attributes["class"] = "Display";
            hidefiltersPolicy.CssClass = "Display";
            revealfiltersPolicy.CssClass = "DisplayNone";
        }

        protected void hidefiltersPolicy_Click(object sender, EventArgs e)
        {
            FilterControlPolicy.Attributes["class"] = "DisplayNone";
            hidefiltersPolicy.CssClass = "DisplayNone";
            revealfiltersPolicy.CssClass = "Display";
        }

        protected void revealfiltersSeries_Click(object sender, EventArgs e)
        {
            FilterControlSeries.Attributes["class"] = "Display";
            hidefiltersSeries.CssClass = "Display";
            revealfiltersSeries.CssClass = "DisplayNone";
        }

        protected void hidefiltersSeries_Click(object sender, EventArgs e)
        {
            FilterControlSeries.Attributes["class"] = "DisplayNone";
            hidefiltersSeries.CssClass = "DisplayNone";
            revealfiltersSeries.CssClass = "Display";
        }

        protected void ddlChanges_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlChanges.SelectedIndex)
            {
                case 0:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text Display";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    ddlCountyChange.Attributes["class"] = "Text DisplayNone";
                    ddlStateChange.Attributes["class"] = "Text DisplayNone";
                    break;
                case 1:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    ddlCountyChange.Attributes["class"] = "Text DisplayNone";
                    ddlStateChange.Attributes["class"] = "Text Display";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text Display";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
                case 2:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    ddlCountyChange.Attributes["class"] = "Text Display";
                    ddlStateChange.Attributes["class"] = "Text DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text Display";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
            }
        }

        protected void ddlCountyChange_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlCountyChange.SelectedIndex)
            {
                case 0:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text Display";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
                case 1:
                    editPolicy.Attributes["class"] = "Display";
                    PolicyTableEdit.Attributes["class"] = "Display";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text Display";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
                case 2:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "Display";
                    departmentTablesEdit.Attributes["class"] = "Display";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text Display";
                    break;
            }
        }

        protected void ddlStateChange_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlStateChange.SelectedIndex)
            {
                case 0:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text Display";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
                case 1:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "DisplayNone";
                    SeriesTableEdit.Attributes["class"] = "DisplayNone";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text Display";
                    helperSeries.Attributes["class"] = "Text DisplayNone";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
                case 2:
                    editPolicy.Attributes["class"] = "DisplayNone";
                    PolicyTableEdit.Attributes["class"] = "DisplayNone";
                    editSeries.Attributes["class"] = "Display";
                    SeriesTableEdit.Attributes["class"] = "Display";
                    editDepartment.Attributes["class"] = "DisplayNone";
                    departmentTablesEdit.Attributes["class"] = "DisplayNone";
                    helperInfo.Attributes["class"] = "Text DisplayNone";
                    helperStateBox.Attributes["class"] = "Text DisplayNone";
                    helperCountyBox.Attributes["class"] = "Text DisplayNone";
                    helperStateChoice.Attributes["class"] = "Text DisplayNone";
                    helperCountyChoice.Attributes["class"] = "Text DisplayNone";
                    helperScheduleStandard.Attributes["class"] = "Text DisplayNone";
                    helperSeries.Attributes["class"] = "Text Display";
                    helperPolicy.Attributes["class"] = "Text DisplayNone";
                    helperDepartment.Attributes["class"] = "Text DisplayNone";
                    break;
            }
        }
       
        protected void policiesGridDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {    
            DataDetailViewDepartment.Attributes["class"] = "Display";
            DataGridViewDepartment.Attributes["class"] = "DisplayNone";
            FilterControlDepartment.Attributes["class"] = "DisplayNone";
            hidefiltersDepartment.CssClass = "DisplayNone";
            revealfiltersDepartment.CssClass = "Display";
            SqlDataScopePolicy.SelectCommand = "SELECT DISTINCT CONCAT(DepartmentName, ': ', DivisionName) FROM divisionlkup WHERE PolicyGroupUID = " + DetailsViewDivision.Rows[5].Cells[1].Text.ToString();
            SqlDataReader sqlReader = (SqlDataReader)SqlDataScopePolicy.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                string scopestring = "<br /><b>The following Department: Divisions share the selected Policy Group: </b><br />";
                while (sqlReader.Read())
                {
                    scopestring = scopestring + sqlReader[0].ToString() + "<br>";
                }
                policyGroupScope2.Text = scopestring;
            }
            else
            {
                DataScopePolicy.Text = "";
            }
        }

        protected void DetailsViewDivision_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnCommand")
            {
                DataGridViewDepartment.Attributes["class"] = "Display";
                DetailsViewDivision.Attributes["class"] = "DisplayNone";
                FilterControlDepartment.Attributes["class"] = "Display";
                hidefiltersDepartment.CssClass = "Display";
                revealfiltersDepartment.CssClass = "DisplayNone";
                policiesGridDepartment.SelectedIndex = -1;
            }
        }
        
        protected void DepartmentTableEdit_DataBound(object sender, EventArgs e)
        {
            if (DetailsViewDivision.DataItemCount == 0)
            {
                DepartmentTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void PolicyGroupTableEdit_DataBound(object sender, EventArgs e)
        {
            if (DetailsViewDivision.DataItemCount == 0)
            {
                PolicyGroupTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void DivisionTableEdit_DataBound(object sender, EventArgs e)
        {
            if (DetailsViewDivision.DataItemCount == 0)
            {
                DivisionTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void DetailsPolicyTableEdit_DataBound(object sender, EventArgs e)
        {
            if (DetailsView1Policy.DataItemCount == 0)
            {
                DetailsPolicyTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void hidefiltersDepartment_Click(object sender, EventArgs e)
        {
            FilterControlDepartment.Attributes["class"] = "DisplayNone";
            hidefiltersDepartment.CssClass = "DisplayNone";
            revealfiltersDepartment.CssClass = "Display";
        }

        protected void revealfiltersDepartment_Click(object sender, EventArgs e)
        {
            FilterControlDepartment.Attributes["class"] = "Display";
            hidefiltersDepartment.CssClass = "Display";
            revealfiltersDepartment.CssClass = "DisplayNone";
        }

        protected void DetailsSeriesTableEdit_DataBound(object sender, EventArgs e)
        {
            if (DetailsView1.DataItemCount == 0)
            {
                DetailsSeriesTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void DepartmentTableEdit_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            string newUID = ((TextBox)DepartmentTableEdit.Rows[1].Cells[1].Controls[0]).Text.ToString();
            string oldUID = policiesGridDepartment.SelectedRow.Cells[1].Text.ToString();
            if (newUID == oldUID)
            {
                SqlDataDepartmentTableEdit.UpdateCommand = "UPDATE [department] SET [DepartmentName] = @DepartmentName WHERE [DepartmentUID] = @departmentUID;";
            }
            else
            {
                SqlDataDepartmentTableEdit.UpdateCommand = "INSERT INTO [department] ([DepartmentName], [departmentUID]) VALUES (@DepartmentName, @departmentUID); UPDATE [division] SET [DepartmentUID] = @departmentUID WHERE [DepartmentUID] = '" + oldUID + "'; DELETE FROM [department] WHERE [departmentUID] = '" + oldUID +"';";
            }
        }

        protected void DepartmentTableEdit_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                DepartmentTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Update")
            {
                DepartmentTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Insert")
            {
                DepartmentTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void DivisionTableEdit_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                DivisionTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Update")
            {
                DivisionTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Insert")
            {
                DivisionTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void PolicyGroupTableEdit_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                PolicyGroupTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Update")
            {
                PolicyGroupTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Insert")
            {
                PolicyGroupTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }

        protected void DepartmentTableEdit_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void DepartmentTableEdit_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void PolicyGroupTableEdit_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void PolicyGroupTableEdit_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void DivisionTableEdit_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void DivisionTableEdit_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            policiesGridDepartment.DataBind();
        }

        protected void DetailsPolicyTableEdit_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            policiesGridPolicy.DataBind();
        }

        protected void DetailsPolicyTableEdit_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            policiesGridPolicy.DataBind();
        }

        protected void DetailsPolicyTableEdit_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                DetailsPolicyTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Update")
            {
                DetailsPolicyTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Insert")
            {
                DetailsPolicyTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }
        protected void DetailsSeriesTableEdit_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            CheckBox chk = DetailsSeriesTableEdit.FindControl("deactivate") as CheckBox;

            if (chk != null && chk.Checked)
            {
                SqlDataSeriesTableEdit.UpdateCommand = "DECLARE @NewSeriesUID INT; UPDATE [series] SET [SeriesIsActive] = 'Inactive', [SeriesActiveTo] = GETDATE() WHERE [SeriesUID] = @SeriesUID; INSERT INTO [series] ([StandardUID], [SeriesID], [SeriesName], [SeriesDescription], [SeriesDispositionInstructions], [SeriesRelevantStatutes], [SeriesIsActive], [SeriesActiveFrom], [SeriesActiveTo], [SeriesRevisionFlag]) VALUES (@StandardUID, @SeriesID, @SeriesName, @SeriesDescription, @SeriesDispositionInstructions, @SeriesRelevantStatutes, @SeriesIsActive, @SeriesActiveFrom, @SeriesActiveTo, @SeriesRevisionFlag); SELECT @NewSeriesUID = SCOPE_IDENTITY(); UPDATE [policy] SET [SeriesUID] = @NewSeriesUID WHERE [SeriesUID] = @SeriesUID;";
            }
        }

        protected void DetailsSeriesTableEdit_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            policiesGrid.DataBind();
        }

        protected void DetailsSeriesTableEdit_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            policiesGrid.DataBind();
        }

        protected void DetailsSeriesTableEdit_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                DetailsSeriesTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Update")
            {
                DetailsSeriesTableEdit.ChangeMode(DetailsViewMode.Edit);
            }
            if (e.CommandName == "Insert")
            {
                DetailsSeriesTableEdit.ChangeMode(DetailsViewMode.Insert);
            }
        }
    }
}