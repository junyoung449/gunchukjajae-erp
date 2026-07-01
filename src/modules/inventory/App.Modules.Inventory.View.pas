unit App.Modules.Inventory.View;

{ 재고 관리 화면. .lfm 없이 코드로 컨트롤을 생성한다. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Math, Forms, Controls, StdCtrls, ExtCtrls, Grids,
  Dialogs, Graphics, App.Core.Contracts, App.Core.Entities;

type
  TInventoryView = class(TForm)
  private
    FData: IDataContext;
    FItems: TItemArray;
    FItemCombo: TComboBox;
    FKindCombo: TComboBox;
    FQtyEdit: TEdit;
    FRefEdit: TEdit;
    FStockGrid: TStringGrid;
    FMoveGrid: TStringGrid;
    FWarningLabel: TLabel;
    procedure BuildUI;
    procedure RefreshAll;
    procedure RefreshItemCombo;
    procedure RefreshStockGrid;
    procedure RefreshMoveGrid;
    procedure RegisterClick(Sender: TObject);
    function SelectedItemId: Integer;
    function ItemComboText(const AItem: TItem): string;
    function ItemName(const AItemId: Integer): string;
    function MoveKind: TStockMoveKind;
    function ParseQty(out AQty: Double): Boolean;
    function StockDelta(const AQty: Double; const AKind: TStockMoveKind): Double;
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext);
    class procedure Execute(AOwner: TComponent; const AData: IDataContext);
  end;

implementation

function FormatQty(const AQty: Double): string;
begin
  Result := FormatFloat('#,##0.###', AQty);
end;

function StockMoveKindText(const AKind: TStockMoveKind): string;
begin
  case AKind of
    smkIn: Result := '입고';
    smkOut: Result := '출고';
  else
    Result := '조정';
  end;
end;

{ TInventoryView }

constructor TInventoryView.CreateWithData(AOwner: TComponent;
  const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  BuildUI;
  RefreshAll;
end;

class procedure TInventoryView.Execute(AOwner: TComponent;
  const AData: IDataContext);
var
  View: TInventoryView;
begin
  if AData = nil then
  begin
    ShowMessage('재고 모듈에 필요한 데이터 컨텍스트를 사용할 수 없습니다.');
    Exit;
  end;

  if (AData.Items = nil) or (AData.Inventory = nil) then
  begin
    ShowMessage('재고 모듈에 필요한 저장소를 사용할 수 없습니다.');
    Exit;
  end;

  View := TInventoryView.CreateWithData(AOwner, AData);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure TInventoryView.BuildUI;
var
  TopPanel, EntryPanel, BottomPanel: TPanel;
  Lbl: TLabel;
  BtnApply, BtnClose: TButton;
begin
  Caption := '재고 관리';
  Width := 980;
  Height := 640;
  Position := poOwnerFormCenter;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 34;
  TopPanel.BevelOuter := bvNone;

  FWarningLabel := TLabel.Create(Self);
  FWarningLabel.Parent := TopPanel;
  FWarningLabel.Left := 16;
  FWarningLabel.Top := 9;
  FWarningLabel.Font.Color := clRed;
  FWarningLabel.Font.Style := [fsBold];

  EntryPanel := TPanel.Create(Self);
  EntryPanel.Parent := Self;
  EntryPanel.Align := alTop;
  EntryPanel.Height := 92;
  EntryPanel.BevelOuter := bvNone;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := EntryPanel;
  Lbl.Left := 16;
  Lbl.Top := 18;
  Lbl.Caption := '품목';

  FItemCombo := TComboBox.Create(Self);
  FItemCombo.Parent := EntryPanel;
  FItemCombo.Left := 54;
  FItemCombo.Top := 13;
  FItemCombo.Width := 280;
  FItemCombo.Style := csDropDownList;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := EntryPanel;
  Lbl.Left := 352;
  Lbl.Top := 18;
  Lbl.Caption := '구분';

  FKindCombo := TComboBox.Create(Self);
  FKindCombo.Parent := EntryPanel;
  FKindCombo.Left := 392;
  FKindCombo.Top := 13;
  FKindCombo.Width := 90;
  FKindCombo.Style := csDropDownList;
  FKindCombo.Items.Add('입고');
  FKindCombo.Items.Add('출고');
  FKindCombo.Items.Add('조정');
  FKindCombo.ItemIndex := 0;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := EntryPanel;
  Lbl.Left := 502;
  Lbl.Top := 18;
  Lbl.Caption := '수량';

  FQtyEdit := TEdit.Create(Self);
  FQtyEdit.Parent := EntryPanel;
  FQtyEdit.Left := 542;
  FQtyEdit.Top := 13;
  FQtyEdit.Width := 90;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := EntryPanel;
  Lbl.Left := 16;
  Lbl.Top := 57;
  Lbl.Caption := '참조번호';

  FRefEdit := TEdit.Create(Self);
  FRefEdit.Parent := EntryPanel;
  FRefEdit.Left := 84;
  FRefEdit.Top := 52;
  FRefEdit.Width := 220;

  BtnApply := TButton.Create(Self);
  BtnApply.Parent := EntryPanel;
  BtnApply.Left := 320;
  BtnApply.Top := 52;
  BtnApply.Width := 120;
  BtnApply.Caption := '적용';
  BtnApply.Default := True;
  BtnApply.OnClick := RegisterClick;
  BtnApply.Anchors := [akTop, akLeft];

  FStockGrid := TStringGrid.Create(Self);
  FStockGrid.Parent := Self;
  FStockGrid.Align := alClient;
  FStockGrid.FixedRows := 1;
  FStockGrid.ColCount := 6;
  FStockGrid.RowCount := 2;
  FStockGrid.Options := FStockGrid.Options + [goRowSelect] - [goEditing];
  FStockGrid.Cells[0, 0] := '품목코드';
  FStockGrid.Cells[1, 0] := '품목명';
  FStockGrid.Cells[2, 0] := '규격';
  FStockGrid.Cells[3, 0] := '단위';
  FStockGrid.Cells[4, 0] := '현재고';
  FStockGrid.Cells[5, 0] := '상태';
  FStockGrid.ColWidths[0] := 100;
  FStockGrid.ColWidths[1] := 270;
  FStockGrid.ColWidths[2] := 210;
  FStockGrid.ColWidths[3] := 80;
  FStockGrid.ColWidths[4] := 100;
  FStockGrid.ColWidths[5] := 110;

  FMoveGrid := TStringGrid.Create(Self);
  FMoveGrid.Parent := Self;
  FMoveGrid.Align := alBottom;
  FMoveGrid.Height := 152;
  FMoveGrid.FixedRows := 1;
  FMoveGrid.ColCount := 5;
  FMoveGrid.RowCount := 2;
  FMoveGrid.Options := FMoveGrid.Options + [goRowSelect] - [goEditing];
  FMoveGrid.Cells[0, 0] := '일시';
  FMoveGrid.Cells[1, 0] := '구분';
  FMoveGrid.Cells[2, 0] := '품목';
  FMoveGrid.Cells[3, 0] := '수량';
  FMoveGrid.Cells[4, 0] := '참조번호';
  FMoveGrid.ColWidths[0] := 150;
  FMoveGrid.ColWidths[1] := 70;
  FMoveGrid.ColWidths[2] := 310;
  FMoveGrid.ColWidths[3] := 90;
  FMoveGrid.ColWidths[4] := 160;

  BottomPanel := TPanel.Create(Self);
  BottomPanel.Parent := Self;
  BottomPanel.Align := alBottom;
  BottomPanel.Height := 52;
  BottomPanel.BevelOuter := bvNone;

  BtnApply := TButton.Create(Self);
  BtnApply.Parent := BottomPanel;
  BtnApply.Left := 610;
  BtnApply.Top := 12;
  BtnApply.Width := 100;
  BtnApply.Caption := '적용';
  BtnApply.OnClick := RegisterClick;
  BtnApply.Anchors := [akTop, akRight];

  BtnClose := TButton.Create(Self);
  BtnClose.Parent := BottomPanel;
  BtnClose.Left := 722;
  BtnClose.Top := 12;
  BtnClose.Width := 78;
  BtnClose.Caption := '닫기';
  BtnClose.ModalResult := mrClose;
  BtnClose.Anchors := [akTop, akRight];
end;

procedure TInventoryView.RefreshAll;
begin
  FItems := FData.Items.GetAll;
  RefreshItemCombo;
  RefreshStockGrid;
  RefreshMoveGrid;
end;

procedure TInventoryView.RefreshItemCombo;
var
  I, OldItemId: Integer;
begin
  OldItemId := SelectedItemId;
  FItemCombo.Items.BeginUpdate;
  try
    FItemCombo.Items.Clear;
    for I := 0 to High(FItems) do
      if FItems[I].Active then
        FItemCombo.Items.Add(ItemComboText(FItems[I]));
  finally
    FItemCombo.Items.EndUpdate;
  end;

  FItemCombo.ItemIndex := 0;
  if OldItemId <> 0 then
    for I := 0 to High(FItems) do
      if (FItems[I].Active) and (FItems[I].Id = OldItemId) then
      begin
        FItemCombo.ItemIndex := FItemCombo.Items.IndexOf(ItemComboText(FItems[I]));
        Break;
      end;
end;

procedure TInventoryView.RefreshStockGrid;
var
  I, Col, Row, NegativeCount: Integer;
  Stock: Double;
begin
  FStockGrid.RowCount := Max(2, Length(FItems) + 1);
  for Row := 1 to FStockGrid.RowCount - 1 do
    for Col := 0 to FStockGrid.ColCount - 1 do
      FStockGrid.Cells[Col, Row] := '';

  NegativeCount := 0;
  for I := 0 to High(FItems) do
  begin
    Row := I + 1;
    Stock := FData.Inventory.GetStock(FItems[I].Id);
    FStockGrid.Cells[0, Row] := FItems[I].Code;
    FStockGrid.Cells[1, Row] := FItems[I].Name;
    FStockGrid.Cells[2, Row] := FItems[I].Spec;
    FStockGrid.Cells[3, Row] := FItems[I].UnitName;
    FStockGrid.Cells[4, Row] := FormatQty(Stock);
    if Stock < 0 then
    begin
      FStockGrid.Cells[5, Row] := '음수 경고';
      Inc(NegativeCount);
    end
    else
      FStockGrid.Cells[5, Row] := '정상';
  end;

  if NegativeCount > 0 then
    FWarningLabel.Caption := Format('음수 재고 품목 %d건이 있습니다.', [NegativeCount])
  else
    FWarningLabel.Caption := '';
end;

procedure TInventoryView.RefreshMoveGrid;
var
  Moves: TStockMoveArray;
  I, Col, Row, SourceIndex: Integer;
begin
  Moves := FData.Inventory.GetMoves;
  FMoveGrid.RowCount := Max(2, Length(Moves) + 1);
  for Row := 1 to FMoveGrid.RowCount - 1 do
    for Col := 0 to FMoveGrid.ColCount - 1 do
      FMoveGrid.Cells[Col, Row] := '';

  for I := 0 to High(Moves) do
  begin
    SourceIndex := High(Moves) - I;
    Row := I + 1;
    FMoveGrid.Cells[0, Row] :=
      FormatDateTime('yyyy-mm-dd hh:nn', Moves[SourceIndex].MovedAt);
    FMoveGrid.Cells[1, Row] := StockMoveKindText(Moves[SourceIndex].Kind);
    FMoveGrid.Cells[2, Row] := ItemName(Moves[SourceIndex].ItemId);
    FMoveGrid.Cells[3, Row] := FormatQty(Moves[SourceIndex].Qty);
    FMoveGrid.Cells[4, Row] := Moves[SourceIndex].RefNo;
  end;
end;

procedure TInventoryView.RegisterClick(Sender: TObject);
var
  ItemId: Integer;
  Qty, CurrentStock, NextStock: Double;
  Kind: TStockMoveKind;
begin
  ItemId := SelectedItemId;
  if ItemId = 0 then
  begin
    ShowMessage('품목을 선택해 주세요.');
    FItemCombo.SetFocus;
    Exit;
  end;

  if not ParseQty(Qty) then
  begin
    FQtyEdit.SetFocus;
    Exit;
  end;

  Kind := MoveKind;
  if (Kind <> smkAdjust) and (Qty <= 0) then
  begin
    ShowMessage('입고/출고 수량은 0보다 커야 합니다.');
    FQtyEdit.SetFocus;
    Exit;
  end;

  if (Kind = smkAdjust) and (Qty = 0) then
  begin
    ShowMessage('조정 수량은 0이 아니어야 합니다.');
    FQtyEdit.SetFocus;
    Exit;
  end;

  CurrentStock := FData.Inventory.GetStock(ItemId);
  NextStock := CurrentStock + StockDelta(Qty, Kind);
  if NextStock < 0 then
    if MessageDlg('음수 재고 경고',
      Format('등록 후 현재고가 %s이 됩니다. 계속 등록하시겠습니까?',
        [FormatQty(NextStock)]), mtWarning, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  FData.Inventory.Move(ItemId, Qty, Kind, Trim(FRefEdit.Text));
  FQtyEdit.Text := '';
  FRefEdit.Text := '';
  RefreshAll;
end;

function TInventoryView.SelectedItemId: Integer;
var
  ComboIndex, ActiveIndex, I: Integer;
begin
  Result := 0;
  ComboIndex := FItemCombo.ItemIndex;
  if ComboIndex < 0 then Exit;

  ActiveIndex := -1;
  for I := 0 to High(FItems) do
    if FItems[I].Active then
    begin
      Inc(ActiveIndex);
      if ActiveIndex = ComboIndex then
        Exit(FItems[I].Id);
    end;
end;

function TInventoryView.ItemComboText(const AItem: TItem): string;
begin
  Result := Format('%s - %s', [AItem.Code, AItem.Name]);
end;

function TInventoryView.ItemName(const AItemId: Integer): string;
var
  I: Integer;
begin
  for I := 0 to High(FItems) do
    if FItems[I].Id = AItemId then
      Exit(FItems[I].Name);
  Result := '#' + IntToStr(AItemId);
end;

function TInventoryView.MoveKind: TStockMoveKind;
begin
  case FKindCombo.ItemIndex of
    1: Result := smkOut;
    2: Result := smkAdjust;
  else
    Result := smkIn;
  end;
end;

function TInventoryView.ParseQty(out AQty: Double): Boolean;
var
  TextValue: string;
begin
  TextValue := StringReplace(Trim(FQtyEdit.Text), ',', '', [rfReplaceAll]);
  Result := (TextValue <> '') and TryStrToFloat(TextValue, AQty);
  if not Result then
    ShowMessage('수량은 숫자로 입력해야 합니다.');
end;

function TInventoryView.StockDelta(const AQty: Double;
  const AKind: TStockMoveKind): Double;
begin
  case AKind of
    smkIn: Result := AQty;
    smkOut: Result := -AQty;
  else
    Result := AQty;
  end;
end;

end.
