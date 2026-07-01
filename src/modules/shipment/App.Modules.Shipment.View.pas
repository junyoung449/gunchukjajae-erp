unit App.Modules.Shipment.View;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Math, Forms, Controls, StdCtrls, ExtCtrls, Grids, Dialogs,
  App.Core.Contracts, App.Core.Entities;

type
  TShipmentView = class(TForm)
  private
    FData: IDataContext;
    FRows: TShipmentArray;
    FGrid: TStringGrid;
    procedure BuildUI;
    procedure RefreshGrid;
    procedure NewClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    function SelectedShipment(out AShipment: TShipment): Boolean;
    function PartnerName(const APartnerId: Integer): string;
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext);
    class procedure Execute(AOwner: TComponent; const AData: IDataContext);
  end;

implementation

type
  TShipmentEditForm = class(TForm)
  private
    FData: IDataContext;
    FPartners: TPartnerArray;
    FItems: TItemArray;
    FShipment: TShipment;
    FPartnerCombo: TComboBox;
    FItemCombo: TComboBox;
    FQtyEdit: TEdit;
    FNoteEdit: TEdit;
    FLineGrid: TStringGrid;
    FTotalLabel: TLabel;
    procedure BuildUI;
    procedure AddLabel(const ACaption: string; const ALeft, ATop: Integer);
    procedure AddLineClick(Sender: TObject);
    procedure DeleteLineClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure RefreshLineGrid;
    procedure RecalcTotal;
    function ItemAt(const AIndex: Integer): TItem;
    function PartnerAt(const AIndex: Integer): TPartner;
    function FindItemName(const AItemId: Integer): string;
    function StockWarningAccepted: Boolean;
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext);
    property Shipment: TShipment read FShipment;
  end;

function FormatMoney(const AValue: Currency): string;
begin
  Result := FormatFloat('#,##0.##', AValue);
end;

function FormatQty(const AValue: Double): string;
begin
  Result := FormatFloat('#,##0.###', AValue);
end;

function ParseQty(const AText: string; out AQty: Double): Boolean;
var
  Text: string;
begin
  Text := StringReplace(Trim(AText), ',', '', [rfReplaceAll]);
  Result := (Text <> '') and TryStrToFloat(Text, AQty);
end;

{ TShipmentEditForm }

constructor TShipmentEditForm.CreateWithData(AOwner: TComponent;
  const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  FPartners := FData.Partners.GetByKind(pkCustomer);
  FItems := FData.Items.GetAll;
  FShipment := Default(TShipment);
  FShipment.ShipDate := Now;
  BuildUI;
  RefreshLineGrid;
end;

procedure TShipmentEditForm.AddLabel(const ACaption: string; const ALeft,
  ATop: Integer);
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(Self);
  Lbl.Parent := Self;
  Lbl.Left := ALeft;
  Lbl.Top := ATop + 4;
  Lbl.Caption := ACaption;
end;

procedure TShipmentEditForm.BuildUI;
var
  BtnAdd, BtnDelete, BtnSave, BtnCancel: TButton;
  I: Integer;
begin
  Caption := '출고 등록';
  Width := 720;
  Height := 470;
  BorderStyle := bsDialog;
  Position := poOwnerFormCenter;

  AddLabel('거래처', 18, 20);
  FPartnerCombo := TComboBox.Create(Self);
  FPartnerCombo.Parent := Self;
  FPartnerCombo.Left := 92;
  FPartnerCombo.Top := 18;
  FPartnerCombo.Width := 260;
  FPartnerCombo.Style := csDropDownList;
  for I := 0 to High(FPartners) do
    if FPartners[I].Active then
      FPartnerCombo.Items.Add(FPartners[I].Code + ' - ' + FPartners[I].Name);
  if FPartnerCombo.Items.Count > 0 then
    FPartnerCombo.ItemIndex := 0;

  AddLabel('품목', 18, 62);
  FItemCombo := TComboBox.Create(Self);
  FItemCombo.Parent := Self;
  FItemCombo.Left := 92;
  FItemCombo.Top := 60;
  FItemCombo.Width := 360;
  FItemCombo.Style := csDropDownList;
  for I := 0 to High(FItems) do
    if FItems[I].Active then
      FItemCombo.Items.Add(FItems[I].Code + ' - ' + FItems[I].Name +
        ' (' + FormatMoney(FItems[I].UnitPrice) + ')');
  if FItemCombo.Items.Count > 0 then
    FItemCombo.ItemIndex := 0;

  AddLabel('수량', 470, 62);
  FQtyEdit := TEdit.Create(Self);
  FQtyEdit.Parent := Self;
  FQtyEdit.Left := 510;
  FQtyEdit.Top := 60;
  FQtyEdit.Width := 80;

  BtnAdd := TButton.Create(Self);
  BtnAdd.Parent := Self;
  BtnAdd.Left := 604;
  BtnAdd.Top := 58;
  BtnAdd.Width := 80;
  BtnAdd.Caption := '라인 추가';
  BtnAdd.OnClick := AddLineClick;

  FLineGrid := TStringGrid.Create(Self);
  FLineGrid.Parent := Self;
  FLineGrid.Left := 18;
  FLineGrid.Top := 102;
  FLineGrid.Width := 666;
  FLineGrid.Height := 220;
  FLineGrid.FixedRows := 1;
  FLineGrid.ColCount := 6;
  FLineGrid.RowCount := 2;
  FLineGrid.Options := FLineGrid.Options + [goRowSelect] - [goEditing];
  FLineGrid.Cells[0, 0] := '품목코드';
  FLineGrid.Cells[1, 0] := '품명';
  FLineGrid.Cells[2, 0] := '수량';
  FLineGrid.Cells[3, 0] := '단위';
  FLineGrid.Cells[4, 0] := '단가';
  FLineGrid.Cells[5, 0] := '금액';
  FLineGrid.ColWidths[0] := 90;
  FLineGrid.ColWidths[1] := 210;
  FLineGrid.ColWidths[2] := 70;
  FLineGrid.ColWidths[3] := 70;
  FLineGrid.ColWidths[4] := 95;
  FLineGrid.ColWidths[5] := 100;

  BtnDelete := TButton.Create(Self);
  BtnDelete.Parent := Self;
  BtnDelete.Left := 18;
  BtnDelete.Top := 332;
  BtnDelete.Width := 100;
  BtnDelete.Caption := '라인 삭제';
  BtnDelete.OnClick := DeleteLineClick;

  FTotalLabel := TLabel.Create(Self);
  FTotalLabel.Parent := Self;
  FTotalLabel.Left := 480;
  FTotalLabel.Top := 338;
  FTotalLabel.Width := 200;
  FTotalLabel.Alignment := taRightJustify;

  AddLabel('비고', 18, 368);
  FNoteEdit := TEdit.Create(Self);
  FNoteEdit.Parent := Self;
  FNoteEdit.Left := 92;
  FNoteEdit.Top := 366;
  FNoteEdit.Width := 400;

  BtnSave := TButton.Create(Self);
  BtnSave.Parent := Self;
  BtnSave.Left := 516;
  BtnSave.Top := 398;
  BtnSave.Width := 78;
  BtnSave.Caption := '저장';
  BtnSave.OnClick := SaveClick;

  BtnCancel := TButton.Create(Self);
  BtnCancel.Parent := Self;
  BtnCancel.Left := 606;
  BtnCancel.Top := 398;
  BtnCancel.Width := 78;
  BtnCancel.Caption := '취소';
  BtnCancel.ModalResult := mrCancel;
end;

function TShipmentEditForm.ItemAt(const AIndex: Integer): TItem;
var
  Count, I: Integer;
begin
  Count := -1;
  Result := Default(TItem);
  for I := 0 to High(FItems) do
    if FItems[I].Active then
    begin
      Inc(Count);
      if Count = AIndex then
        Exit(FItems[I]);
    end;
end;

function TShipmentEditForm.PartnerAt(const AIndex: Integer): TPartner;
var
  Count, I: Integer;
begin
  Count := -1;
  Result := Default(TPartner);
  for I := 0 to High(FPartners) do
    if FPartners[I].Active then
    begin
      Inc(Count);
      if Count = AIndex then
        Exit(FPartners[I]);
    end;
end;

function TShipmentEditForm.FindItemName(const AItemId: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(FItems) do
    if FItems[I].Id = AItemId then
      Exit(FItems[I].Name);
end;

procedure TShipmentEditForm.AddLineClick(Sender: TObject);
var
  Item: TItem;
  Line: TShipmentLine;
  Qty: Double;
begin
  if FItemCombo.ItemIndex < 0 then
  begin
    ShowMessage('품목을 선택하세요.');
    Exit;
  end;

  if (not ParseQty(FQtyEdit.Text, Qty)) or (Qty <= 0) then
  begin
    ShowMessage('0보다 큰 수량을 입력하세요.');
    FQtyEdit.SetFocus;
    Exit;
  end;

  Item := ItemAt(FItemCombo.ItemIndex);
  Line := Default(TShipmentLine);
  Line.ItemId := Item.Id;
  Line.Qty := Qty;
  Line.UnitPrice := Item.UnitPrice;
  Line.Amount := Line.UnitPrice * Line.Qty;
  SetLength(FShipment.Lines, Length(FShipment.Lines) + 1);
  FShipment.Lines[High(FShipment.Lines)] := Line;
  FQtyEdit.Clear;
  RefreshLineGrid;
end;

procedure TShipmentEditForm.DeleteLineClick(Sender: TObject);
var
  Idx, I: Integer;
begin
  Idx := FLineGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FShipment.Lines)) then
  begin
    ShowMessage('라인을 선택하세요.');
    Exit;
  end;

  for I := Idx to High(FShipment.Lines) - 1 do
    FShipment.Lines[I] := FShipment.Lines[I + 1];
  SetLength(FShipment.Lines, Length(FShipment.Lines) - 1);
  RefreshLineGrid;
end;

procedure TShipmentEditForm.RefreshLineGrid;
var
  Row, I, J: Integer;
  Item: TItem;
begin
  FLineGrid.RowCount := Max(2, Length(FShipment.Lines) + 1);
  for Row := 1 to FLineGrid.RowCount - 1 do
    for J := 0 to FLineGrid.ColCount - 1 do
      FLineGrid.Cells[J, Row] := '';

  for I := 0 to High(FShipment.Lines) do
  begin
    Row := I + 1;
    Item := FData.Items.GetById(FShipment.Lines[I].ItemId);
    FLineGrid.Cells[0, Row] := Item.Code;
    FLineGrid.Cells[1, Row] := Item.Name;
    FLineGrid.Cells[2, Row] := FormatQty(FShipment.Lines[I].Qty);
    FLineGrid.Cells[3, Row] := Item.UnitName;
    FLineGrid.Cells[4, Row] := FormatMoney(FShipment.Lines[I].UnitPrice);
    FLineGrid.Cells[5, Row] := FormatMoney(FShipment.Lines[I].Amount);
  end;
  RecalcTotal;
end;

procedure TShipmentEditForm.RecalcTotal;
var
  I: Integer;
begin
  FShipment.Total := 0;
  for I := 0 to High(FShipment.Lines) do
    FShipment.Total := FShipment.Total + FShipment.Lines[I].Amount;
  FTotalLabel.Caption := '합계: ' + FormatMoney(FShipment.Total);
end;

function TShipmentEditForm.StockWarningAccepted: Boolean;
var
  I, J: Integer;
  ItemId: Integer;
  NeedQty, StockQty: Double;
  Msg: string;
  AlreadyChecked: Boolean;
begin
  Result := True;
  Msg := '';
  for I := 0 to High(FShipment.Lines) do
  begin
    ItemId := FShipment.Lines[I].ItemId;
    AlreadyChecked := False;
    for J := 0 to I - 1 do
      if FShipment.Lines[J].ItemId = ItemId then
      begin
        AlreadyChecked := True;
        Break;
      end;
    if AlreadyChecked then
      Continue;

    NeedQty := 0;
    for J := 0 to High(FShipment.Lines) do
      if FShipment.Lines[J].ItemId = ItemId then
        NeedQty := NeedQty + FShipment.Lines[J].Qty;

    StockQty := FData.Inventory.GetStock(ItemId);
    if NeedQty > StockQty then
      Msg := Msg + Format('%s: stock %s, ship %s',
        [FindItemName(ItemId), FormatQty(StockQty), FormatQty(NeedQty)]) +
        LineEnding;
  end;

  if Msg <> '' then
    Result := MessageDlg('재고 부족 경고',
      '일부 품목의 현재 재고가 출고 수량보다 부족합니다.' +
      LineEnding + LineEnding + Msg + LineEnding + '그래도 저장할까요?',
      mtWarning, [mbYes, mbNo], 0) = mrYes
  else
    Result := True;
end;

procedure TShipmentEditForm.SaveClick(Sender: TObject);
var
  Partner: TPartner;
begin
  if FPartnerCombo.ItemIndex < 0 then
  begin
    ShowMessage('거래처를 선택하세요.');
    Exit;
  end;

  if Length(FShipment.Lines) = 0 then
  begin
    ShowMessage('출고 라인을 하나 이상 추가하세요.');
    Exit;
  end;

  if not StockWarningAccepted then
    Exit;

  Partner := PartnerAt(FPartnerCombo.ItemIndex);
  FShipment.PartnerId := Partner.Id;
  FShipment.ShipNo := 'SH' + FormatDateTime('yyyymmddhhnnss', Now);
  FShipment.ShipDate := Now;
  FShipment.Note := Trim(FNoteEdit.Text);
  RecalcTotal;
  ModalResult := mrOk;
end;

{ TShipmentView }

constructor TShipmentView.CreateWithData(AOwner: TComponent;
  const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  BuildUI;
  RefreshGrid;
end;

class procedure TShipmentView.Execute(AOwner: TComponent;
  const AData: IDataContext);
var
  View: TShipmentView;
begin
  if (AData = nil) or (AData.Shipments = nil) then
  begin
    ShowMessage('출고 저장소를 사용할 수 없습니다.');
    Exit;
  end;

  View := TShipmentView.CreateWithData(AOwner, AData);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure TShipmentView.BuildUI;
var
  ButtonPanel: TPanel;
  BtnNew, BtnDelete, BtnClose: TButton;
begin
  Caption := '출고';
  Width := 860;
  Height := 540;
  Position := poOwnerFormCenter;

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

  BtnDelete := TButton.Create(Self);
  BtnDelete.Parent := ButtonPanel;
  BtnDelete.Left := 106;
  BtnDelete.Top := 12;
  BtnDelete.Width := 82;
  BtnDelete.Caption := '삭제';
  BtnDelete.OnClick := DeleteClick;

  BtnClose := TButton.Create(Self);
  BtnClose.Parent := ButtonPanel;
  BtnClose.Left := 746;
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
  FGrid.Cells[0, 0] := '출고번호';
  FGrid.Cells[1, 0] := '거래처';
  FGrid.Cells[2, 0] := '일자';
  FGrid.Cells[3, 0] := '라인수';
  FGrid.Cells[4, 0] := '합계';
  FGrid.Cells[5, 0] := '비고';
  FGrid.ColWidths[0] := 130;
  FGrid.ColWidths[1] := 220;
  FGrid.ColWidths[2] := 130;
  FGrid.ColWidths[3] := 70;
  FGrid.ColWidths[4] := 120;
  FGrid.ColWidths[5] := 160;
end;

procedure TShipmentView.RefreshGrid;
var
  Row, I, J: Integer;
begin
  FRows := FData.Shipments.GetAll;
  FGrid.RowCount := Max(2, Length(FRows) + 1);
  for Row := 1 to FGrid.RowCount - 1 do
    for J := 0 to FGrid.ColCount - 1 do
      FGrid.Cells[J, Row] := '';

  for I := 0 to High(FRows) do
  begin
    Row := I + 1;
    FGrid.Cells[0, Row] := FRows[I].ShipNo;
    FGrid.Cells[1, Row] := PartnerName(FRows[I].PartnerId);
    FGrid.Cells[2, Row] := FormatDateTime('yyyy-mm-dd hh:nn', FRows[I].ShipDate);
    FGrid.Cells[3, Row] := IntToStr(Length(FRows[I].Lines));
    FGrid.Cells[4, Row] := FormatMoney(FRows[I].Total);
    FGrid.Cells[5, Row] := FRows[I].Note;
  end;
end;

function TShipmentView.PartnerName(const APartnerId: Integer): string;
var
  Partner: TPartner;
begin
  Partner := FData.Partners.GetById(APartnerId);
  Result := Partner.Name;
end;

function TShipmentView.SelectedShipment(out AShipment: TShipment): Boolean;
var
  Idx: Integer;
begin
  Result := False;
  AShipment := Default(TShipment);
  Idx := FGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FRows)) then
  begin
    ShowMessage('출고 건을 선택하세요.');
    Exit;
  end;

  AShipment := FRows[Idx];
  Result := True;
end;

procedure TShipmentView.NewClick(Sender: TObject);
var
  Form: TShipmentEditForm;
begin
  Form := TShipmentEditForm.CreateWithData(Self, FData);
  try
    if Form.ShowModal = mrOk then
    begin
      FData.Shipments.Add(Form.Shipment);
      RefreshGrid;
    end;
  finally
    Form.Free;
  end;
end;

procedure TShipmentView.DeleteClick(Sender: TObject);
var
  Shipment: TShipment;
begin
  if not SelectedShipment(Shipment) then
    Exit;

  if MessageDlg('출고 삭제',
    '선택한 출고 건을 삭제할까요? 재고 이동 내역은 되돌리지 않습니다.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  FData.Shipments.Delete(Shipment.Id);
  RefreshGrid;
end;

end.
