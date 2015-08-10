<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminlogin.aspx.cs" Inherits="RetentionSchedules.adminlogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>Please enter Admin Passphrase<br /><br />
    <asp:TextBox ID="txtPass" runat="server" TextMode="Password"></asp:TextBox><br/>
    <asp:Button ID="btnSubmit" runat="server" Text="Submit" /><br/><br />
    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label><br/>
    </div>
    </form>
</body>
</html>
