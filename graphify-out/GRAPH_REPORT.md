# Graph Report - .  (2026-07-01)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 185 nodes · 274 edges · 13 communities (8 shown, 5 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 2 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `830e7f75`
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

## God Nodes (most connected - your core abstractions)
1. `App.Modules.Partner.View` - 18 edges
2. `TItemView` - 17 edges
3. `TPartnerView` - 17 edges
4. `App.Data.Memory` - 13 edges
5. `App.Modules.Item.View` - 13 edges
6. `IndexOf()` - 12 edges
7. `TMemoryDataContext` - 12 edges
8. `TMainForm` - 10 edges
9. `TMemoryPartnerRepository` - 10 edges
10. `App.Core.Contracts` - 9 edges

## Surprising Connections (you probably didn't know these)
- `Item Module Maintenance` --cites--> `TItemView`  [EXTRACTED]
  docs/maintenance/item.md → src/modules/item/App.Modules.Item.View.pas
- `Partner Module Maintenance` --cites--> `TPartnerView`  [EXTRACTED]
  docs/maintenance/partner.md → src/modules/partner/App.Modules.Partner.View.pas
- `TMainForm` --calls--> `TItemView`  [EXTRACTED]
  src/app/App.Main.pas → src/modules/item/App.Modules.Item.View.pas
- `TMainForm` --calls--> `TPartnerView`  [EXTRACTED]
  src/app/App.Main.pas → src/modules/partner/App.Modules.Partner.View.pas

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Repository Pattern & DI** — src_app, src_core, src_modules [EXTRACTED 0.95]
- **Dual Data Provider Strategy** — memory_provider, firebird_provider, src_core [EXTRACTED 1.00]

## Communities (13 total, 5 thin omitted)

### Community 0 - "App.Data.Memory"
Cohesion: 0.08
Nodes (20): IDataContext, IHistoryRepository, IInventoryRepository, IShipmentRepository, App.Data.Memory, MakeItem(), MakePartner(), TMemoryDataContext (+12 more)

### Community 1 - "App.Core.Contracts"
Cohesion: 0.06
Nodes (7): App.Core.Contracts, IHistoryRepository, IInventoryRepository, IItemRepository, IPartnerRepository, IQuoteRepository, IShipmentRepository

### Community 2 - "IndexOf"
Cohesion: 0.10
Nodes (16): IItemRepository, IPartnerRepository, IQuoteRepository, TMemoryItemRepository, Delete(), GetById(), Update(), TMemoryPartnerRepository (+8 more)

### Community 3 - "App.Modules.Item.View"
Cohesion: 0.11
Nodes (10): App.Main, ERP, App.Core.Entities, App.Core.ProviderFactory, App.Modules.Item.View, FormatPrice(), AddLabel(), BuildUI() (+2 more)

### Community 4 - "TItemView"
Cohesion: 0.22
Nodes (18): Item Module Maintenance, Firebird Provider, Memory Provider, IItemRepository, TForm, TItemView, BuildUI(), CodeExists() (+10 more)

### Community 5 - "TPartnerView"
Cohesion: 0.27
Nodes (16): Partner Module Maintenance, IPartnerRepository, TForm, TPartnerView, BuildUI(), CodeExists(), CreateWithPartners(), DeleteClick() (+8 more)

### Community 6 - "App.Modules.Partner.View"
Cohesion: 0.22
Nodes (11): App.Modules.Partner.View, DigitsOnly(), FormatBizNo(), IsValidBizNo(), PartnerKindFromIndex(), PartnerKindIndex(), PartnerKindText(), AddLabel() (+3 more)

### Community 7 - "TMainForm"
Cohesion: 0.43
Nodes (8): TForm, TMainForm, BuildUI(), CreateWithData(), FillSummary(), ItemClick(), ModulePlaceholderClick(), PartnerClick()

## Knowledge Gaps
- **17 isolated node(s):** `TForm`, `App.Core.Entities`, `IItemRepository`, `IPartnerRepository`, `IInventoryRepository` (+12 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `App.Data.Memory` connect `App.Data.Memory` to `IndexOf`, `App.Modules.Item.View`?**
  _High betweenness centrality (0.463) - this node is a cross-community bridge._
- **Why does `App.Core.Contracts` connect `App.Core.Contracts` to `IDataContext`, `App.Modules.Item.View`?**
  _High betweenness centrality (0.354) - this node is a cross-community bridge._
- **Why does `App.Modules.Partner.View` connect `App.Modules.Partner.View` to `App.Modules.Item.View`, `TPartnerView`?**
  _High betweenness centrality (0.252) - this node is a cross-community bridge._
- **What connects `TForm`, `App.Core.Entities`, `IItemRepository` to the rest of the system?**
  _17 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `App.Data.Memory` be split into smaller, more focused modules?**
  _Cohesion score 0.0784313725490196 - nodes in this community are weakly interconnected._
- **Should `App.Core.Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.06451612903225806 - nodes in this community are weakly interconnected._
- **Should `IndexOf` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._