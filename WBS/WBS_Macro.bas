Attribute VB_Name = "WBS_Macro"
Option Explicit

Private Const WBS_SHEET As String = "WBS"
Private Const HOLIDAY_SHEET As String = "休日"
Private Const SETTINGS_SHEET As String = "設定"
Private Const FIRST_TASK_ROW As Long = 6
Private Const LAST_TASK_ROW As Long = 105
Private Const FIRST_DATE_COL As Long = 18
Private Const LAST_DATE_COL As Long = 383

Public Sub RefreshWBS()
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    On Error GoTo CleanFail

    CalculateSchedule
    UpdateCalendarHeaders
    DrawLightningLine
    Worksheets(SETTINGS_SHEET).Calculate
    Worksheets(WBS_SHEET).Calculate
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    MsgBox "WBSを再計算しました。予定・実績・カミナリ戦を確認してください。", vbInformation
    Exit Sub

CleanFail:
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    MsgBox "再計算中にエラーが発生しました: " & Err.Description, vbExclamation
End Sub

Public Sub InputWBSRow()
    Dim ws As Worksheet
    Dim targetRow As Long
    Dim taskName As String, owner As String, taskType As String
    Dim startText As String, durationText As String, progressText As String
    Dim predecessor As String, note As String

    Set ws = Worksheets(WBS_SHEET)
    targetRow = ActiveCell.Row
    If targetRow < FIRST_TASK_ROW Or targetRow > LAST_TASK_ROW Then
        targetRow = FirstEmptyTaskRow(ws)
    End If

    taskName = InputBox("タスク名を入力してください。", "WBS入力", CStr(ws.Cells(targetRow, 3).Value))
    If Len(taskName) = 0 Then Exit Sub
    owner = InputBox("担当者を入力してください。", "WBS入力", CStr(ws.Cells(targetRow, 4).Value))
    taskType = InputBox("種別を入力してください（フェーズ / タスク / マイルストーン）。", "WBS入力", CStr(ws.Cells(targetRow, 5).Value))
    If Len(taskType) = 0 Then taskType = "タスク"
    startText = InputBox("予定開始日を入力してください（yyyy/m/d）。", "WBS入力", Format$(ws.Cells(targetRow, 6).Value, "yyyy/m/d"))
    durationText = InputBox("予定日数を入力してください。", "WBS入力", CStr(ws.Cells(targetRow, 7).Value))
    progressText = InputBox("進捗率を0から100の数値で入力してください。", "WBS入力", CStr(ws.Cells(targetRow, 11).Value * 100))
    predecessor = InputBox("先行IDを入力してください（任意）。", "WBS入力", CStr(ws.Cells(targetRow, 12).Value))
    note = InputBox("備考を入力してください（任意）。", "WBS入力", CStr(ws.Cells(targetRow, 16).Value))

    If IsDate(startText) Then ws.Cells(targetRow, 6).Value = CDate(startText)
    If IsNumeric(durationText) Then ws.Cells(targetRow, 7).Value = CDbl(durationText)
    If IsNumeric(progressText) Then ws.Cells(targetRow, 11).Value = WorksheetFunction.Min(100, WorksheetFunction.Max(0, CDbl(progressText))) / 100
    ws.Cells(targetRow, 3).Value = taskName
    ws.Cells(targetRow, 4).Value = owner
    ws.Cells(targetRow, 5).Value = taskType
    ws.Cells(targetRow, 12).Value = predecessor
    ws.Cells(targetRow, 16).Value = note
    RefreshWBS
End Sub

Public Sub SetProjectPeriod()
    Dim startText As String, endText As String
    startText = InputBox("プロジェクト開始月を入力してください（yyyy/m）。", "プロジェクト期間", Format$(Worksheets(SETTINGS_SHEET).Range("B4").Value, "yyyy/m"))
    If Len(startText) = 0 Or Not IsDate(startText) Then Exit Sub
    endText = InputBox("プロジェクト終了月を入力してください（yyyy/m）。", "プロジェクト期間", Format$(Worksheets(SETTINGS_SHEET).Range("B5").Value, "yyyy/m"))
    If Len(endText) = 0 Or Not IsDate(endText) Then Exit Sub
    If DateSerial(Year(CDate(endText)), Month(CDate(endText)), 1) < DateSerial(Year(CDate(startText)), Month(CDate(startText)), 1) Then
        MsgBox "終了月は開始月以降を指定してください。", vbExclamation
        Exit Sub
    End If
    Worksheets(SETTINGS_SHEET).Range("B4").Value = DateSerial(Year(CDate(startText)), Month(CDate(startText)), 1)
    Worksheets(SETTINGS_SHEET).Range("B5").Value = DateSerial(Year(CDate(endText)), Month(CDate(endText)), 1)
    UpdateCalendarHeaders
    Worksheets(WBS_SHEET).Calculate
    DrawLightningLine
    MsgBox "ガントチャートの表示期間を更新しました。", vbInformation
End Sub

Public Sub UpdateCalendarHeaders()
    Dim ws As Worksheet, startMonth As Date, endMonth As Date
    Dim currentDate As Date, col As Long
    Set ws = Worksheets(WBS_SHEET)
    startMonth = DateSerial(Year(Worksheets(SETTINGS_SHEET).Range("B4").Value), Month(Worksheets(SETTINGS_SHEET).Range("B4").Value), 1)
    endMonth = DateSerial(Year(Worksheets(SETTINGS_SHEET).Range("B5").Value), Month(Worksheets(SETTINGS_SHEET).Range("B5").Value) + 1, 0)
    For col = FIRST_DATE_COL To LAST_DATE_COL
        currentDate = DateAdd("d", col - FIRST_DATE_COL, startMonth)
        If currentDate <= endMonth Then
            ws.Cells(4, col).Value = currentDate
            ws.Cells(5, col).Value = currentDate
        Else
            ws.Cells(4, col).ClearContents
            ws.Cells(5, col).ClearContents
        End If
    Next col
End Sub

Public Sub CalculateSchedule()
    Dim ws As Worksheet
    Dim row As Long, predecessor As String, predecessorRow As Long
    Dim startDate As Variant, duration As Variant, predecessorEnd As Variant
    Set ws = Worksheets(WBS_SHEET)

    For row = FIRST_TASK_ROW To LAST_TASK_ROW
        If Len(ws.Cells(row, 3).Value) > 0 Then
            startDate = ws.Cells(row, 6).Value
            duration = ws.Cells(row, 7).Value
            predecessor = Trim$(CStr(ws.Cells(row, 12).Value))
            If Len(predecessor) > 0 Then
                predecessorRow = FindTaskRow(predecessor)
                If predecessorRow > 0 Then
                    predecessorEnd = ws.Cells(predecessorRow, 8).Value
                    If IsDate(predecessorEnd) And IsDate(startDate) Then
                        If CDate(startDate) <= CDate(predecessorEnd) Then
                            startDate = Application.WorkDay_Intl(CDate(predecessorEnd), 1, 1, HolidayRange())
                            ws.Cells(row, 6).Value = startDate
                        End If
                    ElseIf IsDate(predecessorEnd) And Not IsDate(startDate) Then
                        startDate = Application.WorkDay_Intl(CDate(predecessorEnd), 1, 1, HolidayRange())
                        ws.Cells(row, 6).Value = startDate
                    End If
                End If
            End If
            If IsDate(startDate) And IsNumeric(duration) And duration > 0 Then
                ws.Cells(row, 8).Value = Application.WorkDay_Intl(CDate(startDate), CLng(duration) - 1, 1, HolidayRange())
            End If
        End If
    Next row
End Sub

Public Sub AddWBSRow()
    Dim ws As Worksheet, insertAt As Long
    Set ws = Worksheets(WBS_SHEET)
    insertAt = ActiveCell.Row
    If insertAt < FIRST_TASK_ROW Or insertAt > LAST_TASK_ROW Then insertAt = FIRST_TASK_ROW
    ws.Rows(insertAt).Insert Shift:=xlDown
    ws.Rows(insertAt + 1).Copy
    ws.Rows(insertAt).PasteSpecial Paste:=xlPasteFormats
    ws.Rows(insertAt).PasteSpecial Paste:=xlPasteFormulas
    Application.CutCopyMode = False
    ws.Range(ws.Cells(insertAt, 1), ws.Cells(insertAt, 5)).ClearContents
    ws.Range(ws.Cells(insertAt, 6), ws.Cells(insertAt, 7)).ClearContents
    ws.Range(ws.Cells(insertAt, 9), ws.Cells(insertAt, 12)).ClearContents
    ws.Range(ws.Cells(insertAt, 15), ws.Cells(insertAt, 16)).ClearContents
    MsgBox "入力行を追加しました。黄色のセルに入力してください。", vbInformation
End Sub

Public Sub DrawLightningLine()
    Dim ws As Worksheet, shape As Shape, dateCol As Long, lastCol As Long
    Dim todayValue As Date, col As Long
    Set ws = Worksheets(WBS_SHEET)
    todayValue = Date
    lastCol = ws.Cells(5, ws.Columns.Count).End(xlToLeft).Column
    dateCol = 0
    For col = FIRST_DATE_COL To lastCol
        If IsDate(ws.Cells(5, col).Value) Then
            If CDate(ws.Cells(5, col).Value) = todayValue Then dateCol = col: Exit For
        End If
    Next col
    On Error Resume Next
    ws.Shapes("LightningLine").Delete
    On Error GoTo 0
    If dateCol = 0 Then Exit Sub
    Set shape = ws.Shapes.AddLine(ws.Cells(5, dateCol).Left + ws.Cells(5, dateCol).Width / 2, _
                                  ws.Cells(5, dateCol).Top, _
                                  ws.Cells(LAST_TASK_ROW, dateCol).Left + ws.Cells(LAST_TASK_ROW, dateCol).Width / 2, _
                                  ws.Cells(LAST_TASK_ROW, dateCol).Top + ws.Cells(LAST_TASK_ROW, dateCol).Height)
    shape.Name = "LightningLine"
    shape.Line.ForeColor.RGB = RGB(220, 38, 38)
    shape.Line.Weight = 2.5
    shape.Line.DashStyle = msoLineDash
    shape.Placement = xlMove
End Sub

Public Sub ExportWBSAsPDF()
    Dim path As String
    path = ThisWorkbook.Path & Application.PathSeparator & "開発マイルストーン_WBS.pdf"
    Worksheets(WBS_SHEET).ExportAsFixedFormat Type:=xlTypePDF, Filename:=path, Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, IgnorePrintAreas:=False, OpenAfterPublish:=False
    MsgBox "PDFを出力しました: " & path, vbInformation
End Sub

Private Function FindTaskRow(ByVal taskId As String) As Long
    Dim row As Long
    For row = FIRST_TASK_ROW To LAST_TASK_ROW
        If CStr(Worksheets(WBS_SHEET).Cells(row, 1).Value) = taskId Then
            FindTaskRow = row
            Exit Function
        End If
    Next row
    FindTaskRow = 0
End Function

Private Function FirstEmptyTaskRow(ByVal ws As Worksheet) As Long
    Dim row As Long
    For row = FIRST_TASK_ROW To LAST_TASK_ROW
        If Len(ws.Cells(row, 3).Value) = 0 Then
            FirstEmptyTaskRow = row
            Exit Function
        End If
    Next row
    FirstEmptyTaskRow = FIRST_TASK_ROW
End Function

Private Function HolidayRange() As Range
    Set HolidayRange = Worksheets(HOLIDAY_SHEET).Range("A4:A200")
End Function