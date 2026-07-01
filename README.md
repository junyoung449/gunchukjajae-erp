# Quote Module Maintenance

## 1. Implemented Features
- Shows quote list with quote number, partner, date, subtotal, VAT, and total.
- Creates, edits, deletes, and previews quotes in Memory mode.
- Loads partners through `IPartnerRepository` and items through `IItemRepository`.
- Adds item lines with the item's default unit price automatically filled.
- Recalculates line amount, SubTotal, Vat(10%), and Total when quantity or unit price changes.

## 2. Created or Modified Files
| File | Role |
|------|------|
| `src/modules/quote/App.Modules.Quote.View.pas` | Quote list and edit UI |
| `src/app/App.Main.pas` | Routes module button index 3 to `TQuoteView.Execute(Self, FData)` |
| `src/app/ERP.lpi` | Registers the quote unit and `../modules/quote` search path |
| `docs/maintenance/quote.md` | Maintenance notes |

## 3. Key Classes and Methods
- `TQuoteView.Execute`: entry point from the main form. Receives `IDataContext`.
- `TQuoteView.RefreshGrid`: reloads quotes from `IQuoteRepository.GetAll`.
- `TQuoteView.EditQuote`: opens the quote editor for both create and update.
- `TQuoteEditForm.AddLineClick`: adds the selected item and copies its unit price.
- `TQuoteEditForm.Recalculate`: updates amounts, subtotal, VAT, and total from current grid values.
- `TQuoteEditForm.SaveClick`: validates partner/date/lines and returns the completed `TQuote`.

## 4. Execution Flow
1. The main form button at index `3` calls `TMainForm.QuoteClick`.
2. `QuoteClick` opens `TQuoteView.Execute(Self, FData)`.
3. The quote view reads list data from `FData.Quotes.GetAll`.
4. Create/edit opens `TQuoteEditForm`, which reads partners and items through `FData.Partners` and `FData.Items`.
5. Saving writes only through `FData.Quotes.Add` or `FData.Quotes.Update`.

## 5. Data Creation and Mutation Points
- New quotes are created through `IQuoteRepository.Add`.
- Existing quotes are changed through `IQuoteRepository.Update`.
- Deleted quotes are removed through `IQuoteRepository.Delete`.
- Item and partner data are read-only in this module.
- The view does not reference the Memory provider implementation directly.

## 6. Delphi/Object Pascal Techniques Used
- Runtime-created Lazarus LCL controls with `CreateNew`.
- `TStringGrid` editable cells for line quantity and unit price.
- Repository interface injection through `IDataContext`.
- `Currency` and `Double` parsing with formatted display values.

## 7. Study Notes
- Review `TQuoteLine` and `TQuote` in `App.Core.Entities`.
- Review `IQuoteRepository` in `App.Core.Contracts`.
- Review `TQuoteEditForm.Recalculate` for UI-driven aggregate calculation.

## 8. Extension Points
- Add quote numbering rules in `NewQuoteNo`.
- Add print/export behavior by replacing `PreviewClick` with a report form.
- Add line-level discount or VAT rules in `Recalculate`.
