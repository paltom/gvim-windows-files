scriptversion 3

function! formatting#empty_lines(count, above)
  let current_position = getcurpos()
  let new_position = [current_position[1], current_position[4]]
  let line_to_insert = new_position[0]
  if a:above
    let line_to_insert = new_position[0] - 1
    let new_position[0] += a:count
  endif
  call append(line_to_insert, repeat([""], a:count))
  call cursor(new_position)
endfunction

function! formatting#insert_mode_put()
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
