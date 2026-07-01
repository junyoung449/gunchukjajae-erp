# 건축자재상 ERP (온프레미스)

건축자재 유통업체를 위한 **온프레미스 Windows 데스크톱 ERP**입니다.
단일 매장~소수 지점 규모의 자재상이 품목·거래처·재고·견적·출고를 한 곳에서
관리하도록 만드는 것을 목표로 합니다.

## 기술 스택

| 항목 | 내용 |
|------|------|
| 언어 | Object Pascal (Delphi 문법 호환) |
| 빌드 툴체인 | **Free Pascal + Lazarus** (무료·오픈소스) |
| UI | 데스크톱 GUI (Lazarus LCL / Delphi VCL 호환) |
| 데이터 접근 | FireDAC(Delphi) / SQLDB(Lazarus) 계열 |
| 데이터베이스 | Firebird (임베디드/서버) — **미설치 시 인메모리 모드로 구동** |

### DB 없이도 구동됩니다
데이터 접근은 인터페이스로 추상화되어 있습니다.

- **Memory 모드(기본값)**: Firebird가 없어도 샘플 데이터로 즉시 실행됩니다.
  평가·데모·초기 개발 시 별도 설치가 필요 없습니다.
- **Firebird 모드**: 설정 파일에서 전환하면 FireDAC로 Firebird에 연결합니다.
  연결 실패 시 자동으로 Memory 모드로 폴백합니다.

전환은 `config/app.ini` 의 `[Data] Provider=Memory|Firebird` 값으로 제어합니다.

## 모듈

개발 우선순위 순서입니다.

1. **품목 관리(Item)** — 자재 품목 마스터(규격/단위/단가)
2. **거래처 관리(Partner)** — 고객·매입처 마스터
3. **재고 관리(Inventory)** — 입출고·재고수량·창고 이동
4. **견적 관리(Quote)** — 견적서 작성·품목 라인·금액 계산
5. **출고 처리(Shipment)** — 출고 등록, 재고 차감
6. **이력 조회(History)** — 거래·재고 변동 이력 조회

## 저장소 구조

```
├─ src/
│  ├─ core/      공통 계약(데이터 접근 인터페이스·엔티티)
│  ├─ modules/   모듈별 유닛
│  └─ app/       메인 셸(폼·엔트리)
├─ docs/
│  └─ maintenance/  유지보수·학습 문서 (구현된 코드와 연결된 자료)
└─ config/       실행 설정
```

## 브랜치 전략

- `main` — 통합·릴리스
- `develop` — 개발 통합
- `feature/01-item` … `feature/06-history` — 모듈별 작업 브랜치

각 모듈은 브랜치에서 구현 후 Pull Request로 리뷰를 거쳐 병합합니다.

## 빌드

무료 툴체인으로 빌드합니다.

- **Lazarus/FPC(무료)**: `src/app` 의 프로젝트(`.lpi`)를 Lazarus에서 열거나
  `lazbuild src/app/ERP.lpi` 로 빌드합니다.
- **Delphi(선택)**: RAD Studio 보유 시 `.dproj` 로도 빌드할 수 있게 유지합니다.

가상환경 없이 로컬에서 바로 빌드하며, 초기 실행은 별도 설정 없이 Memory 모드로
동작합니다.
