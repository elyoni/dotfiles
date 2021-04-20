function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir))
endfunction

function! PlugHasDir(name)
    return (
        \ isdirectory(g:plugs[a:name].dir))
endfunction

function! PlugLoadedTest(name)
    if PlugLoaded(a:name)
        echo "Plugin Was found"
    else
        echo "Plugin Wasn't found"
    endif

endfunction

function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')

    exe 'source' s:fpath
  endfor
endfunction


