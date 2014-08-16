" File:          magento.vim
" Author:        Michael Joseph
" Website:       michael-joseph.me
" Contact:     vim@michael-joseph.me
" Version:       0.1.3

let s:install_dir = expand("<sfile>:p:h")

func! magento#ucfirst(word)
    let ucfirst = tolower(a:word)
    return substitute(ucfirst, '^.', '\U\0', '')
endfunc

func! magento#ucBeforeUnderscore(string)
    let ucfirst = magento#ucfirst(a:string)
    return substitute(ucfirst, '_.', '\U\0', 'g')
endfunc

func! magento#deleteFirstLine()
    "delete first line
    execute ":1:d"
endfunc

func! magento#escapeSlash(string)
     return substitute(a:string,'/','\\/','g')
endfunc
func! magento#CComment(fileType)
    execute "/<?".a:fileType
    execute ":r ".s:install_dir."/magento/pattern/comment/".a:fileType.".tpl"
    call magento#CReplace()
    execute ":w"
endfunc

func! magento#CReplace()
    execute ":%s/{package}/".magento#escapeSlash(g:package)."_".g:name."/g"
    execute ":%s/{category}/".magento#escapeSlash(g:package)."/g"
    execute ":%s/{author}/".magento#escapeSlash(g:author)."/g"
    execute ":%s/{copyright}/".magento#escapeSlash(g:copyright)."/g"
    execute ":%s/{license}/".magento#escapeSlash(g:license)."/g"
endfunc

func! magento#AddNode(file,path,node,value,origfile)
    let @x=system("xmlstarlet ed -s /".a:path." -t elem -n ".a:node." -v '".a:value."' ".a:origfile." | xmlstarlet fo -s 4")
    call system("rm -rf ".a:file)
    execute ":split ".a:file
    execute ":pu x"
    call magento#deleteFirstLine()
    execute ":wq"
endfunc

func! magento#ExistingNode(file,path)
   let x=system("xmlstarlet sel -t -v 'count(".a:path.")' ". a:file)
   if (x==0)
       return 0
   else
       return 1
   endif
endfunc

func! magento#CreateModule()
    if !exists('g:package') || !exists('g:name')
        echom "Wich module do you want to update or create ?"
        let g:separator = '/'
        if has('win32')
            let g:separator = '\\'
        endif

        "pool
        let poolFlag = 0
        while poolFlag==0
            let pool = input('Pool Name? Local (l) or Community (c): ')
            if pool == "l"
                let pool = "local"
                let poolFlag = 1
            elseif pool == "c"
                let pool = "community"
                let poolFlag = 1
            endif
        endwhile
        echom " "

        "package
        let g:package=""
        while g:package == ""
            let g:package = input('Package name: ')
            let g:lpackage = tolower(g:package)
            let g:package = magento#ucfirst(g:package)
            echom " "
        endwhile

        "extension
        let g:name=""
        while g:name == ""
            let g:name = input('Extension name: ')
            let g:lname = tolower(g:name)
            let g:name = magento#ucfirst(g:name)
            let g:ccom = expand(":Ccom")
            echom " "
        endwhile

        "details
        echom " "
        echom "[Pool Name]: ".pool
        echom "[Package Name]: ".g:package
        echom "[Extension Name]: ".g:name
        let g:path = "app".g:separator."code".g:separator.pool.g:separator.g:package
        let g:declarationXml = "app".g:separator."etc".g:separator."modules".g:separator.g:package."_".g:name.".xml"
        let g:configXml = g:path.g:separator.g:name.g:separator."etc".g:separator."config.xml"
        echom "Module Path: ".g:path 

        if !filereadable(g:path.g:separator.g:name.g:separator."etc".g:separator."config.xml")
            if !isdirectory("app".g:separator."etc".g:separator."modules")
                call system("mkdir -p app".g:separator."etc".g:separator."modules")
            endif

            call system("touch ".g:declarationXml)
            call magento#AddNode(g:declarationXml,"config/modules",g:package."_".g:name,"",s:install_dir."/magento/pattern/module.xml")
            call magento#AddNode(g:declarationXml,"config/modules/".g:package."_".g:name,"active","true",g:declarationXml)
            call magento#AddNode(g:declarationXml,"config/modules/".g:package."_".g:name,"codePool",pool,g:declarationXml)
            execute ":split ".g:declarationXml
            call magento#CComment("xml")

            call system("mkdir -p ".g:path.g:separator.g:name.g:separator."etc")
            call system("mkdir -p ".g:path.g:separator.g:name.g:separator."Block")
            call system("mkdir -p ".g:path.g:separator.g:name.g:separator."Helper")

            "create config xml
            call system("touch ".g:configXml)
            call magento#AddNode(g:configXml,"config/modules",g:package."_".g:name,"",s:install_dir."/magento/pattern/config.xml")
            call magento#AddNode(g:configXml,"config/modules/".g:package."_".g:name,"version","1.0.0",g:configXml)
            call magento#AddNode(g:configXml,"config/global","helpers","",g:configXml)
            call magento#AddNode(g:configXml,"config/global/helpers",g:lpackage."_".g:lname,"",g:configXml)
            call magento#AddNode(g:configXml,"config/global/helpers/".g:lpackage."_".g:lname,"class",g:package."_".g:name."_Helper",g:configXml)
            execute ":split ".g:configXml
            call magento#CComment("xml")

            "create helper file
            call system("touch ".g:path.g:separator.g:name."/Helper".g:separator."Data.php")
            execute ":split ".g:path.g:separator.g:name."/Helper".g:separator."Data.php"
            execute ":r ".s:install_dir."/magento/pattern/Helper.php"
            call magento#deleteFirstLine()
            execute "/<?php"
            call magento#CComment("php")
            call magento#deleteFirstLine()
            execute ":w"

        endif
    endif
endfunc

func! magento#CreateController()
    let controllerName = magento#ucfirst(input('Controller name: '))

    if controllerName==""
        let controllerName = "Index"
    endif

    if !isdirectory(g:path.g:separator.g:name.g:separator."controllers")
        call system("mkdir -p ".g:path.g:separator.g:name.g:separator."controllers")
    endif
    call system("touch ".g:path.g:separator.g:name.g:separator.'controllers'.g:separator.controllerName."Controller.php")
    execute ":split ".g:path.g:separator.g:name.g:separator.'controllers'.g:separator.controllerName."Controller.php"
    execute ":r ".s:install_dir."/magento/pattern/Controller.php"
    execute ":%s/{package}_{modulename}_{controllername}/".g:package."_".g:name."_".controllerName."/g"
    call magento#deleteFirstLine()
    call magento#CComment('php')
    call magento#deleteFirstLine()
    execute ":w"
    execute ":split ".g:configXml

    "verify if frontend node exists
    let frontendNode = magento#ExistingNode(g:configXml,"config/frontend")
    if frontendNode==0
        call magento#AddNode(g:configXml,"config","frontend","",g:configXml)
    endif
    let routersNode = magento#ExistingNode(g:configXml,"config/frontend/routers")

    "verify if routers node exists
    if routersNode==0
        call magento#AddNode(g:configXml,"config/frontend","routers","",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers",g:lpackage."_".g:lname,"",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:lpackage."_".g:lname,"use","standard",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:lpackage."_".g:lname,"args","",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:lpackage."_".g:lname."/args","module",g:package."_".g:name,g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:lpackage."_".g:lname."/args","frontName",g:lname,g:configXml)
    endif
endfunc

func! magento#CreateBlock()
    let block = magento#ucBeforeUnderscore(input('Block Name: '))
    if !isdirectory(g:path.g:separator.g:name.g:separator."Block")
        call system("mkdir -p ".g:path.g:separator.g:name.g:separator."Block")
    endif
    "create subfolder
    let blockList = split(block,'_')
    "create block sub folder
    if(len(blockList)>1)
        call remove(blockList,len(blockList)-1)
        if !isdirectory(g:path.g:separator.g:name.g:separator."Block".g:separator.join(blockList,g:separator))
            call system("mkdir -p ".g:path.g:separator.g:name.g:separator."Block".g:separator.join(blockList,g:separator))
        endif
    endif
    call system("touch ".g:path.g:separator.g:name.g:separator."Block".g:separator.block.".php")
    execute ":split ".g:path.g:separator.g:name.g:separator."Block".g:separator.join(split(block,'_'),g:separator).".php"
    execute ":r ".s:install_dir."/magento/pattern/Block.php"
    execute ":%s/{block}/".block."/g"
    call magento#deleteFirstLine()
    call magento#CComment("php")
    call magento#deleteFirstLine()
    execute ":w"
    execute ":split ".g:configXml

    "verify if blocks node exists
    let blocksNode = magento#ExistingNode(g:configXml,"config/global/blocks")
    if blocksNode==0
        call magento#AddNode(g:configXml,"config/global","blocks","",g:configXml)
        call magento#AddNode(g:configXml,"config/global/blocks",g:lpackage."_".g:lname,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/blocks/".g:lpackage."_".g:lname,"class",g:package."_".g:name."_Block",g:configXml)
        execute ":w"
    endif

endfunc
