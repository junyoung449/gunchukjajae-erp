# 견적 관리 유지보수 문서

## 1. 구현한 기능
- 견적번호, 거래처, 일자, 공급가액, 부가세, 합계를 견적 목록에 표시한다.
- Memory 모드에서 견적 신규 작성, 수정, 삭제, 미리보기를 제공한다.
- 거래처는 `IPartnerRepository`, 품목은 `IItemRepository`를 통해 조회한다.
- 품목 라인을 추가할 때 선택한 품목의 기본 단가를 자동으로 채운다.
- 수량 또는 단가를 수정하면 라인 금액, 공급가액, 부가세(10%), 합계를 즉시 다시 계산한다.

## 2. 생성·수정한 파일
| 파일 | 역할 |
|------|------|
| `src/modules/quote/App.Modules.Quote.View.pas` | 견적 목록과 편집 화면 |
| `src/app/App.Main.pas` | 메인 화면의 3번 모듈 버튼을 `TQuoteView.Execute(Self, FData)`에 연결 |
| `src/app/ERP.lpi` | quote 유닛과 `../modules/quote` 검색 경로 등록 |
| `docs/maintenance/quote.md` | 견적 모듈 유지보수 안내 |
| `README.md` | 견적 모듈 유지보수 안내와 동일한 요약 문서 |

## 3. 주요 클래스와 메서드
- `TQuoteView.Execute`: 메인 화면에서 호출되는 견적 모듈 진입점이다. `IDataContext`를 받는다.
- `TQuoteView.RefreshGrid`: `IQuoteRepository.GetAll`로 견적 목록을 다시 읽어 그리드를 갱신한다.
- `TQuoteView.EditQuote`: 신규와 수정에서 공통으로 견적 편집 화면을 연다.
- `TQuoteEditForm.AddLineClick`: 선택한 품목을 라인에 추가하고 기본 단가를 복사한다.
- `TQuoteEditForm.Recalculate`: 현재 그리드 값 기준으로 라인 금액, 공급가액, 부가세, 합계를 갱신한다.
- `TQuoteEditForm.SaveClick`: 거래처, 일자, 라인 입력을 검증하고 완성된 `TQuote` 값을 반환한다.

## 4. 코드 실행 흐름
1. 메인 화면의 버튼 인덱스 `3`이 `TMainForm.QuoteClick`을 호출한다.
2. `QuoteClick`은 `TQuoteView.Execute(Self, FData)`로 견적 화면을 연다.
3. 견적 화면은 `FData.Quotes.GetAll`로 목록 데이터를 읽는다.
4. 신규 또는 수정 시 `TQuoteEditForm`을 열고, 거래처와 품목은 `FData.Partners`, `FData.Items`로 조회한다.
5. 저장 시 견적 데이터는 `FData.Quotes.Add` 또는 `FData.Quotes.Update`로만 변경한다.

## 5. 데이터 생성·변경 위치
- 신규 견적은 `IQuoteRepository.Add`를 통해 생성한다.
- 기존 견적은 `IQuoteRepository.Update`를 통해 변경한다.
- 견적 삭제는 `IQuoteRepository.Delete`를 통해 처리한다.
- 품목과 거래처 데이터는 이 모듈에서 읽기 전용으로만 사용한다.
- 화면 코드는 Memory 구현체를 직접 참조하지 않고 `IDataContext`와 repository 인터페이스만 사용한다.

## 6. 사용한 Delphi/Object Pascal 기술
- `.lfm` 없이 `CreateNew`와 런타임 컨트롤 생성으로 Lazarus LCL 화면을 구성한다.
- `TStringGrid` 편집 셀로 라인 수량과 단가를 입력받는다.
- `IDataContext`를 통한 인터페이스 기반 repository 주입을 사용한다.
- `Currency`, `Double` 값을 문자열로 파싱하고 표시용 포맷으로 변환한다.

## 7. 코드를 이해하기 위한 학습 항목
- `App.Core.Entities`의 `TQuoteLine`, `TQuote` record 구조
- `App.Core.Contracts`의 `IQuoteRepository` 계약
- `TQuoteEditForm.Recalculate`의 화면 입력 기반 합계 계산 방식
- `TStringGrid.OnSetEditText` 이벤트와 실시간 계산 흐름

## 8. 수정 또는 확장 시 확인할 위치
- 견적번호 생성 규칙 변경: `NewQuoteNo`
- 출력 또는 인쇄 기능 확장: `TQuoteView.PreviewClick`
- 할인, 부가세율, 라인별 과세 규칙 변경: `TQuoteEditForm.Recalculate`
- 저장 전 검증 규칙 변경: `TQuoteEditForm.SaveClick`
