# Excel VBA 開発を VS Code で行うための拡張機能比較と導入手順

> 作成日: 2026-09-24
> 対象: Excel VBA（標準モジュール／クラスモジュール／UserForm）を VS Code 上で編集し、Git でバージョン管理したいチーム向け

## 1. 前提・調査方法

以下の候補について、VS Code Marketplace の公開ページを直接確認し、機能・要件・インストール方法を調査した。
（`modern-vba` / `vba-tools` は Marketplace 上に該当する拡張機能が存在しないため対象から除外した。）

- xlflow for Visual Studio Code
- excel-vba-sync
- VBA-J
- XLIDE（XLIDE: VBA for VS Code）
- XVBA（XVBA - Live Server VBA / XVBA - Ribbon Menu）

## 2. 選定の評価観点

今回のプラグイン選定では、以下10個の観点で評価する。

1. **VBA標準/クラスモジュール編集** — `.bas`/`.cls` をVS Code上でストレスなく編集できるか
2. **UserForm（フォーム）編集** — フォームのレイアウト・コントロールをGUIで編集できるか
3. **LSP（補完・診断・型推論）** — コード補完、構文/型エラーの検知、シグネチャヘルプなど言語サーバーレベルの支援があるか
4. **AST静的解析** — 構文木（AST）に基づくLint/フォーマッタ/リファクタリングなど、単純な正規表現ではない構造的な解析ができるか
5. **テストフレームワーク** — VBAプロシージャに対する単体テストを記述・実行できる仕組みがあるか
6. **Excel ↔ VS Code 同期** — 編集内容をどれだけシームレス（自動・双方向）にExcel側へ反映できるか
7. **マクロ実行** — VS Code上の操作からExcelのマクロを実行し、結果やエラーを確認できるか
8. **Git管理のしやすさ** — テキスト化・差分確認・履歴確認のしやすさ
9. **Git前提のプロジェクト構成** — マニフェスト等によりプロジェクト単位でGit運用することを前提に設計されているか
10. **AIエージェント連携** — Copilot/Claude等のAIエージェントがVBAコードを読み書き・解析できる仕組み（MCPサーバー、Agent Skill等）があるか

## 3. プラグイン比較表

| 項目                            | **xlflow**                                                                          | **excel-vba-sync**                                                                     | **VBA-J**                                                   | **XLIDE**                                                                                                                      | **XVBA (Live Server)**                                                      |
| ------------------------------- | ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| Marketplace ID                  | `harumiWeb.xlflow-vscode`                                                           | `9kv8xiyi.excel-vba-sync`                                                              | `Jyaaru.vba-j`                                              | `WilliamSmithE.xlide`                                                                                                          | `local-smart.excel-live-server`                                             |
| インストール数（調査時点）      | 約450                                                                               | 約7,400                                                                                | 約84                                                        | 約820                                                                                                                          | 約235,000                                                                   |
| 対応OS                          | Windows のみ                                                                        | Windows 10/11 のみ                                                                     | Windows 10/11 (x64) のみ                                    | **Windows/Mac/Linux（Web含む）** ※実行系機能はWindows限定                                                                      | Windows 10/11                                                               |
| Excel/Office 実行時の依存       | 別途 `xlflow` CLI（Go製）を追加インストールが必要。COM経由でExcelを操作             | 拡張機能単体（PowerShell経由でCOM操作）                                                | 拡張機能単体（.NET Framework 4.8同梱、COM操作）             | **不要**（OOXML/OLEファイルを直接読み書き。Excel/COMなしで編集可能）                                                           | 拡張機能単体（VBScript経由でCOM操作）                                       |
| VBA標準/クラスモジュール編集    | ○（LSP補完・診断・Lint/Formatter付き）                                              | ○（Export/Import方式）                                                                 | ○（Export/Import + 保存で自動同期のWatch機能）              | ○（ファイルへ直接読み書き、Rename/Extract Method等7種のリファクタリング）                                                      | ○（保存で自動反映 Live Server）                                             |
| **UserForm（フォーム）編集**    | 生成コマンドあり（New UserForm）。GUIデザイナーは無し                               | 非対応（既存フォームの.frmインポート/エクスポートは可だが新規作成不可）                | 非対応（.frmはテキストとして同期されるがGUIデザイナーなし） | **○ 専用GUIデザイナーあり**（キャンバス・プロパティペイン・ツールボックス）                                                    | 非対応（GUIデザイナーなし）                                                 |
| Git管理のしやすさ               | ◎（Git管理を前提設計。プロジェクトをtomlで管理）                                    | ○（UTF-8でエクスポートしGit管理しやすい）                                              | ○（.bas/.cls/.frmをフォルダにエクスポート）                 | ◎（Export/Import に加え、Git HEAD との差分比較・復元・履歴表示コマンドを標準搭載）                                             | ○（フォルダ同期。手動でGit管理）                                            |
| **Git前提のプロジェクト構成**   | ◎（`xlflow.toml`マニフェストでプロジェクトを定義。CLI自体がGit運用を前提に設計）    | △（エクスポートフォルダ単位の管理。プロジェクトマニフェストはなし）                    | △（同上。フォルダ指定のみ）                                 | ○（プロジェクト単位のマニフェストは持たないが、Git HEAD比較/復元/履歴コマンドを標準搭載）                                      | △（`config.json`で同期先を指定するのみ。プロジェクト管理機能はなし）        |
| コード補完・診断（LSP／型推論） | ○（xlflow-lsp。補完・診断・型推論・シグネチャヘルプ、late bindingの静的型推論あり） | △（AI/MCP経由の解析が中心。エディタ単体の補完は無し）                                  | ×（無し。同期特化）                                         | ○（プロジェクト内シンボル・Office オブジェクトモデルに対応したIntelliSense、ライブ診断、Go to Definition/Find All References） | ○（LSPによる補完・ホバー・Go to Definition）                                |
| **AST静的解析**                 | ◎（ASTベースのLinter/Formatter/型推論をLSPとは別に搭載）                            | △（`vba_analyze_flow`等MCPツールで制御フロー・呼び出しグラフを取得可能。Lintではない） | ×                                                           | ○（プロジェクト全体の静的解析・7種のリファクタリング・デッドコード検出）                                                       | ×                                                                           |
| **Excel ↔ VS Code 同期**        | ○（`Pull Workbook`/`Push Sources`。セッション機能で高速化可）                       | ○（手動Export/Import方式。保存時にImport提案あり）                                     | ◎（Watchモードで保存→自動反映の双方向同期）                 | △（保存で直接ファイルへ書き込み。Excelがファイルを開いている場合は一旦閉じて保存→再度開き直す）                                | ◎（Live Serverが保存の都度、変更ファイルのみ自動反映）                      |
| **マクロ実行（VS Code上から）** | ○（CodeLensから`Run Procedure`/`Run Macro`、テストランナーあり）                    | ○（`List & Run Macro`コマンド、MCP経由`excel_run_macro`、実行中断も可能）              | ×（実行機能なし。同期のみ）                                 | ○（`Open in Office Application`で実行、`@xlide-test`でユニットテスト実行）                                                     | ◎（TreeViewから直接マクロ実行、エラーログ・Immediate Window相当の出力あり） |
| **テストフレームワーク**        | ◎（VBAテストフレームワーク内蔵。`Run Tests`/`Run Test Procedure`/自動検出）         | ×（マクロ実行機能はあるがテストフレームワークはなし）                                  | ×                                                           | ○（`@xlide-test`アノテーションでユニットテスト。実行にはOfficeアプリが必要）                                                   | ×                                                                           |
| AIエージェント連携              | ○（Agent Skill、CLIのAIフレンドリー出力）                                           | ○（内蔵MCPサーバー、22ツール）                                                         | 非対応                                                      | ○（AI向けツール群、別途MCPサーバー`xlide-mcp`も提供）                                                                          | 非対応                                                                      |
| ライセンス                      | MIT / OSS                                                                           | OSS                                                                                    | 記載なし                                                    | OSS                                                                                                                            | 記載なし                                                                    |
| 特記事項                        | VBA専用の独自CLIが必要でセットアップがやや重い                                      | セキュリティソフトにブロックされる場合がある（VBAプロジェクトを外部操作するため）      | 中国語圏の作者、多言語対応(EN/JA/CN)                        | Excel/Wordを起動せずに編集可能。VB6プロジェクトにも対応                                                                        | 老舗・実績多数だが過去のバージョンで不具合修正履歴が多い                    |

### 比較表のポイント

- **フォーム（UserForm）をGUIで編集したい場合は XLIDE 一択**。他のツールはテキスト（.frm）としての同期・編集はできるが、専用デザイナーを持つのは XLIDE のみ。
- **Git連携の完成度**も XLIDE が高く、`Compare Module with Git HEAD`（差分表示）、`Restore Module from Git HEAD`（復元）、`Show Module History`（履歴表示）をコマンドとして標準搭載している。
- **Excel/COM不要で編集できる**のも XLIDE の特徴（バイナリ/OOXMLファイルを直接パースするため、Excelがインストールされていない環境やCI上でも解析・整形が可能）。ただしこれは裏を返すと「Excelを開いたまま保存すると一旦閉じて再度開き直す」動きになり、実行中のExcelセッションへの**即時反映（ホットリロード）という点ではXVBAより弱い**。
- **LSP（補完・診断・型推論）は xlflow・XLIDE・XVBAの3つが対応**。特にxlflowとXLIDEはlate binding（`CreateObject`）の型推論や、プロジェクト内シンボルを踏まえた診断まで踏み込んでいる。excel-vba-sync・VBA-JはLSPを持たず、同期・実行に特化。
- **マクロ実行を頻繁に行い、保存→即実行のループを高速に回したい場合はXVBAが最も強い**（Live Serverによる自動反映＋TreeViewからのワンクリック実行＋エラーログ表示）。xlflowとexcel-vba-sync（MCP経由）も実行はできるが、ワークフローの手軽さではXVBAが優位。
- excel-vba-sync / VBA-J は「Excelとファイルの同期」に主眼を置いたシンプルなツールで、既存の運用（VBEで書いたコードをGit管理したいだけ）には十分だが、フォームのGUI編集・LSPは無い。
- **AST静的解析・テストフレームワーク・Git前提のプロジェクト構成の3観点を追加すると、xlflowが圧倒的に強い**。`xlflow.toml`によるプロジェクトマニフェスト、ASTベースのLint/Formatter、テストフレームワークの3点をすべて標準搭載しているのはxlflowのみである。XLIDEはテスト実行・静的解析を持つが、プロジェクトマニフェストという概念はなくGit HEAD比較コマンドで代替している。
- **AIエージェント連携は xlflow・excel-vba-sync・XLIDE の3つが対応**。excel-vba-syncはMCPツール数（22個）で最も充実しているが、xlflowはAgent SkillがLint/テスト/Git運用と統合されている点、XLIDEは別プロセスのMCPサーバー（`xlide-mcp`）でフォーム編集まで含めて操作できる点がそれぞれ強み。

## 4. 全ツールの導入手順

以下はすべて VS Code がインストール済みであることを前提とする。

### 4.1 xlflow for Visual Studio Code

1. xlflow CLI 本体を導入する（いずれか1つ）。
   ```powershell
   # クイックインストール
   irm https://harumiweb.github.io/xlflow/install.ps1 | iex

   # または WinGet
   winget install HarumiWeb.Xlflow

   # または Scoop
   scoop bucket add harumiweb https://github.com/harumiWeb/scoop-bucket
   scoop install xlflow
   ```
2. Excel の「トラストセンター」→「マクロの設定」→「VBAプロジェクトオブジェクトモデルへのアクセスを信頼する」を有効化する。
3. VS Code拡張機能をインストールする。
   ```powershell
   code --install-extension harumiWeb.xlflow-vscode
   ```
4. `xlflow` が PATH に無い場合は `settings.json` に実行ファイルパスを指定する。
   ```jsonc
   { "xlflow.path": "C:\\path\\to\\xlflow.exe" }
   ```
5. サイドバーから `New Project`（新規）または `Init Existing Workbook`（既存の.xlsm/.xlam/.xlsbを変換）を実行してプロジェクトを作成。
6. `Pull Workbook` で取り込み、`Push Sources` で編集内容をExcelへ反映。

### 4.2 excel-vba-sync

1. VS Code拡張機能をインストールする。
   ```powershell
   code --install-extension 9kv8xiyi.excel-vba-sync
   ```
   （Marketplaceからインストールできない場合はGitHub Releasesの `.vsix` を "Install from VSIX..." で導入）
2. Excel側で「VBAプロジェクトオブジェクトモデルへのアクセスを信頼する」を有効化する。
3. 対象の `.xlsm` をExcelで開いた状態で、コマンドパレットから `Export All Modules From VBA` を実行。
4. `Set Export Folder` でエクスポート先フォルダを指定し、Git管理対象にする。
5. VS Codeで `.bas`/`.cls`/`.frm` を編集し、保存時に表示される通知から `Import`、またはコマンド `Import Module To VBA` でExcelへ反映。
6. インポート後はExcel側で動作確認のうえ、`Ctrl+S` でワークブックを保存（自動保存はされない）。

> 注意: PowerShell経由でVBAプロジェクトを外部操作するため、アンチウイルス/EDR（特にDefenderのASRルール）にブロックされる場合がある。事前に必ずバックアップを取得すること。

### 4.3 VBA-J

1. VS Code拡張機能をインストールする。
   ```powershell
   code --install-extension Jyaaru.vba-j
   ```
2. Windows 10/11 (x64) 上で、Microsoft Excelがインストールされていることを確認する（追加ランタイム不要、.NET Framework 4.8を使用）。
3. アクティビティバーの「VBA Sync」アイコンを開き、`＋` で新規セッションを追加。
4. `Select Workbook` で対象のExcelファイル（開いているものでも可）を紐付ける。
5. `Export All` でワークスペースへ `.bas`/`.cls`/`.frm` を取り出す。
6. 日本語コメントなどが文字化けする場合は `Enable Encoding Conversion` を有効化し、`Excel Encoding` に `cp932`（Shift_JIS）を選択。
7. VS Codeでファイルを編集後、`Start Watch` を有効にすると保存時に自動でExcelへ反映される（`Import All` による一括反映も可能）。

### 4.4 XLIDE（VBA for VS Code）

1. VS Code拡張機能をインストールする。
   ```powershell
   code --install-extension WilliamSmithE.xlide
   ```
2. 追加ランタイムのインストールは不要（拡張機能自身がOOXML/OLEファイルを直接解析するため）。VS Code 1.95以上が必要。
3. `.xlsm`（またはその他対応形式）を含むフォルダを VS Code で開く。
4. サイドバーの XLIDE ツリーでファイルを展開し、モジュールをクリックして編集、`Ctrl+S` で保存するとファイルへ直接書き戻される。
5. UserForm を編集する場合は、ツリーからフォームを選択して開くとデザイナー（キャンバス／プロパティペイン／ツールボックス）が起動する。
6. マクロ実行やユニットテストを行う場合のみ、Windows + 該当のOffice アプリケーション（Excel等）が必要。
7. Git管理を行う場合は、コマンドパレットから以下を利用できる。
   - `XLIDE: Export All Modules to Folder`（レビュー用にソースを書き出し）
   - `XLIDE: Compare Module with Git HEAD` / `Compare File with Git HEAD`（差分確認）
   - `XLIDE: Restore Module from Git HEAD`（コミット済み状態へ復元）

### 4.5 XVBA（Live Server VBA / Ribbon Menu）

1. VS Code拡張機能をインストールする。
   ```powershell
   code --install-extension local-smart.excel-live-server
   # リボンメニュー編集も使う場合
   code --install-extension local-smart.xvba-ribbon
   ```
2. Excel側で「ブックを開いたときにマクロを実行する」設定と、「VBAプロジェクトオブジェクトモデルへのアクセスを信頼する」を有効化する。
3. XVBAツリービューの `Bootstrap` をクリックし、ワークスペース直下に `config.json` を生成する。
   ```json
   {
     "app_name": "XVBA",
     "excel_file": "index.xlsb",
     "vba_folder": "vba-files"
   }
   ```
4. 既存のVBAコードがある場合は `Import VBA` で全モジュールを取り込む。
5. `Start XVBA Live Server` を実行すると、以降ファイル保存のたびに変更分のみExcelへ自動反映される。
6. 文字化けする場合は `settings.json` に以下を追加する。
   ```jsonc
   {
     "files.encoding": "windows1252",
     "files.autoGuessEncoding": true
   }
   ```

## 5. 選定結論：10観点（VBA/Form編集・LSP・AST解析・テスト・Excel同期・マクロ実行・Git管理・Git前提構成・AI連携）を満たす構成

AST静的解析・テストフレームワーク・Git前提のプロジェクト構成・AIエージェント連携の4観点を加えると、**xlflowが単独で最も広い範囲をカバーする**ことが明確になった。`xlflow.toml` によるプロジェクトマニフェスト、ASTベースのLint/Formatter、テストフレームワーク、Agent Skillの4つを標準搭載しているのはxlflowのみである。一方でxlflowはUserFormの**GUIデザイナーを持たない**ため、フォームのレイアウト編集だけはXLIDEで補う必要がある。したがって、10観点すべてを満たすには **xlflow（中心）+ XLIDE（UserForm GUI編集専用）** の併用を推奨する。

### 5.1 推奨構成: xlflow + XLIDE の併用

| 拡張機能                                | 主な役割                                                                                                                                                                                            |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **xlflow**（`harumiWeb.xlflow-vscode`） | VBA/クラスモジュールの編集、LSP補完・診断・型推論、ASTベースのLint/Formatter、テストフレームワーク、`xlflow.toml`によるGit前提のプロジェクト構成、Agent Skillを介したAI連携、マクロ実行（CodeLens） |
| **XLIDE**（`WilliamSmithE.xlide`）      | UserFormのGUIデザイナー（キャンバス・プロパティペイン・ツールボックス）によるフォームレイアウト編集のみを担当                                                                                       |

**選定理由**

1. **AST静的解析・テストフレームワーク・Git前提のプロジェクト構成の3点をすべて標準搭載しているのはxlflowのみ**。`xlflow.toml`はプロジェクト全体をGit管理することを前提に設計されており、CLI自体が「Excel VBAマクロをGitでバージョン管理する」ことを主目的として作られている。
2. **LSP（補完・診断・型推論）もxlflowが最も踏み込んでいる**（late bindingの静的型推論、Rubberduck互換のドキュメンテーションコメント対応など）。
3. **AIエージェント連携はxlflowのAgent Skillが、Lint・テスト・Git運用と統合された形で提供される**点が実務上扱いやすい（`xlflow skill install`でCopilot/Claude Code等に対して「xlflowをどう操作するか」を教え込める）。
4. **UserFormのGUI編集だけはxlflowでは行えない**ため、フォームのレイアウト作業に限定してXLIDEを併用する。XLIDEのLSP・Git連携・AST的な静的解析機能は重複するため使用せず、あくまで「フォームデザイナー」としての利用に留める。
5. マクロ実行はxlflowのCodeLens（`Run Procedure`/`Run Macro`）とテストランナーで完結できるため、追加でXVBA等の同期特化ツールを入れる必要性は薄い。反復実行の速さを最優先する場合のみ、5.3の代替案としてXVBAの追加導入を検討する。

**運用上の注意（併用時の競合回避）**

- xlflowとXLIDEはどちらも同じ `.bas`/`.cls`/`.frm`/`.frm`系ファイルを扱えるため、**プロジェクトの正としての取り込み・反映（Pull/Push）はxlflowのコマンドに一本化**し、XLIDEはUserFormを開いてデザイナーで編集・保存する用途のみに限定する。
- XLIDEでフォームを編集した後は、xlflowの `Pull Workbook` で最新化してからxlflow側のLSP・テスト・Lintを実行する。

### 5.2 推奨構成・運用フロー

```
リポジトリ構成（例）
Excel_VBA/
  xlflow.toml                               ← xlflowのプロジェクトマニフェスト（Git管理の起点）
  src/
    Module1.bas
    Class1.cls
    UserForm1.frm                           ← レイアウトはXLIDEのデザイナーで編集
  tests/
    Module1Tests.bas                        ← xlflowのテストフレームワーク対象
  workbook/
    central_heat_source_calculation.xlsm    ← 正本（バイナリ、Gitに含めるかは運用次第）
  .vscode/
    settings.json
  .gitignore
```

1. **導入**: xlflow CLI + xlflow拡張機能（`harumiWeb.xlflow-vscode`）、および XLIDE（`WilliamSmithE.xlide`）を両方インストールする。
2. **プロジェクト初期化**: `Init Existing Workbook` で既存の `.xlsm` を xlflow プロジェクト化し、`xlflow.toml` を生成する。
3. **通常編集フェーズ**: xlflowの `Pull Workbook` でソースを取り込み、VS Code上でLSP補完・診断を受けながら編集。`xlflow: Lint Workspace` / `xlflow: Format Project` でAST解析ベースの静的チェックを行う。
4. **フォームレイアウト編集フェーズ**: XLIDEツリーからUserFormを開き、デザイナーでコントロールを配置。保存後、xlflowの `Pull Workbook` で同期を取り直す。
5. **テスト・マクロ実行フェーズ**: `xlflow: Run Tests`（自動テスト）、CodeLensの`Run Procedure`（個別マクロ実行）で動作確認する。
6. **Excelへの反映**: `Push Sources` で編集内容をワークブックへ反映し、Excel側で最終確認のうえ保存する。
7. **Git管理**: `xlflow.toml` と `src/`・`tests/` 配下のテキストファイルをコミット対象にする。`.xlsm` 自体をリポジトリに含める場合は Git LFS の利用を検討する（バイナリのため差分表示に向かないため）。

### 5.3 補足：用途に応じた代替案

- **反復的なマクロ実行・保存→即Excel反映のループ速度を最優先する場合** → 上記構成に加えて **XVBA（Live Server VBA）** を追加導入し、動作確認フェーズのみXVBAのLive Serverを使う（xlflowのPull/Push・XLIDEのフォーム編集とはタイミングを分離して運用する）。
- **CLIの追加インストールを避け、単一の拡張機能に絞りたい場合** → XLIDEのみで運用（AST解析相当の静的解析・テスト実行・Git HEAD比較は持つが、プロジェクトマニフェストによるGit前提構成やAgent Skillは持たない）。
- **既存の運用を変えず、最小構成でエクスポート/インポートとAI（MCP）連携だけ行いたい場合** → excel-vba-sync単体（MCP 22ツールでAI連携は手厚いが、LSP・AST解析・テストフレームワークは無い）。
- **保存するたびに自動でExcelへ反映したい（Watch型）だけで十分な場合** → VBA-JまたはXVBA単体（フォームはVBE側で編集を継続、AST解析・テスト・AI連携は無し）。

以上より、「VBAとFormの編集に加え、LSP・AST静的解析・テストフレームワーク・Excel↔VS Code同期・マクロ実行・Git管理・Git前提のプロジェクト構成・AIエージェント連携」まで含めた10観点を満たすには、**xlflow（LSP・AST解析・テスト・Git構成・AI連携・マクロ実行の中核）とXLIDE（UserFormのGUI編集専用）の併用構成**が最も要件充足度が高い。
