import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

/** Quiet, local macOS cues for completed work and blocking user prompts. */
export default function sounds(pi: ExtensionAPI) {
  let playback: AbortController | undefined;

  function play(sound: "Glass" | "Pop", ctx: ExtensionContext) {
    if (process.platform !== "darwin" || ctx.mode !== "tui") return;

    playback?.abort();
    playback = new AbortController();

    /** Audio must never delay a question or fail the agent's work. */
    void pi.exec("/usr/bin/afplay", ["-v", "0.25", `/System/Library/Sounds/${sound}.aiff`], {
      signal: playback.signal,
      timeout: 3000,
    }).catch(() => {});
  }

  /** agent_end can precede retries, compaction, and queued continuations. */
  pi.on("agent_settled", (event, ctx) => {
    if (!event.aborted) play("Glass", ctx);
  });

  pi.on("ui_prompt_start", (_event, ctx) => {
    /** Questions during work need attention; manually opened menus do not. */
    if (!ctx.isIdle()) play("Pop", ctx);
  });

  pi.on("session_shutdown", () => {
    playback?.abort();
    playback = undefined;
  });

  pi.registerCommand("sound-test", {
    description: "Preview notification sounds: /sound-test [done|input]",
    handler: async (args, ctx) => {
      const cue = args.trim() || "done";
      if (cue !== "done" && cue !== "input") {
        ctx.ui.notify("Usage: /sound-test [done|input]", "warning");
        return;
      }
      play(cue === "done" ? "Glass" : "Pop", ctx);
    },
  });
}
