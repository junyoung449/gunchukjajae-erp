# Graph Report - .  (2026-07-01)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 169 nodes · 231 edges · 17 communities (12 shown, 5 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.87)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `af164e55`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_IndexOf|IndexOf]]
- [[_COMMUNITY_App.Core.Contracts|App.Core.Contracts]]
- [[_COMMUNITY_App.Data.Memory|App.Data.Memory]]
- [[_COMMUNITY_TMemoryShipmentRepository|TMemoryShipmentRepository]]
- [[_COMMUNITY_ERP|ERP]]
- [[_COMMUNITY_IPartnerRepository|IPartnerRepository]]
- [[_COMMUNITY_TMainForm|TMainForm]]
- [[_COMMUNITY_IItemRepository|IItemRepository]]
- [[_COMMUNITY_IQuoteRepository|IQuoteRepository]]
- [[_COMMUNITY_Inventory Module|Inventory Module]]
- [[_COMMUNITY_App Shell|App Shell]]
- [[_COMMUNITY_IItemRepository|IItemRepository]]
- [[_COMMUNITY_Architecture Documentation|Architecture Documentation]]
- [[_COMMUNITY_건축자재상 ERP (온프레미스)|건축자재상 ERP (온프레미스)]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]

## God Nodes (most connected - your core abstractions)
1. `App.Modules.Partner.View` - 18 edges
2. `TPartnerView` - 14 edges
3. `App.Data.Memory` - 12 edges
4. `IndexOf()` - 12 edges
5. `TMemoryDataContext` - 12 edges
6. `TMemoryPartnerRepository` - 10 edges
7. `TMemoryItemRepository` - 9 edges
8. `TMemoryQuoteRepository` - 9 edges
9. `TMemoryShipmentRepository` - 9 edges
10. `App.Core.Contracts` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Pull Request Template` --references--> `Maintenance Documentation Guide`  [EXTRACTED]
  .github/pull_request_template.md → docs/maintenance/README.md
- `Maintenance Documentation Guide` --references--> `Maintenance Document Template`  [EXTRACTED]
  docs/maintenance/README.md → docs/maintenance/_template.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Data Abstraction Pattern** — src_core_iitemrepository, src_core_memory_provider, src_core_firebird_provider [EXTRACTED 1.00]
- **ERP Business Logic Flow** — src_modules_item, src_modules_inventory, src_modules_shipment, src_modules_history [EXTRACTED 0.90]
- **Partner Module Implementation** — src_modules_partner_app_modules_partner_view, src_core_interfaces_ipartnerrepository, src_core_entities_tpartner, docs_maintenance_partner [EXTRACTED 0.90]
- **Project Architecture Layers** — src_core, src_modules, src_app [EXTRACTED 1.00]

## Communities (17 total, 5 thin omitted)

### Community 0 - "IndexOf"
Cohesion: 0.10
Nodes (14): IDataContext, IInventoryRepository, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create(), Seed() (+6 more)

### Community 1 - "App.Core.Contracts"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 2 - "App.Data.Memory"
Cohesion: 0.10
Nodes (5): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IShipmentRepository

### Community 3 - "TMemoryShipmentRepository"
Cohesion: 0.30
Nodes (15): PartnerKindText(), TForm, TPartnerView, BuildUI(), CodeExists(), CreateWithPartners(), DeleteClick(), EditClick() (+7 more)

### Community 4 - "ERP"
Cohesion: 0.21
Nodes (7): Partner Module Maintenance Doc, IShipmentRepository, App.Main, ERP, App.Core.ProviderFactory, TPartner Entity, IPartnerRepository

### Community 5 - "IPartnerRepository"
Cohesion: 0.24
Nodes (10): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), AddLabel(), BuildUI() (+2 more)

### Community 6 - "TMainForm"
Cohesion: 0.33
Nodes (5): IHistoryRepository, TMemoryHistoryRepository, ItemName(), PartnerName(), GetById()

### Community 7 - "IItemRepository"
Cohesion: 0.48
Nodes (7): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ModulePlaceholderClick(), PartnerClick()

### Community 9 - "Inventory Module"
Cohesion: 0.47
Nodes (6): App Configuration, Module Task Issue Template, App Shell, Core Layer, Modules Layer, Source Tree Overview

### Community 12 - "Architecture Documentation"
Cohesion: 0.33
Nodes (6): History Module, Inventory Module, Item Module, Partner Module, Quote Module, Shipment Module

### Community 13 - "건축자재상 ERP (온프레미스)"
Cohesion: 0.67
Nodes (3): Maintenance Documentation Guide, Maintenance Document Template, Pull Request Template

### Community 14 - "Community 14"
Cohesion: 0.67
Nodes (3): Firebird Provider, IItemRepository, Memory Provider

## Knowledge Gaps
- **15 isolated node(s):** `IItemRepository`, `IPartnerRepository`, `IInventoryRepository`, `IQuoteRepository`, `IHistoryRepository` (+10 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `IndexOf` to `App.Core.Contracts`, `ERP`, `TMainForm`?**
  _High betweenness centrality (0.413) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Data.Memory` to `IQuoteRepository`, `App Shell`, `IItemRepository`, `ERP`?**
  _High betweenness centrality (0.341) - this node is a cross-community bridge._
- **Why does `App.Modules.Partner.View` connect `IPartnerRepository` to `TMemoryShipmentRepository`, `ERP`?**
  _High betweenness centrality (0.269) - this node is a cross-community bridge._
- **What connects `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` to the rest of the system?**
  _15 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09686609686609686 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._