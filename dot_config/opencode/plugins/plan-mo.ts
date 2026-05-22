import type { Plugin } from "@opencode-ai/plugin"
import { spawn } from "node:child_process"

export const PlanMoPlugin: Plugin = async ({ $ }) => {
  try {
    await $`which mo`.quiet()
  } catch {
    return {}
  }

  return {
    "tool.execute.after": async (input) => {
      const tool = String(input.tool).toLowerCase()
      if (tool !== "write" && tool !== "edit") return

      const args = input.args as Record<string, unknown> | undefined
      const filePath = args?.filePath
      if (typeof filePath !== "string" || !filePath) return
      if (!filePath.includes("opencode/plans/")) return

      spawn("mo", [filePath], {
        detached: true,
        stdio: "ignore",
      }).unref()
    },
  }
}
