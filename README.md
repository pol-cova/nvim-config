# Neovim Config

Personal Neovim setup for general development and competitive programming.

## Maintenance

- `:checkhealth` checks editor, provider, plugin, LSP, and tool health.
- `:Lazy` manages plugins.
- `:Mason` manages language servers, formatters, linters, and debug adapters.
- `:MasonToolsInstallSync` installs configured Mason tools.

## Core Keys

- `<leader>ff` find files
- `<leader>fs` search text
- `<leader>fp` switch project
- `<leader>ee` toggle file explorer
- `<leader>ef` reveal current file in explorer
- `<leader>gd` open Git diff view
- `<leader>gh` show current file history
- `<leader>x` opens Trouble diagnostics commands

## C++ Competitive Programming

- `<leader>cc` compile current C++ file
- `<leader>cr` compile and run current C++ file
- `<leader>ci` compile and run using `input.txt`
- `<leader>cfd` write a local `.clangd` with GCC include paths for `bits/stdc++.h`

The compile commands use the newest versioned Homebrew `g++` and fall back to
`g++`. They save the current file before compiling. `clang-tidy` linting is
skipped for single-file C/C++ buffers without a compile database and for C++
files that include `bits/stdc++.h`.

## Git

This directory is a git repository so config changes can be reviewed and
rolled back intentionally.

Remote: `https://github.com/pol-cova/nvim-config.git` (`main` branch).

## New PC setup

### macOS / Linux

```bash
git clone https://github.com/pol-cova/nvim-config.git ~/.config/nvim
nvim  # lazy.nvim bootstraps itself, then :Lazy sync
:MasonToolsInstallSync  # install LSPs, formatters, linters, codelldb
:checkhealth             # verify providers, clangd, python/node
```

Prereqs: Neovim 0.10+, `git`, a C++ compiler
(`brew install gcc` on macOS, `build-essential` on Ubuntu / `gcc-c++` on Fedora),
`make` (for LuaSnip `install_jsregexp`), and a Nerd Font.

### Windows 10/11 — ICPC machine (do this BEFORE the contest, with internet)

> On Windows Neovim reads `%LOCALAPPDATA%\nvim`, **not** `~/.config/nvim`.

**1. Install base tools (PowerShell as Admin):**

```powershell
winget install Neovim.Neovim Git.Git MSYS2.MSYS2
```

**2. Install the C++ toolchain (in the MSYS2 UCRT64 terminal, not PowerShell):**

```bash
pacman -Syu            # update, restart terminal when asked, run again
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-make
```

Why UCRT64: it ships `bits/stdc++.h` and `gnu++17`, matching ICPC judges.
Do NOT use MSVC `cl.exe` — `bits/stdc++.h` won't exist.

**3. Put the compiler on PATH:**

Add `C:\msys64\ucrt64\bin` to System Environment Variables > Path
(Settings > System > About > Advanced system settings > Environment Variables).
Then in a NEW PowerShell verify:

```powershell
g++ --version        # should print GCC 13/14
make --version
nvim --version       # 0.10+
```

**4. Clone this config to the Windows location:**

```powershell
git clone https://github.com/pol-cova/nvim-config.git $env:LOCALAPPDATA\nvim
nvim
```

Inside Neovim:

```vim
:Lazy sync
:MasonToolsInstallSync   " clangd, codelldb, clang-format, etc.
:TSUpdate                " pre-download Treesitter parsers (offline safety)
:checkhealth
```

**5. Verify C++ works (takes 60 seconds):**

1. Create `test.cpp` with `#include <bits/stdc++.h>`.
2. `<leader>cr` — should compile with the auto-detected `g++` and run.
3. `<leader>ci` — same but reads `input.txt` next to the file.
4. `<leader>cfd` — once per contest folder, writes `.clangd` pointing at
   YOUR detected compiler, then restarts clangd. Red squiggles on
   `bits/stdc++.h` should disappear.
5. `:LspInfo` should show `clangd` attached; `:Mason` should show `clangd`,
   `codelldb`, `clang-format` installed.

### ICPC day checklist (offline-safe)

- Do steps 1–5 at home/hotel. Contest machines often have no/flaky internet:
  `:Lazy`, `:Mason`, and `:TSUpdate` must already be done.
- Bring a USB backup of `%LOCALAPPDATA%\nvim` + `%LOCALAPPDATA%\nvim-data`
  (Mason + Lazy cache) in case you must set up on a lab PC.
- Per-problem workflow: copy `template.cpp` (or type `cp` + `<Tab>` for the
  CP snippet) → `<leader>ci` with `input.txt` → `<leader>cr` for quick runs.
- If Windows Defender blocks your compiled `.exe`: allow the contest folder
  or add an exclusion for it before the contest.
- If clangd shows errors but `g++` compiles fine: run `<leader>cfd` then
  `<leader>rs` (`:LspRestart`). Never commit `.clangd` — it's machine-local.

### Troubleshooting (Windows)

| Symptom | Fix |
|---|---|
| `No C++ compiler found` | `C:\msys64\ucrt64\bin` not on PATH, or terminal not reopened after adding it. `where g++` should print the MSYS2 path. |
| `bits/stdc++.h: No such file` from `g++` | You're using MSVC/Xcode clang, not MSYS2 GCC. `nvim --headless -c "lua print(require('paulcontreras.core.cpp').compiler())" -c qa` should print `.../ucrt64/bin/g++.exe`. Set `$CXX` or fix PATH order. |
| `bits/stdc++.h` red in editor but compiles | Run `<leader>cfd` in that folder, then `:LspRestart clangd`. |
| `cp` not found in `<leader>cmk` | Expected on cmd/PowerShell — that mapping auto-uses `copy /Y` on Windows. |
| Single quotes printed in terminal (`'--- Running ---'`) | Update config (`git pull`): echo lines are now quote-free for cmd/PowerShell/bash. |
