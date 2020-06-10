scriptversion 3

set guioptions+=M
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

filetype plugin indent on
set encoding=utf-8

" Shell {{{
set shell=bash
set shellcmdflag=-c
set shellxquote=\"
set shellslash
set belloff=all
" }}}

" Misc {{{
let g:sneak#label = v:true

let g:pear_tree_ft_disabled = [
      \ "vim",
      \]
let g:pear_tree_repeatable_expand = v:false
let g:pear_tree_smart_openers = v:true
let g:pear_tree_smart_closers = v:true
let g:pear_tree_smart_backspace = v:true

inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
noremap H ^
noremap L $

set more
set updatetime=100
" }}}

" Searching {{{
set ignorecase
set smartcase
set incsearch
augroup highlight_while_searching_only
  autocmd!
  set nohlsearch
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup end
vnoremap / y/<c-r>"<cr>
vnoremap g/ /

let g:fzf_layout = #{window: "botright 12 split"}
let g:fzf_action = {
      \ "ctrl-t": "tab split",
      \ "ctrl-s": "split",
      \ "ctrl-v": "vsplit",
      \}
let g:fzf_colors = {
      \ "fg+": ["fg", "fzfblue"],
      \ "hl+": ["fg", "fzfgreen"],
      \ "prompt": ["fg", "fzfmagenta"],
      \}
" }}}

" Formatting {{{
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent
set smartindent

nnoremap <silent> [<space> :<c-u>call formatting#empty_lines(v:count1, v:true)<cr>
nnoremap <silent> ]<space> :<c-u>call formatting#empty_lines(v:count1, v:false)<cr>

augroup auto_tab_replacement
  autocmd!
  let g:autoretab = v:true
  autocmd BufWrite * if g:autoretab | retab | endif
augroup end
augroup auto_remove_trail_space
  autocmd!
  let g:autoremove_trail_space = v:true
  autocmd BufWrite * if g:autoremove_trail_space | %s/\v\s+$//e | endif
augroup end
" }}}

" Theme {{{
set number
set relativenumber
set numberwidth=5
set signcolumn=yes
let g:signify_sign_change = '~'

syntax on
set background=light
augroup highlight_tweaks
  autocmd!
  autocmd ColorScheme * call colors#update_highlights()
augroup end
colorscheme solarized

set laststatus=2

set nowrap
set scrolloff=3
set sidescroll=1
set sidescrolloff=10
let &listchars   = "tab:\u00bb\ "
let &listchars ..= ",trail:\u2423"
let &listchars ..= ",precedes:\u27ea"
let &listchars ..= ",extends:\u27eb"
set list

augroup colorcolumn
  autocmd!
  autocmd BufNewFile,BufRead,BufWinEnter,WinEnter * let &l:colorcolumn = "80,"..join(range(120, 999), ",")
  autocmd WinLeave * let &l:colorcolumn = join(range(1, 999), ",")
augroup end
augroup cursorline
  autocmd!
  autocmd VimEnter * setlocal cursorline
  autocmd BufNewFile,BufRead,BufWinEnter,WinEnter * if &diff | setlocal nocursorline | else | setlocal cursorline | endif
  autocmd OptionSet diff if v:option_new | setlocal nocursorline | else | setlocal cursorline | endif
  autocmd WinLeave * setlocal nocursorline
augroup end

let g:virtualenv_stl_format = '(%n)'
function! Statusline()
  let stl   = "%#stl1#"
  let stl ..= "%(%{func#call_if_exists('', 'virtualenv#statusline', [])} %)"
  let stl ..= "%{statusline#cwd()} "
  let stl ..= "%#stl5#"
  let stl ..= "%( (%{func#call_if_exists('', 'FugitiveHead', [8])})%{func#call_if_exists('', 'sy#repo#get_stats_decorated', [])}%)"
  let stl ..= "%#stl2# "
  let stl ..= "%{statusline#filename()} %m%r"
  let stl ..= "%*"
  let stl ..= "%="
  let stl ..= "%( $[%{func#call_if_exists('', 'xolox#session#find_current_session', [])}] %)"
  let stl ..= "%(%#stl3#%{statusline#lsp_server()==1?'o':''}%#stl4#%{statusline#lsp_server()==2?'x':''}%* %)"
  let stl ..= "\u2261%p%%"
  return stl
endfunction
function! StatuslineNC()
  let stl   = "%{statusline#cwd()} "
  let stl ..= " "
  let stl ..= "%{statusline#filename()} %m%r"
  let stl ..= "%*"
  let stl ..= "%="
  return stl
endfunction
setlocal statusline=%!Statusline()
augroup statusline
  autocmd!
  autocmd WinEnter,BufWinEnter * setlocal statusline=%!Statusline()
  autocmd WinLeave * setlocal statusline=%!StatuslineNC()
augroup end
" }}}

" GUI settings {{{
set lines=100
set columns=500

set guioptions-=T
set guioptions-=m
set guioptions-=e
set guioptions-=L
set guioptions-=l
set guioptions-=r
set guioptions-=R
set guioptions+=c
set guioptions+=!
set guifont=Hack:h12:cEASTEUROPE:qDRAFT
set clipboard+=unnamed
inoremap <expr> <c-v> formatting#insert_mode_put()
inoremap <c-g><c-v> <c-v>
" }}}

" Complete {{{
imap <c-space> <Plug>(asyncomplete_force_refresh)
" }}}

" LSP {{{
if executable("pyls")
  au User lsp_setup call lsp#register_server(#{
      \ name: "pyls",
        \ cmd: {server_info -> ["pyls"]},
        \ whitelist: ["python"],
        \})
endif
" }}}

" Sessions {{{
set sessionoptions-=help
set sessionoptions+=resize
set sessionoptions+=winpos
let g:session_autoload = "no"
let g:session_autosave = "yes"
let g:session_default_to_last = 1
" }}}

" vim:foldmethod=marker
