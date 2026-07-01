# 이력 조회 유지보수 문서

## 1. 구현한 기능
- 재고 이동, 출고, 견적 이력을 한 화면의 그리드에 통합 표시한다.
- 시작일, 종료일, 거래처, 품목, 유형 필터를 제공한다.
- 화면은 조회 전용이며 데이터 생성, 수정, 삭제 메서드를 호출하지 않는다.

## 2. 생성·수정한 파일
| 파일 | 역할 |
|------|------|
| `src/modules/history/App.Modules.History.View.pas` | 이력 조회 화면과 필터/그리드 갱신 로직 |
| `src/app/App.Main.pas` | 메인 화면의 이력 버튼을 `THistoryView.Execute`에 연결 |
| `src/app/ERP.lpi` | history 유닛과 검색 경로 등록 |
| `docs/maintenance/history.md` | 유지보수 안내 |

## 3. 주요 클래스와 메서드
- `THistoryView.Execute`: 메인 화면에서 호출하는 이력 조회 진입점이다.
- `THistoryView.BuildUI`: 기간, 거래처, 품목, 유형 필터와 결과 그리드를 생성한다.
- `THistoryView.BuildFilter`: 화면 입력값을 `THistoryFilter`로 변환하고 날짜 형식을 검증한다.
- `THistoryView.RefreshGrid`: `IHistoryRepository.Query` 결과를 읽어 필터 보정 후 그리드를 갱신한다.
- `THistoryView.SortRowsByDateDesc`: 결과를 최신 일시순으로 정렬한다.

## 4. 코드 실행 흐름
1. 메인 화면에서 `이력` 버튼을 누르면 `TMainForm.HistoryClick`이 실행된다.
2. `THistoryView.Execute(Self, FData)`가 데이터 컨텍스트를 받아 모달 화면을 연다.
3. 화면 생성 시 `Items.GetAll`, `Partners.GetAll`로 필터 콤보를 채운다.
4. `RefreshGrid`가 `FData.History.Query(Filter)`를 호출해 이력 행을 읽는다.
5. 조회 결과는 일시, 유형, 참조번호, 거래처, 품목, 수량, 금액 컬럼에 표시된다.

## 5. 데이터가 생성·변경되는 위치
- 이 화면은 데이터 변경을 수행하지 않는다.
- 사용하는 읽기 인터페이스는 `IDataContext.History`, `IDataContext.Items`, `IDataContext.Partners`이다.
- 데이터 통합 방식이 바뀌면 `IHistoryRepository.Query` 구현을 확인한다.

## 6. 사용한 Delphi/Object Pascal 기술
- `.lfm` 없이 `CreateNew`와 런타임 컨트롤 생성으로 폼을 구성했다.
- `TComboBox`, `TEdit`, `TStringGrid`를 사용해 필터와 목록을 구현했다.
- `record` 기반 `THistoryFilter`, `THistoryRow`를 저장소 인터페이스와 주고받는다.
- `set of THistoryKind`를 사용해 유형 필터를 저장소에 전달한다.

## 7. 이 코드를 이해하기 위한 학습 항목
- Lazarus LCL 폼과 컨트롤 생성 방식
- `TStringGrid` 행/열 데이터 표시
- 인터페이스 기반 저장소 주입
- `TDateTime`, `EncodeDate`, `FormatDateTime` 사용법
- Object Pascal의 set 타입

## 8. 수정 또는 확장 시 확인할 위치
- 필터 항목 추가: `THistoryView.BuildUI`, `THistoryView.BuildFilter`, `THistoryFilter`
- 그리드 컬럼 추가: `THistoryView.BuildUI`, `THistoryView.RefreshGrid`, `THistoryRow`
- 이력 유형 추가: `THistoryKind`, `HistoryKindText`, `IHistoryRepository.Query`
- 메인 화면 진입 방식 변경: `TMainForm.HistoryClick`
