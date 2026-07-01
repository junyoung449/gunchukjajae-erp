unit App.Modules.Quote.View;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Math, Forms, Controls, StdCtrls, ExtCtrls,
  Grids, Dialogs, App.Core.Contracts, App.Core.Entities;

type
  TQuoteView = class(TForm)
  private
    FData: IDataContext;
    FRows: TQuoteArray;
    FSearchEdit: TEdit;
    FGrid: TStringGrid;
    procedure BuildUI;
    procedure RefreshGrid;
    procedure SearchChanged(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    function SelectedQuote(out AQuote: TQuote): Boolean;
    function PartnerName(const APartnerId: Integer): string;
    function EditQuote(var AQuote: TQuote; const AIsNew: Boolean): Boolean;
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext);
    class procedure Execute(AOwner: TComponent; const AData: IDataContext);
  end;

implementation

type
  TQuoteEditForm = class(TForm)
  private
    FData: IDataContext;
    FQuote: TQuote;
    FPartners: TPartnerArray;
    FItems: TItemArray;
    FLineItemIds: array of Integer;
    FUpdating: Boolean;
    FPartnerCombo: TComboBox;
    FDateEdit: TEdit;
    FItemCombo: TComboBox;
    FLineGrid: TStringGrid;
    FSubTotalLabel: TLabel;
    FVatLabel: TLabel;
    FTotalLabel: TLabel;
    FNoteMemo: TMemo;
    procedure BuildUI(const AIsNew: Boolean);
    procedure LoadLookups;
    procedure LoadLinesToGrid;
    procedure AddLabel(const ACaption: string; const AParent: TWinControl;
      const ALeft, ATop: Integer);
    procedure AddLineClick(Sender: TObject);
    procedure DeleteLineClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure LineGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure LineGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Recalculate;
    function PartnerComboIndex(const APartnerId: Integer): Integer;
    function ItemComboIndex(const AItemId: Integer): Integer;
    function ItemName(const AItemId: Integer): string;
    function ParseCurrencyText(const AValue: string; out ANumber: Currency): Boolean;
    function ParseFloatText(const AValue: string; out ANumber: Double): Boolean;
  public
    constructor CreateWithQuote(AOwner: TComponent; const AData: IDataContext;
      const AQuote: TQuote; const AIsNew: Boolean);
    property Quote: TQuote read FQuote;
  end;

function FormatMoney(const AValue: Currency): string;
begin
  Result := FormatFloat('#,##0.##', AValue);
end;

function FormatQty(const AValue: Double): string;
begin
  Result := FormatFloat('#,##0.###', AValue);
end;

function NewQuoteNo: string;
begin
  Result := 'QT' + FormatDateTime('yyyymmddhhnnss', Now);
end;

{ TQuoteEditForm }

constructor TQuoteEditForm.CreateWithQuote(AOwner: TComponent;
  const AData: IDataContext; const AQuote: TQuote; const AIsNew: Boolean);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  FQuote := AQuote;
  LoadLookups;
  BuildUI(AIsNew);
  LoadLinesToGrid;
  Recalculate;
end;

procedure TQuoteEditForm.LoadLookups;
begin
  FPartners := FData.Partners.GetByKind(pkCustomer);
  FItems := FData.Items.GetAll;
end;

procedure TQuoteEditForm.AddLabel(const ACaption: string;
  const AParent: TWinControl; const ALeft, ATop: Integer);
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(Self);
  Lbl.Parent := AParent;
  Lbl.Left := ALeft;
  Lbl.Top := ATop + 4;
  Lbl.Caption := ACaption;
end;

procedure TQuoteEditForm.BuildUI(const AIsNew: Boolean);
var
  BtnAdd, BtnDelete, BtnSave, BtnCancel: TButton;
  PanelTop, PanelBottom: TPanel;
  I: Integer;
begin
  if AIsNew then
    Caption := '견적 신규'
  else
    Caption := '견적 수정';
  Width := 820;
  Height := 620;
  BorderStyle := bsDialog;
  Position := poOwnerFormCenter;

  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 104;
  PanelTop.BevelOuter := bvNone;

  AddLabel('거래처', PanelTop, 16, 18);
  FPartnerCombo := TComboBox.Create(Self);
  FPartnerCombo.Parent := PanelTop;
  FPartnerCombo.Left := 82;
  FPartnerCombo.Top := 14;
  FPartnerCombo.Width := 260;
  FPartnerCombo.Style := csDropDownList;
  for I := 0 to High(FPartners) do
    FPartnerCombo.Items.Add(FPartners[I].Code + ' - ' + FPartners[I].Name);
  FPartnerCombo.ItemIndex := PartnerComboIndex(FQuote.PartnerId);

  AddLabel('일자', PanelTop, 370, 18);
  FDateEdit := TEdit.Create(Self);
  FDateEdit.Parent := PanelTop;
  FDateEdit.Left := 418;
  FDateEdit.Top := 14;
  FDateEdit.Width := 120;
  if FQuote.QuoteDate = 0 then
    FDateEdit.Text := FormatDateTime('yyyy-mm-dd', Date)
  else
    FDateEdit.Text := FormatDateTime('yyyy-mm-dd', FQuote.QuoteDate);

  AddLabel('품목', PanelTop, 16, 58);
  FItemCombo := TComboBox.Create(Self);
  FItemCombo.Parent := PanelTop;
  FItemCombo.Left := 82;
  FItemCombo.Top := 54;
  FItemCombo.Width := 340;
  FItemCombo.Style := csDropDownList;
  for I := 0 to High(FItems) do
    if FItems[I].Active then
      FItemCombo.Items.Add(FItems[I].Code + ' - ' + FItems[I].Name);
  if FItemCombo.Items.Count > 0 then
    FItemCombo.ItemIndex := 0;

  BtnAdd := TButton.Create(Self);
  BtnAdd.Parent := PanelTop;
  BtnAdd.Left := 438;
  BtnAdd.Top := 52;
  BtnAdd.Width := 88;
  BtnAdd.Caption := '라인 추가';
  BtnAdd.OnClick := AddLineClick;

  BtnDelete := TButton.Create(Self);
  BtnDelete.Parent := PanelTop;
  BtnDelete.Left := 536;
  BtnDelete.Top := 52;
  BtnDelete.Width := 88;
  BtnDelete.Caption := '라인 삭제';
  BtnDelete.OnClick := DeleteLineClick;

  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alBottom;
  PanelBottom.Height := 142;
  PanelBottom.BevelOuter := bvNone;

  FSubTotalLabel := TLabel.Create(Self);
  FSubTotalLabel.Parent := PanelBottom;
  FSubTotalLabel.Left := 540;
  FSubTotalLabel.Top := 16;
  FSubTotalLabel.Width := 220;

  FVatLabel := TLabel.Create(Self);
  FVatLabel.Parent := PanelBottom;
  FVatLabel.Left := 540;
  FVatLabel.Top := 42;
  FVatLabel.Width := 220;

  FTotalLabel := TLabel.Create(Self);
  FTotalLabel.Parent := PanelBottom;
  FTotalLabel.Left := 540;
  FTotalLabel.Top := 68;
  FTotalLabel.Width := 220;

  AddLabel('비고', PanelBottom, 16, 12);
  FNoteMemo := TMemo.Create(Self);
  FNoteMemo.Parent := PanelBottom;
  FNoteMemo.Left := 82;
  FNoteMemo.Top := 12;
  FNoteMemo.Width := 420;
  FNoteMemo.Height := 82;
  FNoteMemo.ScrollBars := ssVertical;
  FNoteMemo.Text := FQuote.Note;

  BtnSave := TButton.Create(Self);
  BtnSave.Parent := PanelBottom;
  BtnSave.Left := 612;
  BtnSave.Top := 102;
  BtnSave.Width := 78;
  BtnSave.Caption := '저장';
  BtnSave.OnClick := SaveClick;

  BtnCancel := TButton.Create(Self);
  BtnCancel.Parent := PanelBottom;
  BtnCancel.Left := 700;
  BtnCancel.Top := 102;
  BtnCancel.Width := 78;
  BtnCancel.Caption := '취소';
  BtnCancel.ModalResult := mrCancel;

  FLineGrid := TStringGrid.Create(Self);
  FLineGrid.Parent := Self;
  FLineGrid.Align := alClient;
  FLineGrid.FixedRows := 1;
  FLineGrid.ColCount := 4;
  FLineGrid.RowCount := 2;
  FLineGrid.Options := FLineGrid.Options + [goEditing] - [goRowSelect];
  FLineGrid.OnSetEditText := LineGridSetEditText;
  FLineGrid.OnSelectCell := LineGridSelectCell;
  FLineGrid.Cells[0, 0] := '품목';
  FLineGrid.Cells[1, 0] := '수량';
  FLineGrid.Cells[2, 0] := '단가';
  FLineGrid.Cells[3, 0] := '금액';
  FLineGrid.ColWidths[0] := 360;
  FLineGrid.ColWidths[1] := 110;
  FLineGrid.ColWidths[2] := 130;
  FLineGrid.ColWidths[3] := 140;
end;

procedure TQuoteEditForm.LoadLinesToGrid;
var
  I, Row: Integer;
begin
  FUpdating := True;
  try
    SetLength(FLineItemIds, Length(FQuote.Lines));
    FLineGrid.RowCount := Max(2, Length(FQuote.Lines) + 1);
    for Row := 1 to FLineGrid.RowCount - 1 do
    begin
      FLineGrid.Cells[0, Row] := '';
      FLineGrid.Cells[1, Row] := '';
      FLineGrid.Cells[2, Row] := '';
      FLineGrid.Cells[3, Row] := '';
    end;

    for I := 0 to High(FQuote.Lines) do
    begin
      Row := I + 1;
      FLineItemIds[I] := FQuote.Lines[I].ItemId;
      FLineGrid.Cells[0, Row] := ItemName(FQuote.Lines[I].ItemId);
      FLineGrid.Cells[1, Row] := FormatQty(FQuote.Lines[I].Qty);
      FLineGrid.Cells[2, Row] := FormatMoney(FQuote.Lines[I].UnitPrice);
      FLineGrid.Cells[3, Row] := FormatMoney(FQuote.Lines[I].Amount);
    end;
  finally
    FUpdating := False;
  end;
end;

function TQuoteEditForm.PartnerComboIndex(const APartnerId: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FPartners) do
    if FPartners[I].Id = APartnerId then
      Exit(I);
  if (Result < 0) and (Length(FPartners) > 0) then
    Result := 0;
end;

function TQuoteEditForm.ItemComboIndex(const AItemId: Integer): Integer;
var
  I, VisibleIndex: Integer;
begin
  Result := -1;
  VisibleIndex := 0;
  for I := 0 to High(FItems) do
    if FItems[I].Active then
    begin
      if FItems[I].Id = AItemId then
        Exit(VisibleIndex);
      Inc(VisibleIndex);
    end;
end;

function TQuoteEditForm.ItemName(const AItemId: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(FItems) do
    if FItems[I].Id = AItemId then
      Exit(FItems[I].Code + ' - ' + FItems[I].Name);
end;

function TQuoteEditForm.ParseCurrencyText(const AValue: string;
  out ANumber: Currency): Boolean;
var
  Text: string;
begin
  Text := StringReplace(Trim(AValue), ',', '', [rfReplaceAll]);
  Result := (Text <> '') and TryStrToCurr(Text, ANumber);
end;

function TQuoteEditForm.ParseFloatText(const AValue: string;
  out ANumber: Double): Boolean;
var
  Text: string;
begin
  Text := StringReplace(Trim(AValue), ',', '', [rfReplaceAll]);
  Result := (Text <> '') and TryStrToFloat(Text, ANumber);
end;

procedure TQuoteEditForm.AddLineClick(Sender: TObject);
var
  ItemIndex, RealIndex, I, Row: Integer;
  Line: TQuoteLine;
begin
  if FItemCombo.ItemIndex < 0 then
  begin
    ShowMessage('품목을 선택해 주세요.');
    Exit;
  end;

  ItemIndex := FItemCombo.ItemIndex;
  RealIndex := -1;
  for I := 0 to High(FItems) do
    if FItems[I].Active then
    begin
      if ItemIndex = 0 then
      begin
        RealIndex := I;
        Break;
      end;
      Dec(ItemIndex);
    end;
  if RealIndex < 0 then Exit;

  Line := Default(TQuoteLine);
  Line.ItemId := FItems[RealIndex].Id;
  Line.Qty := 1;
  Line.UnitPrice := FItems[RealIndex].UnitPrice;
  Line.Amount := Line.Qty * Line.UnitPrice;

  SetLength(FQuote.Lines, Length(FQuote.Lines) + 1);
  FQuote.Lines[High(FQuote.Lines)] := Line;
  SetLength(FLineItemIds, Length(FQuote.Lines));
  FLineItemIds[High(FLineItemIds)] := Line.ItemId;

  Row := Length(FQuote.Lines);
  FLineGrid.RowCount := Max(2, Length(FQuote.Lines) + 1);
  FUpdating := True;
  try
    FLineGrid.Cells[0, Row] := ItemName(Line.ItemId);
    FLineGrid.Cells[1, Row] := FormatQty(Line.Qty);
    FLineGrid.Cells[2, Row] := FormatMoney(Line.UnitPrice);
    FLineGrid.Cells[3, Row] := FormatMoney(Line.Amount);
    FLineGrid.Row := Row;
    FLineGrid.Col := 1;
  finally
    FUpdating := False;
  end;
  Recalculate;
end;

procedure TQuoteEditForm.DeleteLineClick(Sender: TObject);
var
  Idx, I: Integer;
begin
  Idx := FLineGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FQuote.Lines)) then
  begin
    ShowMessage('라인을 선택해 주세요.');
    Exit;
  end;

  for I := Idx to High(FQuote.Lines) - 1 do
    FQuote.Lines[I] := FQuote.Lines[I + 1];
  SetLength(FQuote.Lines, Length(FQuote.Lines) - 1);
  LoadLinesToGrid;
  Recalculate;
end;

procedure TQuoteEditForm.LineGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    Exit;
  if ACol in [0, 3] then
    FLineGrid.Options := FLineGrid.Options - [goEditing]
  else
    FLineGrid.Options := FLineGrid.Options + [goEditing];
end;

procedure TQuoteEditForm.LineGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if FUpdating or (ARow <= 0) or (ARow > Length(FQuote.Lines)) then
    Exit;
  if not (ACol in [1, 2]) then
    Exit;
  Recalculate;
end;

procedure TQuoteEditForm.Recalculate;
var
  I, Row: Integer;
  Qty: Double;
  Price: Currency;
begin
  if FUpdating then Exit;

  FUpdating := True;
  try
    FQuote.SubTotal := 0;
    for I := 0 to High(FQuote.Lines) do
    begin
      Row := I + 1;
      if not ParseFloatText(FLineGrid.Cells[1, Row], Qty) then
        Qty := 0;
      if not ParseCurrencyText(FLineGrid.Cells[2, Row], Price) then
        Price := 0;

      FQuote.Lines[I].Qty := Qty;
      FQuote.Lines[I].UnitPrice := Price;
      FQuote.Lines[I].Amount := Qty * Price;
      FQuote.SubTotal := FQuote.SubTotal + FQuote.Lines[I].Amount;
      FLineGrid.Cells[3, Row] := FormatMoney(FQuote.Lines[I].Amount);
    end;

    FQuote.Vat := FQuote.SubTotal * 0.1;
    FQuote.Total := FQuote.SubTotal + FQuote.Vat;
    FSubTotalLabel.Caption := '공급가액: ' + FormatMoney(FQuote.SubTotal);
    FVatLabel.Caption := '부가세(10%): ' + FormatMoney(FQuote.Vat);
    FTotalLabel.Caption := '합계: ' + FormatMoney(FQuote.Total);
  finally
    FUpdating := False;
  end;
end;

procedure TQuoteEditForm.SaveClick(Sender: TObject);
var
  QuoteDate: TDateTime;
begin
  Recalculate;
  if FPartnerCombo.ItemIndex < 0 then
  begin
    ShowMessage('거래처를 선택해 주세요.');
    FPartnerCombo.SetFocus;
    Exit;
  end;

  if not TryStrToDate(FDateEdit.Text, QuoteDate) then
  begin
    ShowMessage('올바른 일자를 입력해 주세요.');
    FDateEdit.SetFocus;
    Exit;
  end;

  if Length(FQuote.Lines) = 0 then
  begin
    ShowMessage('견적 라인을 하나 이상 추가해 주세요.');
    Exit;
  end;

  FQuote.PartnerId := FPartners[FPartnerCombo.ItemIndex].Id;
  FQuote.QuoteDate := QuoteDate;
  FQuote.Note := FNoteMemo.Text;
  if FQuote.QuoteNo = '' then
    FQuote.QuoteNo := NewQuoteNo;
  ModalResult := mrOk;
end;

{ TQuoteView }

constructor TQuoteView.CreateWithData(AOwner: TComponent; const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  BuildUI;
  RefreshGrid;
end;

class procedure TQuoteView.Execute(AOwner: TComponent; const AData: IDataContext);
var
  View: TQuoteView;
begin
  if (AData = nil) or (AData.Quotes = nil) or (AData.Items = nil)
    or (AData.Partners = nil) then
  begin
    ShowMessage('견적 데이터를 사용할 수 없습니다.');
    Exit;
  end;

  View := TQuoteView.CreateWithData(AOwner, AData);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure TQuoteView.BuildUI;
var
  TopPanel, ButtonPanel: TPanel;
  SearchLabel: TLabel;
  BtnNew, BtnEdit, BtnDelete, BtnPreview, BtnClose: TButton;
begin
  Caption := '견적 관리';
  Width := 940;
  Height := 560;
  Position := poOwnerFormCenter;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 48;
  TopPanel.BevelOuter := bvNone;

  SearchLabel := TLabel.Create(Self);
  SearchLabel.Parent := TopPanel;
  SearchLabel.Left := 16;
  SearchLabel.Top := 17;
  SearchLabel.Caption := '검색';

  FSearchEdit := TEdit.Create(Self);
  FSearchEdit.Parent := TopPanel;
  FSearchEdit.Left := 72;
  FSearchEdit.Top := 12;
  FSearchEdit.Width := 280;
  FSearchEdit.OnChange := SearchChanged;

  ButtonPanel := TPanel.Create(Self);
  ButtonPanel.Parent := Self;
  ButtonPanel.Align := alBottom;
  ButtonPanel.Height := 52;
  ButtonPanel.BevelOuter := bvNone;

  BtnNew := TButton.Create(Self);
  BtnNew.Parent := ButtonPanel;
  BtnNew.Left := 16;
  BtnNew.Top := 12;
  BtnNew.Width := 82;
  BtnNew.Caption := '신규';
  BtnNew.OnClick := NewClick;

  BtnEdit := TButton.Create(Self);
  BtnEdit.Parent := ButtonPanel;
  BtnEdit.Left := 106;
  BtnEdit.Top := 12;
  BtnEdit.Width := 82;
  BtnEdit.Caption := '수정';
  BtnEdit.OnClick := EditClick;

  BtnDelete := TButton.Create(Self);
  BtnDelete.Parent := ButtonPanel;
  BtnDelete.Left := 196;
  BtnDelete.Top := 12;
  BtnDelete.Width := 82;
  BtnDelete.Caption := '삭제';
  BtnDelete.OnClick := DeleteClick;

  BtnPreview := TButton.Create(Self);
  BtnPreview.Parent := ButtonPanel;
  BtnPreview.Left := 286;
  BtnPreview.Top := 12;
  BtnPreview.Width := 82;
  BtnPreview.Caption := '미리보기';
  BtnPreview.OnClick := PreviewClick;

  BtnClose := TButton.Create(Self);
  BtnClose.Parent := ButtonPanel;
  BtnClose.Left := 826;
  BtnClose.Top := 12;
  BtnClose.Width := 82;
  BtnClose.Caption := '닫기';
  BtnClose.ModalResult := mrClose;
  BtnClose.Anchors := [akTop, akRight];

  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.FixedRows := 1;
  FGrid.ColCount := 6;
  FGrid.RowCount := 2;
  FGrid.Options := FGrid.Options + [goRowSelect] - [goEditing];
  FGrid.OnDblClick := GridDblClick;
  FGrid.Cells[0, 0] := '견적번호';
  FGrid.Cells[1, 0] := '거래처';
  FGrid.Cells[2, 0] := '일자';
  FGrid.Cells[3, 0] := '공급가액';
  FGrid.Cells[4, 0] := '부가세';
  FGrid.Cells[5, 0] := '합계';
  FGrid.ColWidths[0] := 130;
  FGrid.ColWidths[1] := 220;
  FGrid.ColWidths[2] := 100;
  FGrid.ColWidths[3] := 120;
  FGrid.ColWidths[4] := 110;
  FGrid.ColWidths[5] := 120;
end;

function TQuoteView.PartnerName(const APartnerId: Integer): string;
var
  Partner: TPartner;
begin
  Partner := FData.Partners.GetById(APartnerId);
  Result := Partner.Name;
end;

procedure TQuoteView.RefreshGrid;
var
  Quotes: TQuoteArray;
  I, Row: Integer;
  Keyword, Partner: string;
begin
  Quotes := FData.Quotes.GetAll;
  Keyword := Trim(FSearchEdit.Text);
  SetLength(FRows, 0);

  for I := 0 to High(Quotes) do
  begin
    Partner := PartnerName(Quotes[I].PartnerId);
    if (Keyword = '') or AnsiContainsText(Quotes[I].QuoteNo, Keyword)
      or AnsiContainsText(Partner, Keyword) then
    begin
      SetLength(FRows, Length(FRows) + 1);
      FRows[High(FRows)] := Quotes[I];
    end;
  end;

  FGrid.RowCount := Max(2, Length(FRows) + 1);
  for Row := 1 to FGrid.RowCount - 1 do
  begin
    FGrid.Cells[0, Row] := '';
    FGrid.Cells[1, Row] := '';
    FGrid.Cells[2, Row] := '';
    FGrid.Cells[3, Row] := '';
    FGrid.Cells[4, Row] := '';
    FGrid.Cells[5, Row] := '';
  end;

  for I := 0 to High(FRows) do
  begin
    Row := I + 1;
    FGrid.Cells[0, Row] := FRows[I].QuoteNo;
    FGrid.Cells[1, Row] := PartnerName(FRows[I].PartnerId);
    FGrid.Cells[2, Row] := FormatDateTime('yyyy-mm-dd', FRows[I].QuoteDate);
    FGrid.Cells[3, Row] := FormatMoney(FRows[I].SubTotal);
    FGrid.Cells[4, Row] := FormatMoney(FRows[I].Vat);
    FGrid.Cells[5, Row] := FormatMoney(FRows[I].Total);
  end;
end;

procedure TQuoteView.SearchChanged(Sender: TObject);
begin
  RefreshGrid;
end;

function TQuoteView.SelectedQuote(out AQuote: TQuote): Boolean;
var
  Idx: Integer;
begin
  Result := False;
  AQuote := Default(TQuote);
  Idx := FGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FRows)) then
  begin
    ShowMessage('견적을 선택해 주세요.');
    Exit;
  end;

  AQuote := FRows[Idx];
  Result := True;
end;

function TQuoteView.EditQuote(var AQuote: TQuote; const AIsNew: Boolean): Boolean;
var
  Form: TQuoteEditForm;
begin
  Form := TQuoteEditForm.CreateWithQuote(Self, FData, AQuote, AIsNew);
  try
    Result := Form.ShowModal = mrOk;
    if Result then
      AQuote := Form.Quote;
  finally
    Form.Free;
  end;
end;

procedure TQuoteView.NewClick(Sender: TObject);
var
  Quote: TQuote;
begin
  Quote := Default(TQuote);
  Quote.QuoteDate := Date;
  if not EditQuote(Quote, True) then Exit;
  FData.Quotes.Add(Quote);
  RefreshGrid;
end;

procedure TQuoteView.EditClick(Sender: TObject);
var
  Quote: TQuote;
begin
  if not SelectedQuote(Quote) then Exit;
  if not EditQuote(Quote, False) then Exit;
  FData.Quotes.Update(Quote);
  RefreshGrid;
end;

procedure TQuoteView.DeleteClick(Sender: TObject);
var
  Quote: TQuote;
begin
  if not SelectedQuote(Quote) then Exit;
  if MessageDlg('견적 삭제', '선택한 견적을 삭제하시겠습니까?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  FData.Quotes.Delete(Quote.Id);
  RefreshGrid;
end;

procedure TQuoteView.PreviewClick(Sender: TObject);
var
  Quote: TQuote;
  Lines: TStringList;
  I: Integer;
begin
  if not SelectedQuote(Quote) then Exit;

  Lines := TStringList.Create;
  try
    Lines.Add('견적번호: ' + Quote.QuoteNo);
    Lines.Add('거래처: ' + PartnerName(Quote.PartnerId));
    Lines.Add('일자: ' + FormatDateTime('yyyy-mm-dd', Quote.QuoteDate));
    Lines.Add('');
    for I := 0 to High(Quote.Lines) do
      Lines.Add(Format('%s  수량 %s  단가 %s  금액 %s',
        [FData.Items.GetById(Quote.Lines[I].ItemId).Name,
         FormatQty(Quote.Lines[I].Qty),
         FormatMoney(Quote.Lines[I].UnitPrice),
         FormatMoney(Quote.Lines[I].Amount)]));
    Lines.Add('');
    Lines.Add('공급가액: ' + FormatMoney(Quote.SubTotal));
    Lines.Add('부가세(10%): ' + FormatMoney(Quote.Vat));
    Lines.Add('합계: ' + FormatMoney(Quote.Total));
    if Trim(Quote.Note) <> '' then
    begin
      Lines.Add('');
      Lines.Add('비고: ' + Quote.Note);
    end;
    ShowMessage(Lines.Text);
  finally
    Lines.Free;
  end;
end;

procedure TQuoteView.GridDblClick(Sender: TObject);
begin
  EditClick(Sender);
end;

end.
