# Graph Report - ERP-05-shipment  (2026-07-01)

## Corpus Check
- 19 files · ~9,085 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 291 nodes · 399 edges · 23 communities (15 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7b864761`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_App.Data.Memory|App.Data.Memory]]
- [[_COMMUNITY_App.Core.Contracts|App.Core.Contracts]]
- [[_COMMUNITY_IndexOf|IndexOf]]
- [[_COMMUNITY_App.Modules.Item.View|App.Modules.Item.View]]
- [[_COMMUNITY_TItemView|TItemView]]
- [[_COMMUNITY_TPartnerView|TPartnerView]]
- [[_COMMUNITY_App.Modules.Partner.View|App.Modules.Partner.View]]
- [[_COMMUNITY_TMainForm|TMainForm]]
- [[_COMMUNITY_IDataContext|IDataContext]]
- [[_COMMUNITY_Core Layer|Core Layer]]
- [[_COMMUNITY_Architecture Guide|Architecture Guide]]
- [[_COMMUNITY_ERP Project Overview|ERP Project Overview]]
- [[_COMMUNITY_App Shell|App Shell]]
- [[_COMMUNITY_거래처 관리 유지보수 문서|거래처 관리 유지보수 문서]]
- [[_COMMUNITY_Shipment Maintenance|Shipment Maintenance]]
- [[_COMMUNITY_module-task|module-task.md]]
- [[_COMMUNITY_pull_request_template|pull_request_template.md]]
- [[_COMMUNITY_src|src]]
- [[_COMMUNITY_Firebird Provider|Firebird Provider]]
- [[_COMMUNITY_Memory Provider|Memory Provider]]
- [[_COMMUNITY_IItemRepository|IItemRepository]]
- [[_COMMUNITY_IPartnerRepository|IPartnerRepository]]
- [[_COMMUNITY_Modules Layer|Modules Layer]]

## God Nodes (most connected - your core abstractions)
1. `App.Modules.Shipment.View` - 31 edges
2. `App.Modules.Partner.View` - 18 edges
3. `TItemView` - 14 edges
4. `TPartnerView` - 14 edges
5. `App.Data.Memory` - 13 edges
6. `App.Modules.Item.View` - 13 edges
7. `IndexOf()` - 12 edges
8. `TMemoryDataContext` - 12 edges
9. `TMemoryPartnerRepository` - 10 edges
10. `TShipmentView` - 10 edges

## Surprising Connections (you probably didn't know these)
- `TMemoryDataContext` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 2_
- `RefreshGrid()` --calls--> `PartnerKindText()`  [EXTRACTED]
  src/modules/partner/App.Modules.Partner.View.pas → src/modules/partner/App.Modules.Partner.View.pas  _Bridges community 5 → community 3_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Repository Pattern & DI** — src_app, src_core, src_modules [EXTRACTED 0.95]
- **Dual Data Provider Strategy** — memory_provider, firebird_provider, src_core [EXTRACTED 1.00]

## Communities (23 total, 8 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.06
Nodes (28): App.Data.Memory, TMemoryHistoryRepository, ItemName(), PartnerName(), TMemoryInventoryRepository, TMemoryItemRepository, Delete(), GetById() (+20 more)

### Community 1 - "App.Core.Contracts"
Cohesion: 0.10
Nodes (26): App.Modules.Shipment.View, FormatMoney(), FormatQty(), ParseQty(), TForm, AddLabel(), AddLineClick(), BuildUI() (+18 more)

### Community 2 - "IndexOf"
Cohesion: 0.07
Nodes (13): ERP, IDataContext, Items(), App.Core.ProviderFactory, CreateDataContext(), MakeItem(), MakePartner(), TMemoryDataContext (+5 more)

### Community 3 - "App.Modules.Item.View"
Cohesion: 0.20
Nodes (11): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), PartnerKindText(), AddLabel() (+3 more)

### Community 4 - "TItemView"
Cohesion: 0.12
Nodes (22): App.Core.Entities, App.Modules.Item.View, FormatPrice(), AddLabel(), BuildUI(), CreateWithItem(), SaveClick(), TItemView (+14 more)

### Community 5 - "TPartnerView"
Cohesion: 0.33
Nodes (14): TPartnerView, BuildUI(), CodeExists(), CreateWithPartners(), DeleteClick(), EditClick(), EditPartner(), Execute() (+6 more)

### Community 6 - "App.Modules.Partner.View"
Cohesion: 0.06
Nodes (7): App.Core.Contracts, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository

### Community 7 - "TMainForm"
Cohesion: 0.39
Nodes (9): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ItemClick(), ModulePlaceholderClick(), PartnerClick() (+1 more)

### Community 8 - "IDataContext"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 10 - "Architecture Guide"
Cohesion: 0.11
Nodes (16): 데이터 접근 방식, 레이어, 모듈 간 의존, 어디를 고칠 것인가 (빠른 안내), 이 구조의 이유, 전체 구조 개요, 구성, 문서 작성 원칙 (+8 more)

### Community 11 - "ERP Project Overview"
Cohesion: 0.25
Nodes (7): DB 없이도 구동됩니다, 건축자재상 ERP (온프레미스), 기술 스택, 모듈, 브랜치 전략, 빌드, 저장소 구조

### Community 13 - "거래처 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 14 - "Shipment Maintenance"
Cohesion: 0.20
Nodes (9): 1. Implemented Features, 2. Created Or Modified Files, 3. Main Classes And Methods, 4. Runtime Flow, 5. Where Data Is Created Or Changed, 6. Delphi And Object Pascal Concepts Used, 7. Learning Topics, 8. Change Extension Points (+1 more)

### Community 16 - "module-task.md"
Cohesion: 0.40
Nodes (4): 대상 모듈, 브랜치, 완료 기준, 작업 범위

### Community 17 - "pull_request_template.md"
Cohesion: 0.40
Nodes (4): 개요, 변경 사항, 체크리스트, 테스트 방법

## Knowledge Gaps
- **63 isolated node(s):** `TForm`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository`, `IQuoteRepository` (+58 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `TItemView`?**
  _High betweenness centrality (0.235) - this node is a cross-community bridge._
- **Why does `Items()` connect `IndexOf` to `App.Data.Memory`, `App.Core.Contracts`, `App.Modules.Item.View`, `TItemView`?**
  _High betweenness centrality (0.222) - this node is a cross-community bridge._
- **Why does `App.Core.Entities` connect `TItemView` to `App.Data.Memory`, `App.Core.Contracts`, `App.Modules.Item.View`?**
  _High betweenness centrality (0.182) - this node is a cross-community bridge._
- **What connects `TForm`, `IItemRepository`, `IPartnerRepository` to the rest of the system?**
  _63 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.06086956521739131 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.0953058321479374 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.0735632183908046 - nodes in this community are weakly interconnected._