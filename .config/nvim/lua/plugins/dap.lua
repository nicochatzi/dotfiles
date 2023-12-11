-- debugging
return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      local dap = require('dap')
      dap.adapters.codelldb = {
        -- type = 'server',
        -- host = '127.0.0.1',
        -- port = 13000, -- 💀 Use the port printed out or specified with `--port`
        type = 'server',
        port = '${port}',
        executable = {
          -- CHANGE THIS to your path!
          command = '~/.codelldb/extension/adapter/codelldb',
          args = { '--port', '${port}' },
          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }
      dap.configurations.rust = {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fin.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
      }
      require('dapui').setup {}
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    event = 'VeryLazy',
    config = function()
      require('dapui').setup {
        layouts = {
          {
            elements = {
              {
                id = 'scopes',
                size = 0.40,
              },
              {
                id = 'stacks',
                size = 0.40,
              },
              {
                id = 'breakpoints',
                size = 0.10,
              },
              {
                id = 'watches',
                size = 0.10,
              },
            },
            position = 'right',
            size = 100,
          },
          {
            elements = {
              {
                id = 'repl',
                size = 0.5,
              },
              {
                id = 'console',
                size = 0.5,
              },
            },
            position = 'bottom',
            size = 15,
          },
        },
      }
      local dap, dapui = require('dap'), require('dapui')
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      require('neodev').setup {
        library = { plugins = { 'nvim-dap-ui' }, types = true },
      }
    end,
  },
}
