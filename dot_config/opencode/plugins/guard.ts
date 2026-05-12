import type { Plugin } from "@opencode-ai/plugin"
import { readFileSync, existsSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

interface Rule {
  matcher: string
  regex: string
  message: string
}

const RULES_TOML = join(homedir(), ".config", "guard-and-guide", "rules.toml")

const CANONICAL_MAP: Record<string, string> = {
  bash: "Bash",
  shell: "Bash",
  read: "Read",
  write: "Write",
  edit: "Edit",
}

const FIELD_MAP: Record<string, string> = {
  Bash: "command",
  Read: "filePath",
  Write: "filePath",
  Edit: "filePath",
}

function expandMatcher(matcher: string): string[] {
  return matcher.split("|").flatMap((name) => {
    if (name === "File") return ["Read", "Write", "Edit"]
    return [name]
  })
}

function parseToml(content: string): Rule[] {
  const rules: Rule[] = []
  let current: Partial<Rule> = {}
  for (const line of content.split("\n")) {
    const t = line.trim()
    if (t === "" || t.startsWith("#")) continue
    if (t === "[[rules]]") {
      if (current.matcher) rules.push(current as Rule)
      current = {}
      continue
    }
    const m = t.match(/^(\w+)\s*=\s*(['"])(.*)\2\s*$/)
    if (m) {
      const [, key, , val] = m
      if (key === "matcher") current.matcher = val
      else if (key === "regex") current.regex = val
      else if (key === "message") current.message = val
    }
  }
  if (current.matcher) rules.push(current as Rule)
  return rules
}

function loadRules(): Rule[] {
  try {
    if (existsSync(RULES_TOML)) {
      return parseToml(readFileSync(RULES_TOML, "utf-8"))
    }
  } catch {
  }
  return []
}

const rules = loadRules()

export const GuardPlugin: Plugin = async () => {
  if (rules.length === 0) return {}

  return {
    "tool.execute.before": async (input, output) => {
      const rawTool = String(input?.tool ?? "").toLowerCase()
      const canonical = CANONICAL_MAP[rawTool]
      if (!canonical) return

      const value = String((output?.args as Record<string, unknown> | undefined)?.[FIELD_MAP[canonical]] ?? "")

      for (const rule of rules) {
        const tools = expandMatcher(rule.matcher)
        if (!tools.includes(canonical)) continue
        let matched = false
        try {
          matched = new RegExp(rule.regex).test(value)
        } catch {
          continue
        }
        if (matched) throw new Error(rule.message)
      }
    },
  }
}
