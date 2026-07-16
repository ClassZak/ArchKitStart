""" LEADER KEY
let mapleader=' '




""" PLUGINS
call plug#begin()


Plug 'scrooloose/nerdtree'	, { 'on' : 'NERDTreeToggle' }
" Ctrl + Shift + E
inoremap <c-s-e> <Esc>:NERDTreeToggle<cr>
nnoremap <c-s-e> <Esc>:NERDTreeToggle<cr>
" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim'	, { 'branch' : 'release'}
autocmd BufRead,BufNewFile *.c,*.h set filetype=c
autocmd BufRead,BufNewFile *.cpp,*.hpp set filetype=cpp
" use <tab> to trigger completion and navigate to the next complete item
" THIS FUNCTION WAS COPIED FROM COC WIKI
function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <Tab>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh
inoremap <silent><expr> <S-Tab>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\"\<C-h>"
" Use <c-space> to trigger completion
" THIS FUNCTION WAS COPIED FROM COC WIKI
inoremap <silent><expr> <c-@> coc#refresh()
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" C++
"Plug 'angelskieglazki/hcch.vim'
"Plug 'jackguo380/vim-lsp-cxx-highlight' " not work
Plug 'bfrg/vim-c-cpp-modern'
" vim-c-cpp-modern settings
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_type_name_highlight = 1
let g:cpp_operator_highlight = 1
let g:cpp_builtin_types_as_statement = 1
let g:cpp_simple_highlight = 1

" Rust
"Plug 'rust-lang/rust.vim'
"Plug 'rust-lang/rust-analyzer'
"Plug 'arzg/vim-rust-syntax-ext'

" Assembly
Plug 'Shirk/vim-gas'

" Themes
Plug 'gruvbox-community/gruvbox'
Plug 'glepnir/oceanic-material'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'nanotech/jellybeans.vim'
Plug 'liuchengxu/space-vim-dark'

" Menu
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File search
Plug 'wincent/ferret'

" git
Plug 'tpope/vim-fugitive'


call plug#end()

filetype plugin indent on




""" AIRLINE SETTINGS
let g:airline_powerline_fonts=1
set encoding=utf-8
set termencoding=utf-8
let g:airline_filetype_overrides = {
	\ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}']
\}




""" COLORSCHEME
"Select one theme scheme color colorscheme colortheme
"colorscheme onedark
"colorscheme gruvbox
colorscheme onedark
"colorscheme oceanic_material
"colorscheme hybrid_material
"colorscheme jellybeans
"colorscheme space-vim-dark

set background=dark




""" FONT
"set guifont=Consolas:h8
"set guifont=Adwaita\ Mono
"Windows
if (has("win32") || has("win64"))
	set guifont=Noto\ Mono\ for\ Powerline:h7.75
else
	set guifont=Adwaita\ Mono
endif
"set nowrap
syntax on
set number
set numberwidth=6




""" TERM SETTINGS
"term terminal
"Use 24-bit (tru-color) mode in Vim/Neovim outside tmux
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux 24-bit color support
"(see < https://sunaku.github.io./tmux-24bit-color.html#usage > for more information)
if (has("win32") || has("win64"))
else
	if (empty($TMUX))
		if (has("nvim"))
			let $NVIM_TUI_ENABLE_TRUE_COLOR=1
		endif
		if (has("termguicolors"))
			set termguicolors
		endif
	endif
	set term=xterm-256color
	set t_Co=256
endif




""" MENU SETTINGS
set wildmenu
set showcmd
" For status line
set laststatus=2




""" NUMCOLUMN
set number
set numberwidth=6




""" INDENT
set shiftwidth=4 " размер отступов (нажатие на << или >>)
set tabstop=4 " ширина табуляции
set softtabstop=4 " ширина 'мягкого' таба
set autoindent " ai - включить автоотступы (копируется отступ предыдущей строки)
set cindent " ci - отступы в стиле С
set smartindent " Умные отступы (например, автоотступ после {)




""" BACKSPACE
set backspace=indent,eol,start




""" FILE ACCOSIATIONS
" let c_syntax_for_h="" " Used for C style for *.h files instead of C++




""" COMMANDS
" 1 Command for handle calling double space replacing into quadruple space
command! SpacesDoubleToQuadruple %s/ \{2\}/\ \ \ \ /g
" 2 Command for handle calling double space replacing into tabs
command! SpacesDoubleToTabs %s/ \{2\}/\t/g
" 3 Command for handle calling space replacing into tabs
command! SpacesToTabs %s/ \{4\}/\t/g
" 4 Command fot handle calling replacing spaces at the lines beginning into tabs
command! SpacesToTabsFirst %s/^\ \{4\}/\t/g
" 5 Force using tabs for all files
autocmd FileType * set noexpandtab
" 6 Saving without \n
function! SaveWithoutEOL()
	silent! %s/\n$//e
	let l:save_binary = &binary
	let l:save_eol=&eol

	set noeol
	set binary
	write
	let &binary = l:save_binary
	let &eol = l:save_eol
endfunction
command! SaveNoEOL call SaveWithoutEOL()
" 7 Reopen in cyrilic encoding for Windows
command! ReopenCP1251 e ++enc=cp1251
" 8 Fake Bearer header
command! FakeAuthBearerHeader %s/Bearer\ \S+/Bearer\ something/g



""" MAPPING AND SYMBOLS LISTING
set mps+=<:> " HTML-tag highlight
"" Russian symbols keymap
"set langmap=фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
"For foot
set langmap=ФИСВУАПРШОЛДЖЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKL:MNOPQRSTUVWXYZ,фисвуапршолджьтщзйкыегмцчня;abcdefghijkl:mnopqrstuvwxyz
set list		  " Show insivible symbols
set listchars=tab:▸\ ,space:\_




" 1. Switch between buffers like in Visual Studio
nnoremap <C-Tab> :bnext<CR>
nnoremap <C-S-Tab> :bprevious<CR>
" 2. Switch between windows (not work)
nnoremap <C-Tab> <C-w>w
nnoremap <C-S-Tab> <C-w>W
" 3. Switch between vim tabs
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>





""" BACKUP SETTINGS
set nobackup
set nowritebackup
set noundofile
if (has("win32") || has("win64"))
	set noswapfile
endif




""" MOUSE SETTINGS
"set mouse=




""" AUTOACCEPT
source $VIMRUNTIME/vimrc_example.vim
" Auto accept changes vim.rc config
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
