# 재고 관리 유지보수 문서

## 1. 구현된 기능
- 품목별 현재고 목록을 표시한다. 품목명, 규격, 단위, 현재수량, 상태를 한 화면에서 확인할 수 있다.
- 입고, 출고, 조정 이동을 등록한다. 등록 값은 품목 선택, 수량, 참조번호로 구성된다.
- 출고 또는 음수 조정으로 현재고가 0보다 작아질 때 경고 확인창을 표시한다.
- 목록 상단에는 음수 재고 품목 수를 별도 경고 문구로 표시한다.
- 최근 재고 이동 내역을 역순으로 표시한다.

## 2. 생성·수정한 파일
| 파일 | 역할 |
|------|------|
| `src/modules/inventory/App.Modules.Inventory.View.pas` | 재고 관리 화면과 입고/출고/조정 등록 UI |
| `src/app/App.Main.pas` | 메인 화면의 재고 버튼을 `TInventoryView.Execute(Self, FData)`에 연결 |
| `src/app/ERP.lpi` | 재고 화면 유닛과 `../modules/inventory` 검색 경로 등록 |
| `docs/maintenance/inventory.md` | 유지보수 안내 |

## 3. 주요 클래스와 메서드
- `TInventoryView.Execute`: 메인 화면에서 호출되는 재고 관리 진입점이다. `IDataContext`와 필요한 저장소가 있는지 확인한 뒤 화면을 연다.
- `TInventoryView.RefreshAll`: 품목, 현재고, 이동 내역을 다시 읽어 화면을 갱신한다.
- `TInventoryView.RefreshStockGrid`: `IItemRepository.GetAll`과 `IInventoryRepository.GetStock`으로 품목별 현재고를 구성한다.
- `TInventoryView.RefreshMoveGrid`: `IInventoryRepository.GetMoves` 결과를 최신순으로 표시한다.
- `TInventoryView.RegisterClick`: 입력값을 검증하고 음수 재고 경고 후 `IInventoryRepository.Move`를 호출한다.
- `TInventoryView.StockDelta`: 이동 구분별 현재고 증감 방향을 계산한다.

## 4. 코드 실행 흐름
1. 메인 화면에서 세 번째 버튼을 누르면 `TMainForm.InventoryClick`이 실행된다.
2. `TInventoryView.Execute(Self, FData)`가 `IDataContext`를 받아 재고 화면을 연다.
3. 화면 생성 후 `RefreshAll`이 품목 목록과 재고 이동 내역을 읽어 그리드를 채운다.
4. 사용자가 품목, 구분, 수량, 참조번호를 입력하고 등록을 누르면 `RegisterClick`이 실행된다.
5. 등록 후 현재고가 음수가 될 경우 확인창을 띄우고, 사용자가 계속을 선택하면 `Move`를 호출한다.
6. 이동 등록 후 입력값을 비우고 `RefreshAll`로 현재고와 이동 내역을 다시 표시한다.

## 5. 데이터가 생성·변경되는 위치
- 품목 목록은 `IDataContext.Items`의 `IItemRepository.GetAll`로만 조회한다.
- 현재고와 이동 내역은 `IDataContext.Inventory`의 `IInventoryRepository.GetStock`, `Move`, `GetMoves`로만 접근한다.
- 화면 코드는 Memory 구현체나 Firebird 구현체를 직접 참조하지 않는다.
- 조정 이동은 `TMemoryInventoryRepository.GetStock`의 기존 규칙에 따라 부호 있는 수량으로 반영된다.

## 6. 사용한 Delphi/Object Pascal 기술
- `.lfm` 없이 `CreateNew`와 런타임 컨트롤 생성으로 LCL 화면을 구성한다.
- `TStringGrid`로 품목별 재고와 이동 내역을 표시한다.
- `TComboBox`로 품목과 이동 구분을 선택한다.
- `TryStrToFloat`로 수량 입력을 검증한다.
- `MessageDlg`로 음수 재고 등록 전 사용자 확인을 받는다.

## 7. 이 코드를 이해하기 위한 학습 항목
- Lazarus LCL 폼과 컨트롤 생성 방식
- `IDataContext` 기반 저장소 주입
- `TStockMoveKind`별 재고 수량 계산
- `TStringGrid` 행 초기화와 갱신
- 인터페이스 기반 데이터 접근과 Memory 모드 대체 가능성

## 8. 수정 또는 확장 시 확인할 위치
- 화면 컬럼이나 입력 항목을 바꿀 때는 `TInventoryView.BuildUI`와 각 `Refresh*Grid` 메서드를 함께 확인한다.
- 재고 부족 정책을 바꿀 때는 `TInventoryView.RegisterClick`의 음수 재고 확인 로직을 확인한다.
- 이동 유형 계산 규칙을 바꿀 때는 `TInventoryView.StockDelta`와 `App.Data.Memory.TMemoryInventoryRepository.GetStock`의 규칙이 일치하는지 확인한다.
- 출고 모듈과 연결할 때는 `IInventoryRepository.Move(..., smkOut, ...)` 호출 흐름을 기준으로 확인한다.
