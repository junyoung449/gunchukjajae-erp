unit App.Modules.History.View;

{ 이력 조회 화면. 데이터 컨텍스트의 저장소 인터페이스만 읽고 결과를 표시한다. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Math, Forms, Controls, StdCtrls, ExtCtrls, Grids, Dialogs,
  App.Core.Contracts, App.Core.Entities;

type
  THistoryView = class(TForm)
  private
    FData: IDataContext;
    FRows: THistoryRowArray;
    FPartners: TPartnerArray;
    FItems: TItemArray;
    FFromEdit: TEdit;
    FToEdit: TEdit;
    FPartnerCombo: TComboBox;
    FItemCombo: TComboBox;
    FKindCombo: TComboBox;
    FGrid: TStringGrid;
    procedure BuildUI;
    procedure LoadFilters;
    procedure RefreshGrid;
    procedure FilterChanged(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    function BuildFilter(out AFilter: THistoryFilter): Boolean;
    function SelectedPartnerId: Integer;
    function SelectedPartnerName: string;
    function SelectedItemId: Integer;
    function SelectedItemName: string;
    procedure SortRowsByDateDesc;
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext);
    class procedure Execute(AOwner: TComponent; const AData: IDataContext);
  end;

implementation

const
  DATE_HINT = 'yyyy-mm-dd';

function HistoryKindText(const AKind: THistoryKind): string;
begin
  case AKind of
    hkStockMove: Result := '재고이동';
    hkShipment:  Result := '출고';
  else
    Result := '견적';
  end;
end;

function ParseIsoDate(const AText: string; out ADate: TDateTime): Boolean;
var
  Y, M, D: Word;
  YInt, MInt, DInt: Integer;
  Text: string;
begin
  Result := False;
  ADate := 0;
  Text := Trim(AText);
  if Text = '' then
    Exit(True);

  if (Length(Text) <> 10) or (Text[5] <> '-') or (Text[8] <> '-') then
    Exit(False);

  if not TryStrToInt(Copy(Text, 1, 4), YInt) then Exit(False);
  if not TryStrToInt(Copy(Text, 6, 2), MInt) then Exit(False);
  if not TryStrToInt(Copy(Text, 9, 2), DInt) then Exit(False);
  if (YInt < 1) or (YInt > 9999) or (MInt < 1) or (MInt > 12) or
     (DInt < 1) or (DInt > 31) then Exit(False);
  Y := YInt;
  M := MInt;
  D := DInt;

  try
    ADate := EncodeDate(Y, M, D);
    Result := True;
  except
    Result := False;
  end;
end;

function FormatAmount(const AAmount: Currency): string;
begin
  if AAmount = 0 then
    Result := ''
  else
    Result := FormatFloat('#,##0.##', AAmount);
end;

{ THistoryView }

constructor THistoryView.CreateWithData(AOwner: TComponent;
  const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  BuildUI;
  LoadFilters;
  RefreshGrid;
end;

class procedure THistoryView.Execute(AOwner: TComponent; const AData: IDataContext);
var
  View: THistoryView;
begin
  if (AData = nil) or (AData.History = nil) or
     (AData.Items = nil) or (AData.Partners = nil) then
  begin
    ShowMessage('이력 조회에 필요한 저장소를 사용할 수 없습니다.');
    Exit;
  end;

  View := THistoryView.CreateWithData(AOwner, AData);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure THistoryView.BuildUI;
var
  TopPanel, ButtonPanel: TPanel;
  Lbl: TLabel;
  BtnRefresh, BtnClear, BtnClose: TButton;
begin
  Caption := '이력 조회';
  Width := 1040;
  Height := 600;
  Position := poOwnerFormCenter;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 88;
  TopPanel.BevelOuter := bvNone;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := TopPanel;
  Lbl.Left := 16;
  Lbl.Top := 16;
  Lbl.Caption := '시작일';

  FFromEdit := TEdit.Create(Self);
  FFromEdit.Parent := TopPanel;
  FFromEdit.Left := 66;
  FFromEdit.Top := 11;
  FFromEdit.Width := 104;
  FFromEdit.TextHint := DATE_HINT;
  FFromEdit.OnChange := FilterChanged;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := TopPanel;
  Lbl.Left := 184;
  Lbl.Top := 16;
  Lbl.Caption := '종료일';

  FToEdit := TEdit.Create(Self);
  FToEdit.Parent := TopPanel;
  FToEdit.Left := 234;
  FToEdit.Top := 11;
  FToEdit.Width := 104;
  FToEdit.TextHint := DATE_HINT;
  FToEdit.OnChange := FilterChanged;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := TopPanel;
  Lbl.Left := 360;
  Lbl.Top := 16;
  Lbl.Caption := '거래처';

  FPartnerCombo := TComboBox.Create(Self);
  FPartnerCombo.Parent := TopPanel;
  FPartnerCombo.Left := 414;
  FPartnerCombo.Top := 11;
  FPartnerCombo.Width := 190;
  FPartnerCombo.Style := csDropDownList;
  FPartnerCombo.OnChange := FilterChanged;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := TopPanel;
  Lbl.Left := 626;
  Lbl.Top := 16;
  Lbl.Caption := '품목';

  FItemCombo := TComboBox.Create(Self);
  FItemCombo.Parent := TopPanel;
  FItemCombo.Left := 668;
  FItemCombo.Top := 11;
  FItemCombo.Width := 230;
  FItemCombo.Style := csDropDownList;
  FItemCombo.OnChange := FilterChanged;

  Lbl := TLabel.Create(Self);
  Lbl.Parent := TopPanel;
  Lbl.Left := 16;
  Lbl.Top := 52;
  Lbl.Caption := '유형';

  FKindCombo := TComboBox.Create(Self);
  FKindCombo.Parent := TopPanel;
  FKindCombo.Left := 66;
  FKindCombo.Top := 47;
  FKindCombo.Width := 130;
  FKindCombo.Style := csDropDownList;
  FKindCombo.Items.Add('전체');
  FKindCombo.Items.Add('재고이동');
  FKindCombo.Items.Add('출고');
  FKindCombo.Items.Add('견적');
  FKindCombo.ItemIndex := 0;
  FKindCombo.OnChange := FilterChanged;

  BtnRefresh := TButton.Create(Self);
  BtnRefresh.Parent := TopPanel;
  BtnRefresh.Left := 214;
  BtnRefresh.Top := 46;
  BtnRefresh.Width := 82;
  BtnRefresh.Caption := '조회';
  BtnRefresh.OnClick := FilterChanged;

  BtnClear := TButton.Create(Self);
  BtnClear.Parent := TopPanel;
  BtnClear.Left := 304;
  BtnClear.Top := 46;
  BtnClear.Width := 82;
  BtnClear.Caption := '초기화';
  BtnClear.OnClick := ClearClick;

  ButtonPanel := TPanel.Create(Self);
  ButtonPanel.Parent := Self;
  ButtonPanel.Align := alBottom;
  ButtonPanel.Height := 52;
  ButtonPanel.BevelOuter := bvNone;

  BtnClose := TButton.Create(Self);
  BtnClose.Parent := ButtonPanel;
  BtnClose.Left := 926;
  BtnClose.Top := 12;
  BtnClose.Width := 82;
  BtnClose.Caption := '닫기';
  BtnClose.ModalResult := mrClose;
  BtnClose.Anchors := [akTop, akRight];

  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.FixedRows := 1;
  FGrid.ColCount := 7;
  FGrid.RowCount := 2;
  FGrid.Options := FGrid.Options + [goRowSelect] - [goEditing];
  FGrid.Cells[0, 0] := '일시';
  FGrid.Cells[1, 0] := '유형';
  FGrid.Cells[2, 0] := '참조번호';
  FGrid.Cells[3, 0] := '거래처';
  FGrid.Cells[4, 0] := '품목';
  FGrid.Cells[5, 0] := '수량';
  FGrid.Cells[6, 0] := '금액';
  FGrid.ColWidths[0] := 140;
  FGrid.ColWidths[1] := 90;
  FGrid.ColWidths[2] := 110;
  FGrid.ColWidths[3] := 170;
  FGrid.ColWidths[4] := 260;
  FGrid.ColWidths[5] := 90;
  FGrid.ColWidths[6] := 120;
end;

procedure THistoryView.LoadFilters;
var
  I: Integer;
begin
  FPartners := FData.Partners.GetAll;
  FPartnerCombo.Items.Clear;
  FPartnerCombo.Items.Add('전체');
  for I := 0 to High(FPartners) do
    FPartnerCombo.Items.Add(FPartners[I].Name);
  FPartnerCombo.ItemIndex := 0;

  FItems := FData.Items.GetAll;
  FItemCombo.Items.Clear;
  FItemCombo.Items.Add('전체');
  for I := 0 to High(FItems) do
    FItemCombo.Items.Add(FItems[I].Name);
  FItemCombo.ItemIndex := 0;
end;

function THistoryView.SelectedPartnerId: Integer;
begin
  Result := 0;
  if (FPartnerCombo.ItemIndex > 0) and
     (FPartnerCombo.ItemIndex - 1 <= High(FPartners)) then
    Result := FPartners[FPartnerCombo.ItemIndex - 1].Id;
end;

function THistoryView.SelectedPartnerName: string;
begin
  Result := '';
  if (FPartnerCombo.ItemIndex > 0) and
     (FPartnerCombo.ItemIndex - 1 <= High(FPartners)) then
    Result := FPartners[FPartnerCombo.ItemIndex - 1].Name;
end;

function THistoryView.SelectedItemId: Integer;
begin
  Result := 0;
  if (FItemCombo.ItemIndex > 0) and (FItemCombo.ItemIndex - 1 <= High(FItems)) then
    Result := FItems[FItemCombo.ItemIndex - 1].Id;
end;

function THistoryView.SelectedItemName: string;
begin
  Result := '';
  if (FItemCombo.ItemIndex > 0) and (FItemCombo.ItemIndex - 1 <= High(FItems)) then
    Result := FItems[FItemCombo.ItemIndex - 1].Name;
end;

function THistoryView.BuildFilter(out AFilter: THistoryFilter): Boolean;
var
  FromDate, ToDate: TDateTime;
begin
  Result := False;
  AFilter := Default(THistoryFilter);

  if not ParseIsoDate(FFromEdit.Text, FromDate) then
  begin
    ShowMessage('시작일은 yyyy-mm-dd 형식으로 입력해 주세요.');
    FFromEdit.SetFocus;
    Exit;
  end;

  if not ParseIsoDate(FToEdit.Text, ToDate) then
  begin
    ShowMessage('종료일은 yyyy-mm-dd 형식으로 입력해 주세요.');
    FToEdit.SetFocus;
    Exit;
  end;

  if (FromDate <> 0) and (ToDate <> 0) and (FromDate > ToDate) then
  begin
    ShowMessage('시작일은 종료일보다 늦을 수 없습니다.');
    FFromEdit.SetFocus;
    Exit;
  end;

  AFilter.FromDate := FromDate;
  if ToDate <> 0 then
    AFilter.ToDate := ToDate + EncodeTime(23, 59, 59, 999);
  AFilter.PartnerId := SelectedPartnerId;
  AFilter.ItemId := SelectedItemId;

  case FKindCombo.ItemIndex of
    1: AFilter.Kinds := [hkStockMove];
    2: AFilter.Kinds := [hkShipment];
    3: AFilter.Kinds := [hkQuote];
  else
    AFilter.Kinds := [];
  end;

  Result := True;
end;

procedure THistoryView.SortRowsByDateDesc;
var
  I, J: Integer;
  Temp: THistoryRow;
begin
  for I := 0 to High(FRows) - 1 do
    for J := I + 1 to High(FRows) do
      if FRows[I].When_ < FRows[J].When_ then
      begin
        Temp := FRows[I];
        FRows[I] := FRows[J];
        FRows[J] := Temp;
      end;
end;

procedure THistoryView.RefreshGrid;
var
  Filter: THistoryFilter;
  RawRows: THistoryRowArray;
  I, Row, N: Integer;
  PartnerName, ItemName: string;
begin
  if not BuildFilter(Filter) then
    Exit;

  RawRows := FData.History.Query(Filter);
  PartnerName := SelectedPartnerName;
  ItemName := SelectedItemName;
  SetLength(FRows, 0);
  N := 0;
  for I := 0 to High(RawRows) do
  begin
    if (PartnerName <> '') and (not SameText(RawRows[I].PartnerName, PartnerName)) then
      Continue;
    if (ItemName <> '') and (not SameText(RawRows[I].ItemName, ItemName)) then
      Continue;
    SetLength(FRows, N + 1);
    FRows[N] := RawRows[I];
    Inc(N);
  end;

  SortRowsByDateDesc;

  FGrid.RowCount := Max(2, Length(FRows) + 1);
  for Row := 1 to FGrid.RowCount - 1 do
    for I := 0 to FGrid.ColCount - 1 do
      FGrid.Cells[I, Row] := '';

  for I := 0 to High(FRows) do
  begin
    Row := I + 1;
    FGrid.Cells[0, Row] := FormatDateTime('yyyy-mm-dd hh:nn:ss', FRows[I].When_);
    FGrid.Cells[1, Row] := HistoryKindText(FRows[I].Kind);
    FGrid.Cells[2, Row] := FRows[I].RefNo;
    FGrid.Cells[3, Row] := FRows[I].PartnerName;
    FGrid.Cells[4, Row] := FRows[I].ItemName;
    FGrid.Cells[5, Row] := FormatFloat('#,##0.##', FRows[I].Qty);
    FGrid.Cells[6, Row] := FormatAmount(FRows[I].Amount);
  end;
end;

procedure THistoryView.FilterChanged(Sender: TObject);
begin
  RefreshGrid;
end;

procedure THistoryView.ClearClick(Sender: TObject);
begin
  FFromEdit.Text := '';
  FToEdit.Text := '';
  FPartnerCombo.ItemIndex := 0;
  FItemCombo.ItemIndex := 0;
  FKindCombo.ItemIndex := 0;
  RefreshGrid;
end;

end.
