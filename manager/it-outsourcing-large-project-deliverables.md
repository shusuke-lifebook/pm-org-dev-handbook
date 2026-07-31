# IT受託開発（大規模案件）成果物一覧

## 目的
このドキュメントは、受注前からリリース後の保守まで、IT受託開発の大規模案件で必要になりやすい成果物を一覧化したものです。

## 前提
- 開発モデルはウォーターフォール/ハイブリッドを想定（アジャイルでも多くは流用可能）
- 顧客監査・セキュリティ審査・運用引き継ぎを含む企業案件を想定
- 参考リンクは「テンプレート例」または「実務で参照頻度の高い公式情報」を優先

## 1. 受注前（営業・提案）
| 成果物                    | 主な内容                                       | 参考リンク（サンプル/有力情報）                                                                                         |
| ------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| RFP回答書（提案依頼回答） | 要求への適合、前提、スコープ、体制、概算       | [Atlassian: RFP Guide](https://www.atlassian.com/work-management/project-management/request-for-proposal-rfp)           |
| 提案書                    | 解決方針、アーキテクチャ案、価値、ロードマップ | [Microsoft: Proposal templates](https://create.microsoft.com/en-us/templates/proposals)                                 |
| 概算見積書（ROM）         | 概算費用、見積前提、除外事項                   | [PMI: Cost Estimating](https://www.pmi.org/learning/library/project-cost-estimating-techniques-6116)                    |
| 体制案（RACI含む）        | 役割分担、責任境界、意思決定者                 | [RACI Matrix (Atlassian)](https://www.atlassian.com/team-playbook/plays/roles-and-responsibilities)                     |
| リスク初期評価            | 主要リスク、対策方針、前提条件                 | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| PoC計画/結果報告          | 技術検証観点、成功条件、結果                   | [AWS: PoC Guidance](https://aws.amazon.com/what-is/proof-of-concept/)                                                   |

## 2. 契約・キックオフ
| 成果物                   | 主な内容                                   | 参考リンク（サンプル/有力情報）                                                                                              |
| ------------------------ | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| 契約書（請負/準委任）    | 契約形態、検収条件、責任範囲、知財         | [経済産業省: 情報システム・モデル契約書](https://www.meti.go.jp/policy/it_policy/keiyaku/)                                   |
| SOW（Statement of Work） | 作業範囲、成果物定義、受入条件             | [SOW Explained (Wrike)](https://www.wrike.com/project-management-guide/faq/what-is-statement-of-work-in-project-management/) |
| プロジェクト憲章         | 目的、成功基準、制約、主要ステークホルダー | [PMI: Project Charter](https://www.pmi.org/learning/library/project-charter-key-elements-11156)                              |
| コミュニケーション計画   | 定例、報告ライン、エスカレーション経路     | [PMBOK関連ノート](../PMBOK/pmbok_7.md)                                                                                       |
| キックオフ資料           | 進め方、ルール、体制、初期マイルストン     | [Kickoff Agenda Template (Miro)](https://miro.com/templates/project-kickoff/)                                                |

## 3. 要件定義
| 成果物                         | 主な内容                             | 参考リンク（サンプル/有力情報）                                                                                         |
| ------------------------------ | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| 要件定義書（業務/機能/非機能） | 業務要件、機能要件、制約、受入観点   | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| 業務フロー図（As-Is/To-Be）    | 現状/将来業務、責任分界              | [BPMN Intro (Camunda)](https://camunda.com/bpmn/)                                                                       |
| ユースケース一覧               | 利用者視点の操作シナリオ整理         | [Use Case Guide (Lucidchart)](https://www.lucidchart.com/pages/uml-use-case-diagram)                                    |
| 非機能要件一覧                 | 性能、可用性、拡張性、保守性、監査性 | [IPA: 非機能要求グレード](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/hikinou/index.html)                  |
| 要件トレーサビリティ表（RTM）  | 要件-設計-テストの追跡関係           | [RTM Template (Smartsheet)](https://www.smartsheet.com/content/requirements-traceability-matrix-templates)              |
| 要件レビュー記録               | 指摘、合意、保留、対応期限           | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |

## 4. 基本設計（外部設計）
| 成果物                      | 主な内容                                | 参考リンク（サンプル/有力情報）                                                                                         |
| --------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| 基本設計書                  | 画面、帳票、IF、データ、処理方式        | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| 画面設計書/ワイヤーフレーム | 画面遷移、項目定義、入力制御            | [Figma Templates](https://www.figma.com/templates/)                                                                     |
| API設計書（OpenAPI推奨）    | エンドポイント、スキーマ、エラー仕様    | [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)                                                      |
| データモデル（ER図）        | エンティティ、関連、キー制約            | [ERD Guide (Lucidchart)](https://www.lucidchart.com/pages/er-diagrams)                                                  |
| 外部IF仕様書                | 連携方式、項目マッピング、再送/リトライ | [Microsoft: Integration patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/category/integration)   |
| プロトタイプ評価記録        | UI/UX評価、課題、改善案                 | [Nielsen Norman Group](https://www.nngroup.com/articles/usability-testing-101/)                                         |

## 5. 詳細設計（内部設計）
| 成果物                       | 主な内容                         | 参考リンク（サンプル/有力情報）                                                         |
| ---------------------------- | -------------------------------- | --------------------------------------------------------------------------------------- |
| 詳細設計書（モジュール設計） | クラス/関数責務、例外、境界条件  | [Clean Code Summary](https://github.com/ryanmcdermott/clean-code-javascript)            |
| テーブル定義書               | 物理名、型、制約、インデックス   | [PostgreSQL Docs](https://www.postgresql.org/docs/current/)                             |
| バッチ/ジョブ設計書          | 実行条件、再実行、監視、運用手順 | [Quartz Scheduler Concepts](https://www.quartz-scheduler.org/documentation/)            |
| エラー処理設計               | 例外分類、通知、復旧方針         | [IPA: 安全なウェブサイトの作り方](https://www.ipa.go.jp/security/vuln/websecurity.html) |
| ログ設計/監査ログ設計        | 出力粒度、マスキング、保管期間   | [IPA: 安全なウェブサイトの作り方](https://www.ipa.go.jp/security/vuln/websecurity.html) |
| セキュリティ設計書           | 認証認可、暗号化、脆弱性対策     | [IPA: 情報セキュリティ](https://www.ipa.go.jp/security/)                                |

## 6. 実装・構成管理
| 成果物                         | 主な内容                             | 参考リンク（サンプル/有力情報）                                                                                         |
| ------------------------------ | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| 実装規約（コーディング規約）   | 命名、構造、レビュー観点、禁止事項   | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| ブランチ運用ルール             | Gitフロー、レビュー、マージ条件      | [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)                                          |
| CI/CDパイプライン定義          | ビルド、テスト、品質ゲート、デプロイ | [GitHub Actions Docs](https://docs.github.com/en/actions)                                                               |
| コードレビュー記録             | 指摘、修正、再レビュー履歴           | [Code Review Guidelines (Google)](https://google.github.io/eng-practices/review/)                                       |
| 依存ライブラリ一覧（SBOM推奨） | OSS一覧、ライセンス、バージョン      | [CISA: SBOM](https://www.cisa.gov/sbom)                                                                                 |

## 7. テスト
| 成果物                       | 主な内容                       | 参考リンク（サンプル/有力情報）                                                                                         |
| ---------------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| テスト計画書                 | 範囲、方針、体制、品質基準     | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| テスト仕様書（観点/ケース）  | 入力、期待値、前提、判定基準   | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| テストデータ設計書           | 正常/異常/境界データ、生成方法 | [Boundary Value Analysis](https://www.geeksforgeeks.org/software-testing-boundary-value-analysis/)                      |
| 単体/結合/総合テスト結果報告 | 実績、不具合、未了項目         | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| 不具合管理台帳               | 重大度、再現手順、原因、対策   | [IPA: ソフトウェアエンジニアリングセンター（SEC）](https://www.ipa.go.jp/archive/digital/iot-en-ci/jyouryuu/index.html) |
| UAT結果報告/受入判定書       | 顧客受入結果、保留、承認記録   | [UAT Checklist (TestLodge)](https://www.testlodge.com/resources/learning_center/user-acceptance-testing-checklist)      |

## 8. リリース・移行
| 成果物               | 主な内容                         | 参考リンク（サンプル/有力情報）                                                                             |
| -------------------- | -------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| リリース計画書       | 手順、判定会、ロールバック基準   | [Release Management (Atlassian)](https://www.atlassian.com/itsm/change-management/release-management)       |
| 本番移行計画書       | データ移行、停止/切替手順、体制  | [Data Migration Strategy (AWS)](https://aws.amazon.com/what-is/data-migration/)                             |
| 移行リハーサル報告書 | 予行実績、所要時間、課題         | [Dry Run Guidance (Google SRE)](https://sre.google/workbook/canarying-releases/)                            |
| リリース判定記録     | Go/No-Go判断、未解決課題、承認者 | [Go/No-Go Checklist (Plutora)](https://www.plutora.com/blog/release-go-no-go-checklist)                     |
| リリースノート       | 変更点、既知課題、注意事項       | [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)                                                    |
| 運用引継ぎ資料       | 監視、障害対応、連絡先、SOP      | [ITIL 4 Overview (AXELOS)](https://www.axelos.com/certifications/itil-service-management/itil-4-foundation) |

## 9. 保守・運用
| 成果物                               | 主な内容                              | 参考リンク（サンプル/有力情報）                                                                    |
| ------------------------------------ | ------------------------------------- | -------------------------------------------------------------------------------------------------- |
| 運用設計書（Runbook）                | 定常運用、障害一次対応、復旧手順      | [Runbook Best Practices (PagerDuty)](https://www.pagerduty.com/resources/learn/what-is-a-runbook/) |
| SLA/SLO定義書                        | 可用性、応答時間、測定方法、罰則/目標 | [Google SRE: SLI/SLO](https://sre.google/sre-book/service-level-objectives/)                       |
| 監視設計書                           | メトリクス、閾値、アラート、通知先    | [Prometheus Monitoring Best Practices](https://prometheus.io/docs/practices/)                      |
| インシデント報告書（ポストモーテム） | 影響、原因、恒久対策、再発防止        | [Atlassian: Incident postmortem](https://www.atlassian.com/incident-management/postmortem)         |
| 変更管理記録（RFC）                  | 変更理由、影響範囲、承認履歴          | [ITIL Change Management](https://www.atlassian.com/itsm/change-management)                         |
| 月次運用報告書                       | 稼働実績、障害傾向、改善提案          | [SRE Reporting Concepts](https://sre.google/workbook/)                                             |
| 改善バックログ                       | 技術的負債、運用品質改善、優先度      | [Product Backlog Guide](https://www.scrum.org/resources/what-is-a-product-backlog)                 |

## 10. 監査・コンプライアンス（横断）
| 成果物                     | 主な内容                         | 参考リンク（サンプル/有力情報）                                                                    |
| -------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------- |
| セキュリティチェックリスト | 脆弱性診断、設定監査、是正状況   | [IPA: 情報セキュリティ](https://www.ipa.go.jp/security/)                                           |
| 個人情報取扱い設計/記録    | 取得/利用/保存/廃棄の統制        | [個人情報保護委員会](https://www.ppc.go.jp/)                                                       |
| 監査証跡一覧               | 証跡保存先、保存期間、責任者     | [IPA: 情報セキュリティ](https://www.ipa.go.jp/security/)                                           |
| BCP/DR計画書               | 目標復旧時間、代替手段、訓練計画 | [NIST Contingency Planning Guide](https://csrc.nist.gov/publications/detail/sp/800-34/rev-1/final) |

## 11. 業界差分追加（建設・建築業）
共通成果物に加えて、建設・建築業では「設計・施工・維持管理データ連携」「現場安全」「図面/モデル整合」が重要になるため、以下を追加する。

| 工程             | 追加成果物                          | 主な内容                                             | 参考リンク（サンプル/有力情報）                                                                                    |
| ---------------- | ----------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| 受注前           | BIM/CIM適用方針書（提案版）         | BIM/CIM適用範囲、3Dモデル活用方法、期待効果          | [国土交通省 BIM/CIM ポータル](https://www.mlit.go.jp/tec/it/bimcim.html)                                           |
| 契約・キックオフ | 情報共有基盤運用計画（CDE運用方針） | 図面・モデル・文書の版管理、承認フロー、アクセス権   | [buildingSMART International](https://www.buildingsmart.org/)                                                      |
| 要件定義         | 現場運用要件定義書                  | 現場端末、オフライン運用、写真/出来形/検査データ要件 | [国土交通省 i-Construction](https://www.mlit.go.jp/tec/i-construction/index.html)                                  |
| 基本設計         | モデル連携設計書（IFC/属性連携）    | BIMモデル属性と業務システム項目のマッピング          | [IFC Overview (buildingSMART)](https://www.buildingsmart.org/standards/bsi-standards/industry-foundation-classes/) |
| 詳細設計         | 図面・モデル整合ルール定義書        | 命名規則、改訂ルール、図面とモデルの差分管理         | [ISO 19650 Overview](https://www.iso.org/standard/68078.html)                                                      |
| テスト           | 現場実証テスト計画/結果             | 通信不安定環境、現場導線、帳票運用の実地検証         | [国土交通省 新技術情報提供システム（NETIS）](https://www.netis.mlit.go.jp/)                                        |
| リリース・移行   | 施工フェーズ移行計画書              | 工程節目に合わせた段階展開、旧帳票からの移行         | [国土交通省 公共工事標準請負契約約款等](https://www.mlit.go.jp/totikensangyo/const/1_6_bt_000215.html)             |
| 保守・運用       | 長期保全データ連携計画書            | 竣工後の維持管理DB連携、履歴管理、証跡保持           | [国土交通省 インフラ分野のDX](https://www.mlit.go.jp/sogoseisaku/point/dx.html)                                    |
| 横断             | 労働安全衛生・現場安全連携設計書    | KY記録、災害報告、是正管理との連携方式               | [厚生労働省 労働安全衛生法関係](https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/0000118557.html)                  |

## 12. 業界差分追加（公共系）
共通成果物に加えて、公共系では「調達手続き準拠」「説明責任」「セキュリティ・監査適合」が重要になるため、以下を追加する。

| 工程             | 追加成果物                                    | 主な内容                                                    | 参考リンク（サンプル/有力情報）                                                                                                |
| ---------------- | --------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 受注前           | 調達仕様適合表（提案時コンプライアンス表）    | 公告仕様への適合可否、代替案、準拠根拠                      | [デジタル庁 デジタル・ガバメント推進標準ガイドライン](https://www.digital.go.jp/resources/standard_guidelines/)                |
| 受注前           | 入札関連提出物チェックリスト                  | 提出様式、資格要件、証明書、有効期限管理                    | [政府電子調達（GEPS）](https://www.geps.go.jp/)                                                                                |
| 契約・キックオフ | 情報セキュリティ実施手順書（政府/自治体準拠） | 取扱区分、持出制御、委託先管理、教育計画                    | [IPA: 情報セキュリティ](https://www.ipa.go.jp/security/)                                                                       |
| 要件定義         | 住民・利用者説明要件定義書                    | 公開情報、説明責任、問い合わせ導線、多言語/アクセシビリティ | [デジタル庁 ウェブアクセシビリティ導入ガイド](https://www.digital.go.jp/resources/introduction-to-web-accessibility-guidebook) |
| 基本設計         | 監査証跡強化設計書                            | 改ざん防止、長期保管、第三者監査対応                        | [ISMAP](https://www.ismap.go.jp/csm)                                                                                           |
| 詳細設計         | 住民情報保護設計書                            | 個人情報最小化、匿名化、権限制御、ログ監査                  | [IPA: 安全なウェブサイトの作り方](https://www.ipa.go.jp/security/vuln/websecurity.html)                                        |
| テスト           | 第三者検証計画/報告書                         | 受託者以外の視点での品質・公平性評価                        | [JIS X 8341-3 概要（ウェブアクセシビリティ）](https://waic.jp/docs/jis2016/)                                                   |
| リリース・移行   | 公開判定会議資料（Go/No-Go拡張版）            | 公開可否の説明責任資料、影響評価、承認記録                  | [デジタル庁 サービス設計](https://www.digital.go.jp/policies/service-design/)                                                  |
| 保守・運用       | 年次監査対応パッケージ                        | 監査ログ、設定証跡、是正履歴、報告様式                      | [会計検査院](https://www.jbaudit.go.jp/)                                                                                       |
| 横断             | 法令・ガイドライン準拠マトリクス              | 要件と法令/ガイドラインの対応表、改定追従                   | [e-Gov法令検索](https://elaws.e-gov.go.jp/)                                                                                    |

## 活用のコツ
- まずは案件の契約形態（請負/準委任）と顧客監査要件に合わせて、必須成果物を絞る
- 次に、要件トレーサビリティ表で「要件→設計→テスト→受入」を一本化する
- 最後に、保守フェーズを見越して運用設計書と引継ぎ資料をリリース前に確定する

## ToDo（追加2項目）
- [ ] 建設・建築業向け: 「最小必須セット（絶対必要）」を抽出し、工程別に必須/任意を明記する
- [ ] 公共系向け: 「入札案件向け必須セット」を提出順（公告確認→提案→契約→受入）で並べ替える

## 補足
- 本一覧はひな型です。業界規制（金融/医療/公共）や顧客標準に応じて追加・削除してください。
