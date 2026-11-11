local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
	{ import = "plugins" },
    -- File manager
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = { { '<C-S-e>', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' } },
        opts = {},
    },
    { "mileszs/ack.vim" },

	-- lazydev
	{
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- ==================== TREESITTER ====================
    {
        'nvim-treesitter/nvim-treesitter',
		lazy = false,
        build = ':TSUpdate',
        opts = {
			ensure_installed = {
				'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query',
				'python', 'sql', 'markdown', 'json', 'yaml',
				'asm', 'nasm',
				'rust', 'javascript', 'typescript', 'html', 'css', 'java', 'kotlin', 'cmake'
			},
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter').setup(opts)
        end,
    },

    -- ==================== LSP + MASON ====================
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'clangd',      -- C/C++
                    'pyright',     -- Python
                    'lua_ls',      -- Lua
                    'sqls',        -- SQL
					'rust_analyzer',
					'ts_ls',
					'html',
					'cssls',
					'jdtls',
					'asm_lsp',
					'jsonls',
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local opts = { capabilities = require('cmp_nvim_lsp').default_capabilities() }

						-- Custom server settings
                        if server_name == 'clangd' then
                            opts.cmd = {
                                'clangd', '--background-index', '--clang-tidy',
                                '--header-insertion=never', '--fallback-style=llvm',
                                '--query-driver=/usr/bin/g++'
                            }
                        elseif server_name == 'pyright' then
                            -- optional: configure python path
                        elseif server_name == 'lua_ls' then
                            local cc_defs = vim.fn.expand("~/repositories/Sumneko/CC-Tweaked")
                            opts.settings = {
                                Lua = {
                                    runtime = { version = 'LuaJIT' },
                                    diagnostics = { globals = { "vim" } },
                                    workspace = {
                                        library = {
                                            vim.api.nvim_get_runtime_file("", true),
                                            cc_defs,
                                        },
                                        ignoreDir = { ".git", "build" },
                                    },
                                    telemetry = { enable = false },
                                }
                            }
                        elseif server_name == 'sqls' then
                            opts.settings = {
                                sqls = {
                                    connections = {
                                        { driver = 'mysql', dataSourceName = ':memory:' },
                                    },
                                },
                            }
                        end

                        require('lspconfig')[server_name].setup(opts)
                    end,
                },
            })

            -- LSP attach autocmds
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local function buf_map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = 'LSP: ' .. desc })
                    end

                    buf_map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
                    buf_map('n', 'gr', vim.lsp.buf.references, 'Goto references')
                    buf_map('n', 'gy', vim.lsp.buf.type_definition, 'Goto type definition')
                    buf_map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
                    buf_map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
                    buf_map({ 'n', 'x' }, '<leader>f', function() vim.lsp.buf.format { async = true } end, 'Format buffer')
                    buf_map('n', '<leader>ac', vim.lsp.buf.code_action, 'Code actions')
                    buf_map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
                    buf_map('n', '<C-Space>', vim.lsp.buf.signature_help, 'Signature help')

                    if vim.lsp.inlay_hint then
                        buf_map('n', '<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
                        end, 'Toggle inlay hints')
                    end

                    if client.server_capabilities.documentHighlight then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = buf,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets',
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()
            cmp.setup {
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert {
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { 'i', 's' }),
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                    ['<C-space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
					{ name = 'nvim_lsp' },
                    { name = 'path' },
                }),
            }
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>sf', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
            { '<leader>sg', '<cmd>Telescope live_grep<CR>', desc = 'Grep' },
            { '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = 'Help' },
            { '<leader>ss', '<cmd>Telescope builtin<CR>', desc = 'Telescope' },
            { '<leader>sr', '<cmd>Telescope resume<CR>', desc = 'Resume' },
            { '<leader>s.', '<cmd>Telescope oldfiles<CR>', desc = 'Recent files' },
            { '<leader><leader>', '<cmd>Telescope buffers<CR>', desc = 'Buffers' },
            { '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', desc = 'Code actions' },
        },
        config = function() require('telescope').setup() end,
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = { options = { theme = 'onedark', component_separators = '|', section_separators = '' } },
    },

    -- Git
    { 'tpope/vim-fugitive' },
    { 'lewis6991/gitsigns.nvim', opts = {} },

    -- Color scheme
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            require('onedark').setup { style = 'dark' }
            vim.cmd.colorscheme 'onedark'
        end,
    },

    -- CMake tools
    {
        'Civitasv/cmake-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },

    -- ==================== DEBUGGING (DAP) ====================
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
            'nvim-neotest/nvim-nio',
            'jay-babu/mason-nvim-dap.nvim',
        },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            -- Keymaps
            vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
            vim.keymap.set('n', '<leader>B', function()
                dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end, { desc = 'Conditional breakpoint' })
            vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
            vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Run last debug config' })

            -- ===== KEY FIX: path to codelldb via Mason bin =====
            local codelldb_path = vim.fn.stdpath('data') .. '/mason/bin/codelldb'
            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = { command = codelldb_path, args = { '--port', '${port}' } },
            }

            dap.adapters.python = {
                type = 'executable',
                command = 'python',
                args = { '-m', 'debugpy.adapter' },
            }

			local lua_debugger_path = vim.fn.stdpath('data') .. '/mason/packages/lua-debugger/extension/debugAdapter.lua'
            dap.adapters.lua = {
                type = 'server',
                host = '127.0.0.1',
                port = 8086,
                executable = { command = 'lua', args = { lua_debugger_path } },
            }

            -- Helper compilation function (as in original)
            local function compile_current_file_cpp()
                local filename = vim.fn.expand('%:t')
                local current_dir = vim.fn.getcwd()
                local filebase = vim.fn.fnamemodify(current_dir .. '/' .. filename, ":t:r")
                local outdir = current_dir .. '/build'
                if vim.fn.isdirectory(outdir) == 0 then
                    vim.fn.mkdir(outdir, 'p')
                end
                local outfile = outdir .. '/' .. filebase
                if vim.fn.has('win32') == 1 then
                    outfile = outfile .. '.exe'
                end

				local cpp_std = vim.env.CPP_STD or "-std=c++26"
                local cmd = string.format('g++ -g -O0 %s "%s" -o "%s" 2>&1', cpp_std, filename, outfile)
                local output = vim.fn.system(cmd)
                local result = vim.v.shell_error

                if result ~= 0 then
                    local info_lines = {
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                        "❌ Compilation error",
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                        "📁 Working directory:  " .. current_dir,
                        "📁 Output directory:   " .. outdir,
                        "📄 Source file:        " .. filename,
                        "💾 Output file:        " .. outfile,
                        "💾 Output file name:   " .. filebase,
                        "🔧 Command:            " .. cmd,
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                        "",
                    }
                    local error_lines = vim.split(output, '\n')
                    for _, line in ipairs(error_lines) do
                        table.insert(info_lines, line)
                    end

                    vim.api.nvim_open_win(0, true, {
                        relative = 'editor',
                        width = math.floor(vim.o.columns * 0.9),
                        height = math.min(#info_lines, 25),
                        row = 5,
                        col = math.floor(vim.o.columns * 0.05),
                        border = 'rounded',
                        title = ' Compilation ' .. filename,
                        title_pos = 'center',
                    })
                    local buf = vim.api.nvim_create_buf(false, true)
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)
                    vim.api.nvim_win_set_buf(0, buf)
                    vim.api.nvim_buf_set_option(buf, 'filetype', 'text')
                    vim.cmd('normal! gg')
                    return nil
                end

                print("✅ Compiled: " .. outfile)
                return outfile
            end

            -- Debug configurations
            dap.configurations.cpp = {
                {
                    name = "▶️ Build and debug current file (g++)",
                    type = "codelldb",
                    request = "launch",
                    program = function() return compile_current_file_cpp() end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    runInTerminal = false,
                },
                {
                    name = "📁 Run arbitrary executable",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/")
                        return path
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    runInTerminal = false,
                },
				{
					name = "🔗 Attach to process (codelldb)",
					type = "codelldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					processHandle = {
						SIGINT = { pass = true, stop = false, notify = true },
					},
				},
                {
                    name = "🔨 Run CMake target (from build/)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local target = vim.fn.input("Target name: ")
                        local build_dir = vim.fn.getcwd() .. "/build"
                        local prog = build_dir .. "/" .. target
                        if vim.fn.has('win32') == 1 then
                            prog = prog .. ".exe"
                        end
                        if vim.fn.filereadable(prog) == 0 then
                            print("File not found: " .. prog)
                            return nil
                        end
                        return prog
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    runInTerminal = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp

            dap.configurations.python = {
                {
                    name = "🐍 Run current Python file",
                    type = "python",
                    request = "launch",
                    program = "${file}",
                    pythonPath = function()
                        local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
                        if vim.fn.executable(venv_python) == 1 then
                            return venv_python
                        else
                            return "python3"
                        end
                    end,
                    console = "integratedTerminal",
                    justMyCode = false,
                },
                {
                    name = "🐍 Debug with arguments",
                    type = "python",
                    request = "launch",
                    program = "${file}",
                    args = function()
                        local args_str = vim.fn.input("Command-line arguments: ")
                        return vim.split(args_str, " ")
                    end,
                    pythonPath = function()
                        local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
                        if vim.fn.executable(venv_python) == 1 then
                            return venv_python
                        else
                            return "python3"
                        end
                    end,
                    console = "integratedTerminal",
                    justMyCode = false,
                },
            }

            dap.configurations.lua = {
                {
                    name = "🌙 Run current Lua file",
                    type = "lua",
                    request = "launch",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end,
    },

    -- Debug UI
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function()
            require('dapui').setup({
                layouts = {
                    {
                        elements = {
                            { id = 'threads', size = 0.2 },
                            { id = 'stacks', size = 0.2 },
                            { id = 'watches', size = 0.2 },
                            { id = 'breakpoints', size = 0.2 },
                            { id = 'scopes', size = 0.2 },
                        },
                        position = 'right',
                        size = 50,
                    },
                    {
                        elements = {
                            { id = 'repl', size = 0.5 },
                            { id = 'console', size = 0.5 },
                        },
                        position = 'bottom',
                        size = 12,
                    },
                },
                controls = { enabled = true, element = 'repl' },
            })
        end,
    },

    -- Virtual text (variable values)
    {
        'theHamsta/nvim-dap-virtual-text',
        config = function() require('nvim-dap-virtual-text').setup() end,
    },

    -- Install debug adapters via Mason
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
        opts = {
            ensure_installed = {
                'codelldb',      -- C/C++/Rust
                'debugpy',       -- Python
                'lua-debugger',  -- Lua
            },
            automatic_installation = true,
        },
    },

    -- Diagnostics
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
            { '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Quickfix' },
            { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Loclist' },
        },
        opts = {},
    },

    -- Additional plugins
    {
        'RRethy/vim-illuminate',
        config = function()
            require('illuminate').configure({
                providers = { 'lsp', 'treesitter', 'regex' },
                delay = 100,
                filetypes_denylist = { 'NvimTree', 'TelescopePrompt' },
            })
            vim.keymap.set('n', '<leader>hn', function() require('illuminate').next_reference() end)
            vim.keymap.set('n', '<leader>hp', function() require('illuminate').prev_reference() end)
        end
    },

    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            vim.g.rainbow_delimiters = {
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },
}, {})
