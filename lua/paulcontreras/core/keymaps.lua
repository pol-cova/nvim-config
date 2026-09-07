-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

---------------------
-- C++ / Competitive Programming --
---------------------

-- Helper: run a shell cmd in a bottom terminal split
local function run_in_term(cmd)
	vim.cmd("botright 12split | terminal " .. cmd)
	vim.cmd("startinsert")
end

local cpp_tools = require("paulcontreras.core.cpp")

local function cpp_compiler()
	return cpp_tools.compiler()
end

local function cpp_output(src)
	return cpp_tools.output_for(src)
end

local function shell_quote(value)
	return vim.fn.shellescape(value)
end

local function save_cpp_buffer()
	if vim.bo.filetype ~= "cpp" or vim.fn.expand("%:p") == "" then
		vim.notify("Open a C++ file first", vim.log.levels.ERROR)
		return false
	end
	vim.cmd.update()
	return true
end

-- Compile only  (<leader>cc)
keymap.set("n", "<leader>cc", function()
	if not save_cpp_buffer() then
		return
	end
	local src = vim.fn.expand("%:p")
	local out = cpp_output(src)
	run_in_term(
		string.format("%s -std=gnu++17 -O2 -Wall -Wextra -o %s %s", cpp_compiler(), shell_quote(out), shell_quote(src))
	)
end, { desc = "C++: Compile" })

-- Compile & run  (<leader>cr)
keymap.set("n", "<leader>cr", function()
	if not save_cpp_buffer() then
		return
	end
	local src = vim.fn.expand("%:p")
	local out = cpp_output(src)
	run_in_term(
		string.format(
			-- NOTE: `echo --- ... ---` without quotes works in bash, cmd, and PowerShell.
			"%s -std=gnu++17 -O2 -Wall -Wextra -o %s %s && echo --- Running --- && %s",
			cpp_compiler(),
			shell_quote(out),
			shell_quote(src),
			shell_quote(out)
		)
	)
end, { desc = "C++: Compile & Run" })

-- Compile & run with input.txt  (<leader>ci)
keymap.set("n", "<leader>ci", function()
	if not save_cpp_buffer() then
		return
	end
	local src = vim.fn.expand("%:p")
	local out = cpp_output(src)
	local dir = vim.fn.expand("%:p:h")
	local inp = dir .. "/input.txt"
	if vim.fn.filereadable(inp) == 0 then
		vim.fn.writefile({}, inp) -- create empty input.txt if missing
	end
	run_in_term(
		string.format(
			"%s -std=gnu++17 -O2 -Wall -Wextra -o %s %s && echo --- Running (input.txt) --- && %s < %s",
			cpp_compiler(),
			shell_quote(out),
			shell_quote(src),
			shell_quote(out),
			shell_quote(inp)
		)
	)
end, { desc = "C++: Compile & Run with input.txt" })

-- Quick generate compile_commands.json or .clangd for C++ projects / CP files.
keymap.set("n", "<leader>cmk", function()
	if vim.fn.filereadable("CMakeLists.txt") == 1 then
		if cpp_tools.is_windows() then
			run_in_term("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build && copy /Y build\\compile_commands.json compile_commands.json")
		else
			run_in_term("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build && cp build/compile_commands.json .")
		end
	else
		vim.notify("No CMakeLists.txt found. Run 'bear -- g++ ...' manually.", vim.log.levels.WARN)
	end
end, { desc = "C++: Generate compile_commands.json" })

keymap.set("n", "<leader>cfd", function()
	local compiler = vim.fn.exepath(cpp_compiler())
	if compiler == "" then
		vim.notify("No C++ compiler found. macOS: brew install gcc | Win: winget install MSYS2.MSYS2 then `pacman -S mingw-w64-ucrt-x86_64-gcc`", vim.log.levels.ERROR)
		return
	end
	compiler = cpp_tools.to_config_path(compiler)

	local lines = {
		"CompileFlags:",
		"  Compiler: " .. compiler,
		"  Remove:",
		'    - "-std=*"',
		"  Add:",
		"    - -std=gnu++17",
		"    - -Wall",
		"    - -Wextra",
		"    - -Wno-main",
	}

	vim.fn.writefile(lines, ".clangd")
	vim.notify("Wrote .clangd using " .. compiler, vim.log.levels.INFO)
	vim.cmd("LspRestart clangd")
end, { desc = "C++: Configure clangd for competitive programming" })
