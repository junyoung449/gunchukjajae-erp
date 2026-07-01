unit App.Data.Memory;

{ 인메모리 데이터 프로바이더 (기본값).
  Firebird 미설치 환경에서도 앱이 구동되도록 하는 구현. 시작 시 샘플 데이터를 시드한다.
  각 저장소는 dynamic array 로 데이터를 보관한다(소규모라 충분). }

{$mode delphi}{$H+}

interface

uses
  SysUtils, App.Core.Entities, App.Core.Contracts;

type
  TMemoryItemRepository = class(TInterfacedObject, IItemRepository)
  private
    FItems: TItemArray;
    FNextId: Integer;
    function IndexOf(const AId: Integer): Integer;
  public
    function GetAll: TItemArray;
    function GetById(const AId: Integer): TItem;
    function Add(const AItem: TItem): Integer;
    procedure Update(const AItem: TItem);
    procedure Delete(const AId: Integer);
  end;

  TMemoryPartnerRepository = class(TInterfacedObject, IPartnerRepository)
  private
    FPartners: TPartnerArray;
    FNextId: Integer;
    function IndexOf(const AId: Integer): Integer;
  public
    function GetAll: TPartnerArray;
    function GetByKind(const AKind: TPartnerKind): TPartnerArray;
    function GetById(const AId: Integer): TPartner;
    function Add(const APartner: TPartner): Integer;
    procedure Update(const APartner: TPartner);
    procedure Delete(const AId: Integer);
  end;

  TMemoryInventoryRepository = class(TInterfacedObject, IInventoryRepository)
  private
    FMoves: TStockMoveArray;
    FNextId: Integer;
  public
    function GetStock(const AItemId: Integer): Double;
    procedure Move(const AItemId: Integer; const AQty: Double;
      const AKind: TStockMoveKind; const ARefNo: string);
    function GetMoves: TStockMoveArray;
  end;

  TMemoryQuoteRepository = class(TInterfacedObject, IQuoteRepository)
  private
    FQuotes: TQuoteArray;
    FNextId: Integer;
    function IndexOf(const AId: Integer): Integer;
  public
    function GetAll: TQuoteArray;
    function GetById(const AId: Integer): TQuote;
    function Add(const AQuote: TQuote): Integer;
    procedure Update(const AQuote: TQuote);
    procedure Delete(const AId: Integer);
  end;

  TMemoryShipmentRepository = class(TInterfacedObject, IShipmentRepository)
  private
    FShipments: TShipmentArray;
    FNextId: Integer;
    FInventory: IInventoryRepository;  // 출고 확정 시 재고 차감에 사용
    function IndexOf(const AId: Integer): Integer;
  public
    constructor Create(const AInventory: IInventoryRepository);
    function GetAll: TShipmentArray;
    function GetById(const AId: Integer): TShipment;
    function Add(const AShipment: TShipment): Integer;
    procedure Delete(const AId: Integer);
  end;

  TMemoryHistoryRepository = class(TInterfacedObject, IHistoryRepository)
  private
    FItems: IItemRepository;
    FPartners: IPartnerRepository;
    FInventory: IInventoryRepository;
    FShipments: IShipmentRepository;
    function ItemName(const AItemId: Integer): string;
    function PartnerName(const APartnerId: Integer): string;
  public
    constructor Create(const AItems: IItemRepository;
      const APartners: IPartnerRepository; const AInventory: IInventoryRepository;
      const AShipments: IShipmentRepository);
    function Query(const AFilter: THistoryFilter): THistoryRowArray;
  end;

  { 데이터 컨텍스트: 저장소들을 생성·연결하고 샘플 데이터를 시드한다. }
  TMemoryDataContext = class(TInterfacedObject, IDataContext)
  private
    FItems: IItemRepository;
    FPartners: IPartnerRepository;
    FInventory: IInventoryRepository;
    FQuotes: IQuoteRepository;
    FShipments: IShipmentRepository;
    FHistory: IHistoryRepository;
    procedure Seed;
  public
    constructor Create;
    function Items: IItemRepository;
    function Partners: IPartnerRepository;
    function Inventory: IInventoryRepository;
    function Quotes: IQuoteRepository;
    function Shipments: IShipmentRepository;
    function History: IHistoryRepository;
    function ProviderName: string;
  end;

implementation

{ ── 공용 헬퍼 ───────────────────────────────────────────────── }

function MakeItem(const ACode, AName, ASpec, AUnit: string;
  const APrice: Currency): TItem;
begin
  Result := Default(TItem);
  Result.Code := ACode; Result.Name := AName; Result.Spec := ASpec;
  Result.UnitName := AUnit; Result.UnitPrice := APrice; Result.Active := True;
end;

function MakePartner(const ACode, AName: string; const AKind: TPartnerKind;
  const ABizNo, AOwner, APhone: string): TPartner;
begin
  Result := Default(TPartner);
  Result.Code := ACode; Result.Name := AName; Result.Kind := AKind;
  Result.BizNo := ABizNo; Result.Owner := AOwner; Result.Phone := APhone;
  Result.Active := True;
end;

{ ── TMemoryItemRepository ───────────────────────────────────── }

function TMemoryItemRepository.IndexOf(const AId: Integer): Integer;
var I: Integer;
begin
  for I := 0 to High(FItems) do
    if FItems[I].Id = AId then Exit(I);
  Result := -1;
end;

function TMemoryItemRepository.GetAll: TItemArray;
begin
  Result := Copy(FItems);
end;

function TMemoryItemRepository.GetById(const AId: Integer): TItem;
var Idx: Integer;
begin
  Idx := IndexOf(AId);
  if Idx >= 0 then Result := FItems[Idx]
  else Result := Default(TItem);
end;

function TMemoryItemRepository.Add(const AItem: TItem): Integer;
var Item: TItem;
begin
  Inc(FNextId);
  Item := AItem;
  Item.Id := FNextId;
  SetLength(FItems, Length(FItems) + 1);
  FItems[High(FItems)] := Item;
  Result := FNextId;
end;

procedure TMemoryItemRepository.Update(const AItem: TItem);
var Idx: Integer;
begin
  Idx := IndexOf(AItem.Id);
  if Idx >= 0 then FItems[Idx] := AItem;
end;

procedure TMemoryItemRepository.Delete(const AId: Integer);
var Idx, I: Integer;
begin
  Idx := IndexOf(AId);
  if Idx < 0 then Exit;
  for I := Idx to High(FItems) - 1 do FItems[I] := FItems[I + 1];
  SetLength(FItems, Length(FItems) - 1);
end;

{ ── TMemoryPartnerRepository ────────────────────────────────── }

function TMemoryPartnerRepository.IndexOf(const AId: Integer): Integer;
var I: Integer;
begin
  for I := 0 to High(FPartners) do
    if FPartners[I].Id = AId then Exit(I);
  Result := -1;
end;

function TMemoryPartnerRepository.GetAll: TPartnerArray;
begin
  Result := Copy(FPartners);
end;

function TMemoryPartnerRepository.GetByKind(const AKind: TPartnerKind): TPartnerArray;
var I, N: Integer;
begin
  SetLength(Result, 0); N := 0;
  for I := 0 to High(FPartners) do
    if (FPartners[I].Kind = AKind) or (FPartners[I].Kind = pkBoth) then
    begin
      SetLength(Result, N + 1); Result[N] := FPartners[I]; Inc(N);
    end;
end;

function TMemoryPartnerRepository.GetById(const AId: Integer): TPartner;
var Idx: Integer;
begin
  Idx := IndexOf(AId);
  if Idx >= 0 then Result := FPartners[Idx]
  else Result := Default(TPartner);
end;

function TMemoryPartnerRepository.Add(const APartner: TPartner): Integer;
var P: TPartner;
begin
  Inc(FNextId);
  P := APartner; P.Id := FNextId;
  SetLength(FPartners, Length(FPartners) + 1);
  FPartners[High(FPartners)] := P;
  Result := FNextId;
end;

procedure TMemoryPartnerRepository.Update(const APartner: TPartner);
var Idx: Integer;
begin
  Idx := IndexOf(APartner.Id);
  if Idx >= 0 then FPartners[Idx] := APartner;
end;

procedure TMemoryPartnerRepository.Delete(const AId: Integer);
var Idx, I: Integer;
begin
  Idx := IndexOf(AId);
  if Idx < 0 then Exit;
  for I := Idx to High(FPartners) - 1 do FPartners[I] := FPartners[I + 1];
  SetLength(FPartners, Length(FPartners) - 1);
end;

{ ── TMemoryInventoryRepository ──────────────────────────────── }

function TMemoryInventoryRepository.GetStock(const AItemId: Integer): Double;
var I: Integer; Sum: Double;
begin
  Sum := 0;
  for I := 0 to High(FMoves) do
    if FMoves[I].ItemId = AItemId then
      case FMoves[I].Kind of
        smkIn:     Sum := Sum + FMoves[I].Qty;
        smkOut:    Sum := Sum - FMoves[I].Qty;
        smkAdjust: Sum := Sum + FMoves[I].Qty;  // 조정은 부호 포함 수량
      end;
  Result := Sum;
end;

procedure TMemoryInventoryRepository.Move(const AItemId: Integer;
  const AQty: Double; const AKind: TStockMoveKind; const ARefNo: string);
var M: TStockMove;
begin
  Inc(FNextId);
  M := Default(TStockMove);
  M.Id := FNextId; M.ItemId := AItemId; M.Qty := AQty; M.Kind := AKind;
  M.RefNo := ARefNo; M.MovedAt := Now;
  SetLength(FMoves, Length(FMoves) + 1);
  FMoves[High(FMoves)] := M;
end;

function TMemoryInventoryRepository.GetMoves: TStockMoveArray;
begin
  Result := Copy(FMoves);
end;

{ ── TMemoryQuoteRepository ──────────────────────────────────── }

function TMemoryQuoteRepository.IndexOf(const AId: Integer): Integer;
var I: Integer;
begin
  for I := 0 to High(FQuotes) do
    if FQuotes[I].Id = AId then Exit(I);
  Result := -1;
end;

function TMemoryQuoteRepository.GetAll: TQuoteArray;
begin
  Result := Copy(FQuotes);
end;

function TMemoryQuoteRepository.GetById(const AId: Integer): TQuote;
var Idx: Integer;
begin
  Idx := IndexOf(AId);
  if Idx >= 0 then Result := FQuotes[Idx] else Result := Default(TQuote);
end;

function TMemoryQuoteRepository.Add(const AQuote: TQuote): Integer;
var Q: TQuote;
begin
  Inc(FNextId);
  Q := AQuote; Q.Id := FNextId;
  SetLength(FQuotes, Length(FQuotes) + 1);
  FQuotes[High(FQuotes)] := Q;
  Result := FNextId;
end;

procedure TMemoryQuoteRepository.Update(const AQuote: TQuote);
var Idx: Integer;
begin
  Idx := IndexOf(AQuote.Id);
  if Idx >= 0 then FQuotes[Idx] := AQuote;
end;

procedure TMemoryQuoteRepository.Delete(const AId: Integer);
var Idx, I: Integer;
begin
  Idx := IndexOf(AId);
  if Idx < 0 then Exit;
  for I := Idx to High(FQuotes) - 1 do FQuotes[I] := FQuotes[I + 1];
  SetLength(FQuotes, Length(FQuotes) - 1);
end;

{ ── TMemoryShipmentRepository ───────────────────────────────── }

constructor TMemoryShipmentRepository.Create(const AInventory: IInventoryRepository);
begin
  inherited Create;
  FInventory := AInventory;
end;

function TMemoryShipmentRepository.IndexOf(const AId: Integer): Integer;
var I: Integer;
begin
  for I := 0 to High(FShipments) do
    if FShipments[I].Id = AId then Exit(I);
  Result := -1;
end;

function TMemoryShipmentRepository.GetAll: TShipmentArray;
begin
  Result := Copy(FShipments);
end;

function TMemoryShipmentRepository.GetById(const AId: Integer): TShipment;
var Idx: Integer;
begin
  Idx := IndexOf(AId);
  if Idx >= 0 then Result := FShipments[Idx] else Result := Default(TShipment);
end;

function TMemoryShipmentRepository.Add(const AShipment: TShipment): Integer;
var S: TShipment; I: Integer;
begin
  Inc(FNextId);
  S := AShipment; S.Id := FNextId;
  if S.ShipNo = '' then S.ShipNo := 'SH' + IntToStr(FNextId);
  SetLength(FShipments, Length(FShipments) + 1);
  FShipments[High(FShipments)] := S;
  // 출고 확정 → 재고 차감
  if FInventory <> nil then
    for I := 0 to High(S.Lines) do
      FInventory.Move(S.Lines[I].ItemId, S.Lines[I].Qty, smkOut, S.ShipNo);
  Result := FNextId;
end;

procedure TMemoryShipmentRepository.Delete(const AId: Integer);
var Idx, I: Integer;
begin
  Idx := IndexOf(AId);
  if Idx < 0 then Exit;
  for I := Idx to High(FShipments) - 1 do FShipments[I] := FShipments[I + 1];
  SetLength(FShipments, Length(FShipments) - 1);
end;

{ ── TMemoryHistoryRepository ────────────────────────────────── }

constructor TMemoryHistoryRepository.Create(const AItems: IItemRepository;
  const APartners: IPartnerRepository; const AInventory: IInventoryRepository;
  const AShipments: IShipmentRepository);
begin
  inherited Create;
  FItems := AItems; FPartners := APartners;
  FInventory := AInventory; FShipments := AShipments;
end;

function TMemoryHistoryRepository.ItemName(const AItemId: Integer): string;
begin
  Result := FItems.GetById(AItemId).Name;
end;

function TMemoryHistoryRepository.PartnerName(const APartnerId: Integer): string;
begin
  Result := FPartners.GetById(APartnerId).Name;
end;

function TMemoryHistoryRepository.Query(const AFilter: THistoryFilter): THistoryRowArray;
var
  Moves: TStockMoveArray;
  Ships: TShipmentArray;
  Row: THistoryRow;
  I, J, N: Integer;

  function DateOk(const AWhen: TDateTime): Boolean;
  begin
    Result := ((AFilter.FromDate = 0) or (AWhen >= AFilter.FromDate))
          and ((AFilter.ToDate   = 0) or (AWhen <= AFilter.ToDate));
  end;

begin
  SetLength(Result, 0); N := 0;

  // 재고 이동
  if (AFilter.Kinds = []) or (hkStockMove in AFilter.Kinds) then
  begin
    Moves := FInventory.GetMoves;
    for I := 0 to High(Moves) do
    begin
      if not DateOk(Moves[I].MovedAt) then Continue;
      if (AFilter.ItemId <> 0) and (Moves[I].ItemId <> AFilter.ItemId) then Continue;
      Row := Default(THistoryRow);
      Row.When_ := Moves[I].MovedAt;
      Row.Kind := hkStockMove;
      Row.RefNo := Moves[I].RefNo;
      Row.ItemName := ItemName(Moves[I].ItemId);
      Row.Qty := Moves[I].Qty;
      SetLength(Result, N + 1); Result[N] := Row; Inc(N);
    end;
  end;

  // 출고
  if (AFilter.Kinds = []) or (hkShipment in AFilter.Kinds) then
  begin
    Ships := FShipments.GetAll;
    for I := 0 to High(Ships) do
    begin
      if not DateOk(Ships[I].ShipDate) then Continue;
      if (AFilter.PartnerId <> 0) and (Ships[I].PartnerId <> AFilter.PartnerId) then Continue;
      for J := 0 to High(Ships[I].Lines) do
      begin
        if (AFilter.ItemId <> 0) and (Ships[I].Lines[J].ItemId <> AFilter.ItemId) then Continue;
        Row := Default(THistoryRow);
        Row.When_ := Ships[I].ShipDate;
        Row.Kind := hkShipment;
        Row.RefNo := Ships[I].ShipNo;
        Row.PartnerName := PartnerName(Ships[I].PartnerId);
        Row.ItemName := ItemName(Ships[I].Lines[J].ItemId);
        Row.Qty := Ships[I].Lines[J].Qty;
        Row.Amount := Ships[I].Lines[J].Amount;
        SetLength(Result, N + 1); Result[N] := Row; Inc(N);
      end;
    end;
  end;
end;

{ ── TMemoryDataContext ──────────────────────────────────────── }

constructor TMemoryDataContext.Create;
begin
  inherited Create;
  FItems := TMemoryItemRepository.Create;
  FPartners := TMemoryPartnerRepository.Create;
  FInventory := TMemoryInventoryRepository.Create;
  FQuotes := TMemoryQuoteRepository.Create;
  FShipments := TMemoryShipmentRepository.Create(FInventory);
  FHistory := TMemoryHistoryRepository.Create(FItems, FPartners, FInventory, FShipments);
  Seed;
end;

procedure TMemoryDataContext.Seed;
var
  Id1, Id2, Id3, Id4: Integer;
begin
  // 품목 샘플
  Id1 := FItems.Add(MakeItem('IT-1001', '포틀랜드 시멘트 40kg', '40kg', '포', 8500));
  Id2 := FItems.Add(MakeItem('IT-1002', '석고보드', '9.5mm 900x1800', '장', 4200));
  Id3 := FItems.Add(MakeItem('IT-1003', '바닥타일', '300x600 무광', 'BOX', 26000));
  Id4 := FItems.Add(MakeItem('IT-1004', '단열재 압출법 보온판', 'T30 900x1800', '장', 9800));
  FItems.Add(MakeItem('IT-1005', '방수 시트', '1m x 20m', 'roll', 45000));

  // 거래처 샘플
  FPartners.Add(MakePartner('CU-01', '대성건설', pkCustomer, '123-45-67890', '김대성', '02-111-2222'));
  FPartners.Add(MakePartner('CU-02', '한빛인테리어', pkCustomer, '234-56-78901', '이한빛', '031-222-3333'));
  FPartners.Add(MakePartner('SU-01', '동양시멘트', pkSupplier, '345-67-89012', '박동양', '051-333-4444'));

  // 초기 재고(입고)
  FInventory.Move(Id1, 200, smkIn, 'INIT');
  FInventory.Move(Id2, 500, smkIn, 'INIT');
  FInventory.Move(Id3, 80,  smkIn, 'INIT');
  FInventory.Move(Id4, 120, smkIn, 'INIT');
end;

function TMemoryDataContext.Items: IItemRepository;       begin Result := FItems; end;
function TMemoryDataContext.Partners: IPartnerRepository; begin Result := FPartners; end;
function TMemoryDataContext.Inventory: IInventoryRepository; begin Result := FInventory; end;
function TMemoryDataContext.Quotes: IQuoteRepository;     begin Result := FQuotes; end;
function TMemoryDataContext.Shipments: IShipmentRepository; begin Result := FShipments; end;
function TMemoryDataContext.History: IHistoryRepository;  begin Result := FHistory; end;
function TMemoryDataContext.ProviderName: string;         begin Result := 'Memory'; end;

end.
