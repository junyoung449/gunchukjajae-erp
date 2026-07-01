unit App.Modules.Item.View;

{ 품목 관리 화면. .lfm 없이 런타임에 컨트롤을 생성한다. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Math, Forms, Controls, StdCtrls, ExtCtrls, Grids,
  Dialogs, Graphics, App.Core.Contracts, App.Core.Entities;

type
  TItemView = class(TForm)
  private
    FItems: IItemRepository;
    FRows: TItemArray;
    FSearchEdit: TEdit;
    FGrid: TStringGrid;
    procedure BuildUI;
    procedure RefreshGrid;
    procedure SearchChanged(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    function SelectedItem(out AItem: TItem): Boolean;
    function CodeExists(const ACode: string; const AExceptId: Integer): Boolean;
    function EditItem(var AItem: TItem; const AIsNew: Boolean): Boolean;
  public
    constructor CreateWithItems(AOwner: TComponent; const AItems: IItemRepository);
    class procedure Execute(AOwner: TComponent; const AItems: IItemRepository);
  end;

implementation

type
  TItemEditForm = class(TForm)
  private
    FItem: TItem;
    FCodeEdit: TEdit;
    FNameEdit: TEdit;
    FSpecEdit: TEdit;
    FUnitEdit: TEdit;
    FPriceEdit: TEdit;
    FActiveCheck: TCheckBox;
    procedure BuildUI(const AIsNew: Boolean);
    procedure SaveClick(Sender: TObject);
    procedure AddLabel(const ACaption: string; const ATop: Integer);
  public
    constructor CreateWithItem(AOwner: TComponent; const AItem: TItem;
      const AIsNew: Boolean);
    property Item: TItem read FItem;
  end;

function FormatPrice(const APrice: Currency): string;
begin
  Result := FormatFloat('#,##0.##', APrice);
end;

{ TItemEditForm }

constructor TItemEditForm.CreateWithItem(AOwner: TComponent; const AItem: TItem;
  const AIsNew: Boolean);
begin
  inherited CreateNew(AOwner);
  FItem := AItem;
  BuildUI(AIsNew);
end;

procedure TItemEditForm.AddLabel(const ACaption: string; const ATop: Integer);
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(Self);
  Lbl.Parent := Self;
  Lbl.Left := 18;
  Lbl.Top := ATop + 4;
  Lbl.Width := 74;
  Lbl.Caption := ACaption;
end;

procedure TItemEditForm.BuildUI(const AIsNew: Boolean);
var
  BtnSave, BtnCancel: TButton;
begin
  Caption := IfThen(AIsNew, '품목 신규', '품목 수정');
  Width := 390;
  Height := 302;
  BorderStyle := bsDialog;
  Position := poOwnerFormCenter;

  AddLabel('품목코드', 20);
  FCodeEdit := TEdit.Create(Self);
  FCodeEdit.Parent := Self;
  FCodeEdit.Left := 100;
  FCodeEdit.Top := 18;
  FCodeEdit.Width := 240;
  FCodeEdit.Text := FItem.Code;

  AddLabel('품목명', 54);
  FNameEdit := TEdit.Create(Self);
  FNameEdit.Parent := Self;
  FNameEdit.Left := 100;
  FNameEdit.Top := 52;
  FNameEdit.Width := 240;
  FNameEdit.Text := FItem.Name;

  AddLabel('규격', 88);
  FSpecEdit := TEdit.Create(Self);
  FSpecEdit.Parent := Self;
  FSpecEdit.Left := 100;
  FSpecEdit.Top := 86;
  FSpecEdit.Width := 240;
  FSpecEdit.Text := FItem.Spec;

  AddLabel('단위', 122);
  FUnitEdit := TEdit.Create(Self);
  FUnitEdit.Parent := Self;
  FUnitEdit.Left := 100;
  FUnitEdit.Top := 120;
  FUnitEdit.Width := 240;
  FUnitEdit.Text := FItem.UnitName;

  AddLabel('기준 단가', 156);
  FPriceEdit := TEdit.Create(Self);
  FPriceEdit.Parent := Self;
  FPriceEdit.Left := 100;
  FPriceEdit.Top := 154;
  FPriceEdit.Width := 240;
  FPriceEdit.Text := CurrToStr(FItem.UnitPrice);

  FActiveCheck := TCheckBox.Create(Self);
  FActiveCheck.Parent := Self;
  FActiveCheck.Left := 100;
  FActiveCheck.Top := 190;
  FActiveCheck.Caption := '사용';
  FActiveCheck.Checked := AIsNew or FItem.Active;

  BtnSave := TButton.Create(Self);
  BtnSave.Parent := Self;
  BtnSave.Left := 174;
  BtnSave.Top := 230;
  BtnSave.Width := 78;
  BtnSave.Caption := '저장';
  BtnSave.OnClick := SaveClick;

  BtnCancel := TButton.Create(Self);
  BtnCancel.Parent := Self;
  BtnCancel.Left := 262;
  BtnCancel.Top := 230;
  BtnCancel.Width := 78;
  BtnCancel.Caption := '취소';
  BtnCancel.ModalResult := mrCancel;
end;

procedure TItemEditForm.SaveClick(Sender: TObject);
var
  PriceText: string;
  Price: Currency;
begin
  if Trim(FCodeEdit.Text) = '' then
  begin
    ShowMessage('품목코드는 필수입니다.');
    FCodeEdit.SetFocus;
    Exit;
  end;

  if Trim(FNameEdit.Text) = '' then
  begin
    ShowMessage('품목명은 필수입니다.');
    FNameEdit.SetFocus;
    Exit;
  end;

  if Trim(FUnitEdit.Text) = '' then
  begin
    ShowMessage('단위는 필수입니다.');
    FUnitEdit.SetFocus;
    Exit;
  end;

  PriceText := StringReplace(Trim(FPriceEdit.Text), ',', '', [rfReplaceAll]);
  if (PriceText = '') or (not TryStrToCurr(PriceText, Price)) then
  begin
    ShowMessage('기준 단가는 숫자로 입력해야 합니다.');
    FPriceEdit.SetFocus;
    Exit;
  end;

  if Price < 0 then
  begin
    ShowMessage('기준 단가는 0 이상이어야 합니다.');
    FPriceEdit.SetFocus;
    Exit;
  end;

  FItem.Code := Trim(FCodeEdit.Text);
  FItem.Name := Trim(FNameEdit.Text);
  FItem.Spec := Trim(FSpecEdit.Text);
  FItem.UnitName := Trim(FUnitEdit.Text);
  FItem.UnitPrice := Price;
  FItem.Active := FActiveCheck.Checked;
  ModalResult := mrOk;
end;

{ TItemView }

constructor TItemView.CreateWithItems(AOwner: TComponent;
  const AItems: IItemRepository);
begin
  inherited CreateNew(AOwner);
  FItems := AItems;
  BuildUI;
  RefreshGrid;
end;

class procedure TItemView.Execute(AOwner: TComponent;
  const AItems: IItemRepository);
var
  View: TItemView;
begin
  if AItems = nil then
  begin
    ShowMessage('품목 저장소를 사용할 수 없습니다.');
    Exit;
  end;

  View := TItemView.CreateWithItems(AOwner, AItems);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure TItemView.BuildUI;
var
  TopPanel, ButtonPanel: TPanel;
  SearchLabel: TLabel;
  BtnNew, BtnEdit, BtnDelete, BtnClose: TButton;
begin
  Caption := '품목 관리';
  Width := 860;
  Height := 540;
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
  FSearchEdit.Left := 58;
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
  FGrid.OnDblClick := GridDblClick;
  FGrid.Cells[0, 0] := '코드';
  FGrid.Cells[1, 0] := '품목명';
  FGrid.Cells[2, 0] := '규격';
  FGrid.Cells[3, 0] := '단위';
  FGrid.Cells[4, 0] := '단가';
  FGrid.Cells[5, 0] := '사용여부';
  FGrid.ColWidths[0] := 110;
  FGrid.ColWidths[1] := 250;
  FGrid.ColWidths[2] := 190;
  FGrid.ColWidths[3] := 80;
  FGrid.ColWidths[4] := 110;
  FGrid.ColWidths[5] := 90;
end;

procedure TItemView.RefreshGrid;
var
  AllItems: TItemArray;
  I, Row: Integer;
  Keyword: string;
begin
  AllItems := FItems.GetAll;
  Keyword := Trim(FSearchEdit.Text);
  SetLength(FRows, 0);

  for I := 0 to High(AllItems) do
    if (Keyword = '') or AnsiContainsText(AllItems[I].Code, Keyword)
      or AnsiContainsText(AllItems[I].Name, Keyword) then
    begin
      SetLength(FRows, Length(FRows) + 1);
      FRows[High(FRows)] := AllItems[I];
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
    FGrid.Cells[0, Row] := FRows[I].Code;
    FGrid.Cells[1, Row] := FRows[I].Name;
    FGrid.Cells[2, Row] := FRows[I].Spec;
    FGrid.Cells[3, Row] := FRows[I].UnitName;
    FGrid.Cells[4, Row] := FormatPrice(FRows[I].UnitPrice);
    if FRows[I].Active then
      FGrid.Cells[5, Row] := '사용'
    else
      FGrid.Cells[5, Row] := '중지';
  end;
end;

procedure TItemView.SearchChanged(Sender: TObject);
begin
  RefreshGrid;
end;

function TItemView.SelectedItem(out AItem: TItem): Boolean;
var
  Idx: Integer;
begin
  Result := False;
  AItem := Default(TItem);
  Idx := FGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FRows)) then
  begin
    ShowMessage('품목을 선택해 주세요.');
    Exit;
  end;

  AItem := FRows[Idx];
  Result := True;
end;

function TItemView.CodeExists(const ACode: string;
  const AExceptId: Integer): Boolean;
var
  Items: TItemArray;
  I: Integer;
begin
  Result := False;
  Items := FItems.GetAll;
  for I := 0 to High(Items) do
    if (Items[I].Id <> AExceptId) and SameText(Items[I].Code, ACode) then
      Exit(True);
end;

function TItemView.EditItem(var AItem: TItem; const AIsNew: Boolean): Boolean;
var
  Form: TItemEditForm;
begin
  Result := False;
  repeat
    Form := TItemEditForm.CreateWithItem(Self, AItem, AIsNew);
    try
      if Form.ShowModal <> mrOk then
        Exit(False);
      AItem := Form.Item;
    finally
      Form.Free;
    end;

    if CodeExists(AItem.Code, AItem.Id) then
    begin
      ShowMessage('이미 사용 중인 품목코드입니다.');
      Continue;
    end;

    Result := True;
    Exit;
  until False;
end;

procedure TItemView.NewClick(Sender: TObject);
var
  Item: TItem;
begin
  Item := Default(TItem);
  Item.Active := True;
  if not EditItem(Item, True) then Exit;
  FItems.Add(Item);
  RefreshGrid;
end;

procedure TItemView.EditClick(Sender: TObject);
var
  Item: TItem;
begin
  if not SelectedItem(Item) then Exit;
  if not EditItem(Item, False) then Exit;
  FItems.Update(Item);
  RefreshGrid;
end;

procedure TItemView.DeleteClick(Sender: TObject);
var
  Item: TItem;
begin
  if not SelectedItem(Item) then Exit;
  if MessageDlg('삭제 확인', '선택한 품목을 삭제하시겠습니까?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  FItems.Delete(Item.Id);
  RefreshGrid;
end;

procedure TItemView.GridDblClick(Sender: TObject);
begin
  EditClick(Sender);
end;

end.
