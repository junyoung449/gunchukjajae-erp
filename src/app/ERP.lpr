program ERP;

{ 진입점. 설정을 읽어 데이터 컨텍스트를 만들고(기본 Memory), 메인 셸을 띄운다.
  DB 없이도 반드시 구동된다. }

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF}
  Interfaces,          // LCL 위젯셋 초기화
  SysUtils,
  Forms,
  App.Core.Contracts,
  App.Core.ProviderFactory,
  App.Data.Memory,
  App.Main;

var
  Config: TAppConfig;
  Data: IDataContext;
  MainForm: TMainForm;
begin
  RequireDerivedFormResource := False;
  Application.Scaled := True;
  Application.Initialize;
  Application.Title := '건축자재상 ERP';
  Application.MainFormOnTaskBar := True;

  Config := LoadConfig(ExtractFilePath(ParamStr(0)) + 'app.ini');
  Data := CreateDataContext(Config);

  MainForm := TMainForm.CreateWithData(Application, Data);
  MainForm.Show;

  Application.Run;
end.
