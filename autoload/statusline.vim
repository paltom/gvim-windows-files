scriptversion 3

function! statusline#cwd()
  return pathshorten(fnamemodify(getcwd(), ":p")[:-2])
endfunction

function! s:relative_path(path, basepath)
  let full_basepath = fnamemodify(a:basepath, ":p")
  let relative_path = matchstr(a:path, '\v'..full_basepath..'\zs.*$')
  if empty(relative_path)
    return a:path
  else
    return relative_path
  endif
endfunction

let s:git_type_to_name = #{
      \ 0: "index",
      \ 2: "current",
      \ 3: "incoming"
      \}
function! statusline#filename()
  let bufname = bufname()
  let filename = fnamemodify(bufname, ":t")
  " Handle special cases
  if getbufvar(bufname, "&filetype") ==# "help"
    return filename
  endif
  let full_bufname = fnamemodify(bufname, ":p")
  if full_bufname =~# '\v^fugitive:'..expand("/")..'{2,}'
    let git_buf_type = matchstr(full_bufname,
          \ '\v'..escape('.git'..expand("/") , '\.')..'{2}\zs\x+\ze')
    if !empty(git_buf_type)
      let git_type_name = get(s:git_type_to_name, git_buf_type, "("..git_buf_type[:7]..")")
      return filename.." @ "..git_type_name
    endif
  endif
  " XXX: add special cases here
  " Handle buffer not associated with file
  if empty(filename)
    return "[No Name]"
  endif
  " Basic case
  let relative_dir = full_bufname
        \->s:relative_path(getcwd())
        \->fnamemodify(":h")
  if relative_dir ==# "."
    return filename
  else
    return expand(join([pathshorten(relative_dir), filename] , "/"))
  endif
endfunction

function! statusline#lsp_server()
  let filetype = getbufvar(bufname(), "&filetype")
  let servers = func#call_if_exists([], 'lsp#get_whitelisted_servers', [filetype])
  if empty(servers)
    return 0
  endif
  let statuses = servers->map({_, name -> func#call_if_exists('', 'lsp#get_server_status', [name])})
  for status in statuses
    if status !=# 'running'
      return 2
    endif
  endfor
  return 1
endfunction
