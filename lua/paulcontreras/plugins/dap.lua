return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup({
      commented = true, -- show virtual text as comment
    })

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    })

    -- Auto open/close dapui with dap sessions
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- codelldb adapter (installed via Mason)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    -- C/C++ configurations
    local cpp_config = {
      {
        name = "Launch (codelldb)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
      {
        name = "Compile & Debug (g++)",
        type = "codelldb",
        request = "launch",
        program = function()
          local src = vim.fn.expand("%:p")
          local out = vim.fn.expand("%:p:r")
          -- compile with debug symbols, no optimizations
          local cmd = string.format("g++ -std=c++17 -g -O0 -o %s %s", out, src)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Compile error:\n" .. result, vim.log.levels.ERROR)
            return nil
          end
          return out
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }
    dap.configurations.cpp = cpp_config
    dap.configurations.c = cpp_config

    -- Keymaps
    local map = vim.keymap.set
    map("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
    map("n", "<F6>", dap.step_over, { desc = "DAP: Step over" })
    map("n", "<F7>", dap.step_into, { desc = "DAP: Step into" })
    map("n", "<F8>", dap.step_out, { desc = "DAP: Step out" })
    map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
    map("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Condition: "))
    end, { desc = "DAP: Conditional breakpoint" })
    map("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
    map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
    map("n", "<leader>dx", dap.terminate, { desc = "DAP: Terminate session" })
  end,
}
