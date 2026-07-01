unit App.Core.Entities;

{ 공통 엔티티 정의.
  모든 모듈이 공유하는 데이터 구조다. 여기서 정의한 record/enum 은 계약의 일부이므로
  변경 시 전 모듈에 영향을 준다. (식별자 영어 / 주석 한글 규칙) }

{$mode delphi}{$H+}{$J-}

interface

type
  { 거래처 구분 }
  TPartnerKind = (pkCustomer, pkSupplier, pkBoth);   // 고객 / 매입처 / 겸용

  { 재고 이동 유형 }
  TStockMoveKind = (smkIn, smkOut, smkAdjust);        // 입고 / 출고 / 조정

  { 이력 유형 }
  THistoryKind = (hkStockMove, hkShipment, hkQuote);  // 재고이동 / 출고 / 견적
  THistoryKinds = set of THistoryKind;

  { 품목 }
  TItem = record
    Id: Integer;
    Code: string;        // 품목코드(고유)
    Name: string;        // 품목명
    Spec: string;        // 규격
    UnitName: string;    // 단위(EA, 장, m2, 포 ...) — 'Unit'은 예약어라 UnitName 사용
    UnitPrice: Currency; // 기준 단가
    Active: Boolean;     // 사용 여부
  end;
  TItemArray = array of TItem;

  { 거래처 }
  TPartner = record
    Id: Integer;
    Code: string;
    Name: string;        // 상호
    Kind: TPartnerKind;
    BizNo: string;       // 사업자번호
    Owner: string;       // 대표자
    Phone: string;
    Address: string;
    Active: Boolean;
  end;
  TPartnerArray = array of TPartner;

  { 재고 이동 1건 }
  TStockMove = record
    Id: Integer;
    ItemId: Integer;
    Qty: Double;
    Kind: TStockMoveKind;
    RefNo: string;       // 참조번호(출고번호 등)
    MovedAt: TDateTime;
    Note: string;
  end;
  TStockMoveArray = array of TStockMove;

  { 견적 라인 / 견적 }
  TQuoteLine = record
    ItemId: Integer;
    Qty: Double;
    UnitPrice: Currency;
    Amount: Currency;    // Qty * UnitPrice
  end;
  TQuoteLineArray = array of TQuoteLine;

  TQuote = record
    Id: Integer;
    QuoteNo: string;
    PartnerId: Integer;
    QuoteDate: TDateTime;
    Lines: TQuoteLineArray;
    SubTotal: Currency;
    Vat: Currency;
    Total: Currency;
    Note: string;
  end;
  TQuoteArray = array of TQuote;

  { 출고 라인 / 출고 }
  TShipmentLine = record
    ItemId: Integer;
    Qty: Double;
    UnitPrice: Currency;
    Amount: Currency;
  end;
  TShipmentLineArray = array of TShipmentLine;

  TShipment = record
    Id: Integer;
    ShipNo: string;
    PartnerId: Integer;
    ShipDate: TDateTime;
    Lines: TShipmentLineArray;
    Total: Currency;
    Note: string;
  end;
  TShipmentArray = array of TShipment;

  { 이력 조회 필터 / 결과행 }
  THistoryFilter = record
    FromDate: TDateTime;   // 0 = 하한 없음
    ToDate: TDateTime;     // 0 = 상한 없음
    PartnerId: Integer;    // 0 = 전체
    ItemId: Integer;       // 0 = 전체
    Kinds: THistoryKinds;  // [] = 전체
  end;

  THistoryRow = record
    When_: TDateTime;      // 'When'은 예약어라 When_ 사용
    Kind: THistoryKind;
    RefNo: string;
    PartnerName: string;
    ItemName: string;
    Qty: Double;
    Amount: Currency;
  end;
  THistoryRowArray = array of THistoryRow;

implementation

end.
