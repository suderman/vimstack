" Load pathogen and remove .vim from the runtime path
runtime! autoload/pathogen.vim
let &rtp = substitute(&rtp, $HOME."/.vim", $HOME."/.vim_disabled", "g")

" Load the inherited, current and local stack
call pathogen#infect($HOME.'/.vim/current/.inherited/.bundle')
call pathogen#infect($HOME.'/.vim/current/.bundle')
call pathogen#infect($HOME.'/.vim/local/.bundle')
syntax on
filetype plugin indent on

function! s:Source(path)
  let l:listing = system('ls -1Ap '. a:path .' | grep -v /\$')
  let l:files = split(l:listing, '\n')
  for l:file in l:files
    exec 'silent! source ' . l:file
  endfor
endfunction

" Source inherited vimrc.vim, *.vim, bundle/*.vim
" set runtimepath+=$HOME.'/.vim/current/.stack'
call s:Source($HOME.'/.vim/current/.stack/vimrc.vim')
call s:Source($HOME.'/.vim/current/.stack/*.vim')
call s:Source($HOME.'/.vim/current/.stack/bundle/*.vim')

" Source current vimrc.vim, *.vim, bundle/*.vim
" set runtimepath+=$HOME.'/.vim/current'
call s:Source($HOME.'/.vim/current/vimrc.vim')
call s:Source($HOME.'/.vim/current/*.vim')
call s:Source($HOME.'/.vim/current/bundle/*.vim')

" Source local vimrc.vim, *.vim, bundle/*.vim
" set runtimepath+=$HOME.'/.vim/local'
call s:Source($HOME.'/.vim/local/vimrc.vim')
call s:Source($HOME.'/.vim/local/*.vim')
call s:Source($HOME.'/.vim/local/bundle/*.vim')

