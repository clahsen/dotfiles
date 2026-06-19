" Implied when a vimrc is found, but be explicit (and keep it first).
set nocompatible

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set number
set rnu  " relative line numbers
set showcmd
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set textwidth=79
set ruler
set cursorline
syntax on
set history=700
set encoding=utf-8
set fileformat=unix
set ambiwidth=single
set scrolloff=12

inoremap jk <ESC>
" colorscheme solarized
" set background=dark
" pastetoggle was removed in Vim 9; modern Vim/Neovim auto-handle bracketed
" paste. Guarded so it doesn't error on newer versions.
if exists('+pastetoggle')
  set pastetoggle=<f5>
endif

" set where to open splits
set splitbelow
set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"code folding
set foldmethod=indent
set foldnestmax=2
nnoremap <space> za

" Enable folding
" set foldmethod=indent
" set foldlevel=99
" Enable folding with the spacebar
" nnoremap <space> za

" color bad whitespaces in python
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" ---- Plugins (vim-plug) ----

" Auto-install vim-plug itself on a fresh machine.
let s:plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_path)
  echo "Installing vim-plug.."
  silent execute '!curl -fLo ' . s:plug_path . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " Install plugins on first start, then re-source so config applies.
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
" Lazy: load only when toggled (mapped to <F6> below).
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" Lazy: load only for filetypes we actually lint.
Plug 'dense-analysis/ale', { 'for': ['python', 'yaml'] }
Plug 'arcticicestudio/nord-vim'
Plug 'mhinz/vim-signify'
" fzf binary + Vim commands (:Files, :Rg, ...). 'do' builds/updates the binary.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" plug#end() also runs `filetype plugin indent on` and `syntax enable`.
call plug#end()

" Enable 24-bit color where supported; nord looks much better with it.
if has('termguicolors')
  set termguicolors
endif
" silent! so a fresh machine without the plugin yet doesn't error on startup.
silent! colorscheme nord

" ---- vim-airline ----"
"  require powerline-symbol patched font intstalled
let g:airline_powerline_fonts = 1
" remove empty angle at the end
let g:airline_skip_empty_sections = 1
" set airline theme
let g:airline_theme = 'nord'
" extension for tab line
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail'

if filereadable(expand('~/.vim/yaml.vim'))
  au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
endif

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <C-n> <Plug>(ale_next_wrap_error)
nmap <C-p> <Plug>(ale_next_wrap_warning)

" ---- Python: lint & format with ruff (run via uv when available) ----
" When a uv project is detected, ALE runs tools through `uv run` so the
" project-pinned ruff is used instead of a global one.
let g:ale_python_auto_uv = 1

" Choose Python linters/fixers from what's installed, so this vimrc also
" works on remote machines without ruff/uv. ALE additionally skips any
" linter/fixer whose executable is missing, so a missing tool is harmless.
let s:py_fixers = ['remove_trailing_lines', 'trim_whitespace']
if executable('ruff') || executable('uv')
  let g:ale_linters = {'python': ['ruff']}
  " 'ruff'        -> ruff check --fix (incl. import sorting via the I rules)
  " 'ruff_format' -> ruff format
  let s:py_fixers += ['ruff', 'ruff_format']
elseif executable('black') || executable('isort')
  let g:ale_linters = {'python': ['flake8']}
  let s:py_fixers += ['isort', 'black']
endif
let g:ale_fixers = {'python': s:py_fixers}

" Only used by the black fallback above (line length 79).
let g:ale_python_black_options = '-l 79'
nmap <F8> <Plug>(ale_fix)
nmap <F6> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1


