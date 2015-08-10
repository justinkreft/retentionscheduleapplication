<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RetentionSchedules.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<link href="Styles/gridstyle.css" rel="stylesheet" />
</head>
<body>
    <div class="HeadText1"><b>Welcome to Wake County's Online Record Retention Wizard</b></div><br />
    <form id="form1" runat="server">
    <div>
	<table border="1" style="width: 1200px">
        <tr>
            <td class="HeadText2 Header" colspan="2" style="width: 800px; padding:20px"><b>Have you ever asked, "How long do I keep that record???"</b><br /><br />
                <div class="Text">This is your guide for all Wake County's record retention policies. Select an option below to begin your search.</div>
                <asp:SqlDataSource ID="ddlQuery" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" DataSourceMode="DataReader" ></asp:SqlDataSource>
            </td>
            <td class="Header Text" style="width: 400px; text-align:right; padding:20px;">
                <asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl="/retention/adminlogin.aspx" ForeColor="White" >Admin</asp:LinkButton><br />
            </td>
        </tr>
        <tr>
            <td class="HeadText2 Schedule" style="vertical-align: top; padding:20px;">
                <b>Search Policies by Department/Division</b><br /><br />
                <asp:DropDownList class="Text" ID="ddlDepartments" runat="server" width="350px" AutoPostBack = "true" OnSelectedIndexChanged="ddlDepartments_SelectedIndexChanged" ValidationGroup="PolicyGroup">
                    <asp:ListItem Text = "--Select Department--" Value = ""></asp:ListItem>
                </asp:DropDownList><br /><br />
                <asp:DropDownList class="Text" ID="ddlDivisions" runat="server" width="350px" AutoPostBack = "true" PostBackUrl="~/wakeretentionpolicies.aspx" ValidationGroup="PolicyGroup">
                    <asp:ListItem Text = "--Select Division--" Value = ""></asp:ListItem>
                </asp:DropDownList><br /><br />
                <asp:Button class="Text" ID="policygroupbutton" runat="server" Text="Search" PostBackUrl="~/wakeretentionpolicies.aspx" OnClick="policygroupbutton_Click" ValidationGroup="PolicyGroup" /><br />
                <asp:RequiredFieldValidator class="Text" ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlDivisions" ErrorMessage="Must Select a Department/Division; " Font-Bold="True" ForeColor="Red" ValidationGroup="PolicyGroup"></asp:RequiredFieldValidator>
                <br />
            </td>
            <td class="HeadText2 Standard" style="vertical-align: top;  padding:20px;">
                <b>Search State Policies by Schedule</b><br /><br />
                <asp:DropDownList class="Text" ID="ddlSchedules" runat="server" width="350px" AutoPostBack = "true" ValidationGroup="Schedule">
                    <asp:ListItem Text = "--Select Schedule--" Value = ""></asp:ListItem>
                    <asp:ListItem Text = "All Schedules" Value = " != ''"></asp:ListItem>
                </asp:DropDownList><br /><br />
                <asp:Button class="Text" ID="schedulebutton" runat="server" Text="Search" PostBackUrl="~/stateretentionpolicies.aspx" OnClick="schedulebutton_Click" ValidationGroup="Schedule" /><br />
                <asp:RequiredFieldValidator class="Text" ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlSchedules" ErrorMessage="Must Select a State Schedule; " Font-Bold="True" ForeColor="Red" ValidationGroup="Schedule"></asp:RequiredFieldValidator>
            </td>
            <td class="HeadText2 Series" style="vertical-align: top;  padding:20px;">
                <b>Search All Wake County Policies</b><br /><br />
                <asp:Button class="Text" ID="allsearchbutton" runat="server" Text="Search" OnClick="allsearchbutton_Click" PostBackUrl="~/policysearch.aspx" /><br />
            </td>
        </tr>
        <tr>
            <td class="Text Policy" colspan="3" style="padding:20px">
                <b class="HeadText2" >Retention Schedule Information:</b><br /><br />
                According to G.S. §121-5 and G.S. §132-8, state and local governmental entities may only destroy public records with the consent of the Department of Cultural Resources (DCR), the Division of Archives and Records.  Retention schedules are the primary way that the Division of Archives and Records gives its consent to state and local governments to destroy their records.  <br /><br />
                Retention schedules serve as the inventory and schedule that DCR is directed by statute to provide.   Retention schedules list records created and maintained by units of state and local government, and give an assessment of a records value (administrative, legal, fiscal, and/or historical) by indicating when (and if) those records should be destroyed.  <br /><br />
                View Records schedule related blog posts from <a href="http://ncrecords.wordpress.com/category/schedules/" target="_blank">The G.S. 132 Files blog</a><br /><br />
                Also see NC Record Retention <a href="http://www.ncdcr.gov/archives/ForGovernment/LawsAndGuidelines.aspx" >Laws and Guidelines</a><br /><br />
            </td>
        </tr>
        <tr>
            <td colspan="3" class="Header"><br /><br /><br /></td>
        </tr>
	</table>
                <asp:HiddenField ID="TitleString" runat="server" Value="Displaying All Wake County Policy Records" />
                <asp:HiddenField ID="ValueString" runat="server" Value=" != ''" />
    </div>
    </form>
</body>
</html>
