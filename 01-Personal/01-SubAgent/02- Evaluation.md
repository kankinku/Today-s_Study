[**https://youtu.be/Umt-KZrcBxQ**](https://youtu.be/Umt-KZrcBxQ)

---
## Sample Data
### Case 1 : UserMaking Test
- 유저가 만들어서 운용하는 테스트 케이스

### Case 2 : LLM Making Test
- llm이 만들어서 운용하는 테스트


---
## Judge
### Case 1 : Rule Base 
- 규칙 기반의 테스트 평가

### Case 2 : LLM Base 
- LLM 기반의 테스트 평가



---
## 원거리 개발
### 1. 전체 시스템 아키텍처 (Workflow)

1. **Slack (Input):** 사용자가 슬랙 채널에 명령어를 입력합니다. (예: "/회의일정 내일 오후 2시")
    
2. **Local Server (Relay):** 슬랙의 **Slash Command** 또는 **Events API**를 통해 요청을 받습니다. (Python Flask/FastAPI, Node.js 등)
    
3. **Gemini CLI/SDK (Processing):** 서버가 받은 텍스트를 Gemini에게 보냅니다.
    
    - _참고:_ CLI를 직접 실행(`subprocess`)하기보다 **Gemini SDK**를 서버 코드에 심는 것이 훨씬 빠르고 안정적입니다.
        
4. **Google Servers (Action):** Gemini가 필요하다고 판단하면 **Google Calendar/Drive API**를 호출하여 데이터를 가져오거나 수정합니다.
    
5. **Return Path:** 구글 서버의 응답을 Gemini가 정리하여 로컬 서버로 보내고, 서버는 이를 다시 슬랙 API를 통해 사용자에게 출력합니다.
    

---

### 2. 이 구조가 '유효한' 이유 (장점)

- **보안성:** 로컬 서버를 거치기 때문에 API 키나 구글 인증 토큰(OAuth)을 슬랙에 직접 노출하지 않고 안전하게 관리할 수 있습니다.
    
- **확장성:** 나중에 구글 서비스뿐만 아니라 회사 내부 DB나 다른 툴(Notion, Jira 등)을 연결하기 매우 쉽습니다.
    
- **자연어 처리:** 사용자가 딱딱한 명령어가 아닌 "나 내일 드라이브에 있는 기획서 좀 찾아줘" 같은 일상어로 요청할 수 있습니다.
    

---

### 3. 더 효율적인 구현을 위한 제언

제시하신 구조에서 **'Gemini CLI'를 사용하는 부분**을 조금 더 효율적으로 바꾼다면 다음과 같은 구성을 추천합니다.

#### ① CLI보다는 SDK 사용을 권장

로컬 서버에서 쉘(Shell) 명령어로 CLI를 실행하면 매번 프로세스를 새로 띄워야 하므로 응답 속도가 느려질 수 있습니다. Python이나 Node.js 서버라면 **Google Generative AI SDK**를 직접 연동하는 것이 리소스 관리나 에러 처리에 훨씬 유리합니다.

#### ② Function Calling (도구 호출) 활용 필수

Gemini가 구글 드라이브나 캘린더와 상호작용하려면, 단순히 텍스트를 주고받는 게 아니라 **Function Calling** 기능을 써야 합니다.

- **작동 방식:** "내일 일정 알려줘" → Gemini가 "아, 캘린더를 조회해야겠군. `list_events()` 함수를 실행해줘"라고 서버에 신호를 보냄 → 서버가 실제 구글 API 실행.
    

#### ③ 터널링 도구 필요 (개발 단계)

로컬 서버가 슬랙으로부터 요청을 받으려면 외부에서 접근 가능한 주소가 필요합니다. 개발 중에는 **ngrok**이나 **zrok** 같은 터널링 도구를 사용해 로컬 서버를 외부와 연결해야 슬랙의 웹훅(Webhook)을 받을 수 있습니다.
	필요 기능 : 종료후 알림, 종료후 종료 로그 전체 출력.