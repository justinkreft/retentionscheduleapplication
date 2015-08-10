<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="policysearch.aspx.cs" Inherits="RetentionSchedules.policysearch" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<link href="Styles/gridstyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td style="width: 850px" class="HeadText1"><b><asp:Label ID="Title" runat="server" CssClass="HeadText1"></asp:Label></b></td>
                <td class="HeadText2"><a href="/retention/default.aspx">Return to Start</a>
                </td>
            </tr>
        </table>
    </div>
    <hr />
    <div>    
    <table border="0">
            <tr>
            <td colspan="4">
                <asp:SqlDataSource ID="ddlQuery" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" DataSourceMode="DataReader" ></asp:SqlDataSource>
            </td>
            </tr>
            <tr>
                <td style="width: 200px" class="HeadText2">
                <b>Narrow by Policy Group</b>
                </td>
                <td style="width: 400px" >
                    <asp:DropDownList ID="ddlPolicyGroup" runat="server" Width="350px" AutoPostBack="True" OnSelectedIndexChanged="ddlPolicyGroup_SelectedIndexChanged" CausesValidation="True" class="Text"></asp:DropDownList>
                </td>
                <td style="width: 150px" >
                </td>
                <td class="Text" rowspan="9"  style="width: 500px; vertical-align: top;" >
                <div style="height: 200px; overflow-y:scroll;" >
                    <asp:SqlDataSource ID="SqlDataScope" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" DataSourceMode="DataReader" ></asp:SqlDataSource>
                    <asp:Label ID="DataScope" runat="server"></asp:Label>
                </div>
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Narrow by Schedule</b>
                </td>
                <td>
                    <asp:DropDownList ID="ddlSchedule" runat="server" Width="350px" AutoPostBack="True" OnSelectedIndexChanged="ddlSchedule_SelectedIndexChanged" CausesValidation="True" class="Text"></asp:DropDownList>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Narrow by Standard</b>    
                </td>
                <td>
                    <asp:DropDownList ID="ddlStandard" runat="server" Width="350px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:DropDownList>
                </td>
                <td></td>
            </tr>
            <tr>
            <td colspan="3"></td>
            </tr>
           
            <tr>
                <td class="HeadText2">
                    <b>Search Policy/Series text</b></td>
                <td class="Text">
                    <asp:TextBox ID="filter1term" runat="server" Width="200px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:TextBox>
                    <asp:CheckBox ID="filter1whole" runat="server" Text="Whole Word/Phrase" AutoPostBack="True" CausesValidation="True" />
                </td>
                <td class="Text">
                    <asp:RegularExpressionValidator ID="filter1punctuationvalidator" runat="server" ControlToValidate="filter1term" Display="Dynamic" ErrorMessage="Remove punctuation; " ValidationExpression="[0-9A-Za-z\s]+" Font-Bold="True" ForeColor="#ff0000" ></asp:RegularExpressionValidator>
                    <asp:RegularExpressionValidator ID="filter1lengthvalidator" runat="server" ErrorMessage="30 character limit; " Display="Dynamic" ControlToValidate="filter1term" ValidationExpression="^[\s\S]{0,30}$" Font-Bold="True" ForeColor="#ff0000" ></asp:RegularExpressionValidator>    
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Select Active Records </b>
                </td>
                <td>
                    <asp:DropDownList ID="active" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                        <asp:ListItem Selected="True" Value="yes">Active Records Only</asp:ListItem>
                        <asp:ListItem Value="no">Inactive Records Only</asp:ListItem>
                        <asp:ListItem Value="both">All Records</asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Select Flagged Records </b>
                </td>
                <td>
                    <asp:DropDownList ID="flag" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                        <asp:ListItem Selected="True" Value="both">All Records</asp:ListItem>
                        <asp:ListItem Value="yes">Flagged Records Only</asp:ListItem>
                        <asp:ListItem Value="no">Non-Flagged Records Only</asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td> 
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Policies Active On</b>
                </td>
                <td colspan="1" class="Text">
                    mm/dd/yyyy: 
                    <asp:TextBox ID="activedate" runat="server" Width="150px" AutoPostBack="True" CausesValidation="True"></asp:TextBox>
                </td>
                <td class="Text">
                    <asp:RegularExpressionValidator ID="datevalidator" runat="server" ErrorMessage="Invalid Date; " Display="Dynamic" ControlToValidate="activedate" ValidationExpression="^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="HeadText2">
                    <b>Export Results </b></td>
                <td>
                </td>
                <td>
                </td>
            </tr>
        </table>
    <hr />
    </div>
    <div class="HeadText2">
        <label id="RecordsReturned" runat="server"></label>
        <label id="PartialReturned" runat="server"></label>
    </div>
    <div id="DataGridView" class="Display" runat="server">
    <asp:SqlDataSource ID="SqlDataRecords" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="" >
        </asp:SqlDataSource>
    <asp:GridView ID="policiesGrid" runat="server" CssClass="Grid" AutoGenerateColumns="False" CellPadding="4" DataSourceID="SqlDataRecords" EnableViewState="False" OnRowDataBound="policiesGrid_RowDataBound" AllowPaging="True" PageSize="30" DataKeyNames="SeriesUID" OnSelectedIndexChanged="policiesGrid_SelectedIndexChanged" >
        <Columns>
            <asp:CommandField ShowSelectButton="True" ItemStyle-BackColor="#0A152B" ItemStyle-ForeColor="#ffffff" ControlStyle-CssClass="HeadText2" ItemStyle-CssClass="Header" />
            <asp:BoundField DataField="TermsFrequency" HeaderText="Terms Frequency" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                <HeaderStyle CssClass="DisplayNone HeadText2 Header Grid"></HeaderStyle>
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="DisplayNone Text Header Grid"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="AllTermsPresent" HeaderText="All Terms Present" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                <HeaderStyle CssClass="DisplayNone HeadText2 Header Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="DisplayNone Text Header Grid"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleUID" HeaderText="Schedule UID">
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>         
            <asp:BoundField DataField="ScheduleName" HeaderText="Schedule Name" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleDescription" HeaderText="Schedule Description" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleIsActive" HeaderText="Schedule Is Active" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleActiveFrom" HeaderText="Schedule Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleActiveTo" HeaderText="Schedule Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleRevisionFlag" HeaderText="Schedule Revision Flag" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardUID" HeaderText="Standard UID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardID" HeaderText="Standard ID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardName" HeaderText="Standard Name" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardDescription" HeaderText="Standard Description" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardIsActive" HeaderText="Standard Is Active" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardActiveFrom" HeaderText="Standard Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardActiveTo" HeaderText="Standard Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardRevisionFlag" HeaderText="Standard Revision Flag" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesUID" HeaderText="Series UID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesID" HeaderText="Series ID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesName" HeaderText="Series Name" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesDescription" HeaderText="Series Description" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesDispositionInstructions" HeaderText="Series Disposition Instructions" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesRelevantStatutes" HeaderText="Series Relevant Statutes" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesIsActive" HeaderText="Series Is Active" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField> 
            <asp:BoundField DataField="SeriesActiveFrom" HeaderText="Series Active From" DataFormatString="{0:yyyy-MM-dd}" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesActiveTo" HeaderText="Series Active To" DataFormatString="{0:yyyy-MM-dd}" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesRevisionFlag" HeaderText="Series Revision Flag" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyGroupUID" HeaderText="Policy Group UID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyUID" HeaderText="Policy UID" >
                <HeaderStyle CssClass="DisplayNone HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="DisplayNone Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyDivisionNote" HeaderText="Policy Division Note" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyGroupName" HeaderText="Policy Group" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyIsActive" HeaderText="Policy Is Active" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyActiveFrom" HeaderText="Policy Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyActiveTo" HeaderText="Policy Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyRevisionFlag" HeaderText="Policy Revision Flag" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
        </Columns>
        <HeaderStyle CssClass="HeadText2 Header Grid" />
        <PagerStyle ForeColor="#ffffff" BackColor="#0A152B" />
        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" Position="TopAndBottom" PreviousPageText="Previous" />
        </asp:GridView>
    </div>
    <div id="DataDetailView" class="DisplayNone" runat="server">
        <asp:SqlDataSource ID="SqlDataDetail" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [compiledpolicies] WHERE ([PolicyUID] = @PolicyUID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGrid" Name="PolicyUID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="ScheduleUID,StandardUID,SeriesUID" DataSourceID="SqlDataDetail" Height="60px" Width="500px" CellPadding="4" OnItemCommand="DetailsView1_ItemCommand" EnableViewState="False" OnDataBound="DetailsView1_DataBound" >
            <CommandRowStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
            <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
            <Fields>
            <asp:ButtonField ButtonType="Button" CommandName="ReturnCommand" Text="Return to Results" />
            <asp:TemplateField><ItemTemplate>Schedule Information</ItemTemplate>
                <HeaderStyle CssClass="HeadText2 Grid Header" ></HeaderStyle>
                <ItemStyle CssClass="HeadText2 Grid Schedule" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Underline="True"></ItemStyle>
            </asp:TemplateField>
            <asp:BoundField DataField="ScheduleUID" HeaderText="Schedule UID">
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>         
            <asp:BoundField DataField="ScheduleName" HeaderText="Schedule Name" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleDescription" HeaderText="Schedule Description" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleIsActive" HeaderText="Schedule Is Active" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleActiveFrom" HeaderText="Schedule Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleActiveTo" HeaderText="Schedule Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ScheduleRevisionFlag" HeaderText="Schedule Revision Flag" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:TemplateField><ItemTemplate>Standard Information</ItemTemplate>
                <HeaderStyle CssClass="HeadText2 Grid Header" ></HeaderStyle>
                <ItemStyle CssClass="HeadText2 Grid Standard" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Underline="True"></ItemStyle>
            </asp:TemplateField>
            <asp:BoundField DataField="StandardUID" HeaderText="Standard UID" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardID" HeaderText="Standard ID" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardName" HeaderText="Standard Name" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardDescription" HeaderText="Standard Description" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardIsActive" HeaderText="Standard Is Active" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardActiveFrom" HeaderText="Standard Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardActiveTo" HeaderText="Standard Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="StandardRevisionFlag" HeaderText="Standard Revision Flag" >
                <HeaderStyle CssClass="HeadText2 Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Standard Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:TemplateField><ItemTemplate>Series Information</ItemTemplate>
                <HeaderStyle CssClass="HeadText2 Grid Header" ></HeaderStyle>
                <ItemStyle CssClass="HeadText2 Grid Series" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Underline="True"></ItemStyle>
            </asp:TemplateField>
            <asp:BoundField DataField="SeriesUID" HeaderText="Series UID" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesID" HeaderText="Series ID" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesName" HeaderText="Series Name" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesDescription" HeaderText="Series Description" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesDispositionInstructions" HeaderText="Series Disposition Instructions" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesRelevantStatutes" HeaderText="Series Relevant Statutes" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesIsActive" HeaderText="Series Is Active" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField> 
            <asp:BoundField DataField="SeriesActiveFrom" HeaderText="Series Active From" DataFormatString="{0:yyyy-MM-dd}" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesActiveTo" HeaderText="Series Active To" DataFormatString="{0:yyyy-MM-dd}" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SeriesRevisionFlag" HeaderText="Series Revision Flag" >
                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:TemplateField><ItemTemplate>Policy Information</ItemTemplate>
                <HeaderStyle CssClass="HeadText2 Grid Header" ></HeaderStyle>
                <ItemStyle CssClass="HeadText2 Grid Policy" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Underline="True"></ItemStyle>
            </asp:TemplateField>
            <asp:BoundField DataField="PolicyGroupUID" HeaderText="Policy Group UID" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyUID" HeaderText="Policy UID" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyDivisionNote" HeaderText="Policy Division Note" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyGroupName" HeaderText="Policy Group" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyIsActive" HeaderText="Policy Is Active" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyActiveFrom" HeaderText="Policy Active From" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyActiveTo" HeaderText="Policy Active To" DataFormatString="{0:yyyy-MM-dd}">
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="PolicyRevisionFlag" HeaderText="Policy Revision Flag" >
                <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
        </Fields>
        </asp:DetailsView>
    </div>
    </form>
</body>
</html>
