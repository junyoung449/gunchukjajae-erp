# Graph Report - .  (2026-07-01)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 208 nodes · 317 edges · 15 communities (10 shown, 5 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 2 edges (avg confidence: 0.9)
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
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]

## God Nodes (most connected - your core abstractions)
1. `TInventoryView` - 21 edges
2. `App.Modules.Partner.View` - 18 edges
3. `TItemView` - 14 edges
4. `TPartnerView` - 14 edges
5. `App.Data.Memory` - 13 edges
6. `App.Modules.Item.View` - 13 edges
7. `IndexOf()` - 12 edges
8. `TMemoryDataContext` - 12 edges
9. `TMemoryPartnerRepository` - 10 edges
10. `TMainForm` - 10 edges

## Surprising Connections (you probably didn't know these)
- `Inventory Maintenance Guide` --cites--> `TInventoryView`  [EXTRACTED]
  docs/maintenance/inventory.md → src/modules/inventory/App.Modules.Inventory.View.pas
- `TMainForm` --calls--> `TInventoryView`  [EXTRACTED]
  src/app/App.Main.pas → src/modules/inventory/App.Modules.Inventory.View.pas
- `TInventoryView` --references--> `IDataContext`  [EXTRACTED]
  src/modules/inventory/App.Modules.Inventory.View.pas → src/core/App.Core.Interfaces.pas
- `TInventoryView` --calls--> `IItemRepository`  [EXTRACTED]
  src/modules/inventory/App.Modules.Inventory.View.pas → src/core/App.Core.Interfaces.pas
- `Firebird Provider` --implements--> `IInventoryRepository`  [INFERRED]
  src/core/App.Data.Firebird.pas → src/core/App.Core.Interfaces.pas

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Data Access Abstraction** — src_core_idatacontext, src_core_memory_provider, src_core_firebird_provider [EXTRACTED 1.00]
- **Inventory Management Flow** — src_app_main, src_modules_inventory_view, src_core_iinventoryrepository [EXTRACTED 1.00]

## Communities (15 total, 5 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.06
Nodes (29): IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository, App.Data.Memory, MakeItem() (+21 more)

### Community 1 - "App.Core.Contracts"
Cohesion: 0.06
Nodes (7): App.Core.Contracts, IDataContext, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IShipmentRepository

### Community 2 - "IndexOf"
Cohesion: 0.14
Nodes (25): Inventory Maintenance Guide, Firebird Provider, IDataContext, IInventoryRepository, IItemRepository, Memory Provider, App.Modules.Inventory.View, FormatQty() (+17 more)

### Community 3 - "App.Modules.Item.View"
Cohesion: 0.17
Nodes (20): App.Modules.Item.View, FormatPrice(), TForm, AddLabel(), BuildUI(), CreateWithItem(), SaveClick(), TItemView (+12 more)

### Community 4 - "TItemView"
Cohesion: 0.30
Nodes (15): PartnerKindText(), TForm, TPartnerView, BuildUI(), CodeExists(), CreateWithPartners(), DeleteClick(), EditClick() (+7 more)

### Community 5 - "TPartnerView"
Cohesion: 0.16
Nodes (7): IDataContext, MakePartner(), TMemoryDataContext, Create(), Seed(), Move(), Add()

### Community 6 - "App.Modules.Partner.View"
Cohesion: 0.18
Nodes (4): App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory

### Community 7 - "TMainForm"
Cohesion: 0.24
Nodes (10): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), AddLabel(), BuildUI() (+2 more)

### Community 8 - "IDataContext"
Cohesion: 0.39
Nodes (9): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), InventoryClick(), ItemClick(), ModulePlaceholderClick() (+1 more)

### Community 10 - "Architecture Guide"
Cohesion: 0.67
Nodes (3): App Shell, Core Layer, Modules Layer

## Knowledge Gaps
- **21 isolated node(s):** `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository`, `IQuoteRepository` (+16 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `TPartnerView`, `App.Modules.Partner.View`?**
  _High betweenness centrality (0.424) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `Core Layer`, `App.Modules.Partner.View`?**
  _High betweenness centrality (0.317) - this node is a cross-community bridge._
- **Why does `App.Modules.Partner.View` connect `TMainForm` to `TItemView`, `App.Modules.Partner.View`?**
  _High betweenness centrality (0.240) - this node is a cross-community bridge._
- **What connects `App.Core.Entities`, `IItemRepository`, `IPartnerRepository` to the rest of the system?**
  _21 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.06086956521739131 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.06060606060606061 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.13538461538461538 - nodes in this community are weakly interconnected._