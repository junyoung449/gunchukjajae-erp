# Shipment Maintenance

## 1. Implemented Features
- Shows shipment list with shipment number, partner, date, line count, total, and note.
- Registers a shipment by selecting a partner, adding item lines, and entering quantity.
- Uses the selected item's current unit price automatically for each shipment line.
- Warns when the requested shipment quantity is greater than current stock, but allows the user to continue after confirmation.
- Deletes shipment records through `IShipmentRepository.Delete`.

## 2. Created Or Modified Files
| File | Role |
|------|------|
| `src/modules/shipment/App.Modules.Shipment.View.pas` | Shipment list and entry UI |
| `src/app/App.Main.pas` | Wires the shipment button to `TShipmentView.Execute(Self, FData)` |
| `src/app/ERP.lpi` | Registers the shipment unit and module search path |
| `docs/maintenance/shipment.md` | Maintenance notes |

## 3. Main Classes And Methods
- `TShipmentView.Execute`: Entry point from the main form. Receives `IDataContext`.
- `TShipmentView.RefreshGrid`: Reads `FData.Shipments.GetAll` and redraws the list.
- `TShipmentEditForm.AddLineClick`: Adds an item line with automatic unit price and calculated amount.
- `TShipmentEditForm.StockWarningAccepted`: Checks `FData.Inventory.GetStock` and asks whether to continue when stock is short.
- `TShipmentEditForm.SaveClick`: Builds `TShipment` with lines, total, partner, date, and note.

## 4. Runtime Flow
1. Main form button index `I = 4` calls `TShipmentView.Execute(Self, FData)`.
2. The shipment view loads existing shipments through `FData.Shipments.GetAll`.
3. The New button opens `TShipmentEditForm`.
4. The user selects a partner, selects items, enters quantities, and adds lines.
5. Save validates partner and lines, checks stock, and returns the completed `TShipment`.
6. `TShipmentView.NewClick` calls only `FData.Shipments.Add(Form.Shipment)`.
7. The Memory provider handles inventory deduction inside `Shipments.Add` by calling `Inventory.Move(..., smkOut, ShipNo)` for each line.

## 5. Where Data Is Created Or Changed
- Shipment records are created only through `IShipmentRepository.Add`.
- Shipment records are deleted through `IShipmentRepository.Delete`.
- The shipment view does not call `Inventory.Move`.
- Inventory changes happen in `TMemoryShipmentRepository.Add` in `src/data/App.Data.Memory.pas`.
- Stock shortage checking in the view is read-only and uses `IInventoryRepository.GetStock`.

## 6. Delphi And Object Pascal Concepts Used
- LCL forms created with `CreateNew` without `.lfm` resources.
- Interface-based repository access through `IDataContext`.
- Dynamic arrays for `TShipmentLineArray`.
- `TStringGrid` for list and line display.
- Modal dialog flow with `ShowModal` and `ModalResult`.

## 7. Learning Topics
- How a view uses injected repository interfaces instead of provider implementations.
- How calculated line totals are kept in record arrays.
- How confirmation dialogs can allow exceptional business actions while still warning users.

## 8. Change Extension Points
- Add shipment editing in `TShipmentView` and reuse the line grid logic.
- Add quote-to-shipment conversion before `TShipmentEditForm.SaveClick`.
- Change stock shortage policy in `StockWarningAccepted`.
- Change inventory posting behavior only in repository/provider code, not in the view.
