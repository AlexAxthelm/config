" Let's use filetypes
filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')

" plugin.filesystem 
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" plugin.ui 
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons' " A nice start screen for vimmhinz/vim-startifys
Plug 'mhinz/vim-startify' " A nice start screen for vim

" plugin.integration 
" Plug 'edkolev/tmuxline.vim'
" Plug 'edkolev/promptline.vim'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'shime/vim-livedown'

" plugin.motion 
" Deprecated!! Plug 'haya14busa/incsearch.vim'
" Plug 'osyo-manga/vim-anzu'

" plugin.utilities 
" Plug 'djoshea/vim-autoread'
Plug 'zef/vim-cycle'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary' "TODO: in vimfiles, if first char is comment, have gcc uncomment, regardless.
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-speeddating'
" Plug 'junegunn/vim-peekaboo'

" plugin.linter 
Plug 'w0rp/ale'

" plugin.prose 
Plug 'junegunn/goyo.vim'
Plug 'amix/vim-zenroom2'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'

" plugin.colorscheme 
Plug 'chriskempson/base16-vim'

" plugin.tk-unclassified 
" Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
" Plug 'myusuf3/numbers.vim'
" Plug 'kshenoy/vim-signature'
" Plug 'editorconfig/editorconfig-vim'
"
" plugin.completion 
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/neco-syntax'
" Plug 'fszymanski/deoplete-emoji'
" Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
" endif
" Plug 'zchee/deoplete-jedi'
" Plug 'SevereOverfl0w/deoplete-github'
" Plug 'zchee/deoplete-docker'
" Plug 'deathlyfrantic/deoplete-spell'
Plug 'wellle/tmux-complete.vim'
" " if g:os ==? 'Darwin'
" 				Plug 'thalesmello/webcomplete.vim'
" endif

" " plugin.language 
" 
" " plugin.language.tools 
Plug 'jpalardy/vim-slime'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 
 " plugin.language.json 
 Plug 'elzr/vim-json'
 
 " plugin.language.dockerfile 
 Plug 'ekalinin/Dockerfile.vim'
 
 " plugin.language.csv 
 Plug 'chrisbra/csv.vim'
 
 " plugin.language.tmux.conf 
 Plug 'tmux-plugins/vim-tmux'
 
 " plugin.language.toml 
 " Plug 'cespare/vim-toml'
 
 " " plugin.language.r 
 " Plug 'jalvesaq/Nvim-R'

" plugin.language.markdown 
" Plug 'rhysd/vim-gfm-syntax'
" Plug 'plasticboy/vim-markdown'
" Plug 'gabrielelana/vim-markdown'
" Plug 'kblin/vim-fountain'

" plugin.language.python 
" Plug 'vim-python/python-syntax'
" Plug 'tmhedberg/SimpylFold'
" Plug 'Vimjas/vim-python-pep8-indent'

" plugin.snippets 
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" " plugin.general.in-testing 
" Plug 'terryma/vim-smooth-scroll'
" Plug 'itchyny/vim-cursorword'
" Plug 'rhysd/committia.vim'
" Plug 'roxma/vim-tmux-clipboard'
" Plug 'tmux-plugins/vim-tmux-focus-events'
" Plug 'jiangmiao/auto-pairs'

" plugin.motion.in-testing 
Plug 'kana/vim-operator-user'
Plug 'haya14busa/vim-operator-flashy'

" plugin.objects.in-testing 
" Plug 'vim-utils/vim-space'

" plugin.filetypes.in-testing 
" Plug 'alcesleo/vim-uppercase-sql'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
" Plug 'severin-lemaignan/vim-minimap'
" Plug 'AndrewRadev/linediff.vim'

Plug 'stephpy/vim-yaml'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

Plug 'wellle/context.vim'

Plug 'github/copilot.vim'

call plug#end()

let mapleader = "\<Space>"

let g:ale_virtualtext_cursor = 'disabled'
let g:ale_set_loclist = 1
let g:ale_open_list = 1
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] [%linter%] %code: %%s'

" let g:ale_r_lintr_lint_package = 1

"  close loclist if it's the last window open
augroup MyGroup
  autocmd!
  if exists('##QuitPre')
    autocmd QuitPre * if &filetype != 'qf' | silent! lclose | endif
  endif
augroup END

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" I like two char tabstops
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

"" prevent window repositioning on open new tab by always having tabline
set showtabline=2

" " Use deoplete.
" let g:deoplete#enable_at_startup = 1
" let g:tmuxcomplete#trigger = ''
" call deoplete#custom#option({
"       \ 'auto_complete_delay': 50,
"       \ 'smart_case': v:true,
"       \ })

autocmd FileType gitcommit setlocal spell

" " Use <tab> for deoplete completion: https://github.com/Shougo/deoplete.nvim/issues/432
" inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<tab>"
" inoremap <expr> <S-tab> pumvisible() ? "\<C-p>" : "\<S-tab>"
" " Use Enter to choose a completion
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" " Keep a option selected at all times.
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set showcmd		" display incomplete commands
set linebreak		" break at whole words --Alex

set cursorline " highlight currentline
set lazyredraw " don't redraw during macros, etc.

set foldenable
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

" highlight last inserted text
nnoremap gV `[v`]

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
" map a double semi-colon to the escape function
inoremap ;; <Esc>

"" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
        set mouse=a
endif

"" " relative numbering
set number relativenumber

"" Set column 80 to be a different color
set colorcolumn=80

set termguicolors

" "" Set colorscheme
" if exists('$BASE16_THEME')
"       \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
"   set background=dark
"   let base16colorspace=256
"   colorscheme base16-$BASE16_THEME
" endif
colorscheme base16-solarized-light

"" Set default register to the clipboard
set clipboard^=unnamed

"" Switch syntax highlighting on, when the terminal has colors
syntax on

" Have True Color work in tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"" set W as well as w to write
command! W  w
command! Q  q
command! Wq  wq
command! WQ  wq

" Limelight Settings
let g:limelight_conceal_ctermfg = 'gray'

" Goyo Settings 

" goyo_enter() 
function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
	let b:quitting = 0
  let b:quitting_bang = 0
  augroup goyo-really-quit
    au!
    autocmd QuitPre <buffer> let b:quitting = 1
  augroup END
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!set noshowmode
  setlocal noshowcmd
  setlocal scrolloff=999
	setlocal nospell
  Limelight
	PencilSoft
	ALEDisable
  " ...
endfunction

" goyo_leave() 
function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
   if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
  setlocal showmode
  setlocal showcmd
  setlocal scrolloff=5
	setlocal spell
  Limelight!
	PencilOff
	ALEEnable
  " ...
endfunction

" Goyo augroup 
augroup goyo-enter-leave
	au!
	autocmd User GoyoEnter nested call <SID>goyo_enter()
	autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

" enable indent guides
let g:indent_guides_enable_on_vim_startup = 1

" vim-cycle settings
augroup vim-cycle-define
	au!
	au VimEnter * call AddCycleGroup(['TRUE', 'FALSE'])
	au VimEnter * call AddCycleGroup(['True', 'False'])
	au VimEnter * call AddCycleGroup(['set', 'get'])
	au VimEnter * call AddCycleGroup(['form', 'to'])
	au VimEnter * call AddCycleGroup(['push', 'pop'])
	au VimEnter * call AddCycleGroup(['mas', 'menos'])
	au VimEnter * call AddCycleGroup(['prev', 'next'])
	au VimEnter * call AddCycleGroup(['start', 'end'])
	au VimEnter * call AddCycleGroup(['light', 'dark'])
	au VimEnter * call AddCycleGroup(['open', 'close'])
	au VimEnter * call AddCycleGroup(['read', 'write'])
	au VimEnter * call AddCycleGroup(['truthy', 'falsy'])
	au VimEnter * call AddCycleGroup(['filter', 'reject'])
	au VimEnter * call AddCycleGroup(['internal', 'external'])
	au VimEnter * call AddCycleGroup(['short', 'normal', 'long'])
	au VimEnter * call AddCycleGroup(['subscribe', 'unsubscribe'])
	au VimEnter * call AddCycleGroup(['header', 'body', 'footer'])
	au VimEnter * call AddCycleGroup(['protected', 'private', 'public'])
	au VimEnter * call AddCycleGroup(['red', 'blue', 'green', 'yellow'])
	au VimEnter * call AddCycleGroup(['tiny', 'small', 'medium', 'big', 'huge'])
	au VimEnter * call AddCycleGroup(['pico', 'nano', 'micro', 'mili', 'kilo', 'mega', 'giga', 'tera', 'peta'])
	au VimEnter * call AddCycleGroup(['sunday', 'monday', 'tuesday', 'wensday', 'thursday', 'friday', 'saturday'])
augroup END

" prefer vertical orientation when using :diffsplit
set diffopt+=vertical

" vim-slime Settings
let g:slime_target = 'tmux'
let g:slime_paste_file = '/tmp/slime_paste'
" let g:slime_python_ipython = 0
" let g:slime_dispatch_ipython_pause = 100
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "{right-of}"}

" " edgemotion
" map <C-j> <Plug>(edgemotion-j)
" map <C-k> <Plug>(edgemotion-k)

" vim-operator-flashy
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" Settings for plugin.motion.haya14busa/vim-easyoperator-line // DEFAULT
" Settings for plugin.motion.haya14busa/vim-easyoperator-phrase // DEFAULT
" " Settings for plugin.motion.haya14busa/incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)
" " Eliminate need for `:noh`
" set hlsearch
" let g:incsearch#auto_nohlsearch = 1
" map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
" map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
" map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
" map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)

" map z*  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
" map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
" map z#  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
" map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)
" " Settings for plugin.motion.haya14busa/incsearch-easymotion.vim
" map z/ <Plug>(incsearch-easymotion-/)
" map zg/ <Plug>(incsearch-easymotion-stay)
" " Settings for plugin.motion.motion.osyo-manga/vim-anzu
" " (Alongside incsearch)
" map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
" map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

" Settings for Plugin: haya14busa/vim-asterisk
let g:asterisk#keeppos = 1

" TODO: put this somewhere
" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" coc.nvim settings
" see: https://blog.ffff.lt/posts/ale-deoplete-languageclient-vs-coc/
let g:coc_global_extensions = [
\ '@yaegassy/coc-marksman',
\ 'coc-browser',
\ 'coc-conventional',
\ 'coc-dash-complete',
\ 'coc-diagnostic',
\ 'coc-dictionary',
\ 'coc-docker',
\ 'coc-dot-complete',
\ 'coc-emoji',
\ 'coc-git',
\ 'coc-gitignore',
\ 'coc-highlight',
\ 'coc-html',
\ 'coc-json',
\ 'coc-just-complete',
\ 'coc-markdown-preview-enhanced',
\ 'coc-markdownlint',
\ 'coc-nav',
\ 'coc-pairs',
\ 'coc-prettier',
\ 'coc-python',
\ 'coc-r-lsp',
\ 'coc-sh',
\ 'coc-snippets',
\ 'coc-sql',
\ 'coc-sqlfluff',
\ 'coc-stylelint',
\ 'coc-symbol-line',
\ 'coc-tabnine',
\ 'coc-texlab', 
\ 'coc-toml',
\ 'coc-vimlsp',
\ 'coc-webview', 
\ 'coc-yaml',
\ 'coc-yank'
\ ]

" Disable ALE LSP in favor of coc.nvim
let g:ale_disable_lsp = 1

" use <Leader>j.k to move between diagnostics
nmap <silent> <Leader>j <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev)

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" TODO: coc-symbol-line add to statusline/tabline
" TODO: explore lualine
