# Graph Report - .  (2026-07-01)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 132 nodes · 160 edges · 14 communities (9 shown, 5 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.87)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1d515453`
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
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 0 → community 3_
- `TMemoryDataContext` --inherits--> `TInterfacedObject`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 3 → community 2_
- `TMemoryShipmentRepository` --inherits--> `IShipmentRepository`  [EXTRACTED]
  src/data/App.Data.Memory.pas → src/data/App.Data.Memory.pas  _Bridges community 3 → community 4_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Data Abstraction Pattern** — src_core_iitemrepository, src_core_memory_provider, src_core_firebird_provider [EXTRACTED 1.00]
- **ERP Business Logic Flow** — src_modules_item, src_modules_inventory, src_modules_shipment, src_modules_history [EXTRACTED 0.90]

## Communities (14 total, 5 thin omitted)

### Community 0 - "IndexOf"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 1 - "App.Core.Contracts"
Cohesion: 0.10
Nodes (5): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IShipmentRepository

### Community 2 - "App.Data.Memory"
Cohesion: 0.14
Nodes (9): IDataContext, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create(), Seed(), Move() (+1 more)

### Community 3 - "TMemoryShipmentRepository"
Cohesion: 0.14
Nodes (10): IHistoryRepository, IInventoryRepository, TMemoryHistoryRepository, ItemName(), PartnerName(), TMemoryInventoryRepository, TMemoryShipmentRepository, Delete() (+2 more)

### Community 4 - "ERP"
Cohesion: 0.21
Nodes (5): IShipmentRepository, App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory

### Community 6 - "TMainForm"
Cohesion: 0.53
Nodes (6): TMainForm, BuildUI(), CreateWithData(), FillSummary(), ModulePlaceholderClick(), TForm

### Community 9 - "Inventory Module"
Cohesion: 0.33
Nodes (6): History Module, Inventory Module, Item Module, Partner Module, Quote Module, Shipment Module

### Community 10 - "App Shell"
Cohesion: 0.50
Nodes (4): App Configuration, App Shell, Core Layer, Modules Layer

### Community 11 - "IItemRepository"
Cohesion: 0.67
Nodes (3): Firebird Provider, IItemRepository, Memory Provider

## Knowledge Gaps
- **11 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+6 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `TMemoryShipmentRepository`, `ERP`?**
  _High betweenness centrality (0.462) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `IQuoteRepository`, `ERP`, `IPartnerRepository`, `IItemRepository`?**
  _High betweenness centrality (0.420) - this node is a cross-community bridge._
- **Why does `TMemoryDataContext` connect `App.Data.Memory` to `TMemoryShipmentRepository`?**
  _High betweenness centrality (0.121) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _11 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.13725490196078433 - nodes in this community are weakly interconnected._