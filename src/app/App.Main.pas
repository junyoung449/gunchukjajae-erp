unit App.Main;

{ 메인 셸 폼.
  이 골격은 데이터 컨텍스트가 정상 주입되어 "DB 없이" 동작함을 보여주는 최소 화면이다.
  실제 모듈 화면(품목/거래처/재고/견적/출고/이력)은 하위 모듈에서 이 셸에 붙는다.
  .lfm 리소스 의존을 피하려고 컨트롤을 코드로 생성한다. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Graphics, Dialogs,
  App.Core.Contracts, App.Core.Entities, App.Modules.Partner.View;

type
  TMainForm = class(TForm)
  private
    FData: IDataContext;
    FMemo: TMemo;
    procedure BuildUI;
    procedure FillSummary;
    procedure PartnerClick(Sender: TObject);
    procedure ModulePlaceholderClick(Sender: TObject);
  public
    constructor CreateWithData(AOwner: TComponent; const AData: IDataContext); reintroduce;
  end;

implementation

constructor TMainForm.CreateWithData(AOwner: TComponent; const AData: IDataContext);
begin
  inherited CreateNew(AOwner);
  FData := AData;
  BuildUI;
  FillSummary;
end;

procedure TMainForm.BuildUI;
var
  TopPanel, BtnPanel: TPanel;
  TitleLbl, ModeLbl: TLabel;
  Names: array[0..5] of string;
  Btn: TButton;
  I: Integer;
begin
  Caption := '건축자재상 ERP';
  Width := 760; Height := 520;
  Position := poScreenCenter;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 56;
  TopPanel.BevelOuter := bvNone;
  TopPanel.Color := clWhite;

  TitleLbl := TLabel.Create(Self);
  TitleLbl.Parent := TopPanel;
  TitleLbl.Left := 16; TitleLbl.Top := 8;
  TitleLbl.Font.Size := 14; TitleLbl.Font.Style := [fsBold];
  TitleLbl.Caption := '건축자재상 ERP';

  ModeLbl := TLabel.Create(Self);
  ModeLbl.Parent := TopPanel;
  ModeLbl.Left := 18; ModeLbl.Top := 34;
  ModeLbl.Caption := '데이터 모드: ' + FData.ProviderName +
    '  (Firebird 미설치 시 자동 인메모리 구동)';

  BtnPanel := TPanel.Create(Self);
  BtnPanel.Parent := Self;
  BtnPanel.Align := alTop;
  BtnPanel.Height := 44;
  BtnPanel.BevelOuter := bvNone;

  Names[0] := '품목'; Names[1] := '거래처'; Names[2] := '재고';
  Names[3] := '견적'; Names[4] := '출고'; Names[5] := '이력';
  for I := 0 to 5 do
  begin
    Btn := TButton.Create(Self);
    Btn.Parent := BtnPanel;
    Btn.Left := 12 + I * 120;
    Btn.Top := 8; Btn.Width := 110; Btn.Height := 28;
    Btn.Caption := Names[I];
    if I = 1 then
      Btn.OnClick := PartnerClick
    else
      Btn.OnClick := ModulePlaceholderClick;
  end;

  FMemo := TMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.Align := alClient;
  FMemo.ReadOnly := True;
  FMemo.ScrollBars := ssBoth;
  FMemo.Font.Name := 'Consolas';
end;

procedure TMainForm.FillSummary;
var
  Items: TItemArray;
  Partners: TPartnerArray;
  I: Integer;
begin
  FMemo.Lines.BeginUpdate;
  try
    FMemo.Lines.Clear;
    FMemo.Lines.Add('=== 코어 계약 검증 (Memory 프로바이더 시드 데이터) ===');
    FMemo.Lines.Add('');

    Items := FData.Items.GetAll;
    FMemo.Lines.Add('[품목 / 현재재고]');
    for I := 0 to High(Items) do
      FMemo.Lines.Add(Format('  %-8s %-24s %6s %10.0f %-3s   재고 %.0f',
        [Items[I].Code, Items[I].Name, Items[I].Spec, Items[I].UnitPrice,
         Items[I].UnitName, FData.Inventory.GetStock(Items[I].Id)]));

    FMemo.Lines.Add('');
    Partners := FData.Partners.GetAll;
    FMemo.Lines.Add('[거래처]');
    for I := 0 to High(Partners) do
      FMemo.Lines.Add(Format('  %-6s %-16s %s',
        [Partners[I].Code, Partners[I].Name, Partners[I].BizNo]));

    FMemo.Lines.Add('');
    FMemo.Lines.Add('상단 버튼(품목/거래처/재고/견적/출고/이력)은 하위 모듈에서 구현됩니다.');
  finally
    FMemo.Lines.EndUpdate;
  end;
end;

procedure TMainForm.PartnerClick(Sender: TObject);
begin
  TPartnerView.Execute(Self, FData.Partners);
  FillSummary;
end;

procedure TMainForm.ModulePlaceholderClick(Sender: TObject);
begin
  ShowMessage((Sender as TButton).Caption + ' 모듈은 준비 중입니다. (해당 모듈 브랜치에서 구현)');
end;

end.
