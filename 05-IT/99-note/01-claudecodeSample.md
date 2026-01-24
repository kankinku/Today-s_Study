## 1. 두 가지 레벨의 설정 (계층적 구조)

Claude Code는 유저 레벨과 프로젝트 레벨의 설정을 합쳐서 인식합니다.

### ① 유저 레벨 (`~/.claude/CLAUDE.md`)

- **목적:** 모든 프로젝트에 공통으로 적용되는 개발자의 개인적인 취향과 철학 설정.
    
- **핵심 내용 예시:**
    
    - **Core Philosophy:** Agent-First(복잡한 작업 위임), Test-Driven(구현 전 테스트), Security-First.
        
    - **Personal Preferences:** 이모지 사용 금지, 불변성(Immutability) 준수, 파일당 줄 수 제한 (200~400줄 권장, 최대 800줄).
        

### ② 프로젝트 레벨 (`프로젝트루트/CLAUDE.md`)

- **목적:** 특정 프로젝트의 기술 스택, 구조, 컨벤션을 명시.
    
- **핵심 내용 예시:**
    
    - **Tech Stack:** Frontend(Next.js 14, React 18, Tailwind), Backend(Supabase, Edge Functions), Testing(Vitest).
        
    - **File Structure:** `src/app`(router), `src/components`(UI), `src/hooks`, `src/lib`(util) 등 구조 정의.
        

---

## 2. 실전 코드 패턴 및 컨벤션 명시

단순한 텍스트 설명을 넘어, Claude가 따라야 할 **코드의 '정석'**을 파일에 직접 작성해둡니다.

### API 응답 및 에러 핸들링

TypeScript

```
// API Response Format
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

// Error Handling Pattern
try {
  const result = await operation();
  return { success: true, data: result };
} catch (error) {
  return { success: false, error: 'message' };
}
```

> 이렇게 명시해두면 Claude가 코드를 생성할 때 자동으로 이 인터페이스와 에러 처리 패턴을 준수합니다.

---

## 3. 규칙의 모듈화 (분리 관리)

내용이 너무 길어질 경우 `~/.claude/rules/` 디렉토리에 주제별로 파일을 분리하여 관리합니다. `CLAUDE.md`에서는 해당 파일들을 참조하도록 설정합니다.

### 세부 규칙 예시

|구분|파일명|주요 포함 내용|
|---|---|---|
|**보안**|`security.md`|하드코딩 시크릿 금지, 환경변수 사용, SQL 인젝션 및 XSS 방지 규칙|
|**코딩 스타일**|`coding-style.md`|불변성 유지 필수, 함수 50줄 이하, 파일 800줄 이하 분리 규칙|
|**워크플로우**|`git-workflow.md`|커밋 메시지 컨벤션, 브랜치 전략 등|

Sheets로 내보내기

---

## 4. 도입 전후 비교 (Before vs After)

이 설정을 적용했을 때 얻을 수 있는 구체적인 이득입니다.

- **시간 절약:** 매 세션마다 프로젝트 구조를 5~10분씩 설명할 필요가 없어짐.
    
- **일관성 유지:** 대화 도중에 AI가 컨벤션을 잊어버리는 현상 방지.
    
- **비용 및 효율:** 설명에 소모되는 **토큰을 50% 이상 절약**하여 더 빠르고 정확한 응답 유도.
    
- **즉시 작업:** "UserProfile 컴포넌트 만들어줘"라고만 해도 프로젝트 스타일(Tailwind, Vitest 등)에 맞춰 즉시 생성.
    

---

**결론:** `CLAUDE.md`는 Claude Code에게 전달하는 **"우리 프로젝트의 법전"**과 같습니다. 이를 통해 AI를 단순한 도구가 아니라, 내 스타일을 완벽히 이해하는 팀 동료처럼 활용할 수 있습니다.