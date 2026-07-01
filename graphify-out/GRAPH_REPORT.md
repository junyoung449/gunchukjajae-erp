# Graph Report - ERP-04-quote  (2026-07-01)

## Corpus Check
- 25 files · ~14,759 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 441 nodes · 618 edges · 61 communities (27 shown, 34 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3401b16c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Core Contracts & Interfaces|Core Contracts & Interfaces]]
- [[_COMMUNITY_Shipment Module UI|Shipment Module UI]]
- [[_COMMUNITY_Quote Module UI|Quote Module UI]]
- [[_COMMUNITY_Partner Module UI|Partner Module UI]]
- [[_COMMUNITY_Item Management|Item Management]]
- [[_COMMUNITY_Architecture & Design Docs|Architecture & Design Docs]]
- [[_COMMUNITY_History Module UI|History Module UI]]
- [[_COMMUNITY_Inventory Module UI|Inventory Module UI]]
- [[_COMMUNITY_Quote View Components|Quote View Components]]
- [[_COMMUNITY_Memory Data Provider|Memory Data Provider]]
- [[_COMMUNITY_Application Entry Points|Application Entry Points]]
- [[_COMMUNITY_Inventory Repository Implementation|Inventory Repository Implementation]]
- [[_COMMUNITY_Main Application Form|Main Application Form]]
- [[_COMMUNITY_Documentation & CICD Templates|Documentation & CI/CD Templates]]
- [[_COMMUNITY_Item Repository Implementation|Item Repository Implementation]]
- [[_COMMUNITY_Partner Repository Implementation|Partner Repository Implementation]]
- [[_COMMUNITY_Quote Repository Implementation|Quote Repository Implementation]]
- [[_COMMUNITY_History Repository Implementation|History Repository Implementation]]
- [[_COMMUNITY_Project Structure Root|Project Structure Root]]
- [[_COMMUNITY_재고 관리 유지보수 문서|재고 관리 유지보수 문서]]
- [[_COMMUNITY_품목 관리 유지보수 문서|품목 관리 유지보수 문서]]
- [[_COMMUNITY_거래처 관리 유지보수 문서|거래처 관리 유지보수 문서]]
- [[_COMMUNITY_Quote Module Maintenance|Quote Module Maintenance]]
- [[_COMMUNITY_Shipment Maintenance|Shipment Maintenance]]
- [[_COMMUNITY_App.Data.Memory|App.Data.Memory]]
- [[_COMMUNITY_TMemoryDataContext|TMemoryDataContext]]
- [[_COMMUNITY_ERP|ERP]]
- [[_COMMUNITY_건축자재상 ERP (온프레미스)|건축자재상 ERP (온프레미스)]]
- [[_COMMUNITY_TMemoryShipmentRepository|TMemoryShipmentRepository]]
- [[_COMMUNITY_module-task|module-task.md]]
- [[_COMMUNITY_pull_request_template|pull_request_template.md]]
- [[_COMMUNITY_src|src]]
- [[_COMMUNITY_Layered Architecture|Layered Architecture]]
- [[_COMMUNITY_History Inquiry Features|History Inquiry Features]]
- [[_COMMUNITY_History Read-Only Query|History Read-Only Query]]
- [[_COMMUNITY_Inventory Management Features|Inventory Management Features]]
- [[_COMMUNITY_Stock Movements|Stock Movements]]
- [[_COMMUNITY_Item CRUD Operations|Item CRUD Operations]]
- [[_COMMUNITY_Item Management Features|Item Management Features]]
- [[_COMMUNITY_Partner CRUD Operations|Partner CRUD Operations]]
- [[_COMMUNITY_Partner Management Features|Partner Management Features]]
- [[_COMMUNITY_Quote Amount Calculation|Quote Amount Calculation]]
- [[_COMMUNITY_Quote Management Features|Quote Management Features]]
- [[_COMMUNITY_Shipment Management Features|Shipment Management Features]]
- [[_COMMUNITY_Shipment Inventory Deduction|Shipment Inventory Deduction]]
- [[_COMMUNITY_Module Task Issue Template|Module Task Issue Template]]
- [[_COMMUNITY_Identifier and Comment Conventions|Identifier and Comment Conventions]]
- [[_COMMUNITY_Maintenance Documentation|Maintenance Documentation]]
- [[_COMMUNITY_PR Template Checklist|PR Template Checklist]]
- [[_COMMUNITY_ERP System|ERP System]]
- [[_COMMUNITY_History Module|History Module]]
- [[_COMMUNITY_Inventory Module|Inventory Module]]
- [[_COMMUNITY_Item Module|Item Module]]
- [[_COMMUNITY_Memory Mode|Memory Mode]]
- [[_COMMUNITY_Partner Module|Partner Module]]
- [[_COMMUNITY_Quote Module|Quote Module]]
- [[_COMMUNITY_Shipment Module|Shipment Module]]
- [[_COMMUNITY_Technical Stack|Technical Stack]]
- [[_COMMUNITY_App Layer|App Layer]]
- [[_COMMUNITY_Core Layer|Core Layer]]
- [[_COMMUNITY_Modules Layer|Modules Layer]]

## God Nodes (most connected - your core abstractions)
1. `App.Modules.Quote.View` - 39 edges
2. `App.Modules.Shipment.View` - 31 edges
3. `App.Modules.Partner.View` - 18 edges
4. `TInventoryView` - 16 edges
5. `THistoryView` - 15 edges
6. `TQuoteView` - 15 edges
7. `TItemView` - 14 edges
8. `TPartnerView` - 14 edges
9. `App.Data.Memory` - 13 edges
10. `App.Modules.Item.View` - 13 edges

## Surprising Connections (you probably didn't know these)
- `TMemoryItemRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 14 → community 11_
- `TMemoryDataContext` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 11 → community 25_
- `TMemoryHistoryRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 11 → community 17_
- `TMemoryPartnerRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 11 → community 15_
- `TMemoryQuoteRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 11 → community 16_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **hyperedge_layer_dependency_flow** — src_applayer, src_moduleslayer, src_corelayer [EXTRACTED 1.00]
- **hyperedge_module_workflow** — readme_itemmodule, readme_partnermodule, readme_inventorymodule, readme_quotemodule, readme_shipmentmodule, readme_historymodule [INFERRED 0.85]

## Communities (61 total, 34 thin omitted)

### Community 0 - "Core Contracts & Interfaces"
Cohesion: 0.05
Nodes (8): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository

### Community 1 - "Shipment Module UI"
Cohesion: 0.09
Nodes (26): App.Modules.Shipment.View, FormatMoney(), FormatQty(), ParseQty(), AddLabel(), AddLineClick(), BuildUI(), CreateWithData() (+18 more)

### Community 2 - "Quote Module UI"
Cohesion: 0.10
Nodes (18): App.Modules.Quote.View, FormatQty(), NewQuoteNo(), AddLabel(), AddLineClick(), BuildUI(), CreateWithQuote(), DeleteLineClick() (+10 more)

### Community 3 - "Partner Module UI"
Cohesion: 0.14
Nodes (25): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), PartnerKindText(), AddLabel() (+17 more)

### Community 4 - "Item Management"
Cohesion: 0.17
Nodes (20): App.Modules.Item.View, FormatPrice(), AddLabel(), BuildUI(), CreateWithItem(), SaveClick(), TItemView, BuildUI() (+12 more)

### Community 6 - "History Module UI"
Cohesion: 0.19
Nodes (19): App.Modules.History.View, FormatAmount(), HistoryKindText(), ParseIsoDate(), THistoryView, BuildFilter(), BuildUI(), ClearClick() (+11 more)

### Community 7 - "Inventory Module UI"
Cohesion: 0.19
Nodes (20): Update(), App.Modules.Inventory.View, FormatQty(), StockMoveKindText(), TInventoryView, BuildUI(), CreateWithData(), Execute() (+12 more)

### Community 8 - "Quote View Components"
Cohesion: 0.30
Nodes (16): FormatMoney(), TForm, TQuoteView, BuildUI(), CreateWithData(), DeleteClick(), EditClick(), EditQuote() (+8 more)

### Community 9 - "Memory Data Provider"
Cohesion: 0.11
Nodes (16): 데이터 접근 방식, 레이어, 모듈 간 의존, 어디를 고칠 것인가 (빠른 안내), 이 구조의 이유, 전체 구조 개요, 구성, 문서 작성 원칙 (+8 more)

### Community 10 - "Application Entry Points"
Cohesion: 0.17
Nodes (15): App.Main, TMainForm, BuildUI(), CreateWithData(), FillSummary(), HistoryClick(), InventoryClick(), ItemClick() (+7 more)

### Community 11 - "Inventory Repository Implementation"
Cohesion: 0.50
Nodes (3): TMemoryInventoryRepository, IInventoryRepository, TInterfacedObject

### Community 12 - "Main Application Form"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 14 - "Item Repository Implementation"
Cohesion: 0.29
Nodes (4): TMemoryItemRepository, Delete(), Update(), IItemRepository

### Community 15 - "Partner Repository Implementation"
Cohesion: 0.25
Nodes (4): TMemoryPartnerRepository, Delete(), Update(), IPartnerRepository

### Community 16 - "Quote Repository Implementation"
Cohesion: 0.22
Nodes (8): GetById(), GetById(), TMemoryQuoteRepository, Delete(), GetById(), Update(), IndexOf(), IQuoteRepository

### Community 17 - "History Repository Implementation"
Cohesion: 0.33
Nodes (5): TMemoryHistoryRepository, ItemName(), PartnerName(), GetById(), IHistoryRepository

### Community 19 - "재고 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현된 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 20 - "품목 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 21 - "거래처 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 22 - "Quote Module Maintenance"
Cohesion: 0.20
Nodes (9): 1. Implemented Features, 2. Created or Modified Files, 3. Key Classes and Methods, 4. Execution Flow, 5. Data Creation and Mutation Points, 6. Delphi/Object Pascal Techniques Used, 7. Study Notes, 8. Extension Points (+1 more)

### Community 23 - "Shipment Maintenance"
Cohesion: 0.20
Nodes (9): 1. Implemented Features, 2. Created Or Modified Files, 3. Main Classes And Methods, 4. Runtime Flow, 5. Where Data Is Created Or Changed, 6. Delphi And Object Pascal Concepts Used, 7. Learning Topics, 8. Change Extension Points (+1 more)

### Community 24 - "App.Data.Memory"
Cohesion: 0.28
Nodes (7): App.Data.Memory, MakeItem(), MakePartner(), Create(), Seed(), Move(), Add()

### Community 26 - "ERP"
Cohesion: 0.29
Nodes (4): ERP, App.Core.ProviderFactory, CreateDataContext(), GetMoves()

### Community 27 - "건축자재상 ERP (온프레미스)"
Cohesion: 0.25
Nodes (7): DB 없이도 구동됩니다, 건축자재상 ERP (온프레미스), 기술 스택, 모듈, 브랜치 전략, 빌드, 저장소 구조

### Community 28 - "TMemoryShipmentRepository"
Cohesion: 0.40
Nodes (3): TMemoryShipmentRepository, Delete(), IShipmentRepository

### Community 29 - "module-task.md"
Cohesion: 0.40
Nodes (4): 대상 모듈, 브랜치, 완료 기준, 작업 범위

### Community 30 - "pull_request_template.md"
Cohesion: 0.40
Nodes (4): 개요, 변경 사항, 체크리스트, 테스트 방법

## Knowledge Gaps
- **110 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+105 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **34 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Update()` connect `Inventory Module UI` to `Core Contracts & Interfaces`, `Shipment Module UI`, `Quote Module UI`, `Partner Module UI`, `Item Management`, `History Module UI`, `Application Entry Points`, `App.Data.Memory`, `ERP`?**
  _High betweenness centrality (0.171) - this node is a cross-community bridge._
- **Why does `App.Data.Memory` connect `App.Data.Memory` to `Inventory Module UI`, `Application Entry Points`, `Inventory Repository Implementation`, `Item Repository Implementation`, `Partner Repository Implementation`, `Quote Repository Implementation`, `History Repository Implementation`, `TMemoryDataContext`, `TMemoryShipmentRepository`?**
  _High betweenness centrality (0.158) - this node is a cross-community bridge._
- **Why does `App.Modules.Quote.View` connect `Quote Module UI` to `Quote View Components`, `Application Entry Points`, `Inventory Module UI`?**
  _High betweenness centrality (0.145) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _121 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Core Contracts & Interfaces` be split into smaller, more focused modules?**
  _Cohesion score 0.05128205128205128 - nodes in this community are weakly interconnected._
- **Should `Shipment Module UI` be split into smaller, more focused modules?**
  _Cohesion score 0.09176788124156546 - nodes in this community are weakly interconnected._
- **Should `Quote Module UI` be split into smaller, more focused modules?**
  _Cohesion score 0.0957983193277311 - nodes in this community are weakly interconnected._