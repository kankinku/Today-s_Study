## 1. 개요

본 영상은 개발 중 긴급한 수정 사항(Hotfix)이 발생했을 때, 기존의 `git stash`나 브랜치 전환 방식의 불편함을 해소할 수 있는 **'Git Worktree'** 기능을 상세히 다룹니다. 초급자부터 시니어 개발자를 위한 베어(Bare) 저장소 전략까지 단계별 활용법을 제시합니다.

## 2. 핵심 개념: Git Worktree란?

- **개념:** 하나의 Git 저장소에 여러 개의 독립된 작업 디렉토리를 연결하여, 브랜치를 체크아웃할 때마다 기존 작업을 멈출 필요 없이 동시에 여러 작업을 수행하게 해주는 기능입니다 [[01:10](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=70)].
    
- **도서관 비유:** 일반적인 Git 방식이 하나의 책상에서 책을 바꿔가며 읽는 것이라면, 워크트리는 여러 책상을 두고 각각 다른 책(브랜치)을 펼쳐놓고 작업하는 것과 같습니다 [[01:38](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=98)].
    
- **장점:** 프로젝트 전체를 새로 복제(Clone)하지 않고 `.git` 폴더(데이터베이스)를 공유하기 때문에 디스크 공간을 크게 절약할 수 있습니다 [[02:21](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=141)].
    

## 3. 실무 활용 및 명령어

### 기본 사용법

1. **워크트리 생성:** `git worktree add <경로> <브랜치이름>` 명령어를 사용하여 현재 프로젝트 폴더 외부(상위 폴더 등)에 새로운 작업 공간을 만듭니다 [[03:43](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=223)].
    
2. **작업 전환:** 단순히 생성된 폴더로 이동(`cd`)하여 작업을 수행합니다. 기존 작업 공간의 지저분한 상태를 유지한 채 깨끗한 환경에서 핫픽스 등을 처리할 수 있습니다 [[04:31](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=271)].
    
3. **동일 브랜치 주의:** 이미 체크아웃된 브랜치를 다른 워크트리에서 동시에 열 수 없습니다. 조회용이라면 `--detach` 옵션을 사용해야 합니다 [[06:35](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=395)].
    

### 관리 및 유지보수

- **목록 확인:** `git worktree list`를 통해 현재 연결된 모든 작업 공간을 확인합니다 [[09:59](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=599)].
    
- **안전한 삭제:** `git worktree remove <경로>`를 사용하여 작업이 끝난 폴더를 정리합니다. 저장되지 않은 변경 사항이 있으면 경고를 줍니다 [[10:56](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=656)].
    
- **유령 워크트리 정리:** 폴더를 수동으로 삭제했을 경우, `git worktree prune` 명령어로 Git의 메타데이터 기록을 정리해야 합니다 [[12:05](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=725)].
    

## 4. 전문가를 위한 고급 전략: 베어(Bare) 저장소

시니어 개발자들이 선호하는 구조로, Git 데이터베이스(`.git`)와 실제 작업 파일들을 완전히 분리하여 관리하는 방식입니다 [[18:35](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=1115)].

- **구조:** 루트 폴더 내에 `.bare` 폴더(두뇌)를 두고, 그 주변에 `main`, `feature`, `review` 등의 목적별 워크트리 폴더를 나란히 배치합니다 [[17:54](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=1074)].
    
- **PR 리뷰 활용:** 동료의 Pull Request(PR)를 로컬 브랜치로 가져와 일회용 워크트리를 만들어 테스트한 뒤, 리뷰가 끝나면 폴더째 삭제하는 깔끔한 워크플로우를 가질 수 있습니다 [[21:05](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=1265)].
    

## 5. 주의사항 및 효율화 팁

- **의존성 설치:** 워크트리는 독립된 폴더이므로, 각 폴더마다 `npm install` 등의 의존성 설치가 필요합니다 [[06:57](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=417)].
    
- **시간 및 용량 절약:** 대형 프로젝트에서 의존성 설치 시간과 용량이 부담된다면, 파일을 복사하지 않고 링크하는 **pnpm**과 같은 패키지 매니저 사용을 권장합니다 [[25:54](http://www.youtube.com/watch?v=JtA2JeqlTnI&t=1554)].
    

---

**영상 링크:** [https://youtu.be/JtA2JeqlTnI](https://www.google.com/search?q=https://youtu.be/JtA2JeqlTnI)