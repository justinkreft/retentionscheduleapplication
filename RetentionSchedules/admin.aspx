<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="RetentionSchedules.admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<link href="Styles/gridstyle.css" rel="stylesheet" />
</head>
<body>
    <div class="HeadText1">Administrative View<br /></div>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hidPass" runat="server" />
        <asp:SqlDataSource ID="ddlQueryPolicy" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" DataSourceMode="DataReader" >
        </asp:SqlDataSource> 
        <asp:SqlDataSource ID="SqlDataScopePolicy" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" DataSourceMode="DataReader" ></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataRecordsPolicy" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="" ></asp:SqlDataSource>                                    
        <asp:SqlDataSource ID="SqlDataRecords" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="" >
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataDetailPolicy" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [compiledpolicies] WHERE ([PolicyUID] = @PolicyUID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGridPolicy" Name="PolicyUID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataDetail" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [combinedstatepolicies] WHERE ([SeriesUID] = @SeriesUID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGrid" Name="SeriesUID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataPolicyTableEdit" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [policy] WHERE ([PolicyUID] = @PolicyUID)" DeleteCommand="UPDATE [policy] SET [PolicyIsActive] = 'Inactive', [PolicyActiveTo] = GetDate() WHERE [PolicyUID] = @PolicyUID" InsertCommand="INSERT INTO [policy] ([SeriesUID], [PolicyGroupUID], [PolicyDivisionNote], [PolicyIsActive], [PolicyActiveFrom], [PolicyRevisionFlag]) VALUES (@SeriesUID, @PolicyGroupUID, @PolicyDivisionNote, 'Active', GetDate(), @PolicyRevisionFlag)" UpdateCommand="UPDATE [policy] SET [SeriesUID] = @SeriesUID, [PolicyGroupUID] = @PolicyGroupUID, [PolicyDivisionNote] = @PolicyDivisionNote, [PolicyIsActive] = @PolicyIsActive, [PolicyActiveFrom] = @PolicyActiveFrom, [PolicyActiveTo] = @PolicyActiveTo, [PolicyRevisionFlag] = @PolicyRevisionFlag WHERE [PolicyUID] = @PolicyUID">
<DeleteParameters>
<asp:Parameter Name="PolicyUID" Type="Int32"></asp:Parameter>
</DeleteParameters>
<InsertParameters>
<asp:Parameter Name="SeriesUID" Type="Int32"></asp:Parameter>
<asp:Parameter Name="PolicyGroupUID" Type="Int32"></asp:Parameter>
<asp:Parameter Name="PolicyDivisionNote" Type="String"></asp:Parameter>
<asp:Parameter Name="PolicyIsActive" DefaultValue="Active" Type="String"></asp:Parameter>
<asp:Parameter Name="PolicyActiveFrom" Type="DateTime"></asp:Parameter>
<asp:Parameter Name="PolicyActiveTo" Type="DateTime"></asp:Parameter>
<asp:Parameter Name="PolicyRevisionFlag" Type="String"></asp:Parameter>
</InsertParameters>
<SelectParameters>
<asp:ControlParameter ControlID="policiesGridPolicy" Name="PolicyUID" PropertyName="SelectedValue" Type="Int32" />
</SelectParameters>
<UpdateParameters>
<asp:Parameter Name="SeriesUID" Type="Int32"></asp:Parameter>
<asp:Parameter Name="PolicyGroupUID" Type="Int32"></asp:Parameter>
<asp:Parameter Name="PolicyDivisionNote" Type="String"></asp:Parameter>
<asp:Parameter Name="PolicyIsActive" Type="String"></asp:Parameter>
<asp:Parameter Name="PolicyActiveFrom" Type="DateTime"></asp:Parameter>
<asp:Parameter Name="PolicyActiveTo" Type="DateTime"></asp:Parameter>
<asp:Parameter Name="PolicyRevisionFlag" Type="String"></asp:Parameter>
<asp:Parameter Name="PolicyUID" Type="Int32"></asp:Parameter>
</UpdateParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataRecordsDivision" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [divisionlkup] WHERE ([DepartmentUID] = CASE WHEN @DepartmentUID = 'Select All' THEN [DepartmentUID] ELSE @DepartmentUID END)" >
    <SelectParameters>
        <asp:ControlParameter ControlID="ddlDepartmentNarrow" Name="DepartmentUID" PropertyName="SelectedValue" Type="String" />
    </SelectParameters>
        </asp:SqlDataSource>                                    
    <asp:SqlDataSource ID="SqlDataDetailDivision" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [divisionlkup] WHERE [DivisionUID] = @DivisionUID">
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGridDepartment" Name="DivisionUID" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataDepartmentTableEdit" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [department] WHERE ([departmentUID] = @departmentUID)" DeleteCommand="DELETE FROM [department] WHERE [departmentUID] = @departmentUID" InsertCommand="INSERT INTO [department] ([DepartmentName], [departmentUID]) VALUES (@DepartmentName, @departmentUID)" UpdateCommand="UPDATE [department] SET [DepartmentName] = @DepartmentName WHERE [DepartmentUID] = @departmentUID;" >
            <DeleteParameters>
                <asp:Parameter Name="departmentUID" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="DepartmentName" Type="String" />
                <asp:Parameter Name="departmentUID" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGridDepartment" Name="departmentUID" PropertyName="SelectedDataKey[1]" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="DepartmentName" Type="String" />
                <asp:Parameter Name="departmentUID" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataPolicyGroupTableEdit" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [policygroup] WHERE ([PolicyGroupUID] = @PolicyGroupUID)" DeleteCommand="DELETE FROM [policygroup] WHERE [PolicyGroupUID] = @PolicyGroupUID" InsertCommand="INSERT INTO [policygroup] ([PolicyGroupName]) VALUES (@PolicyGroupName)" UpdateCommand="UPDATE [policygroup] SET [PolicyGroupName] = @PolicyGroupName WHERE [PolicyGroupUID] = @PolicyGroupUID">
            <DeleteParameters>
                <asp:Parameter Name="PolicyGroupUID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="PolicyGroupName" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGridDepartment" Name="PolicyGroupUID" PropertyName="SelectedDataKey[2]" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="PolicyGroupName" Type="String" />
                <asp:Parameter Name="PolicyGroupUID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataDivisionTableEdit" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [division] WHERE ([DivisionUID] = @DivisionUID)" DeleteCommand="DELETE FROM [division] WHERE [DivisionUID] = @DivisionUID" InsertCommand="INSERT INTO [division] ([DivisionName], [DepartmentUID], [PolicyGroupUID], [DivisionUID]) VALUES (@DivisionName, @DepartmentUID, @PolicyGroupUID, @DivisionUID)" UpdateCommand="UPDATE [division] SET [DivisionName] = @DivisionName, [DepartmentUID] = @DepartmentUID, [PolicyGroupUID] = @PolicyGroupUID WHERE [DivisionUID] = @DivisionUID">
            <DeleteParameters>
                <asp:Parameter Name="DivisionUID" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="DivisionName" Type="String" />
                <asp:Parameter Name="DepartmentUID" Type="String" />
                <asp:Parameter Name="PolicyGroupUID" Type="Int32" />
                <asp:Parameter Name="DivisionUID" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="policiesGridDepartment" Name="DivisionUID" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="DivisionName" Type="String" />
                <asp:Parameter Name="DepartmentUID" Type="String" />
                <asp:Parameter Name="PolicyGroupUID" Type="Int32" />
                <asp:Parameter Name="DivisionUID" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSeriesTableEdit" runat="server" ConnectionString="<%$ ConnectionStrings:DEVOMACHretentionscheduleConnectionString %>" SelectCommand="SELECT * FROM [series] WHERE ([SeriesUID] = @SeriesUID)" DeleteCommand="UPDATE [series] SET [SeriesIsActive] = 'Inactive', [SeriesActiveTo] = GetDate() WHERE [SeriesUID] = @SeriesUID" InsertCommand="INSERT INTO [series] ([StandardUID], [SeriesID], [SeriesName], [SeriesDescription], [SeriesDispositionInstructions], [SeriesRelevantStatutes], [SeriesIsActive], [SeriesActiveFrom], [SeriesRevisionFlag]) VALUES (@StandardUID, @SeriesID, @SeriesName, @SeriesDescription, @SeriesDispositionInstructions, @SeriesRelevantStatutes, 'Active', GetDate(), @SeriesRevisionFlag)" UpdateCommand="UPDATE [series] SET [StandardUID] = @StandardUID, [SeriesID] = @SeriesID, [SeriesName] = @SeriesName, [SeriesDescription] = @SeriesDescription, [SeriesDispositionInstructions] = @SeriesDispositionInstructions, [SeriesRelevantStatutes] = @SeriesRelevantStatutes, [SeriesIsActive] = @SeriesIsActive, [SeriesActiveFrom] = @SeriesActiveFrom, [SeriesActiveTo] = @SeriesActiveTo, [SeriesRevisionFlag] = @SeriesRevisionFlag WHERE [SeriesUID] = @SeriesUID">
            <DeleteParameters>
            <asp:Parameter Name="SeriesUID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
            <asp:Parameter Name="StandardUID" Type="Int32" />
            <asp:Parameter Name="SeriesID" Type="Int32" />
            <asp:Parameter Name="SeriesName" Type="String" />
            <asp:Parameter Name="SeriesDescription" Type="String" />
            <asp:Parameter Name="SeriesDispositionInstructions" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesRelevantStatutes" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesIsActive" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesActiveFrom" Type="DateTime"></asp:Parameter>
            <asp:Parameter Name="SeriesActiveTo" Type="DateTime"></asp:Parameter>
            <asp:Parameter Name="SeriesRevisionFlag" Type="String"></asp:Parameter>
            </InsertParameters>
            <SelectParameters>
            <asp:ControlParameter ControlID="policiesGrid" Name="SeriesUID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
            <asp:Parameter Name="StandardUID" Type="Int32" />
            <asp:Parameter Name="SeriesID" Type="Int32" />
            <asp:Parameter Name="SeriesName" Type="String" />
            <asp:Parameter Name="SeriesDescription" Type="String" />
            <asp:Parameter Name="SeriesDispositionInstructions" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesRelevantStatutes" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesIsActive" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesActiveFrom" Type="DateTime"></asp:Parameter>
            <asp:Parameter Name="SeriesActiveTo" Type="DateTime"></asp:Parameter>
            <asp:Parameter Name="SeriesRevisionFlag" Type="String"></asp:Parameter>
            <asp:Parameter Name="SeriesUID" Type="Int32"></asp:Parameter>
            </UpdateParameters>
        </asp:SqlDataSource>
        
        <table border="1">
            <tr>
                <td class="Text Header" style="width: 700px; height: 200px; vertical-align: top; padding: 20px">
                    <div class="HeadText1">Admin Controls: <br /><br />What Changes need to be made?<br /></div>    
                    <asp:DropDownList class="Text" ID="ddlChanges" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlChanges_SelectedIndexChanged">
                        <asp:ListItem Selected="True" Value="">--Select Actions--</asp:ListItem>
                        <asp:ListItem Value="state">State Level Change (Schedule, Standard, Series)</asp:ListItem>
                        <asp:ListItem Value="county">County Level Change (Policy, Department, Division, Policy Group)</asp:ListItem>
                        </asp:DropDownList>
                    <br />
                    <asp:DropDownList ID="ddlCountyChange" runat="server" Width="300px" AutoPostBack="True" class="Text DisplayNone" OnSelectedIndexChanged="ddlCountyChange_SelectedIndexChanged">
                        <asp:ListItem Selected="True" Value="">--Choose One--</asp:ListItem>
                        <asp:ListItem Value="state">Edit Policies</asp:ListItem>
                        <asp:ListItem Value="county">Edit Department, Division, or Policy Group</asp:ListItem>
                        </asp:DropDownList>
                    <asp:DropDownList ID="ddlStateChange" runat="server" Width="300px" AutoPostBack="True" class="Text DisplayNone" OnSelectedIndexChanged="ddlStateChange_SelectedIndexChanged">
                        <asp:ListItem Selected="True" Value="">--Choose One--</asp:ListItem>
                        <asp:ListItem Value="state">Edit Schedule/Standard</asp:ListItem>
                        <asp:ListItem Value="county">Edit Series</asp:ListItem>
                        </asp:DropDownList>
                    <br />
                    <a href="/retention/default.aspx" class="Text" style="color: #ffffff">Return to Home</a>
                </td>
                <td class="Text Header" style="width: 550px; height: 200px; vertical-align: top; padding: 20px">
                    <div class="HeadText2">Helper Panel</div><br />
                    <div class="Policy" style="width: 490px; height: 140px; overflow-y: scroll; padding: 20px"">
                    <asp:Label ID="helperInfo" class="Text Display" runat="server" Text="Welcome to the Admin Tool for Wake County’s Record Retention Schedule Database. You can edit and insert Policies, Series, Departments, Divisions, and Policy Groups from this page. The right lower panel will display tools to update the database, while the left lower panel will provide a way to search and select individual records.<br /><br />Please indicate what kind of changes you would like to make in the dropdownbox to make to the left."></asp:Label>
                    <asp:Label ID="helperStateBox" class="Text DisplayNone" runat="server" Text="A State level change includes official retention schedule changes published by the NCDCR. No changes to this scope should be made unless published via new schedule releases or schedule updates at <a href=“http://www.ncdcr.gov/archives/ForGovernment/RetentionSchedules/LocalSchedules.aspx”>NCDCR Local Government Retention Schedules</a>.<br /><br /> Please select Series or Schedule/Standard change in the dropdownbox to the left."></asp:Label>
                    <asp:Label ID="helperCountyBox" class="Text DisplayNone" runat="server" Text="A County level change includes assignment of State retention series to policy groups that share the same related retention requirements, or changes to the department/division/policy group structure of the database. <br /><br /> Please select Department/Division/PolicyGroup or Policy change in the dropdownbox to the left."></asp:Label>
                    <asp:Label ID="helperStateChoice" class="Text DisplayNone" runat="server" Text="A State level change includes official retention schedule changes published by the NCDCR. No changes to this scope should be made unless published via new schedule releases or schedule updates at <a href=“http://www.ncdcr.gov/archives/ForGovernment/RetentionSchedules/LocalSchedules.aspx”>NCDCR Local Government Retention Schedules</a>.<br /><br /> Please select Series or Schedule/Standard change in the dropdownbox to the left."></asp:Label>
                    <asp:Label ID="helperCountyChoice" class="Text DisplayNone" runat="server" Text="A County level change includes assignment of State retention series to policy groups that share the same related retention requirements, or changes to the department/division/policy group structure of the database. <br /><br /> Please select Department/Division/PolicyGroup or Policy change in the dropdownbox to the left."></asp:Label>
                    <asp:Label ID="helperScheduleStandard" class="Text DisplayNone" runat="server" Text="Updates to the [Schedule] and [Standard] tables in the database are not permitted through the Admin Tool. Updates to these scopes will be extremely infrequent and will result in significant child table updates. Changes in this scope will require record manipulation by database administrator "></asp:Label>
                    <asp:Label ID="helperSeries" class="Text DisplayNone" runat="server" Text="From this page, you can browse current and inactive local government retention schedules that apply to Wake County. To edit a series policy, you must find and select that series record in the lower left panel. You can insert a new retention series or edit an existing retention series in the lower right panel. Note: While in the “edit” function, you can enable the ‘Deactivate Old, Insert New, Update Child’ checkbox. This function is available for quick/simple updates for individual series published by the state. As a practice, no policy should ever be deleted from the database, only updated to ‘Inactive’ status and replaced with new policy language. Editing without the ‘Deactivate…’ checkbox is for minor, non-fundamental administrative corrections only. Using the ‘Deactivate…’ function will update all related child-records in the [policy] table to the newly inserted SeriesUID. This change is difficult to reverse, and care should be taken when using this function. Reversals will require either a rollback of the database, or record manipulation by database administrator."></asp:Label>
                    <asp:Label ID="helperPolicy" class="Text DisplayNone" runat="server" Text="From this page, you can browse current and inactive assigned policies by department in Wake County. In practice, no policy should ever be deleted. Even if a given policy does not directly apply to a given department (i.e. GIS records in the Finance department) legally the state's published schedule still applies to them. If a record is deactivated, a replacement policy should be inserted to preserve this view. The Edit policy option is for minor, non-fundamental administrative corrections only. Changes to departmental notes should always use the 'deactivate' option first. Assigning all schedule series to a new policy group is not possible through this tool and will require direct record manipulation by database administrator."></asp:Label>
                    <asp:Label ID="helperDepartment" class="Text DisplayNone" runat="server" Text="From this page, you can browse Wake County Departments, Divisions, and Policy Groups. A policy group is typically all division members of a department, but some divisions will prefer to customize divisional policy notes (i.e. 'The budget office retains X records for longer than state requirements. Destroy records after 5 years.'). Divisions and Departments are given unique ids that correspond with designated business ids at Wake County. Changes to Wake County id conventions can and should be updated on an as-needed basis. Changing a division's policy group will immediatly share the policies of that policy group with that division's view of the database. Assigning all schedule series to a new policy group is not possible through this tool and will require direct record manipulation by database administrator."></asp:Label>
                    </div>     
                </td>
            </tr>
            <tr>
               <td class="Schedule" style="width: 700px; padding: 20px">
                <div id="editDepartment" class="DisplayNone" runat="server">
                <div class="HeadText1">Department: View Navigator </div><asp:Button CssClass="DisplayNone" ID="revealfiltersDepartment" runat="server" Text="Open Filter Control" OnClick="revealfiltersDepartment_Click" class="Text" /><asp:Button CssClass="Display" ID="hidefiltersDepartment" runat="server" Text="Hide Filter Control" OnClick="hidefiltersDepartment_Click" class="Text" />      
                <div style="width: 600px; height: 700px; overflow-y: scroll; overflow-x: scroll;">
                        <div id="FilterControlDepartment" class="Display" runat="server">
                        <div class="HeadText2">Narrow Results by Department</div>
                        <asp:DropDownList ID="ddlDepartmentNarrow" runat="server" CssClass="Text" AutoPostBack="true" CausesValidation="true" >
                            <asp:listitem text="--All Selected--" value="Select All" />
                        </asp:DropDownList>
                        </div>
                        <div id="DataGridViewDepartment" class="Display" runat="server">
                            <asp:GridView ID="policiesGridDepartment" runat="server" CssClass="Grid" AutoGenerateColumns="False" CellPadding="4" DataSourceID="SqlDataRecordsDivision" ForeColor="#333333" EnableViewState="False" AllowPaging="True" PageSize="30" DataKeyNames="DivisionUID,DepartmentUID,PolicyGroupUID" OnSelectedIndexChanged="policiesGridDepartment_SelectedIndexChanged">
                                <Columns>
                                    <asp:CommandField ShowSelectButton="True" ItemStyle-BackColor="#0A152B" ItemStyle-ForeColor="#ffffff" ControlStyle-CssClass="HeadText2" ItemStyle-CssClass="Header" HeaderStyle-BackColor="#0A152B" />
                                    <asp:BoundField DataField="DepartmentUID" HeaderText="DepartmentUID" SortExpression="DepartmentUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DepartmentName" HeaderText="DepartmentName" SortExpression="DepartmentName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DivisionUID" HeaderText="DivisionUID" SortExpression="DivisionUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                   <asp:BoundField DataField="DivisionName" HeaderText="DivisionName" SortExpression="DivisionName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PolicyGroupUID" HeaderText="PolicyGroupUID" SortExpression="PolicyGroupUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PolicyGroupName" HeaderText="PolicyGroupName" SortExpression="PolicyGroupName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="Text Policy Grid"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                                <HeaderStyle CssClass="HeadText2 Header Grid" />
                            <PagerStyle ForeColor="#ffffff" BackColor="#0A152B" />
                            <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" Position="TopAndBottom" PreviousPageText="Previous" />
                            </asp:GridView>
                        </div>
                        <div runat="server" id="DataDetailViewDepartment" class="DisplayNone">
                            <asp:DetailsView ID="DetailsViewDivision" runat="server" Height="60px" Width="640px" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DetailsViewDivision_ItemCommand" EnableViewState="False" AutoGenerateRows="False" DataSourceID="SqlDataDetailDivision">
                                <CommandRowStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                                <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                                <Fields>
                                    <asp:ButtonField ButtonType="Button" CommandName="ReturnCommand" Text="Return to All Records" />
                                    <asp:BoundField DataField="DepartmentUID" HeaderText="DepartmentUID" SortExpression="DepartmentUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DepartmentName" HeaderText="DepartmentName" SortExpression="DepartmentName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DivisionUID" HeaderText="DivisionUID" SortExpression="DivisionUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DivisionName" HeaderText="DivisionName" SortExpression="DivisionName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PolicyGroupUID" HeaderText="PolicyGroupUID" SortExpression="PolicyGroupUID" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PolicyGroupName" HeaderText="PolicyGroupName" SortExpression="PolicyGroupName" >
                                        <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                        <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                                    </asp:BoundField>
                                </Fields>
                            </asp:DetailsView>
                        <asp:Label ID="policyGroupScope2" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                </div>
                <div id="editSeries" class="DisplayNone" runat="server">
                <div class="HeadText1">Series: User View Navigator </div><asp:Button CssClass="DisplayNone" ID="revealfiltersSeries" runat="server" Text="Open Filter Control" OnClick="revealfiltersSeries_Click" class="Text" /><asp:Button CssClass="Display" ID="hidefiltersSeries" runat="server" Text="Hide Filter Control" OnClick="hidefiltersSeries_Click" class="Text" />
                <div id="FilterControlSeries" class="Display" runat="server">
                    <table class="Text" border="0" style="height: 200px">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlScheduleSeries" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlScheduleSeries_SelectedIndexChanged" CausesValidation="True" class="Text">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlStandardSeries" runat="server" Width="300px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <b>Text Search </b>
                                    <asp:TextBox ID="filter1termSeries" runat="server" Width="200px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:TextBox><br />
                                    <asp:CheckBox ID="filter1wholeSeries" runat="server" Text="Whole Word/Phrase" AutoPostBack="True" CausesValidation="True" class="Text" />
                                    <asp:RegularExpressionValidator ID="filter1punctuationvalidatorSeries" runat="server" ControlToValidate="filter1termSeries" Display="Dynamic" ErrorMessage="Remove punctuation; " ValidationExpression="[0-9A-Za-z\s]+" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="filter1lengthvalidatorSeries" runat="server" ErrorMessage="30 character limit; " Display="Dynamic" ControlToValidate="filter1termSeries" ValidationExpression="^[\s\S]{0,30}$" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="activeSeries" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                                        <asp:ListItem Value="yes">Active Records Only</asp:ListItem>
                                        <asp:ListItem Value="no">Inactive Records Only</asp:ListItem>
                                        <asp:ListItem Selected="True" Value="both">All Records</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="flagSeries" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                                        <asp:ListItem Selected="True" Value="both">All Records</asp:ListItem>
                                        <asp:ListItem Value="yes">Flagged Records Only</asp:ListItem>
                                        <asp:ListItem Value="no">Non-Flagged Records Only</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Active On:</b> (mm/dd/yyyy) 
                                    <asp:TextBox ID="activedateSeries" runat="server" Width="100px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Date; " Display="Dynamic" ControlToValidate="activedateSeries" ValidationExpression="^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                        </table>
                    <hr />
                    </div>
                    <div style="width: 600px; height: 700px; overflow-y: scroll; overflow-x: scroll;">
                        <div id="DataGridViewSeries" class="Display" runat="server">
    
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
            <asp:BoundField DataField="ScheduleIsActive" HeaderText="Schedule Is Active" >
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
        </Columns>
        <HeaderStyle CssClass="HeadText2 Header Grid" />
        <PagerStyle ForeColor="#ffffff" BackColor="#0A152B" />
        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" Position="TopAndBottom" PreviousPageText="Previous" />
        </asp:GridView>
    </div>
    <div id="DataDetailView" class="DisplayNone" runat="server">
        
        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="ScheduleUID,StandardUID,SeriesUID" DataSourceID="SqlDataDetail" Height="60px" Width="640px" CellPadding="4" OnItemCommand="DetailsView1_ItemCommand" EnableViewState="False" OnDataBound="DetailsView1_DataBound" >
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
            <asp:BoundField DataField="ScheduleIsActive" HeaderText="Schedule Is Active" >
                <HeaderStyle CssClass="HeadText2 Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                <ItemStyle CssClass="Text Schedule Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
            </asp:BoundField>
            <asp:TemplateField ><ItemTemplate>Standard Information</ItemTemplate>
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
            <asp:TemplateField ><ItemTemplate>Series Information</ItemTemplate>
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
            </Fields>
        </asp:DetailsView>
        
    </div>

                        </div>
            

                    </div>


                <div id="editPolicy" class="DisplayNone" runat="server">
                <div class="HeadText1">Policies: User View Navigator </div><asp:Button CssClass="DisplayNone" ID="revealfiltersPolicy" runat="server" Text="Open Filter Control" OnClick="revealfiltersPolicy_Click" class="Text" /><asp:Button CssClass="Display" ID="hidefiltersPolicy" runat="server" Text="Hide Filter Control" OnClick="hidefiltersPolicy_Click" class="Text" />
                <div id="FilterControlPolicy" class="Display" runat="server">
                    <table class="Text" border="0" style="height: 200px">
                            <tr>
                                <td style="width: 300px" >
                                    <asp:DropDownList ID="ddlPolicyGroupPolicy" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlPolicyGroupPolicy_SelectedIndexChanged" CausesValidation="True" class="Text">
                                    </asp:DropDownList>
                                </td>
                                <td rowspan="9"  style="width: 250px; vertical-align: top;" >
                                <div style="height: 200px; overflow-y:scroll;" >
                                    <asp:Label ID="DataScopePolicy" runat="server"></asp:Label>
                                </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlSchedulePolicy" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlSchedulePolicy_SelectedIndexChanged" CausesValidation="True" class="Text"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlStandardPolicy" runat="server" Width="300px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <b>Text Search </b>
                                    <asp:TextBox ID="filter1termPolicy" runat="server" Width="200px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:TextBox><br />
                                    <asp:CheckBox ID="filter1wholePolicy" runat="server" Text="Whole Word/Phrase" AutoPostBack="True" CausesValidation="True" class="Text" />
                                    <asp:RegularExpressionValidator ID="filter1punctuationvalidatorPolicy" runat="server" ControlToValidate="filter1termPolicy" Display="Dynamic" ErrorMessage="Remove punctuation; " ValidationExpression="[0-9A-Za-z\s]+" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="filter1lengthvalidatorPolicy" runat="server" ErrorMessage="30 character limit; " Display="Dynamic" ControlToValidate="filter1termPolicy" ValidationExpression="^[\s\S]{0,30}$" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="activePolicy" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                                        <asp:ListItem Value="yes">Active Records Only</asp:ListItem>
                                        <asp:ListItem Value="no">Inactive Records Only</asp:ListItem>
                                        <asp:ListItem Selected="True" Value="both">All Records</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="flagPolicy" runat="server" AutoPostBack="True" CausesValidation="True" class="Text">
                                        <asp:ListItem Selected="True" Value="both">All Records</asp:ListItem>
                                        <asp:ListItem Value="yes">Flagged Records Only</asp:ListItem>
                                        <asp:ListItem Value="no">Non-Flagged Records Only</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Active On:</b> (mm/dd/yyyy) 
                                    <asp:TextBox ID="activedatePolicy" runat="server" Width="100px" AutoPostBack="True" CausesValidation="True" class="Text"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="datevalidator" runat="server" ErrorMessage="Invalid Date; " Display="Dynamic" ControlToValidate="activedatePolicy" ValidationExpression="^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$" Font-Bold="True" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                        </table>
                    <hr />
                    </div>
                    <div style="width: 600px; height: 700px; overflow-y: scroll; overflow-x: scroll;">
                        <div id="DataGridViewPolicy" class="Display" runat="server">
                            <asp:GridView ID="policiesGridPolicy" runat="server" CssClass="Grid" AutoGenerateColumns="False" CellPadding="4" DataSourceID="SqlDataRecordsPolicy" ForeColor="#333333" GridLines="Both" EnableViewState="False" OnRowDataBound="policiesGridPolicy_RowDataBound" AllowPaging="True" PageSize="30" DataKeyNames="SeriesUID" OnSelectedIndexChanged="policiesGridPolicy_SelectedIndexChanged">
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
                            <div id="DataDetailViewPolicy" class="DisplayNone" runat="server">
                                <asp:DetailsView ID="DetailsView1Policy" runat="server" AutoGenerateRows="False" DataKeyNames="ScheduleUID,StandardUID,SeriesUID" DataSourceID="SqlDataDetailPolicy" Height="60px" Width="640px" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DetailsView1Policy_ItemCommand" EnableViewState="False" OnDataBound="DetailsView1Policy_DataBound" >
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
                    </div>
                </div>






            </td>
            <td class="Schedule" style="vertical-align: top; padding: 20px">
                <div id="PolicyTableEdit" class="DisplayNone" runat="server">
                <div class="HeadText2">
                        Policy Table<br /></div>
                <asp:DetailsView ID="DetailsPolicyTableEdit" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataPolicyTableEdit" Height="60px" Width="490px" CellPadding="4" EnableViewState="False" DataKeyNames="PolicyUID" OnDataBound="DetailsPolicyTableEdit_DataBound" OnItemCommand="DetailsPolicyTableEdit_ItemCommand" OnItemInserted="DetailsPolicyTableEdit_ItemInserted" OnItemUpdated="DetailsPolicyTableEdit_ItemUpdated" >
                        <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                        <CommandRowStyle CssClass="Header HeadText2 Grid" />
                        <Fields>
                        <asp:BoundField DataField="PolicyUID" HeaderText="Policy UID" InsertVisible="False" ReadOnly="True" SortExpression="PolicyUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="SeriesUID" HeaderText="Series UID" SortExpression="SeriesUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyGroupUID" HeaderText="Policy Group UID" SortExpression="PolicyGroupUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyDivisionNote" HeaderText="Policy Division Note" SortExpression="PolicyDivisionNote">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyIsActive" HeaderText="Policy Is Active" InsertVisible="False" SortExpression="PolicyIsActive">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyActiveFrom" InsertVisible="False" HeaderText="Policy Active From" SortExpression="PolicyActiveFrom">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyActiveTo" InsertVisible="False" HeaderText="Policy Active To" SortExpression="PolicyActiveTo">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyRevisionFlag" HeaderText="Policy Revision Flag" SortExpression="PolicyRevisionFlag">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="Header">
                                <EditItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="New" Text="New"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Delete" Text="Deactivate" OnClientClick="return confirm('WARNING: Please Create an Active version of this SeriesUID, PolicyGroupUID immediately after deactivation (Please Record these numbers now)')"></asp:LinkButton>
                                </ItemTemplate>
                                <ControlStyle CssClass="HeadText2" ForeColor="White" />
                            </asp:TemplateField>
                   </Fields>
                   </asp:DetailsView>
                </div>
                <div runat="server" id="SeriesTableEdit" class="DisplayNone">
                    <div class="HeadText2">
                        Series Table<br /></div>
                    <asp:DetailsView ID="DetailsSeriesTableEdit" runat="server" DataSourceID="SqlDataSeriesTableEdit" AutoGenerateRows="False" Height="60px" Width="490px" CellPadding="4" EnableViewState="False" DataKeyNames="SeriesUID" OnDataBound="DetailsSeriesTableEdit_DataBound" OnItemUpdating="DetailsSeriesTableEdit_ItemUpdating" OnItemCommand="DetailsSeriesTableEdit_ItemCommand" OnItemInserted="DetailsSeriesTableEdit_ItemInserted" OnItemUpdated="DetailsSeriesTableEdit_ItemUpdated">
                        <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                        <CommandRowStyle CssClass="Header HeadText2 Grid" ForeColor="White" />
                        <Fields>
                            <asp:BoundField DataField="SeriesUID" HeaderText="SeriesUID" ReadOnly="true" InsertVisible="False" SortExpression="SeriesUID">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="StandardUID" HeaderText="StandardUID" SortExpression="StandardUID">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesID" HeaderText="SeriesID" SortExpression="SeriesID">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesName" HeaderText="SeriesName" SortExpression="SeriesName">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesDescription" HeaderText="SeriesDescription" SortExpression="SeriesDescription">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesDispositionInstructions" HeaderText="SeriesDispositionInstructions" SortExpression="SeriesDispositionInstructions">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesRelevantStatutes" HeaderText="SeriesRelevantStatutes" SortExpression="SeriesRelevantStatutes">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesIsActive" HeaderText="SeriesIsActive" InsertVisible="False" SortExpression="SeriesIsActive">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesActiveFrom" HeaderText="SeriesActiveFrom" InsertVisible="False" SortExpression="SeriesActiveFrom">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesActiveTo" HeaderText="SeriesActiveTo" InsertVisible="False" SortExpression="SeriesActiveTo">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="SeriesRevisionFlag" HeaderText="SeriesRevisionFlag" SortExpression="SeriesRevisionFlag">
                                <HeaderStyle CssClass="HeadText2 Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                                <ItemStyle CssClass="Text Series Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="Header">
                                <EditItemTemplate>
                                    <asp:CheckBox runat="server" ID="deactivate"  ToolTip="Check to Deactivate Current, Insert New, and Update Child Records" Text="Deactivate Old, Insert New, Update Child" />
                                    <br />
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Update" OnClientClick="return confirm('WARNING: If you have clicked the -deactivate- checkbox below, the old series record will be deactivated, a new series record will be created, and a script will be run to update all policy records to match the new series record SeriesUID')"></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert"></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="New" Text="New"></asp:LinkButton>
                                </ItemTemplate>
                            <ControlStyle CssClass="HeadText2" ForeColor="White" />
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>

                </div>
                <div runat="server" id="departmentTablesEdit" class="DisplayNone">
                <div class="HeadText2">
                Department Table<br />
                <asp:DetailsView ID="DepartmentTableEdit" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataDepartmentTableEdit" Height="60px" Width="490px" CellPadding="4" EnableViewState="False" OnDataBound="DepartmentTableEdit_DataBound" OnItemUpdating="DepartmentTableEdit_ItemUpdating" OnItemCommand="DepartmentTableEdit_ItemCommand" OnItemInserted="DepartmentTableEdit_ItemInserted" OnItemUpdated="DepartmentTableEdit_ItemUpdated" >
                    <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                    <CommandRowStyle CssClass="Header HeadText2 Grid" ForeColor="White" />
                        <Fields>
                        <asp:BoundField DataField="DepartmentName" HeaderText="DepartmentName" SortExpression="DepartmentName">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="departmentUID" HeaderText="DepartmentUID" SortExpression="DepartmentUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="Header">
                    <EditItemTemplate>
                    <asp:LinkButton runat="server" Text="Update" CommandName="Update" CausesValidation="True" ID="LinkButton1" OnClientClick="return confirm('Note: Changes to DepartmentUID key will update child records in [division] table')"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" CausesValidation="True" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" CausesValidation="False" ID="LinkButton1" ></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </ItemTemplate>
                    <ControlStyle CssClass="HeadText2" ForeColor="White" />
                    </asp:TemplateField>
                    </Fields>
                </asp:DetailsView><br />
                Policy Group Table<br />
                <asp:DetailsView ID="PolicyGroupTableEdit" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataPolicyGroupTableEdit" Height="60px" Width="490px" CellPadding="4" EnableViewState="False" DataKeyNames="PolicyGroupUID" OnDataBound="PolicyGroupTableEdit_DataBound" OnItemCommand="PolicyGroupTableEdit_ItemCommand" OnItemInserted="PolicyGroupTableEdit_ItemInserted" OnItemUpdated="PolicyGroupTableEdit_ItemUpdated">
                    <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                    <CommandRowStyle CssClass="Header HeadText2 Grid" ForeColor="White" />
                    <Fields>
                        <asp:BoundField DataField="PolicyGroupUID" HeaderText="PolicyGroupUID" InsertVisible="False" ReadOnly="True" SortExpression="PolicyGroupUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyGroupName" HeaderText="PolicyGroupName" SortExpression="PolicyGroupName">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="Header">
                    <EditItemTemplate>
                    <asp:LinkButton runat="server" Text="Update" CommandName="Update" CausesValidation="True" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" CausesValidation="True" ID="LinkButton1" OnClientClick="return confirm('Note: Creation of a division assignment to a new PolicyGroupUID will still require database administration to assign a copy of all currently active series of a schedule to the PolicyGroupUID in [policy] table.')"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" CausesValidation="False" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" CausesValidation="False" ID="LinkButton2" ></asp:LinkButton>
                    </ItemTemplate>
                    <ControlStyle CssClass="HeadText2" ForeColor="White" />
                    </asp:TemplateField>
                    </Fields>
                </asp:DetailsView><br />
                Division Table<br />
                <asp:DetailsView ID="DivisionTableEdit" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataDivisionTableEdit" Height="60px" Width="490px" CellPadding="4" EnableViewState="False" DataKeyNames="DivisionUID" OnDataBound="DivisionTableEdit_DataBound" OnItemCommand="DivisionTableEdit_ItemCommand" OnItemInserted="DivisionTableEdit_ItemInserted" OnItemUpdated="DivisionTableEdit_ItemUpdated">
                    <FieldHeaderStyle BorderColor="#ffffff" BackColor="#0A152B" Font-Bold="True" ForeColor="#ffffff" />
                    <CommandRowStyle CssClass="Header HeadText2 Grid" ForeColor="White" />
                    <Fields>
                        <asp:BoundField DataField="DivisionName" HeaderText="DivisionName" SortExpression="DivisionName">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="DepartmentUID" HeaderText="DepartmentUID" SortExpression="DepartmentUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="PolicyGroupUID" HeaderText="PolicyGroupUID" SortExpression="PolicyGroupUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="DivisionUID" HeaderText="DivisionUID" SortExpression="DivisionUID">
                            <HeaderStyle CssClass="HeadText2 Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></HeaderStyle>
                            <ItemStyle CssClass="Text Policy Grid" HorizontalAlign="Center" VerticalAlign="Middle" ></ItemStyle>
                        </asp:BoundField>
                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="Header">
                        <EditItemTemplate>
                        <asp:LinkButton runat="server" Text="Update" CommandName="Update" CausesValidation="True" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                        <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" CausesValidation="True" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                        </InsertItemTemplate>
                        <ItemTemplate>
                        <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" CausesValidation="False" ID="LinkButton1"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                        </ItemTemplate>
                        <ControlStyle CssClass="HeadText2" ForeColor="White" />
                        </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView><br />
                </div>
                </div>

            </td>
        </tr>
    </table>             
    </form>
</body>
</html>