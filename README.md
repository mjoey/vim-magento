Vim plugin to deploy Magento modules

vim-magento 0.1.3 UNSTABLE and UNCOMPLETE
===========
**Please follow me in order to know when plugin will be complete and stable**

Features
===========
  - Basic module creation:
```
app
├── code
│   └── community
│       └── Mypackage
│           └── Myextension
│               ├── etc
│               │   └── config.xml
│               └── Helper
│                   └── Data.php
└── etc
    └── modules
        └── Mypackage_Myextension.xml
```
  - Front controller creation
  - Block creation
  - Automatic config.xml update


Installation
============
You can install vim-magento with Vundle

Setup
===========
- Install XmlStarlet Command Line http://xmlstar.sourceforge.net/doc/UG/xmlstarlet-ug.html
- Define *g:author* and *g:copyright* in your .vimrc file:
```
"vim-magento setup
let g:author = "Michael Joseph <contact@michael-joseph.me>"
let g:copyright = "Copyright 2016 Michael Joseph http://michael-joseph.me"
let g:license = "http://opensource.org/licenses/MIT"
```
Usage
===========
Type this command and follow instructions
```
:Magento
```
The Abbreviations
===========
In insert mode, you can type those abbreviations to save time:
```
log$    > Mage::log();
llog$   > Mage::log(__CLASS__.' : '.__LINE__);
flog$   > Mage::log(__CLASS__.' : '.__FUNCTION__);
sconf$  > Mage::getStoreConfig();
dat$    > Mage::app()->getLocale()->date()->toString('HH:mm')
```
You can complete or optimize those by editing ab.vim files.
