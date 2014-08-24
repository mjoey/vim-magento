" File    : magento.vim
" Author  : Michael Joseph
" Website : michael-joseph.me
" Contact : vim@michael-joseph.me
" Version : 0.9.0
" License : GNU Affero GPL v3.0

"Include Magento abrevation
let s:install_dir = expand("<sfile>:p:h")

let g:separator = '/'

if has('win32')
    let g:separator = '\\'
endif

execute 'source '. g:separator . s:install_dir . g:separator .'ab.vim'

"declare Magento command
if !exists(':Magento')
    command -nargs=0 Magento call MagentoMenu()
endif

let g:magento=0
let action=""

func! MagentoMenu()
    if !exists('g:vimMagentoLicense')
        let g:vimMagentoLicense="GPL 3.0 http://www.gnu.org/licenses/gpl-3.0.txt"
    endif
    if !exists('g:vimMagentoSignature')
        let g:vimMagentoSignature=1
    endif
    if exists('g:vimMagentoPackage') && exists('g:vimMagentoName') 
        echom "[Magento VIM] Choose your Action"
        echom "Choose your Action"
        echom "s : select/create extension"
        echom "b : create block"
        echom "e : create entity"
        echom "c : create controller"
        echom "o : create observer"
        echom "g : create grid (this feature is coming soon)"
        echom "su: create setup (this feature is coming soon)"
        let action = input('Action: ')
        if action == "s"
            unlet g:vimMagentoPackage
            unlet g:vimMagentoName
            call magento#CreateModule()
        endif
        if action == "b"
            call magento#CreateBlock()
        endif
"        if action == "su"
"            call magento#CreateSetup()
"        endif
        if action == "e"
            call magento#CreateEntity()
        endif
        if action == "c"
            call magento#CreateController()
        endif
        if action == "o"
            call magento#CreateObserver()
        endif
    else
        call magento#CreateModule()
    endif
    let g:magento = 1
endfunc
