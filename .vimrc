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

" Keep the sign gutter always open so text doesn't jump when ALE/signify
" add or remove signs.
set signcolumn=yes

" Persistent undo: keep undo history across sessions (created if missing).
if has('persistent_undo')
  let s:undodir = expand('~/.vim/undo')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p', 0700)
  endif
  let &undodir = s:undodir
  set undofile
endif

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

" ---- fzf (fuzzy finder) ----
" <leader> is '\' by default. Guarded with exists() so they silently no-op
" on a machine where fzf.vim isn't installed yet (e.g. before :PlugInstall).
if exists(':Files')
  nnoremap <leader>f :Files<CR>
  nnoremap <leader>b :Buffers<CR>
  " :Rg needs the ripgrep binary.
  if executable('rg')
    nnoremap <leader>g :Rg<CR>
  endif
endif

if filereadable(expand('~/.vim/yaml.vim'))
  au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
endif

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <C-n> <Plug>(ale_next_wrap_error)
nmap <C-p> <Plug>(ale_next_wrap_warning)

" ---- Python: lint & format with ruff (run from the project venv) ----
" Run Python tools from the project's virtualenv (.venv) and export
" VIRTUAL_ENV to their processes. This makes ruff use the project-pinned
" version AND lets jedi-language-server introspect installed third-party
" packages (numpy, matplotlib, ...) for completion/hover.
"
" Preferred over `ale_python_auto_uv` here: with auto_uv, ALE launches the
" LSP as `uv run jedi-language-server`, which re-syncs on every start and
" fails outright if the server isn't a project dependency. auto_virtualenv
" instead runs .venv/bin/<tool> directly, falling back to the global tool
" (with VIRTUAL_ENV still set) when the venv lacks it.
let g:ale_python_auto_virtualenv = 1

" LSP-powered completion through ALE (must be set before ALE is loaded).
let g:ale_completion_enabled = 1
" Nicer popup: show menu even for one match, don't auto-insert.
set completeopt=menu,menuone,noselect

" <Tab>/<S-Tab> navigate the completion popup when it's visible; otherwise
" <Tab> inserts a literal tab as usual.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Choose Python linters/fixers from what's installed, so this vimrc also
" works on remote machines without ruff/uv. ALE additionally skips any
" linter/fixer whose executable is missing, so a missing tool is harmless.
let s:py_linters = []
let s:py_fixers = ['remove_trailing_lines', 'trim_whitespace']
if executable('ruff') || executable('uv')
  let s:py_linters += ['ruff']
  " 'ruff'        -> ruff check --fix (incl. import sorting via the I rules)
  " 'ruff_format' -> ruff format
  let s:py_fixers += ['ruff', 'ruff_format']
elseif executable('black') || executable('isort')
  let s:py_linters += ['flake8']
  let s:py_fixers += ['isort', 'black']
endif
" jedi-language-server adds completion, goto-definition and hover WITHOUT
" emitting diagnostics, so it doesn't duplicate ruff. Install once with:
"   uv tool install jedi-language-server
if executable('jedi-language-server')
  let s:py_linters += ['jedils']
endif
let g:ale_linters = {'python': s:py_linters}
let g:ale_fixers = {'python': s:py_fixers}
" Auto-run the fixers above on :w, so files stay matching `ruff format` in CI.
let g:ale_fix_on_save = 1

" LSP navigation (these are no-ops in buffers where ALE isn't loaded).
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences<CR>
" Note: this overrides the default K (keyword/:help lookup) with LSP hover.
nnoremap <silent> K  :ALEHover<CR>

" Only used by the black fallback above (line length 79).
let g:ale_python_black_options = '-l 79'
nmap <F8> <Plug>(ale_fix)
nmap <F6> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1


