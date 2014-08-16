" File:          magento.vim
" Author:        Michael Joseph
" Website:       michael-joseph.me
" Contact:	 vim@michael-joseph.me
" Version:       0.1.3

"Include Magento abrevation
let s:install_dir = expand("<sfile>:p:h")
execute 'source /' . s:install_dir . '/ab.vim'

"declare Magento command
if !exists(':Magento')
    command -nargs=0 Magento call MagentoMenu()
endif

let g:magento = 0
let action=""

func! MagentoMenu()
    if exists('g:package') && exists('g:name') 
        echom "[Magento VIM] Choose your Action"
        echom "Choose your Action"
        echom "s : select/create extension"
        echom "b : create block"
        echom "c : create controller"
        echom "e : create entity (this feature is coming soon)"
        echom "g : create grid (this feature is coming soon)"
        echom "su: create setup (this feature is coming soon)"
        let action = input('Action: ')
        if action == "s"
            call magento#CreateModule()
        endif
        if action == "b"
            call magento#CreateBlock()
        endif
"        if action == "su"
"            call magento#CreateSetup()
"        endif
"        if action == "e"
"            call magento#CreateEntity()
"        endif
        if action == "c"
            call magento#CreateController()
        endif
    else
        call magento#CreateModule()
    endif
    let g:magento = 1
endfunc
