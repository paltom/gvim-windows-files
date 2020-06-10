scriptversion 3

let s:git_command = "git --git-dir=%s --work-tree=%s %s"

function! s:git_command(command)
  let git_root_dir = func#call_if_exists("", "FugitiveGitDir", [])
  if fnamemodify(git_root_dir, ":t") =~# ".git"
    let git_root_dir = fnamemodify(git_root_dir, ":h")
  endif
  if empty(git_root_dir)
    return []
  endif
  let git_command = printf(s:git_command,
        \ expand(git_root_dir.."/.git"),
        \ git_root_dir,
        \ a:command,
        \)
  return systemlist(git_command)
        \->map({_, line -> trim(line)})
endfunction

if exists("*fzf#run") && exists("*fzf#wrap") && exists(":Git") == 2
  function! GitBranches()
    let dict = #{
          \ source: <sid>git_command("branch -a")
            \->filter({_, branch -> !empty(branch)})
            \->filter({_, branch -> branch !~# '\v^\s*remotes/.{-}/HEAD\s+-\>\s+'})
          \}
    function! dict.sink(lines)
      if a:lines !~# '\v^\s*\*'
        let branch_name = matchstr(a:lines, '\v^\s*remotes/.{-}/\zs.*\ze$')
        execute "Git checkout "..branch_name
      endif
    endfunction
    call fzf#run(fzf#wrap(dict))
  endfunction

  command! GitBranches call GitBranches()
endif
