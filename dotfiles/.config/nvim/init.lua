--[[
    Neovim config: отладка C/C++ (одиночные файлы, CMake), Python, Lua, SQL
    - Лидер: пробел
    - LSP: clangd, pyright, lua_ls, sqls (Mason)
    - Отладка: nvim-dap (codelldb, debugpy, local-lua-debugger)
    - F5 – меню выбора конфигурации отладки
    - Буфер обмена: "+y, "+p, <leader>y, <leader>p
    - Русская раскладка (физическая ЙЦУКЕН)
    - Подсветка: уникальные цвета для всех групп Treesitter (в т.ч. Python, Lua, SQL)
    - Плагины: подсветка вхождений слова, разноцветные скобки
--]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

------------------------------------------------------------------------------
-- 1. БАЗОВЫЕ НАСТРОЙКИ
------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.numberwidth = 6
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true

-- Отключаем старый Vim‑синтаксис (будем использовать Treesitter)
vim.opt.syntax = 'off'
vim.cmd('syntax off')

-- Ассоциации файлов
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.c', '*.h' },
    callback = function() vim.bo.filetype = 'c' end,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.cpp', '*.hpp', '*.cc', '*.cxx' },
    callback = function() vim.bo.filetype = 'cpp' end,
})
-- CMake
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'CMakeLists.txt', '*.cmake' },
    command = 'set filetype=cmake',
})
-- Assembly (NASM)

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = {'*.nasm', '*.asm'},
    command = 'set filetype=nasm',
})
-- Assembly (GAS)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.s', '*.S' },
    command = 'set filetype=asm',
})
-- Rust
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.rs',
    command = 'set filetype=rust',
})
-- JavaScript
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.js', '*.jsx', '*.cjs', '*.mjs' },
    command = 'set filetype=javascript',
})
-- TypeScript
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.ts', '*.tsx', '*.cts', '*.mts' },
    command = 'set filetype=typescript',
})
-- HTML/CSS (Neovim определяет автоматически, но можно для надёжности)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.html', '*.htm' },
    command = 'set filetype=html',
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.css',
    command = 'set filetype=css',
})
-- Java
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.java',
    command = 'set filetype=java',
})
-- Kotlin
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
   pattern = { '*.kt', '*.kts' },
   command = 'set filetype=kotlin',
})
-- JSON
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
   pattern = { '*.json', },
   command = 'set filetype=kotlin',
})
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.encoding = 'utf-8'
if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end

-- Русская раскладка (ЙЦУКЕН)
vim.opt.langmap = 'ФИСВУАПРШОЛДЖЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKL:MNOPQRSTUVWXYZ,фисвуапршолджьтщзйкыегмцчня;abcdefghijkl:mnopqrstuvwxyz'

------------------------------------------------------------------------------
-- 2. МАППИНГИ
------------------------------------------------------------------------------
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Upper window' })
map('n', '<C-Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<C-S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })
map('n', '[g', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
map('n', ']g', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix' })

-- Буфер обмена
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
map({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

------------------------------------------------------------------------------
-- 3. МЕНЕДЖЕР ПЛАГИНОВ lazy.nvim
------------------------------------------------------------------------------
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
    -- Файловый менеджер
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = { { '<C-S-e>', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' } },
        opts = {},
    },
	{ "mileszs/ack.vim" },
    -- ==================== TREESITTER (ОСНОВНАЯ ПОДСВЕТКА) ====================
    {
        'nvim-treesitter/nvim-treesitter',
		lazy = false,
        build = ':TSUpdate',
        opts = {
			ensure_installed = {
				'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query',
				'python', 'sql', 'markdown', 'jsonls', 'yaml',
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

    -- ==================== LSP + MASON (ДОБАВЛЕНЫ PYTHON, LUA, SQL) ====================
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
                    'sqls',       -- SQL
					'rust_analyzer',
					'ts_ls',
					'html',
					'cssls',
					'jdtls',
					'asm_lsp',
					'json'
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local opts = { capabilities = require('cmp_nvim_lsp').default_capabilities() }

                        -- Индивидуальные настройки серверов
                        if server_name == 'clangd' then
                            opts.cmd = {
                                'clangd', '--background-index', '--clang-tidy',
                                '--header-insertion=never', '--fallback-style=llvm',
                                '--query-driver=/usr/bin/g++'
                            }
                        elseif server_name == 'pyright' then
                            -- Можно указать путь к виртуальному окружению, если нужно
                            -- opts.settings = { python = { pythonPath = vim.fn.getcwd() .. '/venv/bin/python' } }
elseif server_name == 'lua_ls' then
    local cc_defs = vim.fn.expand("~/repositories/Sumneko/CC-Tweaked")  -- ПУТЬ К ВАШЕЙ ПАПКЕ
    opts.settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    vim.api.nvim_get_runtime_file("", true),   -- стандартная библиотека Neovim
                    cc_defs,                                   -- ваши определения CC
                },
                -- Чтобы LSP не ругался на другие файлы в этой папке
                ignoreDir = { ".git", "build" },
            },
            telemetry = { enable = false },
        }
    }
						elseif server_name == 'sqls' then
						    opts.settings = {
						        sqls = {
						            connections = {
						                {
						                    driver = 'mysql',
						                    dataSourceName = ':memory:',
						                },
						            },
						        },
						    }
						end

                        require('lspconfig')[server_name].setup(opts)
                    end,
                },
            })

            -- LSP attach автокоманды
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

    -- Автодополнение
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

    -- Статусная строка
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = { options = { theme = 'onedark', component_separators = '|', section_separators = '' } },
    },

    -- Git
    { 'tpope/vim-fugitive' },
    { 'lewis6991/gitsigns.nvim', opts = {} },

    -- Цветовая схема
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            require('onedark').setup { style = 'dark' }
            vim.cmd.colorscheme 'onedark'
        end,
    },

    -- CMake tools (для C++)
    {
        'Civitasv/cmake-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },

    -- ==================== ОТЛАДКА (DAP) – C/C++, PYTHON, LUA ====================
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

            -- Горячие клавиши отладки
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

            -- Адаптеры отладки
            -- 
			-- local codelldb_path = mason_registry.get_package('codelldb'):get_install_path() .. '/extension/adapter/codelldb'
			local codelldb_path = vim.fn.stdpath('data')  .. '/mason/packages/codelldb/extension/adapter/codelldb'
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

            -- Для Lua используем адаптер local-lua-debugger-vscode (должен быть установлен через Mason)
            -- local lua_debugger_path = mason_registry.get_package('lua-debugger'):get_install_path() .. '/extension/debugAdapter.lua'
			local lua_debugger_path = vim.fn.stdpath('data') .. '/mason/packages/lua-debugger/extension/debugAdapter.lua'
            dap.adapters.lua = {
                type = 'server',
                host = '127.0.0.1',
                port = 8086,
                executable = { command = 'lua', args = { lua_debugger_path } },
            }

            -- Вспомогательные функции
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
                        "❌ Ошибка компиляции",
                        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                        "📁 Рабочая директория: " .. current_dir,
                        "📁 Выходная директория:" .. outdir,
                        "📄 Исходный файл:      " .. filename,
                        "💾 Выходной файл:      " .. outfile,
                        "💾 Имя выходного файла:" .. filebase,
                        "🔧 Команда:            " .. cmd,
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
                        title = ' Компиляция ' .. filename,
                        title_pos = 'center',
                    })
                    local buf = vim.api.nvim_create_buf(false, true)
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)
                    vim.api.nvim_win_set_buf(0, buf)
                    vim.api.nvim_buf_set_option(buf, 'filetype', 'text')
                    vim.cmd('normal! gg')
                    return nil
                end

                print("✅ Скомпилировано: " .. outfile)
                return outfile
            end

            -- Конфигурации отладки для разных языков
            dap.configurations.cpp = {
                {
                    name = "▶️ Собрать и отладить текущий файл (g++)",
                    type = "codelldb",
                    request = "launch",
                    program = function() return compile_current_file_cpp() end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    runInTerminal = false,
                },
                {
                    name = "📁 Запустить произвольный исполняемый файл",
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
                    name = "🔨 Запустить цель CMake (из build/)",
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
                            print("Файл не найден: " .. prog)
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
                    name = "🐍 Запустить текущий Python файл",
                    type = "python",
                    request = "launch",
                    program = "${file}",
                    pythonPath = function()
                        -- Попробуем найти виртуальное окружение
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
                    name = "🐍 Отладка с аргументами",
                    type = "python",
                    request = "launch",
                    program = "${file}",
                    args = function()
                        local args_str = vim.fn.input("Аргументы командной строки: ")
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
                    name = "🌙 Запустить текущий Lua файл",
                    type = "lua",
                    request = "launch",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end,
    },

    -- UI для отладки
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-nio' },
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

    -- Виртуальный текст (значения переменных)
    {
        'theHamsta/nvim-dap-virtual-text',
        config = function() require('nvim-dap-virtual-text').setup() end,
    },

    -- Установка адаптеров отладки через Mason
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
        opts = {
            ensure_installed = {
                'codelldb',      -- C/C++/Rust
                'debugpy',       -- Python
                'lua-debugger',  -- Lua (local-lua-debugger-vscode)
            },
            automatic_installation = true,
        },
    },

    -- Удобный просмотр диагностики
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

    -- ==================== ДОПОЛНИТЕЛЬНЫЕ ПЛАГИНЫ ====================
    -- Подсветка всех вхождений слова под курсором
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

    -- Разноцветные скобки
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

------------------------------------------------------------------------------
-- 4. ПОЛЬЗОВАТЕЛЬСКИЕ КОМАНДЫ
------------------------------------------------------------------------------
vim.api.nvim_create_user_command('SpacesDoubleToQuadruple', '%s/ \\{2\\}/		/g', {})
vim.api.nvim_create_user_command('SpacesDoubleToTabs', '%s/ \\{2\\}/\\t/g', {})
vim.api.nvim_create_user_command('SpacesToTabs', '%s/ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('SpacesToTabsFirst', '%s/^ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('SaveNoEOL', function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines > 0 and lines[#lines] == '' then
        table.remove(lines)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.cmd('write')
end, {})
vim.api.nvim_create_user_command('ReopenCP1251', 'e ++enc=cp1251', {})
vim.api.nvim_create_user_command('ClipboardCurrBuffer', 'write ! wl-copy', {})

------------------------------------------------------------------------------
-- 5. Configs for languages
------------------------------------------------------------------------------
require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd', 'pyright', 'lua_ls', 'sqls',
        'rust_analyzer', 'ts_ls', 'html', 'cssls', 'jdtls', 'asm_lsp', 'json'
    },
    automatic_installation = true,
    handlers = {
        -- общий обработчик
        function(server_name)
            local opts = { capabilities = require('cmp_nvim_lsp').default_capabilities() }
            if server_name == 'clangd' then
                opts.cmd = { 'clangd', '--background-index', '--clang-tidy',
                             '--header-insertion=never', '--fallback-style=llvm',
                             '--query-driver=/usr/bin/g++' }
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
                            { driver = 'mysql', dataSourceName = ':memory:' }
                        }
                    }
                }
            elseif server_name == 'pyright' then
                -- настройки при необходимости
            end
            require('lspconfig')[server_name].setup(opts)
        end,

        -- специальный обработчик для rust_analyzer
        ['rust_analyzer'] = function()
            local opts = {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = { command = "clippy" },
                        diagnostics = { enable = true },
                        rustfmt = { overrideCommand = { "rustfmt", "--edition", "2021" } },
                    },
                },
            }
            require('lspconfig').rust_analyzer.setup(opts)
        end,

        -- можно добавить обработчики для ts_ls, html и т.д.
    },
})

-- Принудительно табы
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function() vim.bo.expandtab = false end,
})

-- Подсветка при yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
})

-- Быстрые исправления
vim.keymap.set('n', '<leader>qf', function()
    vim.lsp.buf.code_action({ context = { only = { 'quickfix' } }, apply = false })
end, { desc = 'Show quick fixes for current line' })

------------------------------------------------------------------------------
-- 5. НАСТРОЙКА ПОДСВЕТКИ (УНИКАЛЬНЫЕ ЦВЕТА ДЛЯ ВСЕХ ЯЗЫКОВ)
------------------------------------------------------------------------------
vim.opt.syntax = 'off'
vim.cmd('syntax off')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'python', 'lua', 'sql', 'nasm',
                'rust', 'asm', 'javascript', 'typescript', 'html', 'css', 'java', 'kotlin', 'cmake' },
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo.filetype
        local ok, err = pcall(vim.treesitter.start, buf, ft)
        if not ok then
            vim.notify("TS start error for " .. ft .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        local hl = vim.api.nvim_set_hl

        -- ===== Базовые группы для всех языков (Treesitter) =====
        hl(0, '@type.builtin',          { fg = '#4ec9b0' })
        hl(0, '@type',                   { fg = '#3cb371' })
        hl(0, '@class',                  { fg = '#ffd700' })
        hl(0, '@struct',                 { fg = '#daa520' })
        hl(0, '@namespace',              { fg = '#87ceeb' })
        hl(0, '@function',               { fg = '#ff6347' })
        hl(0, '@method',                 { fg = '#ff4500' })
        hl(0, '@variable',               { fg = '#1e90ff' })
        hl(0, '@parameter',              { fg = '#f0e68c', italic = true })
        hl(0, '@operator',               { fg = '#ff69b4', bold = true })
        hl(0, '@keyword',                { fg = '#ba55d3', bold = true })
        hl(0, '@keyword.return',         { fg = '#ff00ff' })
        hl(0, '@keyword.conditional',    { fg = '#ff66cc' })
        hl(0, '@keyword.type',           { fg = '#ffcc00' })
        hl(0, '@keyword.import',         { fg = '#00ffff' })
        hl(0, '@keyword.directive.define', { fg = '#00fa9a' })
        hl(0, '@conditional',            { fg = '#dda0dd' })
        hl(0, '@repeat',                 { fg = '#ee82ee' })
        hl(0, '@return',                 { fg = '#da70d6' })
        hl(0, '@number',                 { fg = '#7cfc00' })
        hl(0, '@string',                 { fg = '#ffd700' })
        hl(0, '@comment',                { fg = '#90ee90', italic = true })
        hl(0, '@constant',               { fg = '#ff8c00' })
        hl(0, '@macro',                  { fg = '#cd5c5c' })
        hl(0, '@field',                  { fg = '#6495ed' })
        hl(0, '@property',               { fg = '#b0c4de' })
        hl(0, '@constructor',            { fg = '#5f9ea0' })

        -- LSP semantic tokens
        hl(0, '@lsp.type.variable',      { fg = '#00bfff' })
        hl(0, '@lsp.type.parameter',     { fg = '#ffa07a' })
        hl(0, '@lsp.type.type',          { fg = '#32cd32' })
        hl(0, '@lsp.type.class',         { fg = '#ffcc00', bold = true })
        hl(0, '@lsp.type.function',      { fg = '#ff6666' })
        hl(0, '@lsp.type.namespace',     { fg = '#66ccff' })

        -- Document highlight
        hl(0, 'LspReferenceText',        { bg = '#2d4a7a' })
        hl(0, 'LspReferenceRead',        { bg = '#2d4a7a' })
        hl(0, 'LspReferenceWrite',       { bg = '#2d4a7a' })

        -- Rainbow delimiters
        hl(0, 'RainbowDelimiterRed',     { fg = '#aa2200' })
        hl(0, 'RainbowDelimiterYellow',  { fg = '#55aa00' })
        hl(0, 'RainbowDelimiterBlue',    { fg = '#00aaff' })
        hl(0, 'RainbowDelimiterOrange',  { fg = '#ffaa55' })
        hl(0, 'RainbowDelimiterGreen',   { fg = '#00aa00' })
        hl(0, 'RainbowDelimiterViolet',  { fg = '#8a2be2' })
        hl(0, 'RainbowDelimiterCyan',    { fg = '#0077bb' })

        -- ===== Дополнительные группы для SQL =====
        hl(0, '@keyword.sql',            { fg = '#ba55d3', bold = true })
        hl(0, '@function.sql',           { fg = '#ff6347' })
        hl(0, '@type.sql',               { fg = '#3cb371' })
        hl(0, '@field.sql',              { fg = '#6495ed' })
        hl(0, '@operator.sql',           { fg = '#ff69b4', bold = true })
        hl(0, '@string.sql',             { fg = '#ffd700' })
        hl(0, '@number.sql',             { fg = '#7cfc00' })
        hl(0, '@comment.sql',            { fg = '#90ee90', italic = true })

		-- ===== Дополнительные группы для lua =====
		hl(0, '@comment.lua',				{ fg = '#90ee90', italic = true })

		-- ===== Additional group for Rust =========
		hl(0, '@keyword.rust',            { fg = '#ff7f50' })
		hl(0, '@function.javascript',     { fg = '#adff2f' })
		hl(0, '@tag.html',                { fg = '#87ceeb' })

		-- ===== Additional group for NASM =========
		hl(0, '@keyword.nasm',      { fg = '#ff7f50', bold = true })
		hl(0, '@function.nasm',     { fg = '#adff2f' })
		hl(0, '@label.nasm',        { fg = '#9370db' })
		hl(0, '@comment.nasm',      { fg = '#90ee90', italic = true })
    end,
})

vim.cmd('doautocmd ColorScheme')

print("Neovim config loaded: C/C++, Python, Lua, SQL – LSP, отладка, подсветка")
