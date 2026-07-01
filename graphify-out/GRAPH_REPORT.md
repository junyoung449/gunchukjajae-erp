# Graph Report - ERP  (2026-07-01)

## Corpus Check
- 13 files · ~3,875 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 157 nodes · 185 edges · 14 communities (10 shown, 4 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e2a1941a`
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

## God Nodes (most connected - your core abstractions)
1. `App.Data.Memory` - 13 edges
2. `IndexOf()` - 12 edges
3. `TMemoryDataContext` - 12 edges
4. `TMemoryPartnerRepository` - 10 edges
5. `App.Core.Contracts` - 9 edges
6. `TMemoryItemRepository` - 9 edges
7. `TMemoryQuoteRepository` - 9 edges
8. `TMemoryShipmentRepository` - 9 edges
9. `IDataContext` - 8 edges
10. `IPartnerRepository` - 7 edges

## Surprising Connections (you probably didn't know these)
- `TMemoryItemRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 1 → community 0_
- `TMemoryHistoryRepository` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 10_
- `GetById()` --calls--> `IndexOf()`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 1 → community 10_
- `TMemoryHistoryRepository` --inherits--> `IHistoryRepository`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 10 → community 4_

## Import Cycles
- None detected.

## Communities (14 total, 4 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.09
Nodes (15): IDataContext, IInventoryRepository, IShipmentRepository, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create() (+7 more)

### Community 1 - "IndexOf"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 2 - "App.Core.Contracts"
Cohesion: 0.10
Nodes (5): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IShipmentRepository

### Community 3 - "[모듈명] 유지보수 문서"
Cohesion: 0.11
Nodes (16): 데이터 접근 방식, 레이어, 모듈 간 의존, 어디를 고칠 것인가 (빠른 안내), 이 구조의 이유, 전체 구조 개요, 구성, 문서 작성 원칙 (+8 more)

### Community 4 - "ERP"
Cohesion: 0.21
Nodes (5): IHistoryRepository, App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory

### Community 5 - "건축자재상 ERP (온프레미스)"
Cohesion: 0.25
Nodes (7): DB 없이도 구동됩니다, 건축자재상 ERP (온프레미스), 기술 스택, 모듈, 브랜치 전략, 빌드, 저장소 구조

### Community 7 - "TMainForm"
Cohesion: 0.53
Nodes (6): TMainForm, BuildUI(), CreateWithData(), FillSummary(), ModulePlaceholderClick(), TForm

### Community 10 - "TMemoryHistoryRepository"
Cohesion: 0.40
Nodes (4): TMemoryHistoryRepository, ItemName(), PartnerName(), GetById()

### Community 11 - "module-task.md"
Cohesion: 0.40
Nodes (4): 대상 모듈, 브랜치, 완료 기준, 작업 범위

### Community 12 - "pull_request_template.md"
Cohesion: 0.40
Nodes (4): 개요, 변경 사항, 체크리스트, 테스트 방법

## Knowledge Gaps
- **34 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+29 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `TMemoryHistoryRepository`, `ERP`?**
  _High betweenness centrality (0.329) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `IItemRepository`, `IQuoteRepository`, `ERP`, `IPartnerRepository`?**
  _High betweenness centrality (0.296) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _34 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.09259259259259259 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._
- **Should `[모듈명] 유지보수 문서` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._