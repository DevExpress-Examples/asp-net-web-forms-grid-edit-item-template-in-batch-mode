<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v22.1, Version=22.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function Grid_BatchEditStartEditing(s, e) {
            var templateColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(templateColumn.index))
                return;
            var cellInfo = e.rowValues[templateColumn.index];
            C1spinEdit.SetValue(cellInfo.value);
            if (e.focusedColumn === templateColumn)
                C1spinEdit.Focus();
        }
        function Grid_BatchEditEndEditing(s, e) {
            var templateColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(templateColumn.index))
                return;
            var cellInfo = e.rowValues[templateColumn.index];
            cellInfo.value = C1spinEdit.GetValue();
            cellInfo.text = C1spinEdit.GetText();
            C1spinEdit.SetValue(null);
        }
        function Grid_BatchEditRowValidating(s, e) {
            var templateColumn = s.GetColumnByField("C1");
            var cellValidationInfo = e.validationInfo[templateColumn.index];
            if (!cellValidationInfo) return;
            var value = cellValidationInfo.value;
            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) === "") {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = "C1 is required";
            }
        }

        var preventEndEditOnLostFocus = false;
        function C1spinEdit_KeyDown(s, e) {
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode === ASPx.Key.Esc) {
                var cellInfo = grid.batchEditApi.GetEditCellInfo();
                window.setTimeout(function () {
                    grid.SetFocusedCell(cellInfo.rowVisibleIndex, cellInfo.column.index);
                }, 0);
                s.GetInputElement().blur();
                return;
            }
            if (keyCode !== ASPx.Key.Tab && keyCode !== ASPx.Key.Enter) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (grid.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                preventEndEditOnLostFocus = true;
            }
        }
        function C1spinEdit_LostFocus(s, e) {
            if (!preventEndEditOnLostFocus)
                grid.batchEditApi.EndEdit();
            preventEndEditOnLostFocus = false;
        }

    </script>

</head>
<body>
    <form id="frmMain" runat="server">
        <dx:ASPxGridView ID="Grid" runat="server" KeyFieldName="ID" Width="600" OnBatchUpdate="Grid_BatchUpdate" 
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting" ClientInstanceName="grid" Theme="Office365">
            <ClientSideEvents BatchEditStartEditing="Grid_BatchEditStartEditing" BatchEditEndEditing="Grid_BatchEditEndEditing"
                BatchEditRowValidating="Grid_BatchEditRowValidating" />
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" Width="100" ShowDeleteButton="true" />
                <dx:GridViewDataColumn Width="100" FieldName="C1">
                    <EditItemTemplate>
                        <dx:ASPxSpinEdit ID="C1_spinEdit" runat="server" ClientInstanceName="C1spinEdit" Width="100%">
                            <ClientSideEvents KeyDown="C1spinEdit_KeyDown" LostFocus="C1spinEdit_LostFocus" />
                        </dx:ASPxSpinEdit>
                    </EditItemTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataSpinEditColumn Width="100" FieldName="C2" />
                <dx:GridViewDataTextColumn Width="100" FieldName="C3" />
                <dx:GridViewDataCheckColumn Width="100" FieldName="C4" />
                <dx:GridViewDataDateColumn Width="100" FieldName="C5" />
            </Columns>
            <SettingsPager PageSize="3" />
            <SettingsEditing Mode="Batch" />
        </dx:ASPxGridView>

    </form>
</body>
</html>
