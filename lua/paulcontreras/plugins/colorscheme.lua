return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			local zed = {
				bg = "#191814",
				bg_dark = "#14130f",
				bg_sidebar = "#211f1a",
				bg_float = "#292720",
				bg_highlight = "#302e27",
				bg_visual = "#302c3d",
				bg_search = "#57432a",
				fg = "#f7f7f4",
				fg_muted = "#c7c2b6",
				fg_gutter = "#7f786d",
				border = "#3a372f",
				accent = "#8b8cff",
				accent_2 = "#b3a7ff",
				blue = "#8fb6e8",
				green = "#68c39a",
				cyan = "#83c79c",
				yellow = "#d6a255",
				orange = "#f0c66d",
				magenta = "#c0a8dd",
				red = "#ff6b8a",
				comment = "#9b9487",
			}

			require("tokyonight").setup({
				style = "night",
				transparent = false,
				styles = {
					comments = { italic = true },
					keywords = {},
					functions = {},
					variables = {},
				},
				on_colors = function(colors)
					colors.bg = zed.bg
					colors.bg_dark = zed.bg_dark
					colors.bg_float = zed.bg_float
					colors.bg_highlight = zed.bg_highlight
					colors.bg_popup = zed.bg_float
					colors.bg_search = zed.bg_search
					colors.bg_sidebar = zed.bg_sidebar
					colors.bg_statusline = zed.bg_sidebar
					colors.bg_visual = zed.bg_visual
					colors.border = zed.border
					colors.comment = zed.comment
					colors.fg = zed.fg
					colors.fg_dark = zed.fg_muted
					colors.fg_float = zed.fg
					colors.fg_gutter = zed.fg_gutter
					colors.fg_sidebar = zed.fg_muted
					colors.blue = zed.blue
					colors.blue0 = zed.blue
					colors.blue1 = zed.blue
					colors.blue2 = zed.blue
					colors.blue5 = zed.accent_2
					colors.blue6 = zed.accent
					colors.blue7 = zed.accent
					colors.cyan = zed.cyan
					colors.green = zed.green
					colors.green1 = zed.green
					colors.green2 = zed.green
					colors.magenta = zed.magenta
					colors.magenta2 = zed.magenta
					colors.orange = zed.orange
					colors.purple = zed.magenta
					colors.red = zed.red
					colors.red1 = zed.red
					colors.teal = zed.cyan
					colors.terminal_black = zed.bg_highlight
					colors.yellow = zed.yellow
				end,
				on_highlights = function(hl, colors)
					hl.Normal = { fg = zed.fg, bg = zed.bg }
					hl.NormalFloat = { fg = zed.fg, bg = zed.bg_float }
					hl.FloatBorder = { fg = zed.border, bg = zed.bg_float }
					hl.CursorLine = { bg = zed.bg_highlight }
					hl.CursorLineNr = { fg = zed.fg, bold = true }
					hl.LineNr = { fg = zed.fg_gutter }
					hl.Visual = { bg = zed.bg_visual }
					hl.Search = { fg = zed.bg, bg = zed.yellow }
					hl.IncSearch = { fg = zed.bg, bg = zed.accent }
					hl.WinSeparator = { fg = zed.border }
					hl.Pmenu = { fg = zed.fg, bg = zed.bg_float }
					hl.PmenuSel = { fg = zed.fg, bg = zed.bg_highlight }
					hl.StatusLine = { fg = zed.fg_muted, bg = zed.bg_sidebar }
					hl.StatusLineNC = { fg = zed.fg_gutter, bg = zed.bg_dark }
					hl.Comment = { fg = zed.comment, italic = true }
					hl.String = { fg = zed.green }
					hl.Character = { fg = zed.green }
					hl.Number = { fg = zed.accent }
					hl.Boolean = { fg = zed.accent }
					hl.Constant = { fg = zed.accent }
					hl.Identifier = { fg = zed.fg }
					hl.Function = { fg = zed.blue }
					hl.Statement = { fg = zed.magenta }
					hl.Keyword = { fg = zed.magenta }
					hl.Type = { fg = zed.magenta }
					hl.Special = { fg = zed.accent }
					hl.Operator = { fg = zed.comment }
					hl.Delimiter = { fg = zed.comment }
					hl.DiagnosticError = { fg = zed.red }
					hl.DiagnosticWarn = { fg = zed.yellow }
					hl.DiagnosticInfo = { fg = zed.blue }
					hl.DiagnosticHint = { fg = zed.comment }
					hl.DiffAdd = { fg = zed.green }
					hl.DiffChange = { fg = zed.yellow }
					hl.DiffDelete = { fg = zed.red }
					hl["@variable"] = { fg = zed.fg }
					hl["@variable.builtin"] = { fg = zed.accent }
					hl["@variable.parameter"] = { fg = zed.fg_muted }
					hl["@variable.member"] = { fg = zed.blue }
					hl["@constant"] = { fg = zed.accent }
					hl["@module"] = { fg = zed.yellow }
					hl["@string"] = { fg = zed.green }
					hl["@string.escape"] = { fg = zed.magenta }
					hl["@number"] = { fg = zed.accent }
					hl["@boolean"] = { fg = zed.accent }
					hl["@type"] = { fg = zed.magenta }
					hl["@property"] = { fg = zed.blue }
					hl["@function"] = { fg = zed.blue }
					hl["@function.method"] = { fg = zed.blue }
					hl["@function.builtin"] = { fg = zed.accent }
					hl["@keyword"] = { fg = zed.magenta }
					hl["@operator"] = { fg = zed.comment }
					hl["@punctuation"] = { fg = zed.comment }
					hl["@comment"] = { fg = zed.comment, italic = true }
					hl["@tag"] = { fg = zed.blue }
					hl["@tag.attribute"] = { fg = zed.yellow }
					hl["@tag.delimiter"] = { fg = zed.comment }
					hl.NeoTreeNormal = { fg = zed.fg_muted, bg = zed.bg_sidebar }
					hl.NeoTreeNormalNC = { fg = zed.fg_muted, bg = zed.bg_sidebar }
					hl.NeoTreeDirectoryName = { fg = zed.blue }
					hl.NeoTreeGitAdded = { fg = zed.green }
					hl.NeoTreeGitDeleted = { fg = zed.red }
					hl.NeoTreeGitModified = { fg = zed.yellow }
				end,
			})

			vim.g.terminal_color_0 = zed.bg
			vim.g.terminal_color_1 = zed.red
			vim.g.terminal_color_2 = zed.green
			vim.g.terminal_color_3 = zed.yellow
			vim.g.terminal_color_4 = zed.blue
			vim.g.terminal_color_5 = zed.magenta
			vim.g.terminal_color_6 = zed.cyan
			vim.g.terminal_color_7 = zed.fg_muted
			vim.g.terminal_color_8 = "#555044"
			vim.g.terminal_color_9 = "#ff8aa1"
			vim.g.terminal_color_10 = "#9fc9a2"
			vim.g.terminal_color_11 = "#f0c66d"
			vim.g.terminal_color_12 = "#9fbbe0"
			vim.g.terminal_color_13 = zed.magenta
			vim.g.terminal_color_14 = "#9fc9a2"
			vim.g.terminal_color_15 = zed.fg

			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
