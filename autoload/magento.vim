" File    : magento.vim
" Author  : Michael Joseph
" Website : michael-joseph.me
" Contact : vim@michael-joseph.me
" Version : 0.9.0
" License : GNU GPL v3.0

let s:install_dir = expand("<sfile>:p:h")

func! magento#ucfirst(word)
    let ucfirst = tolower(a:word)
    return substitute(ucfirst, '^.', '\U\0', '')
endfunc

func! magento#ucAfterUnderscore(string)
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

func! magento#replaceSlashByUnderscore(string)
     return substitute(a:string,'/','_','g')
endfunc

func! magento#CComment(fileType)
    execute "/<?".a:fileType
    execute ":r ".s:install_dir."/magento/pattern/comment/".a:fileType.".tpl"
    call magento#CReplace()
    execute ":w"
endfunc

func! magento#CReplace()
    execute ":%s/{package}/".magento#escapeSlash(g:vimMagentoPackage)."_".g:vimMagentoName."/g"
    execute ":%s/{category}/".magento#escapeSlash(g:vimMagentoPackage)."/g"
    execute ":%s/{author}/".magento#escapeSlash(g:vimMagentoAuthor)."/g"
    execute ":%s/{copyright}/".magento#escapeSlash(g:vimMagentoCopyright)."/g"
    if g:vimMagentoSignature==1
       "set register x
       let @x = " * Generate with vim-magento plugin https:\/\/github.com\/mjoey\/vim-magento"
       "paste register x
       execute ':pu x'
    endif
    execute ":%s/{license}/".magento#escapeSlash(g:vimMagentoLicense)."/g"
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

"Create a module
func! magento#CreateModule()
    if !exists('g:vimMagentoPackage') || !exists('g:vimMagentoName')
        echom "Wich module do you want to update or create ?"
        
        "pool
        let poolFlag = 0
        while poolFlag==0
            let pool = input('Pool Name? For local type <l> or community type <c> - to abort type "exit": ')
            if pool == "l"
                let pool = "local"
                let poolFlag = 1
            elseif pool == "c"
                let pool = "community"
                let poolFlag = 1
            elseif pool == "exit"
                return
            endif
        endwhile
        echom " "

        "package
        let g:vimMagentoPackage=""
        while g:vimMagentoPackage == ""
            let g:vimMagentoPackage = input('Package name: ')
            let g:vimMagentoLPackage = tolower(g:vimMagentoPackage)
            let g:vimMagentoPackage = magento#ucfirst(g:vimMagentoPackage)
            echom " "
        endwhile

        "extension
        let g:vimMagentoName=""
        while g:vimMagentoName == ""
            let g:vimMagentoName = input('Extension name: ')
            let g:vimMagentoLName = tolower(g:vimMagentoName)
            let g:vimMagentoName = magento#ucfirst(g:vimMagentoName)
            let g:ccom = expand(":Ccom")
            echom " "
        endwhile

        "details
        echom " "
        echom "[Pool Name]: ".pool
        echom "[Package Name]: ".g:vimMagentoPackage
        echom "[Extension Name]: ".g:vimMagentoName
        let g:path = "app".g:separator."code".g:separator.pool.g:separator.g:vimMagentoPackage
        let g:declarationXml = "app".g:separator."etc".g:separator."modules".g:separator.g:vimMagentoPackage."_".g:vimMagentoName.".xml"
        let g:configXml = g:path.g:separator.g:vimMagentoName.g:separator."etc".g:separator."config.xml"
        echom "Module Path: ".g:path 

        if !filereadable(g:path.g:separator.g:vimMagentoName.g:separator."etc".g:separator."config.xml")
            if !isdirectory("app".g:separator."etc".g:separator."modules")
                call system("mkdir -p app".g:separator."etc".g:separator."modules")
            endif

            call system("touch ".g:declarationXml)
            call magento#AddNode(g:declarationXml,"config/modules",g:vimMagentoPackage."_".g:vimMagentoName,"",s:install_dir."/magento/pattern/module.xml")
            call magento#AddNode(g:declarationXml,"config/modules/".g:vimMagentoPackage."_".g:vimMagentoName,"active","true",g:declarationXml)
            call magento#AddNode(g:declarationXml,"config/modules/".g:vimMagentoPackage."_".g:vimMagentoName,"codePool",pool,g:declarationXml)
            execute ":split ".g:declarationXml
            call magento#CComment("xml")

            call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."etc")
            call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."Block")
            call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."Helper")

            "create config xml
            call system("touch ".g:configXml)
            call magento#AddNode(g:configXml,"config/modules",g:vimMagentoPackage."_".g:vimMagentoName,"",s:install_dir."/magento/pattern/config.xml")
            call magento#AddNode(g:configXml,"config/modules/".g:vimMagentoPackage."_".g:vimMagentoName,"version","1.0.0",g:configXml)
            call magento#AddNode(g:configXml,"config/global","helpers","",g:configXml)
            call magento#AddNode(g:configXml,"config/global/helpers",g:vimMagentoLPackage."_".g:vimMagentoLName,"",g:configXml)
            call magento#AddNode(g:configXml,"config/global/helpers/".g:vimMagentoLPackage."_".g:vimMagentoLName,"class",g:vimMagentoPackage."_".g:vimMagentoName."_Helper",g:configXml)
            execute ":split ".g:configXml
            call magento#CComment("xml")

            "create helper file
            call system("touch ".g:path.g:separator.g:vimMagentoName."/Helper".g:separator."Data.php")
            execute ":split ".g:path.g:separator.g:vimMagentoName."/Helper".g:separator."Data.php"
            execute ":r ".s:install_dir."/magento/pattern/Helper.php"
            call magento#deleteFirstLine()
            execute "/<?php"
            call magento#CComment("php")
            call magento#deleteFirstLine()
            execute ":w"
        endif
    endif
endfunc

"Create a frontend controller
func! magento#CreateController()
    let controllerName = magento#ucfirst(input('Controller name: '))

    if controllerName==""
        let controllerName = "Index"
    endif

    if !isdirectory(g:path.g:separator.g:vimMagentoName.g:separator."controllers")
        call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."controllers")
    endif
    call system("touch ".g:path.g:separator.g:vimMagentoName.g:separator.'controllers'.g:separator.controllerName."Controller.php")
    execute ":split ".g:path.g:separator.g:vimMagentoName.g:separator.'controllers'.g:separator.controllerName."Controller.php"
    execute ":r ".s:install_dir."/magento/pattern/Controller.php"
    execute ":%s/{package}_{modulename}_{controllername}/".g:vimMagentoPackage."_".g:vimMagentoName."_".controllerName."/g"
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
        call magento#AddNode(g:configXml,"config/frontend/routers",g:vimMagentoLPackage."_".g:vimMagentoLName,"",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:vimMagentoLPackage."_".g:vimMagentoLName,"use","standard",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:vimMagentoLPackage."_".g:vimMagentoLName,"args","",g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:vimMagentoLPackage."_".g:vimMagentoLName."/args","module",g:vimMagentoPackage."_".g:vimMagentoName,g:configXml)
        call magento#AddNode(g:configXml,"config/frontend/routers/".g:vimMagentoLPackage."_".g:vimMagentoLName."/args","frontName",g:vimMagentoLName,g:configXml)
    endif
    execute ":w"
endfunc

"Create a block
func! magento#CreateBlock()
    let block = magento#replaceSlashByUnderscore(input('Block Name: '))
    let block = magento#ucAfterUnderscore(block)
    if !isdirectory(g:path.g:separator.g:vimMagentoName.g:separator."Block")
        call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."Block")
    endif
    "create subfolder
    let blockList = split(block,'_')
    "create block sub folder
    if(len(blockList)>1)
        call remove(blockList,len(blockList)-1)
        if !isdirectory(g:path.g:separator.g:vimMagentoName.g:separator."Block".g:separator.join(blockList,g:separator))
            call system("mkdir -p ".g:path.g:separator.g:vimMagentoName.g:separator."Block".g:separator.join(blockList,g:separator))
        endif
    endif
    call system("touch ".g:path.g:separator.g:vimMagentoName.g:separator."Block".g:separator.block.".php")
    execute ":split ".g:path.g:separator.g:vimMagentoName.g:separator."Block".g:separator.join(split(block,'_'),g:separator).".php"
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
        call magento#AddNode(g:configXml,"config/global/blocks",g:vimMagentoLPackage."_".g:vimMagentoLName,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/blocks/".g:vimMagentoLPackage."_".g:vimMagentoLName,"class",g:vimMagentoPackage."_".g:vimMagentoName."_Block",g:configXml)
    endif
    execute ":w"
endfunc

"Create an entity
func! magento#CreateEntity()
    let entity = magento#replaceSlashByUnderscore(input('Entity Name: '))
    let entity = magento#ucAfterUnderscore(entity)
    let lentity = tolower(entity)
    let table = tolower(input('Table Name: '))
    let modelPath = g:path.g:separator.g:vimMagentoName.g:separator."Model"
    "create model folder
    if !isdirectory(modelPath)
        call system("mkdir -p ".modelPath)
    endif
    let entityList = split(entity,'_')
    "create model sub folder
    if(len(entityList)>1)
       call remove(entityList,len(entityList)-1)
        if !isdirectory(modelPath.g:separator.join(entityList,g:separator))
            call system("mkdir -p ".modelPath.g:separator.join(entityList,g:separator))
        endif
    endif

    "create resource folder
    if !isdirectory(modelPath.g:separator."Resource")
        call system("mkdir -p ".modelPath.g:separator."Resource")
    endif

    if !isdirectory(modelPath.g:separator."Resource".g:separator.join(split(entity,'_'),g:separator))
        call system("mkdir -p ".modelPath.g:separator."Resource".g:separator.join(split(entity,'_'),g:separator))
    endif

    execute ":split ".modelPath.g:separator."Resource".g:separator.join(split(entity,'_'),g:separator).g:separator."Collection.php"
    execute ":".line("$")
    execute ":r ".s:install_dir."/magento/pattern/ResourceCollection.php"
    execute ":%s/{modulename}/".g:vimMagentoPackage."_".g:vimMagentoName."/g"
    execute ":%s/{lmodulename}/".g:vimMagentoLPackage."_".g:vimMagentoLName."/g"
    execute ":%s/{lentity}/".lentity."/g"
    execute ":%s/{entity}/".entity."/g"
    call magento#deleteFirstLine()
    call magento#CComment("php")
    call magento#deleteFirstLine()
    execute ":w"
    
    execute ":split ".modelPath.g:separator."Resource".g:separator.join(split(entity,'_'),g:separator).".php"
    execute ":".line("$")
    execute ":r ".s:install_dir."/magento/pattern/ResourceModel.php"
    execute ":%s/{modulename}/".g:vimMagentoPackage."_".g:vimMagentoName."/g"
    execute ":%s/{lmodulename}/".g:vimMagentoLPackage."_".g:vimMagentoLName."/g"
    execute ":%s/{lentity}/".lentity."/g"
    execute ":%s/{entity}/".entity."/g"
    call magento#deleteFirstLine()
    call magento#CComment("php")
    call magento#deleteFirstLine()
    execute ":w"

    execute ":split ".modelPath.g:separator.join(split(entity,'_'),g:separator).".php"
    execute ":".line("$")
    execute ":r ".s:install_dir."/magento/pattern/Model.php"
    execute ":%s/{modulename}/".g:vimMagentoPackage."_".g:vimMagentoName."/g"
    execute ":%s/{lmodulename}/".g:vimMagentoLPackage."_".g:vimMagentoLName."/g"
    execute ":%s/{lentity}/".lentity."/g"
    execute ":%s/{entity}/".entity."/g"
    call magento#deleteFirstLine()
    call magento#CComment("php")
    call magento#deleteFirstLine()
    execute ":w"

    execute ":split ".g:configXml
    "verify if models node exists
    let modelsNode = magento#ExistingNode(g:configXml,"config/global/models")
    if modelsNode==0
        call magento#AddNode(g:configXml,"config/global","models","",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models",g:vimMagentoLPackage."_".g:vimMagentoLName,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName,"class",g:vimMagentoPackage."_".g:vimMagentoName."_Model",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName,"resourceModel",g:vimMagentoLPackage."_".g:vimMagentoLName."_resource",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models",g:vimMagentoLPackage."_".g:vimMagentoLName."_resource","",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource","class",g:vimMagentoPackage."_".g:vimMagentoName."_Model_Resource",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource","entities","",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource/entities",lentity,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource/entities/".lentity,"table",table,g:configXml)
        execute ":w"
    else
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource/entities",lentity,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName."_resource/entities/".lentity,"table",table,g:configXml)
        execute ":w"
    endif
endfunc

"Create observer
func! magento#CreateObserver()
    "area
    let areaFlag = 0
    while areaFlag==0
        let area = input('Area? global (g), frontend (f) or adminhtml (a): ')
        if area == "g"
            let area = "global"
            let areaFlag = 1
        elseif area == "f"
            let area = "frontend"
            let areaFlag = 1
        elseif area == "a"
            let area = "adminhtml"
            let areaFlag = 1
        endif
    endwhile

    "define event name
    let event = ""
    while event==""
        let event = tolower(input('Event name: '))
    endwhile

    "define observer name
    let observer = magento#replaceSlashByUnderscore(input('Observer name: '))
    let observer = magento#ucAfterUnderscore(observer)
    let observerList = split(observer,'_')
    let modelPath = g:path.g:separator.g:vimMagentoName.g:separator."Model"

    "define method name
    let method = ""
    while method==""
        let method = input('Method Name: ')
    endwhile

    "create observer sub folder
    if(len(observerList)>1)
       call remove(observerList,len(entityList)-1)
        if !isdirectory(modelPath.g:separator.join(observerList,g:separator))
            call system("mkdir -p ".modelPath.g:separator.join(observerList,g:separator))
        endif
    endif

    if observer==""
        let observer = "observer"
        call system("touch ".modelPath."Observer.php")
    else
        call system("touch ".modelPath.g:separator.join(split(observer,'_'),g:separator).".php")
    endif

    let observer = tolower(observer)
    execute ":split ".g:path.g:separator.g:vimMagentoName.g:separator."etc".g:separator."config.xml"
    "verify if models node exists
    let modelsNode = magento#ExistingNode(g:configXml,"config/global/models")
    if modelsNode==0
        call magento#AddNode(g:configXml,"config/global","models","",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models",g:vimMagentoLPackage."_".g:vimMagentoLName,"",g:configXml)
        call magento#AddNode(g:configXml,"config/global/models/".g:vimMagentoLPackage."_".g:vimMagentoLName,"class",g:vimMagentoPackage."_".g:vimMagentoName."_Model",g:configXml)
    endif
    "verify if events node exists
    let eventsNode = magento#ExistingNode(g:configXml,"config/".area."/events")
    "verify if area node exists
    let areaNode = magento#ExistingNode(g:configXml,"config/".area)
    if eventsNode==0
        if areaNode==0
            call magento#AddNode(g:configXml,"config",area,"",g:configXml)
        endif
        call magento#AddNode(g:configXml,"config/".area,"events","",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events",event,"",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event,"observers","",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers",g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers/".g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"class",g:vimMagentoLPackage."_".g:vimMagentoLName."/".tolower(observer),g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers/".g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"method",method,g:configXml)
        execute ":w"
    else
        call magento#AddNode(g:configXml,"config/".area."/events",event,"",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event,"observers","",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers",g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"",g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers/".g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"class",g:vimMagentoLPackage."_".g:vimMagentoLName."/".tolower(observer),g:configXml)
        call magento#AddNode(g:configXml,"config/".area."/events/".event."/observers/".g:vimMagentoLPackage."_".g:vimMagentoLName."_".observer,"method",method,g:configXml)
        execute ":w"
    endif
endfunc
