""" PLUGINS
" Plujackguo380/vim-lsp-cxx-highlightgins
call plug#begin()

Plug 'scrooloose/nerdtree'	, { 'on' : 'NERDTreeToggle' }
Plug 'neoclide/coc.nvim'	, { 'branch' : 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'morhetz/gruvbox'
Plug 'glepnir/oceanic-material'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'angelskieglazki/hcch.vim'
Plug 'arcticicestudio/nord-vim'
" File search
Plug 'wincent/ferret'
" git
Plug 'tpope/vim-fugitive'

call plug#end()

filetype plugin on




""" CLANG SETTINGS
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = exepath("clangd")




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
"colorscheme nord
colorscheme oceanic_material

set background=dark




""" FONT
"set guifont=Consolas:h8
set guifont=Adwaita\ Mono
"set nowrap
syntax on
set number
set numberwidth=6




""" TERM SETTINGS
"term terminal
"Use 24-bit (tru-color) mode in Vim/Neovim outside tmux
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux 24-bit color support
"(see < https://sunaku.github.io./tmux-24bit-color.html#usage > for more information)
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
" 1 Command for handle calling space replacing
command! SpacesToTabs %s/ \{4\}/\t/g
" 2 Force using tabs for all files
autocmd FileType * set noexpandtab
" 3 Saving without \n
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
