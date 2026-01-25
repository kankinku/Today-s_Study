
<%*
/**
 * Git Auto Pull Template
 * 실행 시 현재 볼트(같은 레포)에서 origin/main을 pull 합니다.
 *
 * 전제 조건:
 * 1. Templater: "Allow scripts to access network etc." ON
 * 2. Git 설치 및 vaultPath에서 git 명령 가능
 * 3. GitHub 인증(credential) 설정 완료
 */

// 1. 환경 설정
const vaultPath = app.vault.adapter.basePath;
const timestamp = tp.date.now("YYYY-MM-DD HH:mm:ss");

// 2. 로컬 변경사항 체크 후 pull
// - 변경사항 있으면 pull 중단 (충돌 방지)
const cmd = [
  `cd /d "${vaultPath}"`,
  `git rev-parse --is-inside-work-tree`,
  `git fetch origin`,
  `git status --porcelain`,
].join(" && ");

const { exec } = require("child_process");

new Notice(`⬇️ Git Auto Pull 시작...\n대상: ${vaultPath}`);

exec(cmd, (err, stdout, stderr) => {
  if (err) {
    console.error("Git Pull Precheck Error:", err);
    console.log("Stdout:", stdout);
    console.log("Stderr:", stderr);
    new Notice(`❌ Git Pull 실패(사전 체크)\n${err.message}\n콘솔(Ctrl+Shift+I) 확인`);
    tR = "";
    return;
  }

  const lines = stdout.split(/\r?\n/).map(s => s.trim()).filter(Boolean);
  // git status --porcelain 결과는 마지막 쪽에 섞여 들어오므로, "M " 같은 패턴을 포함한 라인이 있는지로 판단
  const hasLocalChanges = lines.some(l => /^[MADRCU?!]{1,2}\s/.test(l) || /^\?\?\s/.test(l));

  if (hasLocalChanges) {
    new Notice("⚠️ 로컬 변경사항이 있어 pull을 중단합니다.\n먼저 커밋/스태시/폐기 중 하나를 하세요.");
    tR = "";
    return;
  }

  const pullCmd = `cd /d "${vaultPath}" && git pull origin main`;
  exec(pullCmd, (pullErr, pullOut, pullErrOut) => {
    if (pullErr) {
      console.error("Git Pull Error:", pullErr);
      console.log("Stdout:", pullOut);
      console.log("Stderr:", pullErrOut);
      new Notice(`❌ Git Pull 실패!\n${pullErr.message}\n콘솔(Ctrl+Shift+I) 확인`);
      tR = "";
      return;
    }

    // 성공/변경없음 메시지 처리
    if (pullOut && pullOut.includes("Already up to date")) {
      new Notice("✅ 이미 최신 상태입니다.");
    } else {
      new Notice(`✅ Git Pull 완료!\n시각: ${timestamp}`);
    }
    console.log("Git Pull Output:", pullOut);
    tR = "";
  });
});

tR = "";
%>
