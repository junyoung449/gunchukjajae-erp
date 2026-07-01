# Graph Report - ERP  (2026-07-01)

## Corpus Check
- 15 files · ~5,331 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 193 nodes · 246 edges · 15 communities (12 shown, 3 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1d515453`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_App.Data.Memory|App.Data.Memory]]
- [[_COMMUNITY_IndexOf|IndexOf]]
- [[_COMMUNITY_App.Core.Contracts|App.Core.Contracts]]
- [[_COMMUNITY_모듈명 유지보수 문서|[모듈명] 유지보수 문서]]
- [[_COMMUNITY_ERP|ERP]]
- [[_COMMUNITY_건축자재상 ERP (온프레미스)|건축자재상 ERP (온프레미스)]]
- [[_COMMUNITY_IPartnerRepository|IPartnerRepository]]
- [[_COMMUNITY_TMainForm|TMainForm]]
- [[_COMMUNITY_IItemRepository|IItemRepository]]
- [[_COMMUNITY_IQuoteRepository|IQuoteRepository]]
- [[_COMMUNITY_TMemoryHistoryRepository|TMemoryHistoryRepository]]
- [[_COMMUNITY_module-task|module-task.md]]
- [[_COMMUNITY_pull_request_template|pull_request_template.md]]
- [[_COMMUNITY_src|src]]
- [[_COMMUNITY_품목 관리 유지보수 문서|품목 관리 유지보수 문서]]

## God Nodes (most connected - your core abstractions)
1. `TItemView` - 14 edges
2. `App.Data.Memory` - 13 edges
3. `App.Modules.Item.View` - 13 edges
4. `IndexOf()` - 12 edges
5. `TMemoryDataContext` - 12 edges
6. `TMemoryPartnerRepository` - 10 edges
7. `App.Core.Contracts` - 9 edges
8. `TMemoryItemRepository` - 9 edges
9. `TInterfacedObject` - 9 edges
10. `TMemoryQuoteRepository` - 9 edges

## Surprising Connections (you probably didn't know these)
- `TMemoryItemRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 1 → community 4_
- `TMemoryDataContext` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 4 → community 0_
- `TMemoryHistoryRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 4 → community 10_
- `Delete()` --calls--> `IndexOf()`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 1 → community 10_
- `EditItem()` --calls--> `CreateWithItem()`  [EXTRACTED]
  src/modules/item/App.Modules.Item.View.pas → src/modules/item/App.Modules.Item.View.pas  _Bridges community 8 → community 4_

## Import Cycles
- None detected.

## Communities (15 total, 3 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.11
Nodes (11): IDataContext, IInventoryRepository, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create(), Seed() (+3 more)

### Community 1 - "IndexOf"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 2 - "App.Core.Contracts"
Cohesion: 0.08
Nodes (6): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IItemRepository, IShipmentRepository

### Community 3 - "[모듈명] 유지보수 문서"
Cohesion: 0.11
Nodes (16): 데이터 접근 방식, 레이어, 모듈 간 의존, 어디를 고칠 것인가 (빠른 안내), 이 구조의 이유, 전체 구조 개요, 구성, 문서 작성 원칙 (+8 more)

### Community 4 - "ERP"
Cohesion: 0.13
Nodes (10): App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory, App.Modules.Item.View, AddLabel(), BuildUI(), CreateWithItem() (+2 more)

### Community 5 - "건축자재상 ERP (온프레미스)"
Cohesion: 0.25
Nodes (7): DB 없이도 구동됩니다, 건축자재상 ERP (온프레미스), 기술 스택, 모듈, 브랜치 전략, 빌드, 저장소 구조

### Community 7 - "TMainForm"
Cohesion: 0.48
Nodes (7): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ItemClick(), ModulePlaceholderClick()

### Community 8 - "IItemRepository"
Cohesion: 0.30
Nodes (15): FormatPrice(), TForm, TItemView, BuildUI(), CodeExists(), CreateWithItems(), DeleteClick(), EditClick() (+7 more)

### Community 10 - "TMemoryHistoryRepository"
Cohesion: 0.18
Nodes (8): IHistoryRepository, IShipmentRepository, TMemoryHistoryRepository, ItemName(), PartnerName(), TMemoryShipmentRepository, Delete(), GetById()

### Community 11 - "module-task.md"
Cohesion: 0.40
Nodes (4): 대상 모듈, 브랜치, 완료 기준, 작업 범위

### Community 12 - "pull_request_template.md"
Cohesion: 0.40
Nodes (4): 개요, 변경 사항, 체크리스트, 테스트 방법

### Community 14 - "품목 관리 유지보수 문서"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

## Knowledge Gaps
- **44 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+39 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `TMemoryHistoryRepository`, `ERP`?**
  _High betweenness centrality (0.282) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `IQuoteRepository`, `ERP`, `IPartnerRepository`?**
  _High betweenness centrality (0.249) - this node is a cross-community bridge._
- **Why does `App.Modules.Item.View` connect `ERP` to `IItemRepository`?**
  _High betweenness centrality (0.159) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _44 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.11255411255411256 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._