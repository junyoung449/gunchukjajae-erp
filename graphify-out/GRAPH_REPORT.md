# Graph Report - .  (2026-07-01)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 172 nodes · 228 edges · 16 communities (10 shown, 6 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a346f43a`
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
- [[_COMMUNITY_Community 15|Community 15]]

## God Nodes (most connected - your core abstractions)
1. `TItemView` - 16 edges
2. `App.Data.Memory` - 13 edges
3. `App.Modules.Item.View` - 13 edges
4. `IndexOf()` - 12 edges
5. `TMemoryDataContext` - 12 edges
6. `TMemoryPartnerRepository` - 10 edges
7. `품목 관리 유지보수 문서` - 9 edges
8. `App.Core.Contracts` - 9 edges
9. `TMemoryItemRepository` - 9 edges
10. `TMemoryQuoteRepository` - 9 edges

## Surprising Connections (you probably didn't know these)
- `Pull Request Template` --references--> `Maintenance Documentation Index`  [EXTRACTED]
  .github/pull_request_template.md → docs/maintenance/README.md
- `TMainForm` --calls--> `TItemView`  [EXTRACTED]
  src/app/App.Main.pas → src/modules/item/App.Modules.Item.View.pas
- `Maintenance Documentation Index` --references--> `Module Maintenance Template`  [EXTRACTED]
  docs/maintenance/README.md → docs/maintenance/_template.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Data Abstraction Pattern** — src_core_iitemrepository, src_core_memory_provider, src_core_firebird_provider [EXTRACTED 1.00]
- **ERP Business Logic Flow** — src_modules_item_view, src_modules_inventory, src_modules_shipment [EXTRACTED 0.80]
- **Development Workflow & Standards** — github_pull_request_template, github_issue_template_module_task, docs_maintenance_readme, concept_memory_mode, concept_core_interface_rule [EXTRACTED 0.90]
- **System Architecture Layers** — src_core, src_modules, src_app [EXTRACTED 1.00]

## Communities (16 total, 6 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.10
Nodes (14): IInventoryRepository, IShipmentRepository, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create(), Seed() (+6 more)

### Community 1 - "IndexOf"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 2 - "App.Core.Contracts"
Cohesion: 0.08
Nodes (6): App.Core.Contracts, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IShipmentRepository

### Community 3 - "[모듈명] 유지보수 문서"
Cohesion: 0.12
Nodes (11): IDataContext, App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory, App.Modules.Item.View, FormatPrice(), AddLabel() (+3 more)

### Community 4 - "ERP"
Cohesion: 0.24
Nodes (17): Firebird Provider, IItemRepository, Memory Provider, TForm, TItemView, BuildUI(), CodeExists(), CreateWithItems() (+9 more)

### Community 5 - "건축자재상 ERP (온프레미스)"
Cohesion: 0.20
Nodes (9): 1. 구현한 기능, 2. 생성·수정한 파일, 3. 주요 클래스와 메서드, 4. 코드 실행 흐름, 5. 데이터가 생성·변경되는 위치, 6. 사용한 Delphi/Object Pascal 기술, 7. 이 코드를 이해하기 위한 학습 항목, 8. 수정 또는 확장 시 확인할 위치 (+1 more)

### Community 7 - "TMainForm"
Cohesion: 0.33
Nodes (5): IHistoryRepository, TMemoryHistoryRepository, ItemName(), PartnerName(), GetById()

### Community 8 - "IItemRepository"
Cohesion: 0.48
Nodes (7): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ItemClick(), ModulePlaceholderClick()

### Community 9 - "IQuoteRepository"
Cohesion: 0.40
Nodes (6): Core Interface Compliance, Memory Mode, Maintenance Documentation Index, Module Maintenance Template, Module Task Issue Template, Pull Request Template

### Community 11 - "module-task.md"
Cohesion: 0.83
Nodes (4): App Shell Layer, Core Layer, Modules Layer, Source Tree Overview

## Knowledge Gaps
- **20 isolated node(s):** `1. 구현한 기능`, `2. 생성·수정한 파일`, `3. 주요 클래스와 메서드`, `4. 코드 실행 흐름`, `5. 데이터가 생성·변경되는 위치` (+15 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `[모듈명] 유지보수 문서`, `TMainForm`?**
  _High betweenness centrality (0.389) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `TMemoryHistoryRepository`, `[모듈명] 유지보수 문서`, `IPartnerRepository`?**
  _High betweenness centrality (0.322) - this node is a cross-community bridge._
- **Why does `App.Modules.Item.View` connect `[모듈명] 유지보수 문서` to `ERP`?**
  _High betweenness centrality (0.215) - this node is a cross-community bridge._
- **What connects `1. 구현한 기능`, `2. 생성·수정한 파일`, `3. 주요 클래스와 메서드` to the rest of the system?**
  _20 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.09686609686609686 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._