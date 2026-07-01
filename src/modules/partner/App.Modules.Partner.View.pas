unit App.Modules.Partner.View;

{ 거래처 관리 화면. .lfm 없이 런타임에 컨트롤을 생성한다. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Math, Forms, Controls, StdCtrls, ExtCtrls,
  Grids, Dialogs, App.Core.Contracts, App.Core.Entities;

type
  TPartnerView = class(TForm)
  private
    FPartners: IPartnerRepository;
    FRows: TPartnerArray;
    FSearchEdit: TEdit;
    FKindCombo: TComboBox;
    FGrid: TStringGrid;
    procedure BuildUI;
    procedure RefreshGrid;
    procedure FilterChanged(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    function SelectedPartner(out APartner: TPartner): Boolean;
    function CodeExists(const ACode: string; const AExceptId: Integer): Boolean;
    function EditPartner(var APartner: TPartner; const AIsNew: Boolean): Boolean;
  public
    constructor CreateWithPartners(AOwner: TComponent;
      const APartners: IPartnerRepository);
    class procedure Execute(AOwner: TComponent;
      const APartners: IPartnerRepository);
  end;

implementation

type
  TPartnerEditForm = class(TForm)
  private
    FPartner: TPartner;
    FCodeEdit: TEdit;
    FNameEdit: TEdit;
    FKindCombo: TComboBox;
    FBizNoEdit: TEdit;
    FOwnerEdit: TEdit;
    FPhoneEdit: TEdit;
    FAddressEdit: TEdit;
    FActiveCheck: TCheckBox;
    procedure BuildUI(const AIsNew: Boolean);
    procedure SaveClick(Sender: TObject);
    procedure AddLabel(const ACaption: string; const ATop: Integer);
  public
    constructor CreateWithPartner(AOwner: TComponent; const APartner: TPartner;
      const AIsNew: Boolean);
    property Partner: TPartner read FPartner;
  end;

function PartnerKindText(const AKind: TPartnerKind): string;
begin
  case AKind of
    pkCustomer: Result := '고객';
    pkSupplier: Result := '매입처';
  else
    Result := '겸용';
  end;
end;

function PartnerKindIndex(const AKind: TPartnerKind): Integer;
begin
  case AKind of
    pkCustomer: Result := 0;
    pkSupplier: Result := 1;
  else
    Result := 2;
  end;
end;

function PartnerKindFromIndex(const AIndex: Integer): TPartnerKind;
begin
  case AIndex of
    0: Result := pkCustomer;
    1: Result := pkSupplier;
  else
    Result := pkBoth;
  end;
end;

function DigitsOnly(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
    if AValue[I] in ['0'..'9'] then
      Result := Result + AValue[I];
end;

function FormatBizNo(const AValue: string): string;
var
  Digits: string;
begin
  Digits := DigitsOnly(AValue);
  if Length(Digits) = 10 then
    Result := Copy(Digits, 1, 3) + '-' + Copy(Digits, 4, 2) + '-' +
      Copy(Digits, 6, 5)
  else
    Result := Trim(AValue);
end;

function IsValidBizNo(const AValue: string): Boolean;
begin
  Result := Length(DigitsOnly(AValue)) = 10;
end;

{ TPartnerEditForm }

constructor TPartnerEditForm.CreateWithPartner(AOwner: TComponent;
  const APartner: TPartner; const AIsNew: Boolean);
begin
  inherited CreateNew(AOwner);
  FPartner := APartner;
  BuildUI(AIsNew);
end;

procedure TPartnerEditForm.AddLabel(const ACaption: string; const ATop: Integer);
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(Self);
  Lbl.Parent := Self;
  Lbl.Left := 18;
  Lbl.Top := ATop + 4;
  Lbl.Width := 82;
  Lbl.Caption := ACaption;
end;

procedure TPartnerEditForm.BuildUI(const AIsNew: Boolean);
var
  BtnSave, BtnCancel: TButton;
begin
  if AIsNew then
    Caption := '거래처 신규'
  else
    Caption := '거래처 수정';
  Width := 430;
  Height := 390;
  BorderStyle := bsDialog;
  Position := poOwnerFormCenter;

  AddLabel('거래처코드', 20);
  FCodeEdit := TEdit.Create(Self);
  FCodeEdit.Parent := Self;
  FCodeEdit.Left := 110;
  FCodeEdit.Top := 18;
  FCodeEdit.Width := 270;
  FCodeEdit.Text := FPartner.Code;

  AddLabel('상호', 54);
  FNameEdit := TEdit.Create(Self);
  FNameEdit.Parent := Self;
  FNameEdit.Left := 110;
  FNameEdit.Top := 52;
  FNameEdit.Width := 270;
  FNameEdit.Text := FPartner.Name;

  AddLabel('구분', 88);
  FKindCombo := TComboBox.Create(Self);
  FKindCombo.Parent := Self;
  FKindCombo.Left := 110;
  FKindCombo.Top := 86;
  FKindCombo.Width := 140;
  FKindCombo.Style := csDropDownList;
  FKindCombo.Items.Add('고객');
  FKindCombo.Items.Add('매입처');
  FKindCombo.Items.Add('겸용');
  FKindCombo.ItemIndex := PartnerKindIndex(FPartner.Kind);

  AddLabel('사업자번호', 122);
  FBizNoEdit := TEdit.Create(Self);
  FBizNoEdit.Parent := Self;
  FBizNoEdit.Left := 110;
  FBizNoEdit.Top := 120;
  FBizNoEdit.Width := 270;
  FBizNoEdit.Text := FPartner.BizNo;

  AddLabel('대표자', 156);
  FOwnerEdit := TEdit.Create(Self);
  FOwnerEdit.Parent := Self;
  FOwnerEdit.Left := 110;
  FOwnerEdit.Top := 154;
  FOwnerEdit.Width := 270;
  FOwnerEdit.Text := FPartner.Owner;

  AddLabel('연락처', 190);
  FPhoneEdit := TEdit.Create(Self);
  FPhoneEdit.Parent := Self;
  FPhoneEdit.Left := 110;
  FPhoneEdit.Top := 188;
  FPhoneEdit.Width := 270;
  FPhoneEdit.Text := FPartner.Phone;

  AddLabel('주소', 224);
  FAddressEdit := TEdit.Create(Self);
  FAddressEdit.Parent := Self;
  FAddressEdit.Left := 110;
  FAddressEdit.Top := 222;
  FAddressEdit.Width := 270;
  FAddressEdit.Text := FPartner.Address;

  FActiveCheck := TCheckBox.Create(Self);
  FActiveCheck.Parent := Self;
  FActiveCheck.Left := 110;
  FActiveCheck.Top := 258;
  FActiveCheck.Caption := '사용';
  FActiveCheck.Checked := AIsNew or FPartner.Active;

  BtnSave := TButton.Create(Self);
  BtnSave.Parent := Self;
  BtnSave.Left := 214;
  BtnSave.Top := 304;
  BtnSave.Width := 78;
  BtnSave.Caption := '저장';
  BtnSave.OnClick := SaveClick;

  BtnCancel := TButton.Create(Self);
  BtnCancel.Parent := Self;
  BtnCancel.Left := 302;
  BtnCancel.Top := 304;
  BtnCancel.Width := 78;
  BtnCancel.Caption := '취소';
  BtnCancel.ModalResult := mrCancel;
end;

procedure TPartnerEditForm.SaveClick(Sender: TObject);
begin
  if Trim(FCodeEdit.Text) = '' then
  begin
    ShowMessage('거래처코드는 필수입니다.');
    FCodeEdit.SetFocus;
    Exit;
  end;

  if Trim(FNameEdit.Text) = '' then
  begin
    ShowMessage('상호는 필수입니다.');
    FNameEdit.SetFocus;
    Exit;
  end;

  if Trim(FBizNoEdit.Text) = '' then
  begin
    ShowMessage('사업자번호는 필수입니다.');
    FBizNoEdit.SetFocus;
    Exit;
  end;

  if not IsValidBizNo(FBizNoEdit.Text) then
  begin
    ShowMessage('사업자번호는 000-00-00000 형식으로 입력해 주세요.');
    FBizNoEdit.SetFocus;
    Exit;
  end;

  FPartner.Code := Trim(FCodeEdit.Text);
  FPartner.Name := Trim(FNameEdit.Text);
  FPartner.Kind := PartnerKindFromIndex(FKindCombo.ItemIndex);
  FPartner.BizNo := FormatBizNo(FBizNoEdit.Text);
  FPartner.Owner := Trim(FOwnerEdit.Text);
  FPartner.Phone := Trim(FPhoneEdit.Text);
  FPartner.Address := Trim(FAddressEdit.Text);
  FPartner.Active := FActiveCheck.Checked;
  ModalResult := mrOk;
end;

{ TPartnerView }

constructor TPartnerView.CreateWithPartners(AOwner: TComponent;
  const APartners: IPartnerRepository);
begin
  inherited CreateNew(AOwner);
  FPartners := APartners;
  BuildUI;
  RefreshGrid;
end;

class procedure TPartnerView.Execute(AOwner: TComponent;
  const APartners: IPartnerRepository);
var
  View: TPartnerView;
begin
  if APartners = nil then
  begin
    ShowMessage('거래처 저장소를 사용할 수 없습니다.');
    Exit;
  end;

  View := TPartnerView.CreateWithPartners(AOwner, APartners);
  try
    View.ShowModal;
  finally
    View.Free;
  end;
end;

procedure TPartnerView.BuildUI;
var
  TopPanel, ButtonPanel: TPanel;
  SearchLabel, KindLabel: TLabel;
  BtnNew, BtnEdit, BtnDelete, BtnClose: TButton;
begin
  Caption := '거래처 관리';
  Width := 980;
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
  FSearchEdit.Left := 58;
  FSearchEdit.Top := 12;
  FSearchEdit.Width := 260;
  FSearchEdit.OnChange := FilterChanged;

  KindLabel := TLabel.Create(Self);
  KindLabel.Parent := TopPanel;
  KindLabel.Left := 340;
  KindLabel.Top := 17;
  KindLabel.Caption := '구분';

  FKindCombo := TComboBox.Create(Self);
  FKindCombo.Parent := TopPanel;
  FKindCombo.Left := 382;
  FKindCombo.Top := 12;
  FKindCombo.Width := 120;
  FKindCombo.Style := csDropDownList;
  FKindCombo.Items.Add('전체');
  FKindCombo.Items.Add('고객');
  FKindCombo.Items.Add('매입처');
  FKindCombo.Items.Add('겸용');
  FKindCombo.ItemIndex := 0;
  FKindCombo.OnChange := FilterChanged;

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
  BtnClose.Left := 866;
  BtnClose.Top := 12;
  BtnClose.Width := 82;
  BtnClose.Caption := '닫기';
  BtnClose.ModalResult := mrClose;
  BtnClose.Anchors := [akTop, akRight];

  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.FixedRows := 1;
  FGrid.ColCount := 8;
  FGrid.RowCount := 2;
  FGrid.Options := FGrid.Options + [goRowSelect] - [goEditing];
  FGrid.OnDblClick := GridDblClick;
  FGrid.Cells[0, 0] := '코드';
  FGrid.Cells[1, 0] := '상호';
  FGrid.Cells[2, 0] := '구분';
  FGrid.Cells[3, 0] := '사업자번호';
  FGrid.Cells[4, 0] := '대표자';
  FGrid.Cells[5, 0] := '연락처';
  FGrid.Cells[6, 0] := '주소';
  FGrid.Cells[7, 0] := '사용여부';
  FGrid.ColWidths[0] := 90;
  FGrid.ColWidths[1] := 180;
  FGrid.ColWidths[2] := 80;
  FGrid.ColWidths[3] := 120;
  FGrid.ColWidths[4] := 90;
  FGrid.ColWidths[5] := 130;
  FGrid.ColWidths[6] := 190;
  FGrid.ColWidths[7] := 80;
end;

procedure TPartnerView.RefreshGrid;
var
  SourceRows: TPartnerArray;
  I, Row: Integer;
  Keyword: string;
begin
  case FKindCombo.ItemIndex of
    1: SourceRows := FPartners.GetByKind(pkCustomer);
    2: SourceRows := FPartners.GetByKind(pkSupplier);
    3: SourceRows := FPartners.GetByKind(pkBoth);
  else
    SourceRows := FPartners.GetAll;
  end;

  Keyword := Trim(FSearchEdit.Text);
  SetLength(FRows, 0);
  for I := 0 to High(SourceRows) do
    if (Keyword = '') or AnsiContainsText(SourceRows[I].Name, Keyword)
      or AnsiContainsText(SourceRows[I].BizNo, Keyword) then
    begin
      SetLength(FRows, Length(FRows) + 1);
      FRows[High(FRows)] := SourceRows[I];
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
    FGrid.Cells[6, Row] := '';
    FGrid.Cells[7, Row] := '';
  end;

  for I := 0 to High(FRows) do
  begin
    Row := I + 1;
    FGrid.Cells[0, Row] := FRows[I].Code;
    FGrid.Cells[1, Row] := FRows[I].Name;
    FGrid.Cells[2, Row] := PartnerKindText(FRows[I].Kind);
    FGrid.Cells[3, Row] := FRows[I].BizNo;
    FGrid.Cells[4, Row] := FRows[I].Owner;
    FGrid.Cells[5, Row] := FRows[I].Phone;
    FGrid.Cells[6, Row] := FRows[I].Address;
    if FRows[I].Active then
      FGrid.Cells[7, Row] := '사용'
    else
      FGrid.Cells[7, Row] := '중지';
  end;
end;

procedure TPartnerView.FilterChanged(Sender: TObject);
begin
  RefreshGrid;
end;

function TPartnerView.SelectedPartner(out APartner: TPartner): Boolean;
var
  Idx: Integer;
begin
  Result := False;
  APartner := Default(TPartner);
  Idx := FGrid.Row - 1;
  if (Idx < 0) or (Idx > High(FRows)) then
  begin
    ShowMessage('거래처를 선택해 주세요.');
    Exit;
  end;

  APartner := FRows[Idx];
  Result := True;
end;

function TPartnerView.CodeExists(const ACode: string;
  const AExceptId: Integer): Boolean;
var
  Partners: TPartnerArray;
  I: Integer;
begin
  Result := False;
  Partners := FPartners.GetAll;
  for I := 0 to High(Partners) do
    if (Partners[I].Id <> AExceptId) and SameText(Partners[I].Code, ACode) then
      Exit(True);
end;

function TPartnerView.EditPartner(var APartner: TPartner;
  const AIsNew: Boolean): Boolean;
var
  Form: TPartnerEditForm;
begin
  Result := False;
  repeat
    Form := TPartnerEditForm.CreateWithPartner(Self, APartner, AIsNew);
    try
      if Form.ShowModal <> mrOk then
        Exit(False);
      APartner := Form.Partner;
    finally
      Form.Free;
    end;

    if CodeExists(APartner.Code, APartner.Id) then
    begin
      ShowMessage('이미 사용 중인 거래처코드입니다.');
      Continue;
    end;

    Result := True;
    Exit;
  until False;
end;

procedure TPartnerView.NewClick(Sender: TObject);
var
  Partner: TPartner;
begin
  Partner := Default(TPartner);
  Partner.Kind := pkCustomer;
  Partner.Active := True;
  if not EditPartner(Partner, True) then Exit;
  FPartners.Add(Partner);
  RefreshGrid;
end;

procedure TPartnerView.EditClick(Sender: TObject);
var
  Partner: TPartner;
begin
  if not SelectedPartner(Partner) then Exit;
  if not EditPartner(Partner, False) then Exit;
  FPartners.Update(Partner);
  RefreshGrid;
end;

procedure TPartnerView.DeleteClick(Sender: TObject);
var
  Partner: TPartner;
begin
  if not SelectedPartner(Partner) then Exit;
  if MessageDlg('삭제 확인', '선택한 거래처를 삭제하시겠습니까?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  FPartners.Delete(Partner.Id);
  RefreshGrid;
end;

procedure TPartnerView.GridDblClick(Sender: TObject);
begin
  EditClick(Sender);
end;

end.
