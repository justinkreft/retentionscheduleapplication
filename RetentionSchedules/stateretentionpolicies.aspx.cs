using System;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace RetentionSchedules
{
    public partial class stateretentionpolicies : System.Web.UI.Page
    {
        //Set Global Variables
        Char[] andor = { ' ', 'A', 'N', 'D', 'O', 'R' };
        string selectstring = "SELECT (null) AS TermsFrequency, (null) AS AllTermsPresent, * FROM [combinedstatepolicies] WHERE ";
        string scheduleUIDclause = "";
        string standardUIDclause = "";
        string valuestring = " != ''";

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Establish Drop Down List Where clauses
            scheduleUIDclause = "ScheduleUID " + ddlSchedule.SelectedValue.ToString();
            standardUIDclause = "StandardUID " + ddlStandard.SelectedValue.ToString();
            selectstring = selectstring + scheduleUIDclause + " AND " + standardUIDclause + " AND ";
            // Establish querystrings
            string rankingstring = "(";
            string finalrankingcondition = "";
            string querystring = "";
            // Begin querystring builder with Hard filters always on
            querystring = querystring + "(";
            // Active Filter
            switch (active.SelectedValue)
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
            switch (flag.SelectedValue)
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
            if (activedate.Text != "")
            {
                string searchdate = activedate.Text.ToString();
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
            // Filter constructor
            if (filter1term.Text != "")
            {
                // Build Word Strings
                foreach (string term in filter1term.Text.Split(new Char[] { ' ' }))
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
                if (filter1whole.Checked == true)
                {
                    foreach (string scope in scopelist)
                    {
                        querystring = querystring + scope + " LIKE '%" + filter1term.Text.ToString() + "%' OR ";
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

            // Create Returned results labels
            PartialReturned.InnerText = "";
            RecordsReturned.InnerText = "";
            //// Returned Rows results
            SqlDataRecords.DataSourceMode = SqlDataSourceMode.DataReader;
            SqlDataReader sqlGridReader = (SqlDataReader)SqlDataRecords.Select(DataSourceSelectArguments.Empty);
            int totalrows = 0;
            int match = 0;
            int partialmatch = 0;
            if (sqlGridReader.HasRows)
            {
                while (sqlGridReader.Read())
                {
                    totalrows += 1;
                    if (sqlGridReader[1].ToString() != "")
                    {
                        match += Convert.ToInt32(sqlGridReader[1].ToString());
                    }
                }
            }
            partialmatch = totalrows - match;
            RecordsReturned.InnerText = "Found " + totalrows + " records matching filters";
            if (partialmatch != 0 && filter1term.Text != "")
            {
                PartialReturned.InnerText = " (" + match + " exact matches and " + partialmatch + " partial matches with grey background)";
            }
            SqlDataRecords.DataSourceMode = SqlDataSourceMode.DataSet;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Page previousPage = Page.PreviousPage;
            if (previousPage != null && previousPage.IsCrossPagePostBack)
            {
                PageTitle.Text = ((HiddenField)previousPage.FindControl("TitleString")).Value.ToString();
                valuestring = ((HiddenField)previousPage.FindControl("ValueString")).Value.ToString();
            }
            else
            {
                if (!IsPostBack)
                {
                    PageTitle.Text = "No Search Scope Defined: Showing All Records";
                }
            }

            //Construct Drop down lists
            if (!IsPostBack)
            {
                ddlQuery.SelectCommand = "SELECT DISTINCT ScheduleUID, ScheduleName FROM schedule WHERE ScheduleUID " + valuestring + "ORDER BY ScheduleName";
                //Response.Write("ddlSchedule ddlQuery.SelectCommand (ddlPolicyGroup_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
                SqlDataReader sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
                if (sqlReader.HasRows)
                {
                    while (sqlReader.Read())
                    {
                        ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                        ddlSchedule.Items.Add(item);
                    }
                    if (ddlSchedule.Items.Count > 1)
                    {
                        ListItem scheduleall = new ListItem("Narrow results by schedule...", " != ''", true);
                        scheduleall.Selected = true;
                        ddlSchedule.Items.Add(scheduleall);
                    }
                }
                ddlQuery.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM combinedstatepolicies WHERE ScheduleUID " + ddlSchedule.SelectedValue.ToString() + " ORDER BY StandardName";
                //Response.Write("ddlStandard ddlQuery.SelectCommand (ddlPolicyGroup_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
                sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
                if (sqlReader.HasRows)
                {
                    while (sqlReader.Read())
                    {
                        ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                        ddlStandard.Items.Add(item);
                    }
                    ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
                    standardall.Selected = true;
                    ddlStandard.Items.Add(standardall);
                }
            }
        }

        protected void ddlSchedule_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlStandard.Items.Clear();
            ddlQuery.SelectCommand = "SELECT DISTINCT StandardUID, StandardName FROM combinedstatepolicies WHERE ScheduleUID " + ddlSchedule.SelectedValue.ToString() + " ORDER BY StandardName";
            //Response.Write("ddlStandard ddlQuery.SelectCommand (ddlSchedule_SelectedIndexChanged): " + ddlQuery.SelectCommand.ToString() + "<br>");
            SqlDataReader sqlReader = (SqlDataReader)ddlQuery.Select(DataSourceSelectArguments.Empty);
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    ListItem item = new ListItem(sqlReader[1].ToString(), "= " + sqlReader[0].ToString(), true);
                    ddlStandard.Items.Add(item);
                }
            }
            ListItem standardall = new ListItem("Narrow results by schedule...", " != ''", true);
            standardall.Selected = true;
            ddlStandard.Items.Add(standardall);
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
                DataGridView.Attributes["class"] = "Display";
                DataDetailView.Attributes["class"] = "DisplayNone";
                RecordsReturned.Attributes["class"] = "Display";
                PartialReturned.Attributes["class"] = "Display";
            }
        }

        protected void policiesGrid_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataDetailView.Attributes["class"] = "Display";
            DataGridView.Attributes["class"] = "DisplayNone";
            RecordsReturned.Attributes["class"] = "DisplayNone";
            PartialReturned.Attributes["class"] = "DisplayNone";
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            filter1term.Text = "";
            filter1whole.Checked = false;
            flag.SelectedIndex = 0;
            active.SelectedIndex = 0;
            activedate.Text = "";
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
    }
}