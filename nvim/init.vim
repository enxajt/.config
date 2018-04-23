"---------------------------------------------------------------
" vi互換モード禁止
" 各種プラグイン等機能しなくなったりするため
"
if &compatible
   set nocompatible               " Be iMproved
endif

"---------------------------------------------------------------
" dein
"
"if v:version >= 704 && !has('win32')
let s:dein_enabled  = 0
if !has('win32')
  let s:dein_enabled = 1

  " reset augroup
  augroup MyAutoCmd
    autocmd!
  augroup END

  " dein自体の自動インストール
  let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:dein_dir = s:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .",". &runtimepath
  
  " プラグイン読み込み＆キャッシュ作成
  let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_file)
    call dein#end()
    call dein#save_state()
  endif
  " " 不足プラグインの自動インストール
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif                                                                                   

"---------------------------------------------------------------
" win,mac対応
"
" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------
" file, directly 
let $VIMDIR = $HOME."/.config/nvim"
"=の前後にスペースは入れない
set backup
set undofile
let &backupdir=$VIMDIR."/backup" 
let &directory=$VIMDIR."/swp" 
let &undodir=$VIMDIR."/undo"

"---------------------------------------------------------------
" file(encode, format)
"
" 改行コードの自動認識
set fileformats=unix,dos,mac

" textwidthでフォーマットさせたくない
set formatoptions=q

"---------------------------------------------------------------
" file(文字コードの自動認識)
"
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

"---------------------------------------------------------------
" file(md)
"
let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_level = 6

"---------------------------------------------------------------
" file(拡張子)
"
".mdファイルもMarkdown記法として読み込む
au BufRead,BufNewFile *.md,*.conf set filetype=markdown
au BufRead,BufNewFile *.ejs set filetype=html
au BufRead,BufNewFile *.coffee set filetype=javascript

"---------------------------------------------------------------
" file(ファイル名の大文字小文字)
" ファイル名に大文字小文字の区別がないシステム用(例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"if has('path_extra')
"    set tags& tags + =.tags, tags
"endif

"---------------------------------------------------------------
" japanese IME
"
function! ImInActivate()
  call system('fcitx-remote -c')
endfunction
inoremap <silent> <C-[> <ESC>:call ImInActivate()<CR>

"---------------------------------------------------------------
" view 
"
" バッファを保存しなくても他のバッファを表示できるようにする
set hidden 

"起動時のメッセージなし
set shortmess+=I

" 行番号を表示
set number

" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch

" □とか○の文字があってもカーソル位置がずれないようにする
" ただし、éàèなどが全角になる
"if exists('&ambiwidth')
"  set ambiwidth=double
"endif

" Use visual bell instead of beeping when doing something wrong
set visualbell
" vim will neither flash nor beep.  If visualbell
set t_vb=

"---------------------------------------------------------------
" view (全角スペースをハイライト)
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=grey gui=reverse guifg=#2F4F4F
endfunction
"darkgrey 文字色っぽい
"dimgrey 文字色っぽい
"DarksLateGray 緑っぽい#2F4F4F
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

"---------------------------------------------------------------
" view (tab, eol)
"
" タブや改行を表示 (list or nolist)
set list
" 指定されないと、タブは ^I と表示される。
" "tab:>-" とすると、タブが4文字の設定では ">---" となる。
" trail:行末の空白の表示
" ':' と ',' は使えない  
"set listchars=tab:>-,trail:.,eol:↲,nbsp:%
set listchars=tab:▸\ ,eol:↲,nbsp:%

" " 'Yggdroot/indentLine'
" "let g:indentLine_faster = 1
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_leadingSpaceChar = '.'
" "nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

" 折り返しマーク
"set showbreak=

" 勝手に改行するのをやめる
" set textwidth=0    " 日本語入力時には効かなかった
 
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap

"---------------------------------------------------------------
" view (tab)
"
" タブをスペースに展開
" 本当のタブ文字を挿入したい場合は <C-v><Tab>
set expandtab

" タブを、画面上の見た目で何文字分に展開するか
set tabstop=2
"set tabstop=4
" softtabstopが0の場合は、tsを4に設定しても、softtabstop分だけ
" softtabstopが0の場合はtsで指定した分
set softtabstop=0

"vimが挿入('cindent')や(>>や<<)、autoindent時に挿入/削除されるインデントの幅が画面上の見た目で何文字分か
set shiftwidth=2
"set shiftwidth=4

" Tab 入力時 ↓ 
" 行頭の余白内で 'shiftwidth' の数だけインデント
" 行頭以外では 'tabstop' の数だけ空白が挿入
" オフのときは、常に 'tabstop' の数だけインデント
set smarttab

"---------------------------------------------------------------
" view (command)
"
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll
let g:python_highlight_all = 1

" Show partial commands in the last line of the screen
" タイプ途中のコマンドを画面最下行に表示
set showcmd

" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2

" show window title
"set title

"---------------------------------------------------------------
" view (status)
"
"ステータス行を表示
set laststatus=2

" %< - 行が長すぎるときに切り詰める位置
" %f - ファイル名(相対パス), %F - (絶対パス), %t - (パス無し)
" %m - 修正フラグ （[+]または[-]）
" %r - 読み込み専用フラグ（[RO]）
" %h - ヘルプバッファ
" %w - preview window flag
"set statusline=%<%f\ %m%r%h%w
set statusline=%<%f\ %m\ %r%h%w

set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}

" %= - 左寄せと右寄せ項目の区切り（続くアイテムを右寄せにする）
set statusline+=%=

"if has('win32')
"  set statusline+=%{anzu#search_status()}
"endif

" "set ruler" (~行目の,~文字目 ~~%) 代わり
" %l - 現在のカーソルの行番号, %L - 総行数
" %c - column番号
" %V - カラム番号
" %P - カーソルの場所 %表示
set statusline+=%4l/%L,%c%V%4P
"set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}

"set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}

"---------------------------------------------------------------
" view (color) 
"
"colorschemeコマンドを実行する前に設定する
set t_co=256
syntax on

set virtualedit=block
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
set background=dark
"colorscheme hybrid " (Windows用gvim使用時はgvimrcを編集すること)

function! s:load_after_colors()
  if has('win32')
    let color = expand($VIMDIR.'/colors/color_enxajt.vim')
  else
    let color = expand($VIMDIR.'/after.vim')
  endif
  if filereadable(color)
    execute 'source ' color
  endif
endfunction
augroup MyColors
  autocmd!
  autocmd ColorScheme * call s:load_after_colors()
augroup END

" 編集行のハイライト
"set cursorline
" cursorlineの色をクリア
hi clear CursorLine

"---------------------------------------------------------------
" view (コンソールでのカラー表示)
"
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
"    set term=beos-ansi
"    set term=builtin_ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------
" move
"
"カーソルを表示行で移動する。物理行移動は<C-n>,<C-p>
nmap j gj
nmap k gk
nmap <Down> gj
nmap <Up>   gk

" 入力モードでのカーソル移動 ctrl+shift+j と干渉
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-h> <Left>
"inoremap <C-l> <Right>

 " Stop certain movements from always going to the first character of a line.
 " While this behaviour deviates from that of Vi, it does what most users
 " coming from other editors would expect.
 " 移動コマンドを使ったとき、行頭に移動しない
 set nostartofline

 " Instead of failing a command because of unsaved changes, instead raise a
 " dialogue asking if you wish to save changed files.
 " バッファが変更されているとき、コマンドをエラーにするのでなく、保存する
 " かどうか確認を求める
 set confirm

" Auto save
set updatetime=1000
function! s:AutoWriteIfPossible()
  if &modified && !&readonly && bufname('%') !=# '' && &buftype ==# '' && expand("%") !=# ''
    write
  endif
endfunction
augroup AutoWrite
  autocmd!
  autocmd CursorHold * call s:AutoWriteIfPossible()
  autocmd CursorHoldI * call s:AutoWriteIfPossible()
augroup END

"---------------------------------------------------------------
" search
"
set incsearch

" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase

" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan

" 検索語を強調表示
set hlsearch

"\v(Very Magic) Vim方言を使わずに、一般的な正規表現に近い形で書ける
":help magic
" nmap / /\v
" nmap ? ?\v

" if has('win32')
"   map /  <Plug>(incsearch-forward)
"   map ?  <Plug>(incsearch-backward)
"   map g/ <Plug>(incsearch-stay)
" endif

" 検索語が画面の真ん中に来るようにする
"nmap n nzz
""nmap N Nzz "逆方向検索できなくなる  
"nmap * *zz 
"nmap # #zz 
"nmap g* g*zz 
"nmap g# g#zz

" "---------------------------------------------------------------
" " search (osyo-manga/vim-anzu)
" "
" nmap n <Plug>(anzu-n-with-echo)zz
" nmap N <Plug>(anzu-N-with-echo)zz
" nmap * <Plug>(anzu-star-with-echo)
" nmap # <Plug>(anzu-sharp-with-echo)zz
" nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" 
" " if start anzu-mode key mapping
" " anzu-mode is anzu(12/51) in screen
" " nmap n <Plug>(anzu-mode-n)
" " nmap N <Plug>(anzu-mode-N)

"---------------------------------------------------------------
" edit
"
" インデントや改行,挿入モード直後をバックスペース可能
set backspace=indent,eol,start

"---------------------------------------------------------------
" edit (indent)
"
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
"新しい行を作ったときに高度な自動インデントを行う
set smartindent

" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------
" yank 
"
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a

" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
"if !has('gui_running') && has('xterm_clipboard')
"  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
"endif

"通常は無名レジスタに入るヤンク/カットが、*レジスタにも入るようになる
"*レジスタにデータを入れると、クリップボードにデータが入る
set clipboard=unnamed
set clipboard+=unnamedplus

" Capture
command!
      \ -nargs=1
      \ -complete=command
      \ Capture
      \ call Capture(<f-args>)

function! Capture(cmd)
  redir => result
  silent execute a:cmd
  redir END

  let bufname = 'Capture: ' . a:cmd
  new
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  silent file `=bufname`
  silent put =result
  1,2delete _
endfunction

""---------------------------------------------------------------
"" Shougo/deoplete.nvim

""---------------------------------------------------------------
"" Alignを日本語環境で使用するための設定
""
":let g:Align_xstrlen = 3
"":AlignCtrl p0P0

"---------------------------------------------------------------
" key-mappings
"
" h map-modes
"
if has('win32')
  nmap <Space>. :<C-u>tabedit $VIM/_gvimrc<CR>
  nmap <Space>, :<C-u>tabedit $VIM/_vimrc<CR>
elseif has('unix')
  "nmap <Space>, :<C-u>tabedit /root/neovim/share/nvim/sysinit.vim<CR>
  nmap <Space>, :<C-u>tabedit $VIMDIR/init.vim<CR>
  nmap <Space>. :<C-u>tabedit $VIMDIR/dein.toml<CR>
endif

nmap <C-i>d <ESC>a<C-r>=strftime("%Y.%m.%d")<CR>
nmap <C-i>t <ESC>a<C-r>=strftime("%H:%M:%S")<CR>

nnoremap <C-o>u :GundoToggle<CR>

"Turning off Ctrl-Space in Vim
"if !has('gui_running')
"endif
let g:CtrlSpaceDefaultMappingKey = "<C-space>"
"autocmd vimenter * imap <nul> <c-p>
"autocmd VimEnter * map <Nul> <C-Space>
"autocmd VimEnter * map! <Nul> <C-Space>
"autocmd vimenter * imap <nul> <nop>
"autocmd vimenter * map  <nul> <nop>
"autocmd vimenter * vmap <nul> <nop>
"autocmd vimenter * cmap <nul> <nop>
"autocmd vimenter * nmap <nul> <nop>
autocmd vimenter * inoremap <C-Space> <nop>
"autocmd vimenter * inoremap <C-@> <C-Space>

nnoremap <C-o>u :GundoToggle<CR>

""---------------------------------------------------------------
"" key-mappings (junegunn/vim-easy-align)
""
"" repo = 'junegunn/vim-easy-align'
"" Start interactive EasyAlign in visual mode (e.g. vipga)
"" xmap ga <Plug>(EasyAlign)
"vmap <Enter> <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)
"
""---------------------------------------------------------------
"" key-mappings (neocomplete)
""
"" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()
"
"" Recommended key-mappings.
"" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
"  " For no inserting <CR> key.
"  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
"" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"" Close popup by <Space>.
""inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
"
"" For smart TAB completion.
""inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
""        \ <SID>check_back_space() ? "\<TAB>" :
""        \ neocomplete#start_manual_complete()
""  function! s:check_back_space() "{{{
""    let col = col('.') - 1
""    return !col || getline('.')[col - 1]  =~ '\s'
""  endfunction"}}}
"
"" AutoComplPop like behavior.
""let g:neocomplete#enable_auto_select = 1
"
"" Shell like behavior (not recommended.)
""set completeopt+=longest
""let g:neocomplete#enable_auto_select = 1
""let g:neocomplete#disable_auto_complete = 1
""inoremap <expr><TAB>  pumvisible() ? "\<Down>" :
"" \ neocomplete#start_manual_complete()
"
"---------------------------------------------------------------
" key-mappings (neosnippet)
"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
 
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"---------------------------------------------------------------
" unite
"
let g:unite_enable_start_insert = 1
"let g:unite_split_rule = 'botright' " 下or右に開く
let g:unite_split_rule = 'topleft' " 上or左に開く

"---------------------------------------------------------------
" key-mappings (denite)
"
if !has('win32')
  noremap [denite] <Nop>
  nmap <C-l> [denite]
  nnoremap [denite]mt :<C-u>Denite file_mru -default-action=tabopen<CR>
  nmap <silent> [denite]o :<C-u>Denite outline<CR>
endif

"---------------------------------------------------------------
" key-mappings (unite)
"
"if v:version < 704 || has('win64')
  nmap <C-l> [unite]
  
  "nmap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  nmap <silent> [unite]o :<C-u>Unite -vertical -winwidth=40 outline<CR>
  "nmap <silent> [unite]b :<C-u>Unite buffer<CR>
  "nmap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
  
  " BOOKMARK
  "nmap <silent> [unite]c :<C-u>Unite bookmark<CR>
  "nmap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
  
  " most recently viewed files
  let g:unite_source_file_mru_limit = 5000
  "file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
  let g:unite_source_file_mru_filename_format = ''
  nmap <silent> [unite]mt :<C-u>Unite file_mru -default-action=tabopen<CR>
  nmap <silent> [unite]mv :<C-u>Unite file_mru -default-action=vsplit<CR>
  nmap <silent> [unite]ms :<C-u>Unite file_mru -default-action=split<CR>
  "nnoremap <leader>frt :Unite -quick-match file_mru -default-action=tabopen<CR>
  "nnoremap <leader>frh :Unite -quick-match file_mru -default-action=split<CR>
  "nnoremap <leader>frf :Unite -quick-match file_mru<CR>
  
  "" 現在編集中のファイルが所属するプロジェクトのトップディレクトリ
  "" (.git があったり Makefile があったり、configure があったりするディレクトリ)
  "" を起点に unite.vim で file_recして、プロジェクトのファイル一覧を出力
  "nmap <silent> [unite]p :<C-u>call <SID>unite_project('-start-insert')<CR>
  "function! s:unite_project(...)
  "  let opts = (a:0 ? join(a:000, ' ') : '')
  "  let dir = unite#util#path2project_directory(expand('%'))
  "  execute 'Unite' opts 'file_rec:' . dir
  "endfunction
  
  "uniteを開いている間のキーマッピング
  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
  
  	"ESCでuniteを終了
  	nmap <buffer> <ESC> <Plug>(unite_exit)
  
  	"入力モードのときjjでノーマルモードに移動
  	imap <buffer> jj <Plug>(unite_insert_leave)
  	imap <buffer> kk <Plug>(unite_insert_leave)
  
  	"入力モードのときctrl+wでバックスラッシュも削除
  	imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  
  	"ctrl+jで縦に分割して開く
  	nmap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  	inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  
  	"ctrl+lで横に分割して開く
  	nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  	inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  
  	"ctrl+oでその場所に開く
  	nmap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  	inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  
  endfunction
"endif

"---------------------------------------------------------------
" diffchar.vim (vimdiff)
"
" F7でトグル
" vimdiffで起動した際自動的に単語単位の差分(diffchar.vim)を有効
if &diff
  augroup enable_diffchar
    autocmd!
    autocmd VimEnter * execute "%SDChar"
  augroup END
endif

"Char" : 全ての文字間
"Word1" : \w\+ と隣接する \W の境目
"Word2" : 非空白文字と空白文字の境目
"Word3" : \< または \> に該当する境目。vimオプションiskeywordの影響あり
"逆に言えばiskeywordを設定している場合"Word3"を指定すると便利です。
"CSV(,)" : カンマ(,)、セミコロン(;)及びタブ文字(\t)による境目
let g:DiffUnit = "Word3"
"編集中に差分ハイライトを自動で更新するかどうか 0更新しない 1更新する
let g:DiffUpdate = 1

"---------------------------------------------------------------
" neomake.vim and esling (javascript check)
"
"
"autocmd! BufWritePost,BufEnter * Neomake
"let g:neomake_javascript_enabled_makers = ['eslint']

" When writing a buffer.
call neomake#configure#automake('w')
" When writing a buffer, and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing.
call neomake#configure#automake('rw', 1000)

"---------------------------------------------------------------
" neovim terminal emulator
"
if has('unix') && !has('gui_running')
  set sh=zsh
  " ESCでcommand modeにする
  tnoremap <silent> <ESC> <C-\><C-n>
endif

"---------------------------------------------------------------
" plantuml
"
let g:plantuml_executable_script = "$HOME/docker-plantuml/plantuml"

"---------------------------------------------------------------
" go
"
let g:go_bin_path = $GOPATH.'/bin'
filetype plugin indent on
