"============================================================================
"File:        coffee.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Lincoln Stoll <l@lds.li>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
"
" Note: this script requires CoffeeScript version 1.6.2 or newer.
"
if exists("g:loaded_syntastic_coffee_coffee_checker")
    finish
endif
let g:loaded_syntastic_coffee_coffee_checker=1

function! SyntaxCheckers_coffee_coffee_IsAvailable() dict
    let exe = self.getExec()
    return executable(exe) &&
        \ syntastic#util#versionIsAtLeast(syntastic#util#getVersion(exe . ' --version 2>' . syntastic#util#DevNull()), [1,6,2])
endfunction

function! SyntaxCheckers_coffee_coffee_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args': '-cp' })

    let errorformat =
        \ '%E%f:%l:%c: %trror: %m,' .
        \ 'Syntax%trror: In %f\, %m on line %l,' .
        \ '%EError: In %f\, Parse error on line %l: %m,' .
        \ '%EError: In %f\, %m on line %l,' .
        \ '%W%f(%l): lint warning: %m,' .
        \ '%W%f(%l): warning: %m,' .
        \ '%E%f(%l): SyntaxError: %m,' .
        \ '%-Z%p^,' .
        \ '%-G%.%#'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'coffee',
    \ 'name': 'coffee'})
