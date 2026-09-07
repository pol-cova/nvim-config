-- Shared C++ toolchain detection for competitive programming.
-- Portable across macOS, Linux, and Windows:
-- no machine-specific absolute binary is ever returned unless it was
-- discovered at runtime. Everything falls back to PATH lookup ("g++").
local M = {}

---@return boolean
function M.is_windows()
	return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

---@return string ".exe" on Windows, "" elsewhere
function M.exe_suffix()
	if M.is_windows() then
		return ".exe"
	end
	return ""
end

-- Directories probed for GCC binaries (e.g. g++-14, g++.exe).
-- Missing dirs simply yield no candidates, so this list is safe
-- to keep exhaustive for macOS / Linux / Windows sharing.
local function search_dirs()
	local dirs = {
		"/opt/homebrew/bin", -- macOS ARM Homebrew
		"/usr/local/bin", -- macOS Intel Homebrew
		"/opt/local/bin", -- MacPorts
		"/usr/bin", -- system (Linux + macOS Xcode shim)
		"/home/linuxbrew/.linuxbrew/bin", -- Linuxbrew
		-- Windows: MSYS2 / MinGW / LLVM defaults (probed only if they exist)
		"C:/msys64/mingw64/bin", -- MSYS2 MINGW64 (classic)
		"C:/msys64/ucrt64/bin", -- MSYS2 UCRT64 (recommended for new installs)
		"C:/msys64/clang64/bin", -- MSYS2 Clang
		"C:/mingw64/bin", -- standalone MinGW-w64
		"C:/Program Files/LLVM/bin", -- LLVM clang
		"C:/Program Files/mingw-w64/mingw64/bin",
	}
	local home = vim.env.HOME
	if home and home ~= "" then
		table.insert(dirs, 1, home .. "/.linuxbrew/bin")
	end
	-- MSYS2 exposes its prefix via $MSYSTEM_PREFIX (e.g. /mingw64 or
	-- /ucrt64); when inside MSYS2 bash that path is directly usable.
	local msys_prefix = vim.env.MSYSTEM_PREFIX
	if msys_prefix and msys_prefix ~= "" then
		table.insert(dirs, 1, msys_prefix .. "/bin")
	end
	return dirs
end

local function version_of(path)
	-- g++-14 -> 14, g++-13 -> 13 (compare as number, best effort)
	local v = path:match("g%+%+%-(%d+)")
	return tonumber(v) or 0
end

local function dedup_preserve_order(list)
	local seen, out = {}, {}
	for _, v in ipairs(list) do
		if not seen[v] then
			seen[v] = true
			table.insert(out, v)
		end
	end
	return out
end

--- All discovered g++ executables, newest versioned first.
---@return string[]
function M.versioned_compilers()
	local found = {}
	for _, dir in ipairs(search_dirs()) do
		-- versioned (g++-14, g++-13, ...) on Unix-likes
		for _, p in ipairs(vim.fn.glob(dir .. "/g++-*", false, true)) do
			if vim.fn.executable(p) == 1 then
				table.insert(found, p)
			end
		end
		-- unversioned in a probed dir (covers Windows g++.exe)
		for _, p in ipairs({ dir .. "/g++", dir .. "/g++.exe" }) do
			if vim.fn.executable(p) == 1 then
				table.insert(found, p)
			end
		end
	end
	table.sort(found, function(a, b)
		return version_of(a) > version_of(b)
	end)
	return dedup_preserve_order(found)
end

--- Best C++ compiler to use for :compile / :run / :debug.
--- Order: $CXX > newest discovered g++ > PATH g++ > c++ > clang++.
---@return string
function M.compiler()
	local cxx = vim.env.CXX
	if cxx and cxx ~= "" and vim.fn.executable(cxx) == 1 then
		return cxx
	end
	local versioned = M.versioned_compilers()
	if #versioned > 0 then
		return versioned[1]
	end
	for _, name in ipairs({ "g++", "c++", "clang++", "g++.exe", "clang++.exe" }) do
		if vim.fn.executable(name) == 1 then
			return name
		end
	end
	return "g++" -- last resort: let the shell report the missing tool
end

--- Output binary for a source file. Adds .exe on Windows so both
--- `g++ -o out out.cpp` and running the result work on cmd/PowerShell.
---@param src string absolute source path
---@return string
function M.output_for(src)
	local base = vim.fn.fnamemodify(src, ":r")
	if M.is_windows() and not base:lower():match("%.exe$") then
		return base .. ".exe"
	end
	return base
end

--- Normalize a path for .clangd / clangd flags (forward slashes).
---@param p string
---@return string
function M.to_config_path(p)
	return (p:gsub("\\", "/"))
end

--- Value for clangd's --query-driver flag.
--- Lets clangd ask the real GCC for its system include paths so
--- <bits/stdc++.h> resolves without hardcoding include dirs.
---@return string
function M.query_drivers()
	local drivers = {
		"clang",
		"clang++",
		"gcc",
		"g++",
		"c++",
		"cc",
		"g++.exe",
		"gcc.exe",
		"clang++.exe",
	}
	for _, p in ipairs(M.versioned_compilers()) do
		table.insert(drivers, p)
		table.insert(drivers, M.to_config_path(p))
	end
	-- Also allow absolute system paths when they exist (harmless if missing:
	-- clangd just ignores non-matching drivers).
	for _, p in ipairs({
		"/usr/bin/clang",
		"/usr/bin/clang++",
		"/usr/bin/gcc",
		"/usr/bin/g++",
		"C:/msys64/mingw64/bin/g++.exe",
		"C:/msys64/mingw64/bin/gcc.exe",
		"C:/msys64/ucrt64/bin/g++.exe",
		"C:/msys64/ucrt64/bin/gcc.exe",
		"C:/mingw64/bin/g++.exe",
	}) do
		if vim.fn.executable(p) == 1 then
			table.insert(drivers, p)
		end
	end
	return table.concat(dedup_preserve_order(drivers), ",")
end

--- clangd fallbackFlags for single-file buffers without compile_commands.json.
--- Stays on the default stdlib (libc++ on macOS, libstdc++ on MinGW/Linux)
--- to avoid mixing toolchains. Only adds a shim include dir if a
--- bits/stdc++.h shim was detected (macOS manual setup).
---@return string[]
function M.fallback_flags()
	local flags = { "-std=c++17", "-Wall", "-Wextra" }
	-- MinGW / Linux ship bits/stdc++.h with the toolchain: no extra -I.
	-- macOS needs a manual shim; add it only when detected.
	local shim_dirs = {
		"/usr/local/include", -- common manual shim location on macOS
		"/opt/homebrew/include", -- Homebrew prefix
	}
	for _, dir in ipairs(shim_dirs) do
		if vim.fn.filereadable(dir .. "/bits/stdc++.h") == 1 then
			table.insert(flags, "-I" .. dir)
			break
		end
	end
	return flags
end

return M
