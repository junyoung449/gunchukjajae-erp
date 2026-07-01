unit App.Core.Contracts;

{ 데이터 접근 계약(인터페이스).
  ★ 모든 모듈은 이 인터페이스에만 의존한다. Memory/Firebird 등 구현 유닛을 직접
    참조하지 않는다. 이것이 "DB 없이 구동" 및 프로바이더 교체의 핵심이다. }

{$mode delphi}{$H+}

interface

uses
  App.Core.Entities;

type
  { 품목 저장소 }
  IItemRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E01}']
    function GetAll: TItemArray;
    function GetById(const AId: Integer): TItem;
    function Add(const AItem: TItem): Integer;   // 반환: 새 Id
    procedure Update(const AItem: TItem);
    procedure Delete(const AId: Integer);
  end;

  { 거래처 저장소 }
  IPartnerRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E02}']
    function GetAll: TPartnerArray;
    function GetByKind(const AKind: TPartnerKind): TPartnerArray;
    function GetById(const AId: Integer): TPartner;
    function Add(const APartner: TPartner): Integer;
    procedure Update(const APartner: TPartner);
    procedure Delete(const AId: Integer);
  end;

  { 재고 저장소 }
  IInventoryRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E03}']
    function GetStock(const AItemId: Integer): Double;
    procedure Move(const AItemId: Integer; const AQty: Double;
      const AKind: TStockMoveKind; const ARefNo: string);
    function GetMoves: TStockMoveArray;
  end;

  { 견적 저장소 }
  IQuoteRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E04}']
    function GetAll: TQuoteArray;
    function GetById(const AId: Integer): TQuote;
    function Add(const AQuote: TQuote): Integer;
    procedure Update(const AQuote: TQuote);
    procedure Delete(const AId: Integer);
  end;

  { 출고 저장소 (확정 시 재고 차감) }
  IShipmentRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E05}']
    function GetAll: TShipmentArray;
    function GetById(const AId: Integer): TShipment;
    function Add(const AShipment: TShipment): Integer;
    procedure Delete(const AId: Integer);
  end;

  { 이력 조회 (읽기 전용) }
  IHistoryRepository = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E06}']
    function Query(const AFilter: THistoryFilter): THistoryRowArray;
  end;

  { 데이터 컨텍스트: 모든 저장소의 진입점. app 이 이 인터페이스를 모듈에 주입한다. }
  IDataContext = interface
    ['{6B1E4F20-1A11-4C21-9F01-0A1B2C3D4E00}']
    function Items: IItemRepository;
    function Partners: IPartnerRepository;
    function Inventory: IInventoryRepository;
    function Quotes: IQuoteRepository;
    function Shipments: IShipmentRepository;
    function History: IHistoryRepository;
    function ProviderName: string;   // 'Memory' | 'Firebird'
  end;

implementation

end.
