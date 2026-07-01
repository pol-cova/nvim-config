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

local function cpp_compiler()
	return vim.fn.executable("g++-14") == 1 and "g++-14" or "g++"
end

local function shell_quote(value)
	return vim.fn.shellescape(value)
end

-- Compile only  (<leader>cc)
keymap.set("n", "<leader>cc", function()
	local src = vim.fn.expand("%:p")
	local out = vim.fn.expand("%:p:r")
	run_in_term(
		string.format("%s -std=c++17 -O2 -Wall -Wextra -o %s %s", cpp_compiler(), shell_quote(out), shell_quote(src))
	)
end, { desc = "C++: Compile" })

-- Compile & run  (<leader>cr)
keymap.set("n", "<leader>cr", function()
	local src = vim.fn.expand("%:p")
	local out = vim.fn.expand("%:p:r")
	run_in_term(
		string.format(
			"%s -std=c++17 -O2 -Wall -Wextra -o %s %s && echo '--- Running ---' && %s",
			cpp_compiler(),
			shell_quote(out),
			shell_quote(src),
			shell_quote(out)
		)
	)
end, { desc = "C++: Compile & Run" })

-- Compile & run with input.txt  (<leader>ci)
keymap.set("n", "<leader>ci", function()
	local src = vim.fn.expand("%:p")
	local out = vim.fn.expand("%:p:r")
	local dir = vim.fn.expand("%:p:h")
	local inp = dir .. "/input.txt"
	if vim.fn.filereadable(inp) == 0 then
		vim.fn.writefile({}, inp) -- create empty input.txt if missing
	end
	run_in_term(
		string.format(
			"%s -std=c++17 -O2 -Wall -Wextra -o %s %s && echo '--- Running (input.txt) ---' && %s < %s",
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
		run_in_term("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build && cp build/compile_commands.json .")
	else
		vim.notify("No CMakeLists.txt found. Run 'bear -- g++ ...' manually.", vim.log.levels.WARN)
	end
end, { desc = "C++: Generate compile_commands.json" })

keymap.set("n", "<leader>cfd", function()
	local gcc_includes = vim.fn.glob("/opt/homebrew/opt/gcc/include/c++/*", false, true)
	local target_includes = vim.fn.glob("/opt/homebrew/opt/gcc/include/c++/*/aarch64-apple-darwin*", false, true)
	local lines = {
		"CompileFlags:",
		"  Add:",
		"    - -std=c++17",
		"    - -Wall",
		"    - -Wextra",
	}

	for _, dir in ipairs(gcc_includes) do
		table.insert(lines, "    - -I" .. dir)
	end
	for _, dir in ipairs(target_includes) do
		table.insert(lines, "    - -I" .. dir)
	end
	if vim.fn.isdirectory("/usr/local/include") == 1 then
		table.insert(lines, "    - -I/usr/local/include")
	end

	vim.fn.writefile(lines, ".clangd")
	vim.notify("Wrote .clangd for C++ competitive programming headers", vim.log.levels.INFO)
end, { desc = "C++: Write .clangd for bits/stdc++.h" })
