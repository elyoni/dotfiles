function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir))
endfunction

function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')

    exe 'source' s:fpath
  endfor
endfunction


