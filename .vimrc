" Plujackguo380/vim-lsp-cxx-highlightgins
call plug#begin()

Plug 'scrooloose/nerdtree'	, { 'on' : 'NERDTreeToggle' }
Plug 'neoclide/coc.nvim'	, { 'branch' : 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
" git
Plug 'tpope/vim-fugitive'

call plug#end()


" clang
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = exepath("clangd")

" airline
let g:airline_powerline_fonts=1
set encoding=utf-8
set termencoding=utf-8
let g:airline_filetype_overrides = {
	\ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}']
\}






source $VIMRUNTIME/vimrc_example.vim
set guifont=Consolas:h8
"set nowrap

 

set number
set numberwidth=6

set t_Co=256
syntax on
colorscheme slate
colorscheme onedark
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


set wildmenu
set backspace=indent,eol,start
set number
set numberwidth=6
set showcmd
set tabstop=4
let c_syntax_for_h="" " необходимо установить для того, чтобы *.h файлам присваивался тип c, а не cpp
set shiftwidth=4 " размер отступов (нажатие на << или >>)
set tabstop=4 " ширина табуляции
set softtabstop=4 " ширина 'мягкого' таба
set autoindent " ai - включить автоотступы (копируется отступ предыдущей строки)
"set cindent " ci - отступы в стиле С
set smartindent " Умные отступы (например, автоотступ после {)

" Команда для ручного вызова замены пробелов на табы
command! SpacesToTabs %s/ \{4\}/\t/g
set mps+=<:> " показывать совпадающие скобки для HTML-тегов
"" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Принудительно использовать табы для всех файлов
autocmd FileType * set noexpandtab

set langmap=фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
set list		  " Показывать невидимые символы
set listchars=tab:▸\ ,space:\_

set nobackup
set nowritebackup

set noundofile




set mouse=
" Для строки состояния
set laststatus=2






