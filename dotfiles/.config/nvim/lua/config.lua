--[[
  Neovim config that fully replicates your Vim config:
  - same mappings (leader is space, gd, gr, <space>rn, etc.)
  - same plugins (NERDTree → nvim-tree, airline → lualine, etc.)
  - LSP for C/C++ (clangd) with autocompletion (nvim-cmp)
  - diagnostics, code actions, rename
  - all custom commands and autocommands
  - Russian keymap support, display of invisible characters
--]]

-- Leader (must be set before any mappings that use it)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-----------------------
-- Options (equivalent to 'set')
-----------------------
vim.opt.number = true
vim.opt.numberwidth = 6
vim.opt.mouse = 'a'                     -- same as original, but commented; uncomment if needed
vim.opt.showmode = false                -- mode is already shown in lualine
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

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true

-- File associations (equivalent to autocmd in vimrc)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.c', '*.h' },
  callback = function() vim.bo.filetype = 'c' end,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.cpp', '*.hpp' },
  callback = function() vim.bo.filetype = 'cpp' end,
})

-- Disable backup/swap (as in original)
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false                -- we enabled undofile above; if you want exactly like original, comment or remove
vim.opt.swapfile = false

-- Encodings
vim.opt.encoding = 'utf-8'
vim.opt.termencoding = 'utf-8'

-- 24-bit color (equivalent to your condition)
if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end

-- Russian keyboard layout (langmap)
vim.opt.langmap = 'ФИСВУАПРШОЛДЖЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKL:MNOPQRSTUVWXYZ,фисвуапршолджьтщзйкыегмцчня;abcdefghijkl:mnopqrstuvwxyz'

-- Show invisible characters (already set via listchars)
vim.opt.list = true

-----------------------
-- Basic mappings
-----------------------
local map = vim.keymap.set

-- Clear search highlights with Esc
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Window navigation (Ctrl + hjkl)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to upper window' })

-- Buffer switching (Ctrl+Tab / Ctrl+Shift+Tab) – as in original
map('n', '<C-Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<C-S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Exit terminal mode with double Esc
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostics mappings (equivalent to [g and ]g)
map('n', '[g', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']g', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-----------------------
-- Plugins (lazy.nvim)
-----------------------
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
  -- File explorer (equivalent to NERDTree)
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- icons
    keys = {
      { '<C-S-e>', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' }, -- equivalent to Ctrl+Shift+E
    },
    opts = {
      -- default options
    },
  },

  -- Icons (vim-devicons)
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- C/C++ syntax highlighting (equivalent to vim-c-cpp-modern)
  {
    'p00f/clangd_extensions.nvim', -- optional, for extra clangd integration
    -- main highlighting will be via treesitter
  },

  -- Treesitter (highlighting and parsing)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- LSP client and tools
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason.nvim', 'mason-lspconfig.nvim', -- LSP server installers
      { 'williamboman/mason.nvim', opts = {} },
      { 'williamboman/mason-lspconfig.nvim', opts = {} },
    },
    config = function()
      -- LSP setup for C/C++ (clangd)
      local lspconfig = require 'lspconfig'
      lspconfig.clangd.setup {
        -- clangd options (you can add arguments)
        cmd = { 'clangd', '--background-index' },
        -- autocompletion will be handled by nvim-cmp, so disable built-in
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }

      -- Global LSP mappings (applied on LspAttach)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Helper to create buffer-local mappings
          local function buf_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          buf_map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          buf_map('n', 'gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          buf_map('n', 'gy', vim.lsp.buf.type_definition, '[G]oto [T]ype [D]efinition')
          buf_map('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          buf_map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame symbol')
          buf_map({ 'n', 'x' }, '<leader>f', function() vim.lsp.buf.format { async = true } end, '[F]ormat buffer')
          buf_map('n', '<leader>ac', vim.lsp.buf.code_action, 'Code [A]ctions')
          buf_map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')

          if client and client:supports_method('textDocument/inlayHint') then
            buf_map('n', '<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = args.buf }, { bufnr = args.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Highlight references on cursor hold (equivalent to CursorHold)
          if client and client:supports_method('textDocument/documentHighlight', args.buf) then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = args.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = args.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  -- Autocompletion (nvim-cmp)
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',      -- LSP source
      'hrsh7th/cmp-buffer',        -- buffer source
      'hrsh7th/cmp-path',          -- path source
      'L3MON4D3/LuaSnip',          -- snippets
      'saadparwaiz1/cmp_luasnip',  -- snippet integration
      'rafamadriz/friendly-snippets', -- premade snippets
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          -- Tab and Shift-Tab for navigation between items and snippets
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Enter confirms selected item
          ['<C-space>'] = cmp.mapping.complete(),          -- manually trigger completion
          ['<C-e>'] = cmp.mapping.abort(),                 -- close menu
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Telescope (file search, symbols, etc.)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>sf', '<cmd>Telescope find_files<CR>', desc = '[S]earch [F]iles' },
      { '<leader>sg', '<cmd>Telescope live_grep<CR>', desc = '[S]earch by [G]rep' },
      { '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = '[S]earch [H]elp' },
      { '<leader>ss', '<cmd>Telescope builtin<CR>', desc = '[S]earch [S]elect Telescope' },
      { '<leader>sr', '<cmd>Telescope resume<CR>', desc = '[S]earch [R]esume' },
      { '<leader>s.', '<cmd>Telescope oldfiles<CR>', desc = '[S]earch Recent Files' },
      { '<leader><leader>', '<cmd>Telescope buffers<CR>', desc = '[ ] Find existing buffers' },
    },
    config = function()
      require('telescope').setup()
    end,
  },

  -- Statusline (equivalent to airline)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark', -- match your colorscheme
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
      },
    },
  },

  -- Git integration (fugitive and gitsigns)
  {
    'tpope/vim-fugitive', -- same as original
  },
  {
    'lewis6991/gitsigns.nvim', -- highlight changes
    opts = {},
  },

  -- Colorschemes (equivalent to your themes) – keep onedark as main
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'dark' }
      vim.cmd.colorscheme 'onedark'
    end,
  },
  -- Additional themes (as in the list, but only one active)
  -- (others can be installed but not activated)

  -- Optional: Tagbar equivalent for outline
  -- { 'preservim/tagbar', keys = { '<leader>o', '<cmd>TagbarToggle<CR>', desc = 'Toggle outline' } },

  -- Ferret is replaced by Telescope (already included)
  -- Git – already have fugitive

  -- Custom commands (defined later)
}, {})

-----------------------
-- User commands (equivalent to command! in vimrc)
-----------------------
vim.api.nvim_create_user_command('SpacesDoubleToQuadruple', '%s/ \\{2\\}/    /g', {})
vim.api.nvim_create_user_command('SpacesDoubleToTabs', '%s/ \\{2\\}/\\t/g', {})
vim.api.nvim_create_user_command('SpacesToTabs', '%s/ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('FakeAuthBearerHeader', '%s/Bearer\\ \\S\\+/Bearer\\ something/g', {} )
vim.api.nvim_create_user_command('SpacesToTabsFirst', '%s/^ \\{4\\}/\\t/g', {})
vim.api.nvim_create_user_command('SaveNoEOL', function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  -- remove trailing empty line if present (typical)
  if #lines > 0 and lines[#lines] == '' then
    table.remove(lines)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd('write')
end, {})
vim.api.nvim_create_user_command('ReopenCP1251', 'e ++enc=cp1251', {})

-- Force tabs for all files (equivalent to autocmd FileType * set noexpandtab)
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function() vim.bo.expandtab = false end,
})

-- Auto-reload config on write
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = vim.env.MYVIMRC,
  callback = function() vim.cmd('source ' .. vim.env.MYVIMRC) end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})
