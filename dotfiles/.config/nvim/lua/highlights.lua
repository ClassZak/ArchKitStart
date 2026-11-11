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

        -- Base Treesitter groups
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

        -- SQL
        hl(0, '@keyword.sql',            { fg = '#ba55d3', bold = true })
        hl(0, '@function.sql',           { fg = '#ff6347' })
        hl(0, '@type.sql',               { fg = '#3cb371' })
        hl(0, '@field.sql',              { fg = '#6495ed' })
        hl(0, '@operator.sql',           { fg = '#ff69b4', bold = true })
        hl(0, '@string.sql',             { fg = '#ffd700' })
        hl(0, '@number.sql',             { fg = '#7cfc00' })
        hl(0, '@comment.sql',            { fg = '#90ee90', italic = true })

        -- Lua
        hl(0, '@comment.lua',            { fg = '#90ee90', italic = true })

        -- Rust / JS / HTML
        hl(0, '@keyword.rust',           { fg = '#ff7f50' })
        hl(0, '@function.javascript',    { fg = '#adff2f' })
        hl(0, '@tag.html',               { fg = '#87ceeb' })

        -- NASM
        hl(0, '@keyword.nasm',           { fg = '#ff7f50', bold = true })
        hl(0, '@function.nasm',          { fg = '#adff2f' })
        hl(0, '@label.nasm',             { fg = '#9370db' })
        hl(0, '@comment.nasm',           { fg = '#90ee90', italic = true })
    end,
})

vim.cmd('doautocmd ColorScheme')
