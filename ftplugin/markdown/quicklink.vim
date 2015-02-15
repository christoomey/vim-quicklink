function! ConvertVisualSelectionToLink(...)
  if a:0 == 0
    normal gv"vy
    call s:SearchForTerm()
    return
  else
    let url = a:1
  endif
  normal gv
  normal mm
  execute 'normal! "lc[l][]'
  let current_line = line('.')
  let markdown_h2_pattern = '\v^(\w+.*\n-+|#{2,3}\s+\w+)'
  let next_match_line = search(markdown_h2_pattern)
  if next_match_line == 0 || next_match_line < current_line
    let target_line = line('$')
  else
    let target_line = next_match_line - 2
  endif
  let formatted_link = '[' . @l . ']: ' . url
  call append(target_line, formatted_link)
  call s:EnsureLineAbove(target_line)
  normal `m
endfunction

function! s:SearchForTerm()
  let search_prompt = "Search term (leave blank to use clipboard): "
  echohl String | let term = input(search_prompt, @v) | echohl None
  if term == ''
    call ConvertVisualSelectionToLink(system('pbpaste'))
    return
  endif
  let encoded_term = webapi#http#encodeURI(term)
  let api_url = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&filter=1&rsz=small&q='
  let request_url = api_url . encoded_term
  let response = webapi#http#get(request_url)
  let content = webapi#json#decode(response.content)
  let results = content.responseData.results
  call s:DisplaySearchResults(results)
endfunction

function! s:DisplaySearchResults(results)
  let g:search_results = a:results
  let map_expression = '[v:val.url, "  -> " .v:val.titleNoFormatting, ""]'
  let formatted = s:Flatten(map(copy(a:results), map_expression))
  silent pedit search-results
  wincmd P
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nowrap
  nnoremap <buffer> q :q!<cr>
  nnoremap <buffer> <cr> :call SelectSearchResult()<cr>
  nnoremap <buffer> <C-o> :call OpenLinkOnCurrentLine()<cr>
  nnoremap <buffer> <C-n> 2j
  nnoremap <buffer> <C-p> 2k
  nnoremap <buffer> <tab> :call search('^\S')<cr>:noh<cr>
  nnoremap <buffer> <S-tab> :call search('^\S', 'b')<cr>:noh<cr>
  nnoremap <buffer> o :call OpenLinkOnCurrentLine()<cr>
  normal ggdG
  call append(0, formatted)
  normal ddgg
endfunction

function! s:EnsureLineAbove(target_line)
  if !s:ContentsAreEmptyOrLink(getline(a:target_line))
    call append(a:target_line, '')
  endif
endfunction

function! s:ContentsAreEmptyOrLink(contents)
  let contents_are_link = match(a:contents, '\v\[.*\]:\s')
  return (a:contents == '') || (contents_are_link != -1)
endfunction

function! s:Flatten(list)
  let val = []
  for elem in a:list
    if type(elem) == type([])
      call extend(val, s:Flatten(elem))
    else
      call add(val, elem)
    endif
    unlet elem
  endfor
  return val
endfunction

function! SelectSearchResult()
  let selected = g:search_results[line('.') / 3].url
  bdelete
  call ConvertVisualSelectionToLink(selected)
endfunction

function! OpenLinkOnCurrentLine()
  call system('open ' . expand('<cWORD>'))
endfunction

vnoremap <C-k> :call ConvertVisualSelectionToLink()<cr>