Attribute VB_Name = "InputFormHelper"
Option Explicit

Private form As Object
Private selectedRow As Long
Private selectedTaskType As String
Private isCancelled As Boolean

Private WithEvents okButton As MSForms.CommandButton
Private WithEvents cancelButton As MSForms.CommandButton

Private txtTaskName As MSForms.TextBox
Private txtOwner As MSForms.TextBox
Private txtType As MSForms.ComboBox
Private txtStart As MSForms.TextBox
Private txtDuration As MSForms.TextBox
Private txtProgress As MSForms.TextBox
Private txtPredecessor As MSForms.TextBox
Private txtNote As MSForms.TextBox

Public Function ShowForTask(ByVal targetRow As Long, ByVal taskType As String) As Boolean
    Dim ws As Worksheet

    selectedRow = targetRow
    selectedTaskType = taskType
    isCancelled = False
    Set ws = Worksheets("WBS")

    Set form = UserForms.Add("WBSInputForm")
    form.Caption = "WBS���͕⏕"
    form.Width = 440
    form.Height = 380
    form.StartUpPosition = 1

    AddLabel "lblTitle", "WBS���͕⏕", 20, 12, 200, 18
    AddLabel "lblTaskName", "�^�X�N��", 20, 42, 90, 18
    Set txtTaskName = AddTextBox("txtTaskName", 120, 36, 280, 24)
    txtTaskName.Text = CStr(ws.Cells(selectedRow, 3).Value)

    AddLabel "lblOwner", "�S��", 20, 74, 90, 18
    Set txtOwner = AddTextBox("txtOwner", 120, 68, 280, 24)
    txtOwner.Text = CStr(ws.Cells(selectedRow, 4).Value)

    AddLabel "lblType", "���", 20, 106, 90, 18
    Set txtType = AddComboBox("cmbType", 120, 100, 280, 24)
    txtType.AddItem "�t�F�[�Y"
    txtType.AddItem "�^�X�N"
    txtType.AddItem "�}�C���X�g�[��"
    txtType.Text = selectedTaskType
    txtType.Enabled = False

    AddLabel "lblStart", "�J�n��", 20, 138, 90, 18
    Set txtStart = AddTextBox("txtStart", 120, 132, 280, 24)
    If IsDate(ws.Cells(selectedRow, 6).Value) Then
        txtStart.Text = Format$(ws.Cells(selectedRow, 6).Value, "yyyy/m/d")
    End If

    AddLabel "lblDuration", "����", 20, 170, 90, 18
    Set txtDuration = AddTextBox("txtDuration", 120, 164, 280, 24)
    If IsNumeric(ws.Cells(selectedRow, 7).Value) Then
        txtDuration.Text = CStr(ws.Cells(selectedRow, 7).Value)
    End If
    If selectedTaskType = "�}�C���X�g�[��" Then txtDuration.Text = "1"

    AddLabel "lblProgress", "�i����(%)", 20, 202, 90, 18
    Set txtProgress = AddTextBox("txtProgress", 120, 196, 280, 24)
    If IsNumeric(ws.Cells(selectedRow, 11).Value) Then
        txtProgress.Text = Format$(ws.Cells(selectedRow, 11).Value * 100, "0")
    End If
    If selectedTaskType = "�}�C���X�g�[��" Then
        txtProgress.Visible = False
        form.Controls("lblProgress").Visible = False
    End If

    AddLabel "lblPredecessor", "��sID", 20, 234, 90, 18
    Set txtPredecessor = AddTextBox("txtPredecessor", 120, 228, 280, 24)
    txtPredecessor.Text = CStr(ws.Cells(selectedRow, 12).Value)

    AddLabel "lblNote", "���l", 20, 266, 90, 18
    Set txtNote = AddTextBox("txtNote", 120, 260, 280, 54)
    txtNote.MultiLine = True
    txtNote.Text = CStr(ws.Cells(selectedRow, 16).Value)

    Set okButton = AddCommandButton("cmdOK", "���͂���", 210, 330, 90, 26)
    Set cancelButton = AddCommandButton("cmdCancel", "�L�����Z��", 320, 330, 90, 26)

    form.Show

    If isCancelled Then
        Unload form
        Set form = Nothing
        ShowForTask = False
        Exit Function
    End If

    ApplyValues selectedTaskType
    Unload form
    Set form = Nothing
    ShowForTask = True
End Function

Private Function AddLabel(ByVal name As String, ByVal caption As String, ByVal left As Single, ByVal top As Single, ByVal width As Single, ByVal height As Single) As MSForms.Label
    Dim ctrl As MSForms.Label
    Set ctrl = form.Controls.Add("Forms.Label.1", name, True)
    ctrl.Caption = caption
    ctrl.Left = left
    ctrl.Top = top
    ctrl.Width = width
    ctrl.Height = height
    Set AddLabel = ctrl
End Function

Private Function AddTextBox(ByVal name As String, ByVal left As Single, ByVal top As Single, ByVal width As Single, ByVal height As Single) As MSForms.TextBox
    Dim ctrl As MSForms.TextBox
    Set ctrl = form.Controls.Add("Forms.TextBox.1", name, True)
    ctrl.Left = left
    ctrl.Top = top
    ctrl.Width = width
    ctrl.Height = height
    Set AddTextBox = ctrl
End Function

Private Function AddComboBox(ByVal name As String, ByVal left As Single, ByVal top As Single, ByVal width As Single, ByVal height As Single) As MSForms.ComboBox
    Dim ctrl As MSForms.ComboBox
    Set ctrl = form.Controls.Add("Forms.ComboBox.1", name, True)
    ctrl.Left = left
    ctrl.Top = top
    ctrl.Width = width
    ctrl.Height = height
    Set AddComboBox = ctrl
End Function

Private Function AddCommandButton(ByVal name As String, ByVal caption As String, ByVal left As Single, ByVal top As Single, ByVal width As Single, ByVal height As Single) As MSForms.CommandButton
    Dim ctrl As MSForms.CommandButton
    Set ctrl = form.Controls.Add("Forms.CommandButton.1", name, True)
    ctrl.Caption = caption
    ctrl.Left = left
    ctrl.Top = top
    ctrl.Width = width
    ctrl.Height = height
    Set AddCommandButton = ctrl
End Function

Private Sub ApplyValues(ByVal taskType As String)
    Dim ws As Worksheet
    Dim durationValue As Double
    Dim progressValue As Double
    Set ws = Worksheets("WBS")

    ws.Cells(selectedRow, 3).Value = txtTaskName.Text
    ws.Cells(selectedRow, 4).Value = txtOwner.Text
    ws.Cells(selectedRow, 5).Value = txtType.Text

    If Len(Trim$(txtStart.Text)) > 0 And IsDate(txtStart.Text) Then
        ws.Cells(selectedRow, 6).Value = CDate(txtStart.Text)
    End If

    If Len(Trim$(txtDuration.Text)) > 0 And IsNumeric(txtDuration.Text) Then
        durationValue = CDbl(txtDuration.Text)
        If taskType = "�}�C���X�g�[��" And durationValue <= 0 Then durationValue = 1
        ws.Cells(selectedRow, 7).Value = durationValue
    ElseIf taskType = "�}�C���X�g�[��" Then
        ws.Cells(selectedRow, 7).Value = 1
    End If

    If Len(Trim$(txtProgress.Text)) > 0 And IsNumeric(txtProgress.Text) Then
        progressValue = CDbl(txtProgress.Text) / 100
        ws.Cells(selectedRow, 11).Value = WorksheetFunction.Min(100, WorksheetFunction.Max(0, progressValue * 100)) / 100
    End If

    ws.Cells(selectedRow, 12).Value = txtPredecessor.Text
    ws.Cells(selectedRow, 16).Value = txtNote.Text
End Sub

Private Sub okButton_Click()
    If Len(Trim$(txtTaskName.Text)) = 0 Then
        MsgBox "�^�X�N������͂��Ă��������B", vbExclamation
        Exit Sub
    End If
    isCancelled = False
    form.Hide
End Sub

Private Sub cancelButton_Click()
    isCancelled = True
    form.Hide
End Sub
