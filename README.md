# 출고 관리 유지보수 문서

## 1. 구현된 기능
- 출고번호, 거래처, 일자, 라인 수, 합계, 비고를 표시하는 출고 목록 화면을 제공한다.
- 출고 등록 화면에서 거래처를 선택하고, 품목 라인과 수량을 입력해 출고를 저장한다.
- 품목 라인을 추가할 때 선택한 품목의 현재 기준 단가를 자동으로 적용하고 금액을 계산한다.
- 저장 전 출고 수량이 현재 재고보다 큰 품목이 있으면 재고 부족 경고를 표시한다.
- 재고 부족 경고는 기본적으로 저장을 막지 않고, 사용자가 확인하면 출고를 계속 진행할 수 있다.
- 선택한 출고 건은 `IShipmentRepository.Delete`를 통해 삭제할 수 있다.

## 2. 생성 및 수정된 파일
| 파일 | 역할 |
|------|------|
| `src/modules/shipment/App.Modules.Shipment.View.pas` | 출고 목록 및 등록 화면 |
| `src/app/App.Main.pas` | 메인 화면의 출고 버튼을 출고 화면에 연결 |
| `src/app/ERP.lpi` | 출고 유닛과 검색 경로 등록 |
| `docs/maintenance/shipment.md` | 출고 모듈 유지보수 문서 |
| `README.md` | 출고 모듈 유지보수 문서와 동일한 공개 설명 |

## 3. 주요 클래스와 메서드
- `TShipmentView.Execute`: 메인 화면에서 호출하는 출고 화면 진입점이다. `IDataContext`를 받아 화면을 연다.
- `TShipmentView.RefreshGrid`: `FData.Shipments.GetAll`로 출고 목록을 읽어 그리드에 다시 표시한다.
- `TShipmentView.NewClick`: 출고 등록 창을 열고 저장 결과를 `FData.Shipments.Add`로 전달한다.
- `TShipmentEditForm.AddLineClick`: 선택한 품목과 수량으로 출고 라인을 추가한다. 단가는 품목 기준 단가를 자동 사용한다.
- `TShipmentEditForm.StockWarningAccepted`: `FData.Inventory.GetStock`으로 현재 재고를 조회하고 부족 시 계속 진행 여부를 확인한다.
- `TShipmentEditForm.SaveClick`: 거래처, 라인, 합계, 일자, 비고를 담은 `TShipment` 값을 완성한다.

## 4. 코드 실행 흐름
1. 메인 화면의 버튼 인덱스 `I = 4`가 `TShipmentView.Execute(Self, FData)`를 호출한다.
2. `TShipmentView`는 `IDataContext`를 보관하고 `RefreshGrid`로 기존 출고 목록을 표시한다.
3. 사용자가 `신규` 버튼을 누르면 `TShipmentEditForm`이 열린다.
4. 등록 창에서 거래처를 선택하고 품목과 수량을 입력한 뒤 `라인 추가`를 누른다.
5. 각 라인은 `TShipmentLine`으로 저장되며 `UnitPrice`와 `Amount`가 자동 계산된다.
6. 저장 시 재고 부족 여부를 확인하고, 부족하면 경고 후 사용자가 계속할지 선택한다.
7. 저장이 확정되면 화면은 `FData.Shipments.Add(Form.Shipment)`만 호출한다.
8. Memory 프로바이더의 `TMemoryShipmentRepository.Add`가 각 라인에 대해 `Inventory.Move(..., smkOut, ShipNo)`를 호출해 재고를 차감한다.

## 5. 데이터가 생성 및 변경되는 위치
- 출고 데이터 생성은 `IShipmentRepository.Add`를 통해서만 이루어진다.
- 출고 데이터 삭제는 `IShipmentRepository.Delete`를 통해 이루어진다.
- 출고 화면은 `Inventory.Move`를 직접 호출하지 않는다.
- 실제 재고 차감은 `src/data/App.Data.Memory.pas`의 `TMemoryShipmentRepository.Add`에서 처리한다.
- 재고 부족 확인은 읽기 전용 조회이며 `IInventoryRepository.GetStock`만 사용한다.
- 품목과 거래처는 각각 `IItemRepository`, `IPartnerRepository`를 통해 조회한다.

## 6. 사용된 Delphi/Object Pascal 기술
- `.lfm` 없이 `CreateNew`와 LCL 컨트롤 생성 코드로 화면을 구성한다.
- `IDataContext`를 통해 저장소 인터페이스를 주입받는다.
- `TShipmentLineArray` 동적 배열로 출고 라인을 관리한다.
- `TStringGrid`로 출고 목록과 등록 라인을 표시한다.
- `ShowModal`과 `ModalResult`로 등록 창 저장 흐름을 처리한다.

## 7. 코드를 이해하기 위한 학습 항목
- 인터페이스 기반 저장소 접근 방식
- record와 동적 배열을 이용한 화면 입력값 구성
- `TStringGrid` 행 선택과 라인 추가/삭제 처리
- `Currency`와 `Double` 값을 이용한 금액 및 수량 계산
- 사용자 확인 대화상자로 예외 상황을 허용하는 흐름

## 8. 수정 또는 확장 시 확인할 위치
- 출고 목록 컬럼을 바꾸려면 `TShipmentView.BuildUI`와 `TShipmentView.RefreshGrid`를 확인한다.
- 출고 등록 입력 항목을 바꾸려면 `TShipmentEditForm.BuildUI`와 `TShipmentEditForm.SaveClick`을 확인한다.
- 재고 부족 정책을 바꾸려면 `TShipmentEditForm.StockWarningAccepted`를 확인한다.
- 재고 차감 방식은 화면이 아니라 저장소 구현인 `TMemoryShipmentRepository.Add`에서 확인한다.
- 견적에서 출고로 전환하는 기능을 추가할 때는 `TShipmentEditForm`에 라인 초기화 흐름을 추가하면 된다.
