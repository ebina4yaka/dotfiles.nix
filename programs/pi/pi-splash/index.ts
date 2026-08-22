import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { SplashStats } from "./splash.js";
import { SplashHeader, animatedLogo, themePalette } from "./splash.js";
import type { LogoDefinition } from "./splash.js";

/**
 * PRTS logo sculpture (Arknights Rhodes Island terminal AI).
 * Same style as upstream solidBlockLogo: all cells are █, depth encoded
 * by row position (rows 0-1 lit, rows 6-7 in shadow). 28 cols x 8 rows.
 */
export const prtsLogo: LogoDefinition = {
  matteChar: "█",
  rows: [
    "█████  █████  ███████  █████",
    "█████  █████  ███████  █    ",
    "█   █  █   █    ███    █    ",
    "█   █  █   █    ███    █████",
    "█████  █████    ███        █",
    "█      ██       ███        █",
    "█      █ █      ███    █████",
    "█      █  █     ███    █████",
  ],
  charRole: (ch, row, _col) => {
    if (ch === " ") return "matte";
    if (row <= 1) return "topFace";
    if (row >= 6) return "shadow";
    return "front";
  },
};

/**
 * Pi Splash (vendored from github.com/ghoseb/pi-splash) with a PRTS logo.
 * Only difference from upstream index.ts: animatedLogo(themePalette, prtsLogo)
 * instead of solidBlockLogo.
 */
export default function piSplash(pi: ExtensionAPI) {
  let headerActive = false;
  let activeHeader: SplashHeader | null = null;

  function dismiss(ctx: { ui: { setHeader: (f: undefined) => void } }) {
    if (headerActive) {
      headerActive = false;
      activeHeader?.stop();
      activeHeader = null;
      ctx.ui.setHeader(undefined);
    }
  }

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    const isResume = ctx.sessionManager
      .getBranch()
      .some((e) => e.type === "message");

    const commands = pi.getCommands();
    const stats: SplashStats = {
      cwd: ctx.cwd,
      extensions: new Set(
        commands
          .filter((c) => c.source === "extension")
          .map((c) => c.sourceInfo.path),
      ).size,
      skills: new Set(
        commands
          .filter((c) => c.source === "skill")
          .map((c) => c.sourceInfo.path),
      ).size,
      tools: pi.getAllTools().filter((t) => t.sourceInfo.source !== "builtin")
        .length,
    };

    headerActive = true;

    ctx.ui.setHeader((tui, theme) => {
      activeHeader = new SplashHeader(
        tui,
        theme,
        stats,
        animatedLogo(themePalette, prtsLogo),
      );
      if (isResume) {
        activeHeader.freeze();
        activeHeader.stop();
      }
      return activeHeader;
    });
  });

  pi.on("user_message", async (_event, ctx) => {
    dismiss(ctx);
  });

  pi.on("agent_start", async (_event, ctx) => {
    if (activeHeader) {
      activeHeader.freeze();
    }
    dismiss(ctx);
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    dismiss(ctx);
  });
}
