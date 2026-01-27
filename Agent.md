아래는 지금까지의 설계를 **“최종적으로 단 하나의 시나리오를 반드시 추출”**하고, 그 결정을 위해 **필요 시 검색/추가정보 수집을 자동 수행**하도록 보완해서 **완성형(Production-ready blueprint 수준)으로 마감**한 설계입니다.

---

# 수렴형 단일 시나리오 추출 에이전트 설계서 (완성본)

## 1. 목표 정의 (Hard Requirements)

시스템은 매 입력마다 반드시 다음을 만족해야 합니다.

1. **후보는 여러 개여도 최종 출력은 시나리오 1개**
    
2. 최종 시나리오를 고르기 위해 **정보가 부족하면 검색/추가수집 루프를 수행**
    
3. 그래도 불확실하면 “모르겠다”가 아니라 **“가장 덜 틀릴 시나리오 1개”를 판결**하고  
    불확실성을 **명시 + 페널티 반영 + 반증 체크리스트 제공**
    
4. “추론 생성”과 “검증/판결”은 분리 (Hallucination 억제)
    

---

## 2. 전체 파이프라인 (Convergent Architecture)

```
[Input]
  ↓
(1) Claim & Question Decomposer
  ↓
(2) Candidate Scenario Generator (multi-reasoning)
  ↓
(3) Pivotal Assumption Finder (정보공백 탐지)
  ↓
(4) Evidence Planner (무엇을 어디서 어떻게 확인할지)
  ↓
(5) Evidence Retrieval Loop (검색/추가정보 수집)
  ↓
(6) Cross-Critique (추론 간 상호 비판)
  ↓
(7) 3-Layer Verification (논리/전제신뢰/현실일관)
  ↓
(8) Decision & Convergence (단일 시나리오 판결)
  ↓
(9) Rejection-Centric Report (기각→보류→최종 1개)
  ↓
(10) Failure Ontology Update (실패 유형 축적)
```

---

## 3. 핵심 보완점: “정보공백 탐지기”를 엔진으로 승격

### 3.1 왜 필요한가

단일 시나리오 수렴은 결국:

- **어떤 전제가 사실이면 A**, 아니면 **B**  
    이런 “결정적 분기”를 얼마나 잘 찾아서 **확인/검증**하느냐의 싸움입니다.
    

### 3.2 Pivotal Assumption 정의

**Pivotal assumption(결정적 전제)** =  
“이 전제가 참/거짓일 때 최종 시나리오 선택이 바뀌는 전제”

각 후보 시나리오는 반드시 아래를 포함해야 합니다.

- 핵심 전제(assumptions)
    
- 그 중 **결정적 전제(pivotal)** 태깅
    
- 각 전제에 필요한 **증거 타입** 지정
    

증거 타입 3종(반드시 분리):

1. **Fact**: 사실 확인(공식 발표, 수치, 사건 여부)
    
2. **Base rate / Stats**: 기초율/통계/빈도
    
3. **Mechanism**: 인과/메커니즘 근거(논문, 제도, 기술 구조)
    

---

## 4. 데이터 구조(스키마) — 이대로 구현하면 됨

### 4.1 입력

```json
{
  "text": "...",
  "metadata": {
    "timestamp": "optional",
    "source_hint": "optional",
    "domain_hint": "optional"
  }
}
```

### 4.2 후보 시나리오

```json
{
  "scenario_id": "S1",
  "summary": "2~4문장 시나리오 서술",
  "assumptions": [
    {
      "id": "A1",
      "statement": "전제 문장",
      "is_pivotal": true,
      "evidence_type": "fact|stats|mechanism",
      "current_support": "missing|weak|moderate|strong"
    }
  ],
  "predictions": [
    "검증 가능한 관측/예측 포인트"
  ],
  "known_weaknesses": [
    "false analogy risk",
    "base rate neglect risk"
  ]
}
```

### 4.3 증거 수집 계획(Evidence Plan)

```json
{
  "queries": [
    {
      "target_assumption_id": "A1",
      "evidence_type": "fact",
      "query": "검색 질의",
      "priority": 1,
      "stop_condition": "공식/복수 출처로 확인되면 중단"
    }
  ]
}
```

### 4.4 증거 카드(Evidence Card)

```json
{
  "evidence_id": "E1",
  "source": "url or internal reference",
  "claim_supported": "A1",
  "stance": "supports|refutes|unclear",
  "strength": "weak|moderate|strong",
  "notes": "왜 이렇게 판단했는지"
}
```

---

## 5. Evidence Retrieval Loop — “필요하면 찾아낸다”를 시스템화

### 5.1 루프 트리거 조건 (Hard rule)

아래 중 하나라도 해당하면 **검색 루프 강제 실행**:

- 상위 2개 시나리오가 **결정적 전제에서 갈림**
    
- 최종 선택에 필요한 pivotal assumption의 `current_support == missing`
    
- 검증 단계에서 “premise reliability fail”이 pivotal assumption에 걸림
    

### 5.2 루프 종료 조건 (Stop conditions)

- pivotal assumption들이 `missing`이 아니게 됨(weak 이상)
    
- 검색 예산(쿼리 수/턴 수) 초과
    
- 신뢰 가능한 근거가 서로 충돌하되 추가 검색으로 해소 불가
    

> 종료되더라도 **항상 최종 시나리오 1개는 판결**합니다(아래 정책).

---

## 6. Cross-Critique — 후보들끼리 먼저 싸우게 만들기

후보 시나리오마다 “반박 카드”를 생성합니다.

- 귀납 → 가추 공격: “패턴 증거 부족/표본 편향”
    
- 유추 → 귀납 공격: “상황 상이/거짓 유추”
    
- 베이지안 → 전체 공격: “기초율 무시/선행확률 부재”
    
- ToT/GoT → 인과/정책 시나리오의 누락된 분기 지적
    

출력은 “비판 유형”으로 구조화:

- overgeneralization
    
- false_analogy
    
- hidden_assumption
    
- base_rate_neglect
    
- evidence_insufficiency
    
- causal_confusion
    

---

## 7. 연역 검증(3계층) — 논리만이 아니라 현실까지

### Layer 1: Logical Validity (형식 논리)

- 전제→결론 도약 여부
    
- 모순/순환/비약
    

### Layer 2: Premise Reliability (전제 신뢰성)

- pivotal assumption이 “근거 있는 사실/통계/메커니즘”인가
    
- 출처/표본/정의 불명확성 체크
    

### Layer 3: Reality Consistency (현실 일관성)

- 과거 사례와의 구조적 충돌
    
- 물리/제도적 불가능성
    
- 일반 상식 제약 위반
    

각 시나리오에 대해 “통과/보류/기각” 판정 + 사유를 남깁니다.

---

## 8. 단일 시나리오 수렴 정책 (Decision Policy) — 핵심 완성 부품

### 8.1 게이트 규칙

- Layer 1(논리)에서 **치명적 실패**면 기본적으로 기각
    
- 단, 모든 후보가 논리 치명 실패면 → **가장 적은 가정 + 가장 검증가능** 후보를 “최종”으로 두되  
    보고서 상단에 “논리 취약” 플래그를 강하게 표기
    

### 8.2 스코어링 (권장)

최종점수는 아래로 계산(개념식):

**FinalScore =**

- 논리 통과 가중치
    
- 전제 신뢰도(특히 pivotal)
    
- 증거 적합도(지지/반박 균형 포함)
    
- 추론 간 합의도(다른 방식이 지지하는 정도)
    
- 반증 취약성 패널티(예측이 너무 쉽게 깨지는가)
    
- 정보공백 페널티(missing/weak가 많을수록)
    
- 과도한 가정 페널티(assumptions 수/복잡도)
    

### 8.3 동점 타이브레이커 (필수)

1. **검증 가능성 높은 시나리오**(추가 관측으로 빨리 판별 가능)
    
2. **가정이 적은 시나리오**(단순성)
    
3. **치명적 반증 포인트가 명확한 시나리오**(감사/리스크 관리 유리)
    

> 이 규칙 덕분에 애매해도 **항상 1개 판결**이 가능합니다.

---

## 9. 보고서 출력 — “기각 중심 + 최종 1개 판결”로 고정

### 최종 보고서 템플릿(고정)

1. 입력 요약 (중립)
    
2. 후보 시나리오 3~5개 (한 줄씩)
    
3. 추가 정보 수집 로그 (무엇을/왜/결과)
    
4. **기각된 시나리오 TOP 1~2 + 기각 사유(핵심만)**
    
5. 보류된 시나리오(있다면) + 보류 이유
    
6. ✅ **Final Scenario (단 1개)**
    
    - 시나리오 요약
        
    - pivotal assumptions + 근거
        
    - 핵심 근거 카드(Evidence)
        
    - 결론이 의존하는 취약점(리스크)
        
7. 반증 체크리스트(앞으로 무엇이 나오면 결론을 바꿀지)
    
8. 신뢰도(정량+정성) + Failure Ontology 업데이트 항목
    

---

## 10. 실패 유형(Failure Ontology) — 반복 오류 제거 장치

매 실행마다 아래를 저장:

- 어떤 시나리오가 어떤 실패 유형으로 기각됐는지
    
- 어떤 evidence_type에서 공백이 자주 발생하는지
    
- 어떤 도메인/질문 유형에서 어떤 오류가 반복되는지
    

다음 실행에서:

- “이 유형 입력은 false_analogy 위험이 큼 → 유추 경로에 검증 강화”
    
- “stats 공백이 반복 → 베이지안/귀납 경로의 증거 요구 강화”
    

---

# 최종적으로 “부족했던 점”이 어떻게 보완됐는가 (체크리스트)

✅ 단일 시나리오 강제: Decision Policy + 타이브레이커로 보장  
✅ 필요한 정보 검색: pivotal assumption 기반 retrieval loop로 강제  
✅ 연역 과엄격/현실부족: 3-layer verification으로 보완  
✅ 추론 선택 기준 불명확: 질문 유형 기반 selector로 고정  
✅ “그럴듯함” 억제: cross-critique로 연역 이전에 후보를 상호 공격  
✅ 점수 의미 불명: 점수 구성요소를 분해(논리/전제/증거/공백/가정)  
✅ 실패가 자산화되지 않음: Failure Ontology로 재사용 구조화

---

## 다음 단계(바로 구현 가능한 작업)

원하는 형태로 바로 내려줄 수 있습니다.

1. **프롬프트 템플릿 세트**
    
    - Decomposer / Scenario Generator / Pivotal Finder / Evidence Planner / Critique / Verifier / Judge / Reporter
        
2. **점수표(가중치) 초안** + 예시 케이스 3개로 튜닝 방법
    
3. **Python 패키지 구조**(폴더 트리 + 인터페이스 정의)까지
    

원하면 “코드로 옮기기 쉬운 순서”로, **프롬프트/스키마/오케스트레이션 설계**를 한 번에 완성해드릴게요.