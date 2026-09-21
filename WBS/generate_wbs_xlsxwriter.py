from datetime import date, timedelta
from pathlib import Path

import xlsxwriter

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "開発マイルストーン_WBS.xlsx"
DATE_START = date(2026, 10, 1)
DATE_COUNT = 120
TASK_START = 5
TASK_END = 104
CALENDAR_START_COL = 17


def build_workbook():
    workbook = xlsxwriter.Workbook(OUTPUT)
    workbook.set_properties({
        "title": "開発マイルストーン WBS",
        "subject": "ガントチャート・カミナリ戦・予定実績・休日・マイルストーン",
    })

    wbs = workbook.add_worksheet("WBS")
    settings = workbook.add_worksheet("設定")
    holidays = workbook.add_worksheet("休日")
    summary = workbook.add_worksheet("集計")

    navy = "#17324D"
    blue = "#2B6CB0"
    light_blue = "#DCEBFA"
    light_orange = "#FEF3C7"
    actual_green = "#79C2B8"
    today_red = "#FCA5A5"
    input_yellow = "#FFF9E6"
    grid = "#D7DEE8"

    title = workbook.add_format({"bold": True, "font_size": 20, "font_color": "white", "bg_color": navy, "align": "left", "valign": "vcenter"})
    subtitle = workbook.add_format({"font_color": "#64748B", "italic": True})
    header = workbook.add_format({"bold": True, "font_color": "white", "bg_color": navy, "border": 1, "border_color": grid, "align": "center", "valign": "vcenter", "text_wrap": True})
    calendar_header = workbook.add_format({"bold": True, "font_color": "white", "bg_color": navy, "border": 1, "border_color": grid, "align": "center", "valign": "vcenter", "num_format": "m/d"})
    text = workbook.add_format({"border": 1, "border_color": grid, "valign": "vcenter"})
    input_text = workbook.add_format({"border": 1, "border_color": grid, "bg_color": input_yellow, "valign": "vcenter"})
    date_input = workbook.add_format({"border": 1, "border_color": grid, "bg_color": input_yellow, "num_format": "yyyy/m/d", "valign": "vcenter"})
    date_formula = workbook.add_format({"border": 1, "border_color": grid, "num_format": "yyyy/m/d", "valign": "vcenter"})
    percent_input = workbook.add_format({"border": 1, "border_color": grid, "bg_color": input_yellow, "num_format": "0%", "valign": "vcenter"})
    number_input = workbook.add_format({"border": 1, "border_color": grid, "bg_color": input_yellow, "num_format": "0.0", "valign": "vcenter"})
    gantt_cell = workbook.add_format({"border": 1, "border_color": grid, "align": "center"})
    phase_text = workbook.add_format({"bold": True, "font_color": navy, "border": 1, "border_color": grid})
    milestone_text = workbook.add_format({"bg_color": light_orange, "border": 1, "border_color": grid})
    small_header = workbook.add_format({"bold": True, "font_color": "white", "bg_color": blue, "border": 1, "align": "center"})
    label = workbook.add_format({"bold": True, "font_color": navy, "border": 1, "border_color": grid})
    metric = workbook.add_format({"bold": True, "font_size": 14, "font_color": blue, "border": 1, "border_color": grid})
    metric_percent = workbook.add_format({"bold": True, "font_size": 14, "font_color": blue, "border": 1, "border_color": grid, "num_format": "0%"})

    settings.hide_gridlines(2)
    settings.write("A1", "開発マイルストーン WBS", workbook.add_format({"bold": True, "font_size": 18, "font_color": navy}))
    settings.write_column("A3:A7", ["プロジェクト名", "基準日", "ガント表示日数", "週末設定", "今日の日付"], label)
    settings.write("B3", "サンプル開発プロジェクト")
    settings.write_datetime("B4", DATE_START, workbook.add_format({"num_format": "yyyy/m/d"}))
    settings.write_number("B5", DATE_COUNT)
    settings.write("B6", "土日休み")
    settings.write_formula("B7", "=TODAY()", workbook.add_format({"num_format": "yyyy/m/d"}))
    settings.write("D3", "操作", label)
    settings.write("D4", "入力後、VBAの RefreshWBS を実行するとガント・終了日・遅れが再計算されます。")
    settings.write("D5", "VBAの AddWBSRow で入力行を追加できます。")
    settings.write("D6", "休日シートに日付を追加すると、予定終了日から除外されます。")
    settings.set_column("A:A", 18)
    settings.set_column("B:B", 24)
    settings.set_column("D:D", 85)

    holidays.hide_gridlines(2)
    holidays.write("A1", "休日管理", workbook.add_format({"bold": True, "font_size": 18, "font_color": navy}))
    holidays.write_row("A3", ["休日", "名称"], small_header)
    for row, (holiday, name) in enumerate([
        (date(2026, 10, 12), "スポーツの日"),
        (date(2026, 11, 3), "文化の日"),
        (date(2026, 11, 23), "勤労感謝の日"),
    ], 3):
        holidays.write_datetime(row, 0, holiday, workbook.add_format({"num_format": "yyyy/m/d", "border": 1}))
        holidays.write(row, 1, name, text)
    holidays.set_column("A:A", 16)
    holidays.set_column("B:B", 24)
    holidays.freeze_panes(3, 0)

    wbs.hide_gridlines(2)
    wbs.freeze_panes(TASK_START, CALENDAR_START_COL)
    wbs.merge_range("A1:Q1", "開発マイルストーン WBS", title)
    wbs.merge_range("A2:Q2", "予定バー / 実績バー / カミナリ戦（基準日）を一画面で確認できます。入力セルは淡い黄色です。", subtitle)
    headers = ["ID", "階層", "タスク名", "担当", "種別", "予定開始", "予定日数", "予定終了", "実績開始", "実績終了", "進捗率", "先行ID", "開始遅れ", "終了遅れ", "工数", "備考", "状態"]
    wbs.write_row(4, 0, headers, header)
    for col in range(CALENDAR_START_COL, CALENDAR_START_COL + DATE_COUNT):
        current = DATE_START + timedelta(days=col - CALENDAR_START_COL)
        wbs.write_datetime(3, col, current, calendar_header)
        wbs.write_datetime(4, col, current, calendar_header)
        wbs.set_column(col, col, 3.2)
    wbs.set_row(0, 32)
    wbs.set_row(3, 22)
    wbs.set_row(4, 34)

    sample = [
        ("1", 0, "要件定義", "PM", "フェーズ", DATE_START, 10, None, None, 0.0, "", 1.0, "成果物を確認"),
        ("1.1", 1, "キックオフ", "PM", "タスク", DATE_START, 1, None, None, 0.0, "", 1.0, ""),
        ("1.2", 1, "要件ヒアリング", "PL", "タスク", DATE_START + timedelta(days=1), 5, None, None, 0.0, "1.1", 1.0, ""),
        ("1.3", 1, "要件定義書レビュー", "PM", "マイルストーン", DATE_START + timedelta(days=7), 1, None, None, 0.0, "1.2", 1.0, "レビュー完了"),
        ("2", 0, "設計・開発", "PL", "フェーズ", DATE_START + timedelta(days=10), 30, None, None, 0.0, "1.3", 1.0, ""),
        ("2.1", 1, "基本設計", "設計", "タスク", DATE_START + timedelta(days=10), 8, None, None, 0.0, "1.3", 1.0, ""),
        ("2.2", 1, "実装", "開発", "タスク", DATE_START + timedelta(days=18), 15, None, None, 0.0, "2.1", 2.0, ""),
        ("2.3", 1, "リリース判定", "PM", "マイルストーン", DATE_START + timedelta(days=39), 1, None, None, 0.0, "2.2", 1.0, "Go / No-Go"),
    ]
    date_columns = {5, 7, 8, 9}
    for row in range(TASK_START, TASK_END + 1):
        values = sample[row - TASK_START] if row - TASK_START < len(sample) else (None,) * 13
        task_id, level, name, owner, task_type, start, days, actual_start, actual_end, progress, predecessor, effort, note = values
        row_format = phase_text if task_type == "フェーズ" else milestone_text if task_type == "マイルストーン" else input_text
        wbs.write(row, 0, task_id, row_format)
        wbs.write(row, 1, level, row_format)
        wbs.write(row, 2, name, row_format)
        wbs.write(row, 3, owner, row_format)
        wbs.write(row, 4, task_type, row_format)
        if start:
            wbs.write_datetime(row, 5, start, date_input)
        else:
            wbs.write_blank(row, 5, date_input)
        if days:
            wbs.write_number(row, 6, days, number_input)
        else:
            wbs.write_blank(row, 6, number_input)
        wbs.write_formula(row, 7, f'=IF(OR(F{row + 1}="",G{row + 1}=""),"",WORKDAY.INTL(F{row + 1},G{row + 1}-1,1,休日!$A$4:$A$200))', date_formula)
        if actual_start:
            wbs.write_datetime(row, 8, actual_start, date_input)
        else:
            wbs.write_blank(row, 8, date_input)
        if actual_end:
            wbs.write_datetime(row, 9, actual_end, date_input)
        else:
            wbs.write_blank(row, 9, date_input)
        if progress is None:
            wbs.write_blank(row, 10, percent_input)
        else:
            wbs.write_number(row, 10, progress, percent_input)
        wbs.write(row, 11, predecessor, input_text)
        wbs.write_formula(row, 12, f'=IF(OR(F{row + 1}="",I{row + 1}=""),"",NETWORKDAYS.INTL(F{row + 1},I{row + 1}-1,1,休日!$A$4:$A$200)-1)', text)
        wbs.write_formula(row, 13, f'=IF(OR(H{row + 1}="",J{row + 1}=""),"",NETWORKDAYS.INTL(H{row + 1},J{row + 1}-1,1,休日!$A$4:$A$200)-1)', text)
        if effort is None:
            wbs.write_blank(row, 14, number_input)
        else:
            wbs.write_number(row, 14, effort, number_input)
        wbs.write(row, 15, note, input_text)
        wbs.write_formula(row, 16, f'=IF(C{row + 1}="","",IF(E{row + 1}="マイルストーン","MILESTONE",IF(K{row + 1}>=1,"完了",IF(I{row + 1}<>"","進行中","未着手"))))', text)
        for col in range(CALENDAR_START_COL, CALENDAR_START_COL + DATE_COUNT):
            wbs.write_blank(row, col, gantt_cell)

    gantt_first = xlsxwriter.utility.xl_col_to_name(CALENDAR_START_COL)
    gantt_last = xlsxwriter.utility.xl_col_to_name(CALENDAR_START_COL + DATE_COUNT - 1)
    gantt_range = f"{gantt_first}{TASK_START + 1}:{gantt_last}{TASK_END + 1}"
    wbs.conditional_format(gantt_range, {"type": "formula", "criteria": f'=AND({gantt_first}$5>=$F{TASK_START + 1},{gantt_first}$5<=$H{TASK_START + 1},$C{TASK_START + 1}<>"")', "format": workbook.add_format({"bg_color": light_blue})})
    wbs.conditional_format(gantt_range, {"type": "formula", "criteria": f'=AND({gantt_first}$5>=$I{TASK_START + 1},{gantt_first}$5<=IF($J{TASK_START + 1}="",TODAY(),$J{TASK_START + 1}),$I{TASK_START + 1}<>"")', "format": workbook.add_format({"bg_color": actual_green})})
    wbs.conditional_format(gantt_range, {"type": "formula", "criteria": f'=AND({gantt_first}$5=TODAY(),$C{TASK_START + 1}<>"")', "format": workbook.add_format({"bg_color": today_red})})
    wbs.data_validation(f"E{TASK_START + 1}:E{TASK_END + 1}", {"validate": "list", "source": ["フェーズ", "タスク", "マイルストーン"]})
    wbs.data_validation(f"K{TASK_START + 1}:K{TASK_END + 1}", {"validate": "decimal", "criteria": "between", "minimum": 0, "maximum": 1, "ignore_blank": True})
    wbs.add_table(f"A5:Q{TASK_END + 1}", {"name": "WBSTasks", "style": "Table Style Medium 2", "columns": [{"header": h} for h in headers]})
    wbs.set_column("A:A", 8)
    wbs.set_column("B:B", 7)
    wbs.set_column("C:C", 28)
    wbs.set_column("D:D", 12)
    wbs.set_column("E:E", 14)
    wbs.set_column("F:J", 13)
    wbs.set_column("K:K", 9)
    wbs.set_column("L:N", 10)
    wbs.set_column("O:O", 8)
    wbs.set_column("P:P", 24)
    wbs.set_column("Q:Q", 12)
    wbs.repeat_rows(0, 4)
    wbs.set_landscape()
    wbs.fit_to_pages(1, 0)

    summary.hide_gridlines(2)
    summary.write("A1", "プロジェクト集計", workbook.add_format({"bold": True, "font_size": 18, "font_color": navy}))
    metrics = [
        ("総タスク数", f'=COUNTIF(WBS!$C${TASK_START + 1}:$C${TASK_END + 1},"<>")', metric),
        ("完了タスク数", f'=COUNTIF(WBS!$Q${TASK_START + 1}:$Q${TASK_END + 1},"完了")', metric),
        ("進行中タスク数", f'=COUNTIF(WBS!$Q${TASK_START + 1}:$Q${TASK_END + 1},"進行中")', metric),
        ("平均進捗率", f'=IFERROR(AVERAGE(WBS!$K${TASK_START + 1}:$K${TASK_END + 1}),0)', metric_percent),
        ("遅延タスク数", f'=COUNTIF(WBS!$N${TASK_START + 1}:$N${TASK_END + 1},">0")', metric),
        ("総工数", f'=SUM(WBS!$O${TASK_START + 1}:$O${TASK_END + 1})', metric),
    ]
    for row, (label_text, formula, fmt) in enumerate(metrics, 2):
        summary.write(row, 0, label_text, label)
        summary.write_formula(row, 1, formula, fmt)
    summary.write("A11", "凡例", label)
    summary.write("A12", "予定")
    summary.write_blank("B12", None, workbook.add_format({"bg_color": light_blue}))
    summary.write("A13", "実績")
    summary.write_blank("B13", None, workbook.add_format({"bg_color": actual_green}))
    summary.write("A14", "カミナリ戦（基準日）")
    summary.write_blank("B14", None, workbook.add_format({"bg_color": today_red}))
    summary.set_column("A:A", 28)
    summary.set_column("B:B", 18)
    summary.fit_to_pages(1, 0)

    workbook.close()
    return OUTPUT


if __name__ == "__main__":
    print(build_workbook())
