# Agent Skills (Visual Studio Code + Github Copilot) 入門
- Agent Skillsの基礎から開発まで体系的に学習。仕様理解・実装・業務活用(ログ分析／レポート作成)まで網羅し、AI活用を一歩先へ。

1. 基礎知識
   1. Agent Skillsの概要および似たような仕組みとの違いについて学習
2. Agent Skillsの利用
   1. Agent Skillsの使い方を学び、いくつか公開Skillをサンプルとして利用
3. Agent Skillsの仕様
   1. Agen Skillsを実装するために必要な基礎知識を学習
4. Agent Skillsの開発
   1. ログ分析～レポート作成までを行うSkillを作成
5. Agent Skillsのアイデア
   1. 業務改善のため、Skillをどのように使うか

## 前提条件
- 開発環境
  - クライアント：Visual Studio Code
- 生成AI
  - GitHub Copilot
- 有償サービス利用
  - [GitHub Copilot Individual(任意)](https://docs.github.com/ja/copilot/concepts/billing/individual-plans)
- 生成AIの特性
  - 与えられた文字に続くもっともらしい文字を選んで生成する仕組み
  - 講座動画と実際にご自身で検証した動作が同じ結果にならない可能性がある。
  - AIの応答は情報として間違った内容の場合がある。= ご自身で内容の検証が必要

# 1. 基礎知識

## 1.1 Agent Skillsとは
- AIエージェント「手続き的知識」を与える再利用可能なパッケージ
  - 特徴
    - 一貫性
      - 手続きを定義、AIが毎回同じ手順・品質でタスクを実行
    - 知識共有
      - チーム・組織のノウハウをパッケージ化して共有
    - 効率性
      - 必要なときだけ読み込み、トークン消費を最小化
    - 再利用／ポータビリティ
      - 一度作れば異なるAIツール上でも繰り返し利用可能
- 基本構成
  - Markdownファイルとスクリプトで構成
  - オープン化の流れ
    - 2025年10月16日にAuthropicが発表
    - 2025年12月18日に[Open Standard化](https://agentskills.io/)
- ドキュメント・アセット作成
  - AIに特定のスタイルや品質で成果物を作らせる
    - Power Pointスライド
    - Word文章
    - Web UI コンポーネント
- ワークフロー自動化
  - 複数ステップのプロセスを標準化する
    - デバック
    - コードレビュー
    - インシデント対応
- MCP拡張
  - MCPの能力に「使い方の知識」を加える
    - Figma

---

## 1.2 Instructionsとの違い
- カスタム命令(Custom Instruction)とは
  - AIの「基本方針(振る舞い・好み)」を継続的に効かせるための指示
    - 概要：トーン、役割、出力形式、制約などの"共通ルール"を設定
  - 利用目的：毎回行う同じ前提説明を省き、出力のブレを減らす
  - 向いている内容：短いルール／デフォルト設定(例：文末表現、箇条書き、根拠の提示)
  - 注意点：常に効くため、長文にするとコンテキストを圧迫しやすい。
- Agnt Skills vs Instruction
  - Agnt Skills
    - 動的、コンテキスト対応の読み込み
    - ステップ、例、スクリプトを含む
    - 複雑なワークフローに最適
    - 必要なトークンのみを消費
    - ツール間で移行可能
    - 【使い分け】
      - 必要時に読み込む手順／タスク
      - 繰り返し可能なタスク
      - チーム用プレイブック
  - Custom Instructions
    - 常にコンテキストに依存
    - 静的なシステムガイダンス
    - トーン、役割設定に最適
    - シンプルなルールの定義
    - グローバルな振る舞いを制御
    - 【使い分け】
      - 常設の基本ルール
      - デフォルトの振る舞い
      - AIの人格設定

## 1.3 MCPの違い
- Model Context Protocol(MCP)とは
  - AIと外部データ／ツールをつなぐ
  - オープン標準プロトコル(接続規格)
  - 概要：AIエージェントがツール実行・データ参照を安全に行うための仕組み
  - 利用目的：AIエージェントの能力拡張(ツール利用)
  - 開発／運用ツールのAI統合(GitHub/Slackなど)
  - 注意点：
    - セキュリティ管理(AIがツールを実行するため権限制御が重要)
    - 誤操作・自動化ループのリスク
    - 監査ログ(AIの操作履歴)を残す設計
- Agent Skills vs MCP
  - 役割
    - Skills = ノウハウのパッケージ(手順・知識)
    - MCP = 外部ツール／データ アクセス(道具)
  - 実装レベル：
    - Skills = ローカルファイル
    - MCP = リモートAPI／ローカルSTDIO
  - 関係性：
    - 競合ではなく補完関係
    - 両方を組み合わせて効果を最大化

# 2. Agent Skillsの利用
- Agent Skillsの使い方を学び、いくつか公開Skillをサンプルとして利用

## 2.1 Skillリポジトリ
- [Anthropic Skills](https://github.com/anthropics/skills)
  - 特徴：Claude Code公式Skill集
    - skills/docs,skills/xlsx,skills/pptx,skills/pdf
    - skill-creator ・・・など
- [GitHub Awesome Copilot](https://github.com/github/awesome-copilot)
  - 特徴：GitHub Copilot関連
    - Agent,Skill,Pluginなど
    - /skills以下にSkillがある
      - Skill生成(make-skill-template)
      - トラブルシュート
      - DevOps/CICD ・・・など
- [Microsoft Agent Skills](https://github.com/microsoft/skills)
  - 特徴：Microsoft Copilot, Azure関連Skills
    - Foundry & AI(AIプラットフォーム)
    - Entra
    - Monitoring
    - M365 ・・・など
- [skills.sh](https://skills.sh/)
  - 特徴：一般公開されたさまざまなSkillsをnpxを使って簡単にインストール可能
    - Authoripic Skills
    - GiHub Awesome Copilot
    - Microsoft Agent Skills ・・・など