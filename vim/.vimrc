""" PLUGINS
call plug#begin()


Plug 'scrooloose/nerdtree'	, { 'on' : 'NERDTreeToggle' }
" Ctrl + Shift + E
inoremap <c-s-e> <Esc>:NERDTreeToggle<cr>
nnoremap <c-s-e> <Esc>:NERDTreeToggle<cr>
Plug 'neoclide/coc.nvim'	, { 'branch' : 'release'}
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

" C++
Plug 'angelskieglazki/hcch.vim'
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
"colorscheme onedark
colorscheme oceanic_material
"colorscheme hybrid_material
"colorscheme jellybeans

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
if has("win32") || has("win64")
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
let c_syntax_for_h="" " необходимо установить для того, чтобы *.h файлам присваивался тип c, а не cpp




""" COMMANDS
" 1 Command for handle calling double space replacing into quadruple space
command! SpacesDoubleToQuadruple %s/ \{2\}/\ \ \ \ /g
" 2 Command for handle calling double space replacing into tabs
command! SpacesDoubleToTabs %s/ \{2\}/\t/g
" 3 Command for handle calling space replacing into tabs
command! SpacesToTabs %s/ \{4\}/\t/g
" 4 Force using tabs for all files
autocmd FileType * set noexpandtab
" 5 Saving without \n
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




""" MAPPING AND SYMBOLS LISTING
set mps+=<:> " HTML-tag highlight
"" Russian symbols keymap
"set langmap=фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
"For foot
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set list		  " Show insivible symbols
set listchars=tab:▸\ ,space:\_




""" BACKUP SETTINGS
set nobackup
set nowritebackup
set noundofile




""" MOUSE SETTINGS
"set mouse=




""" AUTOACCEPT
source $VIMRUNTIME/vimrc_example.vim
" Auto accept changes vim.rc config
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
