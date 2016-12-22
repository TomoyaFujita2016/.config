colorscheme badwolf
set number
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=4 "画面上でタブ文字が占める幅
set shiftwidth=4 "自動インデントでずれる幅
set softtabstop=4 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set ic "検索の時大文字小文字区別なし
"自動補完===
"set completeopt=menuone
"for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
"        exec "imap " . k . " " . k . "<C-X><C-P><C-N>"
"endfor
"imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"
"===========
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
