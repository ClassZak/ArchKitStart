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
-- HTML/CSS (Neovim detects automatically, but for reliability)
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
   pattern = '*.json',
   command = 'set filetype=json',
})
