# 【GitHub公式OSS SpecKit】VSCodeで始める「仕様駆動開発」実践ガイド
---

## 1. 仕様書駆動開発(SDD)とは？

- 「雰囲気コーディング」からの卒業
従来の「Vibe Coding(雰囲気コーディング)」では、チャットで曖昧な指示をだし、バグ修正に追われがちでした。

- Vibe Coding(従来)
  - ✖ コード先行で全体像が見えない
  - ✖ ドキュメントが不在
  - ✖ 手戻りが発生する

- SDD(Spec-Driven)
  - ✔ 仕様書が正(SSoT)
  - ✔ 仕様書からコードを生成
  - ✔ 実装完了時にドキュメントが残る

---
## 2. AI時代の開発手法の進化

- 従来のテスト駆動開発(TDD)
  - 「テストを先に書き、実装する」手法は強力であるが、AI開発においては以下の課題がある。
    - AIはテストコード自体も「推論」で書くため、仕様の誤解がテストに伝播する。
    - 「何を作るか」の定義があいまいなままテストを書くと手戻りが大きい。
- 仕様書駆動開発(SDD)
  - 「自然言語の仕様書」を最初に確定させる。
    - **自然言語:**人間とAIの共通言語(英語/日本語)で合意形成。
    - **Spec First:**仕様書 → 設計 → タスク → 実装の順序を強制
    - TDDは「実装フェーズ」の一部として組み込まれます。

---

## 3. GitHub Spec Kitの概要
- CLIツール
  - PythonベースのCLIツール。プロジェクトの骨組み作成やコンテキスト管理を行う
- Markdownテンプレート
  - AIが理解しやすい形式で設計された、仕様書(spec)、計画書(plan)、タスク(tasks)の標準テンプレート群。
- エージェント連携
  - GitHub Copilot, Claude Code, Gemini CLIなど主要なAIエージェントとVS Code上でシームレスに連携。

---
## 4. Spec Kitの環境構築
- 前提条件
  - Visual Studio Code
  - GitHub Copilot(または、Claude Dev 等)
  - Python 3.10以上
  - uv (高速パッケージマネジャー)
- セットアップコマンド
  - プロジェクトフォルダで以下のコマンドを実行し、Spec Kit 初期化する。
    ```
    $ uvx specify init
    ```
  - これにより、.specifyディレクトリが生成され、AI用のコンテキスト管理が開始される。

- サンプル作成(人事管理システム)
  - コマンド
    ```
    uvx --from git+https://github.com/github/spec-kit.git specify init .
    ```

    shusuke@DESKTOP-3ACKOMV:~/work_spec_kit/HRMS$ uvx --from git+https://github.com/github/spec-kit.git specify init .
      Built specify-cli @ git+https://github.com/github/spec-kit.git@d1e86f638277
Installed 15 packages in 257ms
              ███████╗██████╗ ███████╗ ██████╗██╗███████╗██╗   ██╗               
              ██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔════╝╚██╗ ██╔╝               
              ███████╗██████╔╝█████╗  ██║     ██║█████╗   ╚████╔╝                
              ╚════██║██╔═══╝ ██╔══╝  ██║     ██║██╔══╝    ╚██╔╝                 
              ███████║██║     ███████╗╚██████╗██║██║        ██║                  
              ╚══════╝╚═╝     ╚══════╝ ╚═════╝╚═╝╚═╝        ╚═╝                  
                                                                                 
                GitHub Spec Kit - Spec-Driven Development Toolkit                


╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
╭──────────────────── Choose your coding agent integration: ────────────────────╮
│                                                                               │
│       agy (Antigravity)                                                       │
│       alquimia (Alquimia AI)                                                  │
│       amp (Amp)                                                               │
│       auggie (Auggie CLI)                                                     │
│       bob (IBM Bob)                                                           │
│       claude (Claude Code)                                                    │
│       cline (Cline)                                                           │
│       codebuddy (CodeBuddy)                                                   │
│       codex (Codex CLI)                                                       │
╭───────────────────────────────────────────────────────────────────────────────╮
│                                                                               │
│  Specify Project Setup                                                        │
│                                                                               │
│  Project         HRMS                                                         │
│  Working Path    /home/shusuke/work_spec_kit/HRMS                             │
│                                                                               │
╰───────────────────────────────────────────────────────────────────────────────╯

Selected coding agent integration: copilot
Selected script type: sh
/home/shusuke/.cache/uv/archive-v0/CTvCscfdWGrdebiV/lib/python3.14/site-packages/
specify_cli/commands/init.py:627: UserWarning: Copilot legacy markdown mode is 
deprecated and will stop being the default in a future Spec Kit release; pass 
--integration-options "--skills" to opt in to Copilot skills mode now.
  resolved_integration.setup(
Initialize Specify Project
├── ● Check required tools (ok)
├── ● Select coding agent integration (copilot)
├── ● Select script type (sh)
├── ● Install integration (GitHub Copilot)
├── ● Install shared infrastructure (scripts (sh) + templates)
├── ● Ensure scripts executable (5 updated)
├── ● Constitution setup (copied from template)
├── ● Install bundled workflow (speckit installed)
└── ● Finalize (project ready)

Project ready.

╭──────────────────────────── Agent Folder Security ────────────────────────────╮
│                                                                               │
│  Some agents may store credentials, auth tokens, or other identifying and     │
│  private artifacts in the agent folder within your project.                   │
│  Consider adding .github/ (or parts of it) to .gitignore to prevent           │
│  accidental credential leakage.                                               │
│                                                                               │
╰───────────────────────────────────────────────────────────────────────────────╯

╭───────────────────────────────── Next Steps ──────────────────────────────────╮
│                                                                               │
│  1. You're already in the project directory!                                  │
│  2. Start using slash commands with your coding agent:                        │
│     2.1 /speckit.constitution - Establish project principles                  │
│     2.2 /speckit.specify - Create baseline specification                      │
│     2.3 /speckit.plan - Create implementation plan                            │
│     2.4 /speckit.tasks - Generate actionable tasks                            │
│     2.5 /speckit.implement - Execute implementation                           │
│     2.6 /speckit.converge - Assess the codebase and append remaining work as  │
│  tasks                                                                        │
│                                                                               │
╰───────────────────────────────────────────────────────────────────────────────╯

╭──────────────────────────── Enhancement Commands ─────────────────────────────╮
│                                                                               │
│  Optional commands that you can use for your specs (improve quality &         │
│  confidence)                                                                  │
│                                                                               │
│  ○ /speckit.clarify (optional) - Ask structured questions to de-risk          │
│  ambiguous areas before planning (run before /speckit.plan if used)           │
│  ○ /speckit.analyze (optional) - Cross-artifact consistency & alignment       │
│  report (after /speckit.tasks, before /speckit.implement)                     │
│  ○ /speckit.checklist (optional) - Generate quality checklists to validate    │
│  requirements completeness, clarity, and consistency (after /speckit.plan)    │
│                                                                               │
╰───────────────────────────────────────────────────────────────────────────────╯
---

## 5. Spec Kitの仕組み

## 6. プロジェクト原則の設定
- sepckit.constifution
  - プロジェクトの「憲法(Consitution)」を定める。これは開発における交渉不可能な原則です。
    - 原則1 「t_wadaのTDDなど人名と手法を書くことでプロンプトでの説明を抽象化」
    - 原則2 「UIUXの一貫、技術スタッフ、コード規則を記載」
    - 原則3 「.github/copilot-instrctions.mdなどツール特有の原則ファイルを作成することで指示を堅牢にする」
    - 原則4 「言語の指定」
  - AIはこの原則を常に参照し、違反するコード生成を防ぎます。

## 999.リンク
- [Spec Kit](https://github.com/github/spec-kit)