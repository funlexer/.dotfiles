call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'valloric/youcompleteme', { 'branch': 'legacy-vim-8.2', 'do': './install.py --go-completer' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'yggdroot/indentline'
Plug 'bronson/vim-trailing-whitespace'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'habamax/vim-asciidoctor'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'tenfyzhong/tagbar-makefile.vim'
Plug 'joshdick/onedark.vim'
call plug#end()

syntax on
let mapleader = " "

set t_Co=256
set background=dark
set nocompatible  " be iMproved
set nu
set rnu
set ts=2
set sw=2
set softtabstop=2
set expandtab " tab을 space로 저장
set scrolloff=15 " scroll offset. 15줄 범위에서부터 scroll
set ruler " 현재 row, col을 출력
set autoindent
set cindent
set incsearch
set hlsearch
set ignorecase
set smartcase
set hidden
set autowrite
set wildmenu "명령어 tab completion
set laststatus=2 " vim-powerline이 꾸며주는 상태바를 항상 출력하기 위해
set enc=utf-8
set fencs=ucs-bom,utf-8,cp949
set fenc=utf-8
set mmp=10000
set noerrorbells visualbell t_vb= " sound, visual bell 둘 다 비활성화.
"set termguicolors
set clipboard=unnamedplus " https://vim.fandom.com/wiki/Accessing_the_symtem_clipboard
if has('mac')
  set clipboard=unnamed
endif

if has('gui_running')
  set guioptions-=T " no toolbar
  set guioptions-=m " no memnubar
  if has("win32")
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ko_kr.utf-8
    source $VIMRUNTIME/menu.vim

    lang mes en
    " E303: Unable to open swap file for [No Name], recovery impossible
    set directory=.,$TEMP
  endif
endif

"colorscheme onedark

"https://github.com/vim/vim/issues/3608
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

autocmd GUIEnter * set visualbell t_vb=
autocmd BufWinEnter *.{md,mkd,mkdn,mark*} silent setf markdown

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit="vertical"

"!+ vim-go
let g:go_version_warning = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <leader>d <Plug>(go-def-tab)

  autocmd FileType go nmap <silent> <leader>x <Plug>(go-doc-vertical)

  autocmd FileType go nmap <silent> <leader>i <Plug>(go-info)

  autocmd FileType go nmap <silent> <leader>gi <Plug>(go-implements)
  autocmd FileType go nmap <silent> <leader>gr <Plug>(go-referrers)

  autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

  autocmd FileType go nmap <silent> <leader>c <Plug>(go-coverage-toggle)

  autocmd FileType go nmap <silent> <leader>bb :GoDecls<cr>

  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

let g:tagbar_type_groovy = {
      \ 'ctagstype' : 'groovy',
      \ 'kinds'     : [
        \ 'p:package:1',
        \ 'c:classes',
        \ 'i:interfaces',
        \ 't:traits',
        \ 'e:enums',
        \ 'm:methods',
        \ 'f:fields:1'
        \ ]
        \ }

nmap <F8> :TagbarToggle<CR>
nmap <C-p> :Files<CR>
nmap <C-n> :NERDTreeToggle<CR>
nmap <Leader>ms :NERDTreeFind<CR>
nmap <Leader>b :BuffergatorOpen<CR>

let g:vim_json_conceal=0
