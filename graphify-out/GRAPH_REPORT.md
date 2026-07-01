# Graph Report - .  (2026-07-01)

## Corpus Check
- Corpus is ~14,760 words - fits in a single context window. You may not need a graph.

## Summary
- 341 nodes · 571 edges · 19 communities (18 shown, 1 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.92)
- Token cost: 0 input · 0 output

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
- `Item Management Features` --describes--> `Item Module`  [INFERRED]
  docs/maintenance/item.md → README.md
- `Inventory Management Features` --describes--> `Inventory Module`  [INFERRED]
  docs/maintenance/inventory.md → README.md
- `Quote Management Features` --describes--> `Quote Module`  [INFERRED]
  docs/maintenance/quote.md → README.md
- `History Inquiry Features` --describes--> `History Module`  [INFERRED]
  docs/maintenance/history.md → README.md
- `Module Dependency Graph` --depends_on--> `Item Module`  [EXTRACTED]
  docs/maintenance/architecture.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **hyperedge_layer_dependency_flow** — src_applayer, src_moduleslayer, src_corelayer [EXTRACTED 1.00]
- **hyperedge_module_workflow** — readme_itemmodule, readme_partnermodule, readme_inventorymodule, readme_quotemodule, readme_shipmentmodule, readme_historymodule [INFERRED 0.85]

## Communities (19 total, 1 thin omitted)

### Community 0 - "Core Contracts & Interfaces"
Cohesion: 0.05
Nodes (8): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository

### Community 1 - "Shipment Module UI"
Cohesion: 0.10
Nodes (26): App.Modules.Shipment.View, FormatMoney(), FormatQty(), ParseQty(), TForm, AddLabel(), AddLineClick(), BuildUI() (+18 more)

### Community 2 - "Quote Module UI"
Cohesion: 0.10
Nodes (18): App.Modules.Quote.View, FormatQty(), NewQuoteNo(), AddLabel(), AddLineClick(), BuildUI(), CreateWithQuote(), DeleteLineClick() (+10 more)

### Community 3 - "Partner Module UI"
Cohesion: 0.14
Nodes (25): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), PartnerKindText(), TForm (+17 more)

### Community 4 - "Item Management"
Cohesion: 0.14
Nodes (21): App.Core.Entities, App.Modules.Item.View, FormatPrice(), TForm, AddLabel(), BuildUI(), CreateWithItem(), SaveClick() (+13 more)

### Community 5 - "Architecture & Design Docs"
Cohesion: 0.13
Nodes (22): Module Dependency Graph, History Inquiry Features, History Read-Only Query, Inventory Management Features, Stock Movements, Item CRUD Operations, Item Management Features, Partner CRUD Operations (+14 more)

### Community 6 - "History Module UI"
Cohesion: 0.19
Nodes (19): App.Modules.History.View, FormatAmount(), HistoryKindText(), ParseIsoDate(), TForm, THistoryView, BuildFilter(), BuildUI() (+11 more)

### Community 7 - "Inventory Module UI"
Cohesion: 0.22
Nodes (19): App.Modules.Inventory.View, FormatQty(), TForm, StockMoveKindText(), TInventoryView, BuildUI(), CreateWithData(), Execute() (+11 more)

### Community 8 - "Quote View Components"
Cohesion: 0.30
Nodes (16): FormatMoney(), TForm, TQuoteView, BuildUI(), CreateWithData(), DeleteClick(), EditClick(), EditQuote() (+8 more)

### Community 9 - "Memory Data Provider"
Cohesion: 0.16
Nodes (6): App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext, Create(), Seed()

### Community 10 - "Application Entry Points"
Cohesion: 0.18
Nodes (4): IDataContext, App.Main, ERP, App.Core.ProviderFactory

### Community 11 - "Inventory Repository Implementation"
Cohesion: 0.18
Nodes (8): IInventoryRepository, IShipmentRepository, TMemoryInventoryRepository, Move(), TMemoryShipmentRepository, Add(), Delete(), TInterfacedObject

### Community 12 - "Main Application Form"
Cohesion: 0.30
Nodes (12): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), HistoryClick(), InventoryClick(), ItemClick() (+4 more)

### Community 13 - "Documentation & CI/CD Templates"
Cohesion: 0.31
Nodes (9): Data Access Abstraction, Layered Architecture, Module Task Issue Template, Maintenance Documentation, PR Template Checklist, Memory Mode, App Layer, Core Layer (+1 more)

### Community 14 - "Item Repository Implementation"
Cohesion: 0.28
Nodes (6): IItemRepository, TMemoryItemRepository, Delete(), GetById(), Update(), IndexOf()

### Community 15 - "Partner Repository Implementation"
Cohesion: 0.22
Nodes (5): IPartnerRepository, TMemoryPartnerRepository, Delete(), GetById(), Update()

### Community 16 - "Quote Repository Implementation"
Cohesion: 0.25
Nodes (5): IQuoteRepository, TMemoryQuoteRepository, Delete(), GetById(), Update()

### Community 17 - "History Repository Implementation"
Cohesion: 0.33
Nodes (5): IHistoryRepository, TMemoryHistoryRepository, ItemName(), PartnerName(), GetById()

## Knowledge Gaps
- **17 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+12 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `Memory Data Provider` to `Item Management`, `Application Entry Points`, `Inventory Repository Implementation`, `Item Repository Implementation`, `Partner Repository Implementation`, `Quote Repository Implementation`, `History Repository Implementation`?**
  _High betweenness centrality (0.265) - this node is a cross-community bridge._
- **Why does `App.Modules.Quote.View` connect `Quote Module UI` to `Quote View Components`, `Application Entry Points`, `Item Management`?**
  _High betweenness centrality (0.242) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `Core Contracts & Interfaces` to `Application Entry Points`, `Item Management`?**
  _High betweenness centrality (0.189) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _22 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Core Contracts & Interfaces` be split into smaller, more focused modules?**
  _Cohesion score 0.05128205128205128 - nodes in this community are weakly interconnected._
- **Should `Shipment Module UI` be split into smaller, more focused modules?**
  _Cohesion score 0.0953058321479374 - nodes in this community are weakly interconnected._
- **Should `Quote Module UI` be split into smaller, more focused modules?**
  _Cohesion score 0.0957983193277311 - nodes in this community are weakly interconnected._