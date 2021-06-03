syntax on
colorscheme badwolf
set encoding=UTF-8
set background=dark
set number
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=4 "画面上でタブ文字が占める幅
set shiftwidth=4 "自動インデントでずれる幅
set softtabstop=4 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set ic "検索の時大文字小文字区別なし
set ttyfast
set lazyredraw
set hlsearch "検索語をハイライト表示
set incsearch
set ambiwidth=double
set backspace=indent,eol,start
set completeopt=menuone,noinsert
let mapleader = "\<Space>"

"scrooloose/nerdcommenter.gitの設定
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'

autocmd FileType vue syntax sync fromstart

nnoremap <ESC><ESC> :nohl<CR>
nnoremap <C-j><C-j> :nohl<CR>
map <C-n> <plug>NERDTreeTabsToggle<CR>

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

"自動補完===
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
        exec "imap " . k . " " . k . "<C-X><C-P><C-N>"
endfor
imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>" "===========
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
"=========

set t_Co=256
imap <C-j> <esc>

" 最後にカーソルがいたところを記憶
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

" terminalとfiletreeをいい感じに表示
noremap <C-e> <ESC>:call LikeIDE()<ENTER>
function! LikeIDE()
  :NERDTreeTabsToggle
  :terminal
  :wincmd x
  :8 wincmd +
  :20 wincmd >
endfunction

let g:NERDDefaultAlign='left'
let g:vim_vue_plugin_config = {
    \'syntax': {
    \   'template': ['html'],
    \   'script': ['javascript'],
    \   'style': ['css'],
    \},
    \'full_syntax': [],
    \'initial_indent': [],
    \'attribute': 0,
    \'keyword': 0,
    \'foldexpr': 0,
    \'debug': 0,
    \}
"=== are===
" flake8をLinterとして登録
let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'html': [],
    \ 'css': ['stylelint'],
    \ 'javascript': ['eslint'],
    \ 'vue': ['eslint', 'vls']
    \ }

" 各ツールをFixerとして登録
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['black', 'autopep8','isort'],
    \ 'javascript': ['eslint'],
    \ }

let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}

" ついでにFixを実行するマッピングしとく
nmap <silent> <Leader>x <Plug>(ale_fix)
" ファイル保存時に自動的にFixするオプションもあるのでお好みで
let g:ale_fix_on_save = 1


" 保存時のみ実行する
let g:python3_host_prog = $PYENV_PATH . '/versions/deinvim/bin/python'
let g:ale_python_flake8_executable = g:python3_host_prog
let g:ale_python_flake8_options = '-m flake8 --ignore="E501"'
let g:ale_python_black_executable = g:python3_host_prog
let g:ale_python_black_options = '-m black'
let g:ale_python_isort_executable = g:python3_host_prog
let g:ale_python_isort_options = '-m isort'
let g:ale_python_autopep8_executable = g:python3_host_prog
let g:ale_python_autopep8_options = '-m autopep8'
let g:ale_lint_on_text_changed = 0
" 表示に関する設定
let g:ale_sign_error = '✖︎'
let g:ale_sign_warning = '▲'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" indent guideの設定
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=60
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=23

" nerdtreeの設定
let g:nerdtree_tabs_autoclose = 1

" ctags
set tags=./.tags;$HOME

" auto-ctags
augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END

function! s:execute_ctags() abort
  " 探すタグ/gitファイル名
  let tag_name = '.tags'
  let git_name = '.git'
  " ディレクトリを遡り、タグファイルを探し、パス取得
  let tags_path = findfile(tag_name, '.;')
  " タグファイルパスが見つからなかった場合
  if tags_path ==# ''
    let tags_path = finddir(git_name, '.;')
    let tags_dirpath = fnamemodify(tags_path, ':p:h')
    execute 'silent !cd' tags_dirpath[:-strlen(git_name)] '&& ctags -R -f' tag_name '2> /dev/null &'
    return
  endif

  " タグファイルのディレクトリパスを取得
  " `:p:h`の部分は、:h filename-modifiersで確認
  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  " 見つかったタグファイルのディレクトリに移動して、ctagsをバックグラウンド実行（エラー出力破棄）
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction

" let g:dein#auto_recache = 1
"=== dein.vim ===
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('vim-airline/vim-airline')
  call dein#add('thinca/vim-quickrun')
  call dein#add('dense-analysis/ale')
  call dein#add('suan/vim-instant-markdown')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('scrooloose/nerdcommenter.git')
  call dein#add('posva/vim-vue')
  call dein#add('mattn/emmet-vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')

  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable
