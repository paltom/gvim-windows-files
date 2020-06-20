scriptversion 3

function! edit#insert_mode_put()
  let keys = "\<esc>g"
  if col(".") == 1
    let keys ..= "P"
  else
    let keys ..= "p"
  endif
  if col(".") == col("$")
    let keys ..= "a"
  else
    let keys ..= "i"
  endif
  return keys
endfunction
