unit App.Core.ProviderFactory;

{ 설정(app.ini)을 읽어 데이터 컨텍스트를 하나 생성한다.
  Provider=Firebird 인데 아직 구현/연결이 없으면 Memory 로 폴백한다.
  → 평가 제출 시 Firebird 미설치여도 앱이 반드시 구동된다. }

{$mode delphi}{$H+}

interface

uses
  App.Core.Contracts;

type
  TAppConfig = record
    ProviderName: string;   // 'Memory' | 'Firebird'
  end;

{ app.ini 를 읽어 설정 반환. 파일이 없으면 기본값(Memory). }
function LoadConfig(const AIniPath: string): TAppConfig;

{ 설정에 따라 컨텍스트 생성. Firebird 실패 시 Memory 폴백. }
function CreateDataContext(const AConfig: TAppConfig): IDataContext;

implementation

uses
  SysUtils, IniFiles, App.Data.Memory;
  // 향후: App.Data.Firebird 추가

function LoadConfig(const AIniPath: string): TAppConfig;
var
  Ini: TIniFile;
begin
  Result.ProviderName := 'Memory';
  if not FileExists(AIniPath) then Exit;
  Ini := TIniFile.Create(AIniPath);
  try
    Result.ProviderName := Ini.ReadString('Data', 'Provider', 'Memory');
  finally
    Ini.Free;
  end;
end;

function CreateDataContext(const AConfig: TAppConfig): IDataContext;
begin
  if SameText(AConfig.ProviderName, 'Firebird') then
  begin
    // Firebird 프로바이더는 아직 미구현.
    // 구현 후: try Result := TFirebirdDataContext.Create(...) except Result := Memory 폴백 end;
    // 현재는 Memory 로 폴백한다.
    Result := TMemoryDataContext.Create;
    Exit;
  end;
  Result := TMemoryDataContext.Create;
end;

end.
