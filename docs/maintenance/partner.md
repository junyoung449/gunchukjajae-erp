# 거래처 관리 유지보수 문서

## 1. 구현한 기능
- 거래처 목록 조회, 상호/사업자번호 검색, 구분 필터, 신규 등록, 수정, 삭제 기능을 제공한다.
- 거래처코드, 상호, 사업자번호를 저장 전에 검증하고 중복 코드는 저장하지 않는다.

## 2. 생성·수정한 파일
| 파일 | 역할 |
|------|------|
| `src/modules/partner/App.Modules.Partner.View.pas` | 거래처 관리 화면과 편집 폼 |
| `src/app/App.Main.pas` | 메인 화면의 거래처 버튼 연결 |
| `src/app/ERP.lpi` | 거래처 화면 유닛과 검색 경로 등록 |
| `docs/maintenance/partner.md` | 유지보수 안내 |

## 3. 주요 클래스와 메서드
- `TPartnerView.Execute`: 메인 화면에서 호출하는 거래처 관리 진입점.
- `TPartnerView.RefreshGrid`: 저장소에서 거래처를 다시 읽어 필터와 검색 결과를 표시한다.
- `TPartnerView.EditPartner`: 신규/수정 공통 편집 흐름과 코드 중복 검사를 처리한다.
- `TPartnerEditForm.SaveClick`: 필수값과 사업자번호 형식을 검증한다.

## 4. 코드 실행 흐름
1. 메인 화면에서 `거래처` 버튼을 누르면 `TMainForm.PartnerClick`이 실행된다.
2. `TPartnerView.Execute(Self, FData.Partners)`가 `IPartnerRepository`를 받아 화면을 연다.
3. 화면 진입 시 `RefreshGrid`가 거래처 목록을 그리드에 표시한다.
4. 구분 필터가 선택되면 `GetByKind` 결과를 바탕으로 목록을 다시 표시한다.
5. 신규/수정/삭제 후 저장소 메서드를 호출하고 즉시 `RefreshGrid`로 목록을 갱신한다.

## 5. 데이터가 생성·변경되는 위치
- 신규 거래처는 `IPartnerRepository.Add`를 통해 생성된다.
- 수정 거래처는 `IPartnerRepository.Update`를 통해 변경된다.
- 삭제는 `IPartnerRepository.Delete`를 통해 처리된다.
- 화면 코드는 Memory 구현을 직접 참조하지 않고 주입받은 저장소 인터페이스만 사용한다.

## 6. 사용한 Delphi/Object Pascal 기술
- `.lfm` 없이 `CreateNew`와 런타임 컨트롤 생성으로 폼을 구성했다.
- `TStringGrid`로 목록을 표시하고 `TComboBox`로 구분 필터를 제공한다.
- `record` 기반 `TPartner` 값을 편집 폼에서 받아 저장소 인터페이스로 전달한다.

## 7. 이 코드를 이해하기 위한 학습 항목
- Lazarus LCL 폼과 컨트롤 생성 방식
- `interface` 기반 저장소 주입
- `TStringGrid` 행/열 데이터 표시
- enum 값과 콤보박스 선택값 매핑

## 8. 수정 또는 확장 시 확인할 위치
- 거래처 필드를 추가할 때는 `App.Core.Entities.TPartner`, 편집 폼, 그리드 컬럼을 함께 확인한다.
- 사업자번호 검증 규칙을 바꿀 때는 `IsValidBizNo`와 `FormatBizNo`를 확인한다.
- 구분 필터 동작을 바꿀 때는 `TPartnerView.RefreshGrid`를 확인한다.
- 메인 화면 진입 방식은 `TMainForm.PartnerClick`을 확인한다.
