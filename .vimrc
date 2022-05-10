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
set encoding=utf8
set fileformat=unix
set ambiwidth=single
set scrolloff=12

inoremap jk <ESC>
" colorscheme solarized
" set background=dark
set pastetoggle=<f5>

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

" Vundle section

" Setup Vundle and Plugins if Vundle is not installed
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if iCanHazVundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :source ~/.vimrc
  :PluginInstall
endif

" END - Setting up Vundle - the vim plugin bundler
set nocompatible                    " required by vundle
filetype off                        " required by vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'preservim/nerdtree'
Plugin 'dense-analysis/ale'
Plugin 'arcticicestudio/nord-vim'
Plugin 'mhinz/vim-signify'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme nord

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

au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <C-n> <Plug>(ale_next_wrap_error)
nmap <C-p> <Plug>(ale_next_wrap_warning)

let g:ale_python_black_options = '-l 79'
let g:ale_fixers = {
\       'python' : [
\       'isort',
\       'black',
\   ]
\}
nmap <F8> <Plug>(ale_fix)
