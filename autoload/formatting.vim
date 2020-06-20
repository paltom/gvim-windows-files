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

function! formatting#remove_trail_space()
  if g:autoremove_trail_space
    try
      %s/\v\s+$//
      normal! ``
    catch /E486:/
    endtry
  endif
endfunction
