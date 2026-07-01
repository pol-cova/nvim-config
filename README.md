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

The compile commands prefer `g++-14` when it is available and fall back to
`g++`. `clang-tidy` linting is skipped for single-file C/C++ buffers without a
compile database, and for C++ files that include `bits/stdc++.h`.

## Git

This directory is a git repository so config changes can be reviewed and
rolled back intentionally.
