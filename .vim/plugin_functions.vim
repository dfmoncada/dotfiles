" vim:ft=vim

" undo tree
let g:undotree_HighlightChangedText=0
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=2
let g:undotree_DiffCommand='diff -u'

function! plugin_functions#attempt_select_last_file() abort
  let l:previous=expand('#:t')
  if l:previous !=# ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

