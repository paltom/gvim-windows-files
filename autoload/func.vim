scriptversion 3

function! func#call_if_exists(default, func_name, args)
  if !exists("*"..a:func_name)
    return a:default
  endif
  return call(a:func_name, a:args)
endfunction
