```bash

cd /Users/davidmontgomery/Library/Application Support/Claude
nano claude_desktop_config.json
# Read START_HERE.md and tell me what you understand before we proceed.
```
```json
{
  "preferences": {
    "coworkScheduledTasksEnabled": true,
    "ccdScheduledTasksEnabled": true,
    "sidebarMode": "chat",
    "coworkWebSearchEnabled": true
  },
 "mcpServers": {
    "toe-project": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/davidmontgomery/coding/entity-project/CrystalAgent"
      ]
    }
  }
}
```

---

## WHEN TO UPDATE THIS FILE

Update this file when:
- A major working front changes (e.g., bit-pulse test moves from analysis
  to writeup phase)
- The behavioral rules need adjustment
- New tools or capabilities are added to the MCP server
- Prior handoff files become obsolete and should no longer be referenced

Do NOT update for routine session outcomes — those go in dated handoff
files in `todo/`.

---

_Last updated: 2026-04-13 by Claude session with D. Montgomery._
_Not committed to git. Personal bootstrap note._


```aiignore
toe-project:list_allowed_directories      — show which paths I can read
toe-project:list_directory <path>         — list files/folders in a directory
toe-project:list_directory_with_sizes     — same with file sizes
toe-project:directory_tree <path>         — recursive tree view as JSON
toe-project:read_file <path>              — read any file
toe-project:read_text_file <path>         — read a text file
toe-project:read_multiple_files <paths>   — read several at once
toe-project:search_files <path> <pattern> — find files by name pattern
toe-project:get_file_info <path>          — metadata about a file
toe-project:write_file <path> <content>   — create or overwrite a file
toe-project:edit_file <path> <edits>      — line-based edits to text files
toe-project:create_directory <path>       — make a new folder
toe-project:move_file <src> <dst>         — move or rename
toe-project:read_media_file <path>        — read image or audio file
```









