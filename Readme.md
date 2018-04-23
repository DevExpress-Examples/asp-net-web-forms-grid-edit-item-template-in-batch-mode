# ASPxGridView - Batch Editing - A simple implementation of an EditItemTemplate


<p>This example demonstrates how to create a custom editor inside a column's EdittemTemplate when ASPxGridView is in Batch Edit mode. Since ASPxGridView performs batch editing on the client side, we cannot process or pass values from editors placed inside templates on the server side. Thus, all processing will be performed on the client side. </p>
<p><br>You can implement the EditItem template for a column by performing the following steps:<br><br>1. Specify a column's EditItemTemplate:</p>


```aspx
<dx:GridViewDataColumn FieldName="C1">
     <EditItemTemplate>
          <dx:ASPxSpinEdit ID="C1_spinEdit" runat="server" ClientInstanceName="C1spinEdit" Width="100%">
          </dx:ASPxSpinEdit>
     </EditItemTemplate>
</dx:GridViewDataColumn>

```


<p> </p>
<p>2. Handle the grid's client-side <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_BatchEditStartEditingtopic">BatchEditStartEditing</a> event to set the grid's cell values to the editor. It is possible to get the focused cell value using the <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridViewBatchEditStartEditingEventArgs_rowValuestopic">e.rowValues</a> property:</p>


```js
       function Grid_BatchEditStartEditing(s, e) {
            var templateColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(templateColumn.index))
                return;
            var cellInfo = e.rowValues[templateColumn.index];
            C1spinEdit.SetValue(cellInfo.value);
            if (e.focusedColumn === templateColumn)
                C1spinEdit.SetFocus();
        }

```


<p> </p>
<p>3. Handle the <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_BatchEditEndEditingtopic">BatchEditEndEditing</a> event to pass a value entered in the editor to the grid's cell:</p>


```js
        function Grid_BatchEditEndEditing(s, e) {
            var templateColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(templateColumn.index))
                return;
            var cellInfo = e.rowValues[templateColumn.index];
            cellInfo.value = C1spinEdit.GetValue();
            cellInfo.text = C1spinEdit.GetText();
            C1spinEdit.SetValue(null);
        }

```


<p> </p>
<p>4. The <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_BatchEditRowValidatingtopic">BatchEditRowValidating</a> event allows validating the grid's cell based on the entered value:</p>


```js
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

```


<p> </p>
<p>5. Finally, handle the editor's client-side <a href="https://documentation.devexpress.com/AspNet/DevExpressWebASPxEditorsScriptsASPxClientTextEdit_KeyDowntopic.aspx">KeyDown</a> and <a href="https://documentation.devexpress.com/AspNet/DevExpressWebASPxEditorsScriptsASPxClientEdit_LostFocustopic.aspx">LostFocus</a> events to emulate the behavior of standard grid editors when an end-user uses a keyboard or mouse:</p>


```js
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

```


<p> </p>
<p><strong>See Also:<br></strong><a href="https://www.devexpress.com/Support/Center/p/T115130">GridView - Batch Editing - A simple implementation of an EditItem template</a> </p>

<br/>


