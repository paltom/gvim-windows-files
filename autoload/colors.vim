scriptversion 3

function! colors#update_highlights()
  highlight! link SignColumn LineNr
  highlight stl1 guifg=#719e07 gui=reverse,bold
  highlight stl2 guifg=#269bd2
  execute "highlight stl3 guifg=#719e07 gui=bold guibg="..
        \synIDattr(synIDtrans(hlID("StatusLine")), "fg", "gui")
  execute "highlight stl4 guifg=#dc322f gui=bold guibg="..
        \synIDattr(synIDtrans(hlID("StatusLine")), "fg", "gui")
  highlight stl5 guifg=#2aa198 gui=bold
  highlight fzfgreen ctermfg=2 ctermbg=2
  highlight fzfmagenta ctermfg=5 ctermbg=5
  highlight fzfblue ctermfg=4 ctermbg=4
endfunction
