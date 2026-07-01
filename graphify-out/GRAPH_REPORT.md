# Graph Report - ERP-04-quote  (2026-07-01)

## Corpus Check
- 19 files · ~9,600 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 304 nodes · 433 edges · 31 communities (22 shown, 9 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f657a32e`
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
- [[_COMMUNITY_TQuoteView|TQuoteView]]
- [[_COMMUNITY_품목 관리 유지보수 문서|품목 관리 유지보수 문서]]
- [[_COMMUNITY_거래처 관리 유지보수 문서|거래처 관리 유지보수 문서]]
- [[_COMMUNITY_Quote Module Maintenance|Quote Module Maintenance]]
- [[_COMMUNITY_App.Data.Memory|App.Data.Memory]]
- [[_COMMUNITY_TMemoryDataContext|TMemoryDataContext]]
- [[_COMMUNITY_TMemoryHistoryRepository|TMemoryHistoryRepository]]
- [[_COMMUNITY_TMemoryItemRepository|TMemoryItemRepository]]
- [[_COMMUNITY_TMemoryPartnerRepository|TMemoryPartnerRepository]]
- [[_COMMUNITY_TMemoryShipmentRepository|TMemoryShipmentRepository]]
- [[_COMMUNITY_module-task|module-task.md]]
- [[_COMMUNITY_pull_request_template|pull_request_template.md]]
- [[_COMMUNITY_src|src]]
- [[_COMMUNITY_Firebird Provider|Firebird Provider]]
- [[_COMMUNITY_Memory Provider|Memory Provider]]
- [[_COMMUNITY_IItemRepository|IItemRepository]]
- [[_COMMUNITY_IPartnerRepository|IPartnerRepository]]
- [[_COMMUNITY_Modules Layer|Modules Layer]]

## God Nodes (most connected - your core abstractions)
1. `App.Modules.Quote.View` - 39 edges
2. `App.Modules.Partner.View` - 18 edges
3. `TPartnerView` - 15 edges
4. `TQuoteView` - 15 edges
5. `TItemView` - 14 edges
6. `App.Data.Memory` - 13 edges
7. `App.Modules.Item.View` - 13 edges
8. `IndexOf()` - 12 edges
9. `TMemoryDataContext` - 12 edges
10. `TMemoryPartnerRepository` - 10 edges

## Surprising Connections (you probably didn't know these)
- `TMemoryItemRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 20 → community 0_
- `TMemoryDataContext` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 18_
- `TMemoryHistoryRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 19_
- `TMemoryPartnerRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 21_
- `TMemoryQuoteRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 2_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Repository Pattern & DI** — src_app, src_core, src_modules [EXTRACTED 0.95]
- **Dual Data Provider Strategy** — memory_provider, firebird_provider, src_core [EXTRACTED 1.00]

## Communities (31 total, 9 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.40
Nodes (3): TMemoryInventoryRepository, IInventoryRepository, TInterfacedObject

### Community 1 - "App.Core.Contracts"
Cohesion: 0.10
Nodes (19): App.Modules.Quote.View, FormatMoney(), FormatQty(), NewQuoteNo(), AddLabel(), AddLineClick(), BuildUI(), CreateWithQuote() (+11 more)

### Community 2 - "IndexOf"
Cohesion: 0.22
Nodes (8): Delete(), Update(), TMemoryQuoteRepository, Delete(), GetById(), Update(), IndexOf(), IQuoteRepository

### Community 3 - "App.Modules.Item.View"
Cohesion: 0.06
Nodes (7): App.Core.Contracts, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository

### Community 4 - "TItemView"
Cohesion: 0.16
Nodes (20): App.Modules.Item.View, FormatPrice(), AddLabel(), BuildUI(), CreateWithItem(), SaveClick(), TItemView, BuildUI() (+12 more)

### Community 5 - "TPartnerView"
Cohesion: 0.30
Nodes (15): PartnerKindText(), TPartnerView, BuildUI(), CodeExists(), CreateWithPartners(), DeleteClick(), EditClick(), EditPartner() (+7 more)

### Community 6 - "App.Modules.Partner.View"
Cohesion: 0.13
Nodes (5): ERP, IDataContext, ProviderName(), App.Core.ProviderFactory, IndexOf()

### Community 7 - "TMainForm"
Cohesion: 0.21
Nodes (11): App.Core.Entities, App.Main, TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ItemClick() (+3 more)

### Community 8 - "IDataContext"
Cohesion: 0.22
Nodes (10): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), AddLabel(), BuildUI() (+2 more)

### Community 10 - "Architecture Guide"
Cohesion: 0.11
Nodes (16): 데이터 접근 방식, 레이어, 모듈 간 의존, 어디를 고칠 것인가 (빠른 안내), 이 구조의 이유, 전체 구조 개요, 구성, 문서 작성 원칙 (+8 more)

### Community 11 - "ERP Project Overview"
Cohesion: 0.25
Nodes (7): DB 없이도 구동됩니다, 건축자재상 ERP (온프레미스), 기술 스택, 모듈, 브랜치 전략, 빌드, 저장소 구조

### Community 13 - "TQuoteView"
Cohesion: 0.32
Nodes (15): TForm, TQuoteView, BuildUI(), CreateWithData(), DeleteClick(), EditClick(), EditQuote(), Execute() (+7 more)

### Community 14 - "품목 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 15 - "거래처 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 16 - "Quote Module Maintenance"
Cohesion: 0.20
Nodes (9): 1. Implemented Features, 2. Created or Modified Files, 3. Key Classes and Methods, 4. Execution Flow, 5. Data Creation and Mutation Points, 6. Delphi/Object Pascal Techniques Used, 7. Study Notes, 8. Extension Points (+1 more)

### Community 17 - "App.Data.Memory"
Cohesion: 0.28
Nodes (7): App.Data.Memory, MakeItem(), MakePartner(), Create(), Seed(), Move(), Add()

### Community 19 - "TMemoryHistoryRepository"
Cohesion: 0.33
Nodes (5): TMemoryHistoryRepository, ItemName(), PartnerName(), GetById(), IHistoryRepository

### Community 20 - "TMemoryItemRepository"
Cohesion: 0.29
Nodes (5): TMemoryItemRepository, Delete(), GetById(), Update(), IItemRepository

### Community 21 - "TMemoryPartnerRepository"
Cohesion: 0.29
Nodes (3): TMemoryPartnerRepository, GetById(), IPartnerRepository

### Community 22 - "TMemoryShipmentRepository"
Cohesion: 0.40
Nodes (3): TMemoryShipmentRepository, Delete(), IShipmentRepository

### Community 23 - "module-task.md"
Cohesion: 0.40
Nodes (4): 대상 모듈, 브랜치, 완료 기준, 작업 범위

### Community 24 - "pull_request_template.md"
Cohesion: 0.40
Nodes (4): 개요, 변경 사항, 체크리스트, 테스트 방법

## Knowledge Gaps
- **64 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+59 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `App.Data.Memory`, `IndexOf`, `App.Modules.Partner.View`, `TMainForm`, `TMemoryDataContext`, `TMemoryHistoryRepository`, `TMemoryItemRepository`, `TMemoryPartnerRepository`, `TMemoryShipmentRepository`?**
  _High betweenness centrality (0.227) - this node is a cross-community bridge._
- **Why does `App.Modules.Quote.View` connect `App.Core.Contracts` to `TQuoteView`, `App.Modules.Partner.View`, `TMainForm`?**
  _High betweenness centrality (0.215) - this node is a cross-community bridge._
- **Why does `ProviderName()` connect `App.Modules.Partner.View` to `App.Core.Contracts`, `TItemView`, `TMainForm`, `IDataContext`, `App.Data.Memory`?**
  _High betweenness centrality (0.169) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _64 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.09682539682539683 - nodes in this community are weakly interconnected._
- **Should `App.Modules.Item.View` be split into smaller, more focused modules?**
  _Cohesion score 0.06451612903225806 - nodes in this community are weakly interconnected._
- **Should `App.Modules.Partner.View` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._