// pi extension: 全てのアシスタント出力を textlint (textlint-rule-preset-ai-writing) で検査する。
//
// プリセットは report-only (fixer 持たず) なので、検出した指摘を `context` イベントで
// 次の LLM 呼び出し直前に直前アシスタントメッセージへ注入し、モデルが次の出力で
// 自己修正する方式。セッション / 画面に表示される本文は書き換えない (context は
// deep copy が渡るため、注入は LLM にしか見えない)。

import { execFile } from "node:child_process";
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const extDir = dirname(fileURLToPath(import.meta.url));

let linter: ((text: string) => Promise<string>) | null = null;
let booting: Promise<void> | null = null;

// ponytail: 初回のみこの dir で npm install が走る (~30s)。先に手動 install すれば不要
async function boot() {
  if (linter) return;
  booting ??= (async () => {
    if (!existsSync(join(extDir, "node_modules", "textlint"))) {
      await new Promise<void>((res, rej) =>
        execFile("npm", ["install", "--no-audit", "--no-fund"], { cwd: extDir }, (e) => (e ? rej(e) : res())),
      );
    }
    const { createRequire } = await import("node:module");
    const req = createRequire(import.meta.url);
    const { createLinter, loadTextlintrc, loadLinterFormatter } = req("textlint");
    const descriptor = await loadTextlintrc({ cwd: extDir });
    const l = createLinter({ descriptor });
    const formatter = await loadLinterFormatter({ formatterName: "stylish" });
    let n = 0;
    linter = async (text: string) => {
      const result = await l.lintText(text, `virtual-${++n}.md`);
      return formatter.format([result]) as string;
    };
  })();
  return booting;
}

function textOf(message: any): string {
  const c = message?.content;
  if (typeof c === "string") return c;
  if (Array.isArray(c)) return c.filter((b: any) => b?.type === "text").map((b: any) => b.text).join("\n\n");
  return "";
}

export default function textlintExtension(pi: any) {
  let lastReport: string | null = null;

  pi.on("message_end", async (event: any, ctx: any) => {
    const msg = event.message;
    if (msg.role !== "assistant") return;
    const text = textOf(msg);
    if (!text.trim()) return;
    try {
      await boot();
      lastReport = (await linter!(text)) || null;
      if (lastReport) ctx.ui?.notify?.("textlint: AIっぽい表現を検出 — 次ターンの LLM 呼び出しに修正指示を注入", "warning");
    } catch (e: any) {
      ctx.ui?.notify?.(`textlint failed: ${e.message}`, "error");
      lastReport = null;
    }
  });

  pi.on("context", async (event: any) => {
    if (!lastReport) return;
    const messages = event.messages;
    const last = messages[messages.length - 1];
    if (last?.role !== "assistant") return;
    const note = `\n\n---\n[textlint] 直前の出力は以下の指摘に違反しています。今後の出力ではこれを踏まえ、機械的な印象を避けた自然な文章にしてください:\n${lastReport}`;
    if (Array.isArray(last.content)) {
      const idx = last.content.map((b: any) => b?.type).lastIndexOf("text");
      if (idx >= 0) last.content[idx] = { ...last.content[idx], text: last.content[idx].text + note };
      else last.content.push({ type: "text", text: note });
    } else {
      last.content = String(last.content) + note;
    }
    return { messages };
  });
}
