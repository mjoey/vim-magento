Author : Michael Joseph <http://michael-joseph.me/><br>
Version : 0.9.0 beta<br>
License : GPL 3.0
INTRODUCTION
========================================================================
Vim-Magento is a Vim plugin that helps you build Magento modules.

INSTALLATION
========================================================================
I recommand to install Vim-Magento with Vundle.

SETUP
========================================================================
/!\ In order to work Vim-Magento needs **XmlStarlet Command Line**.
Please install this before everything.<br>

XmlStarlet installation
--------
- Under Debian distribution you can easily install XmlStarlet with this command line:
```
sudo apt-get install xmlstarlet
```
- Otherwise, go to the following url to install it: http://xmlstar.sourceforge.net/doc/UG/xmlstarlet-ug.html<br>

Global variables
--------
Vim-Magento generate automatically comments, you have to define the global variables below in your .vimrc:
```
let g:vimMagentoAuthor = "Michael Joseph <contact@michael-joseph.me>"
let g:vimMagentoCopyright = "Copyright 2016 Michael Joseph http://michael-joseph.me"
let g:vimMagentoLicense = "No License"
```
If you don't define g:vimMagentoLicense, the default license will be 
```
'GPL 3.0 http://www.gnu.org/licenses/gpl-3.0.txt'
```
To disable Vim-Magento plugin's signature add this line in your .vimrc:
```
let g:vimMagentoSignature=0
```
USAGE
=============
All actions begin with *Magento* command.

THE COMMAND
========================================================================
You only have one command to know:
```
:Magento
```
This command opens the **Magento prompt**.<br>
For each Vim instance, the first time you call *:Magento* command
you have to define the module to be created or updated:
```
Pool name : Type <l> for Local or <c> for Community
```
```
Package name : Type the module package name without special characters
```
```
Extension name : Type the module extension name without special characters
```
<br>
Once module has been defined, two cases are possible:
  <br>&nbsp;&nbsp;&nbsp;&nbsp;1- The module exists, the prompt invites you to choose actions.
  <br>&nbsp;&nbsp;&nbsp;&nbsp;2- The module does not exist, the basic module is created.
<br>
<br>
Basic module's tree example
----
```
app
├── code
│   └── community
│       └── Mypackage
│           └── Myextension
│               ├── etc
│               │   └── config.xml
│               └── Helper
│                   └── Data.php
└── etc
    └── modules
        └── Mypackage_Myextension.xml
```
ACTIONS
========================================================================
The Magento prompt invites you to choose between actions below:

Select / Create a module
--------
* Type \<s>
<br>
<br>
This action enables you to select or create another module
as if it was the first time you were calling |Magento| command.

Block creation 
--------------
* Type \<b>
<br>
<br>
Define **Block name**:
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the block name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To create subfolders you can use \<_> or \</> in your block name.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; > *Example: 'Mysubfolder_Myblock' or 'Mysubfolder/Myblock'*

Front controller creation
--------------
* Type \<c>
<br>
<br>
Define **Controller name**:
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the controller name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To create 'Mypackage_Myextension_CustomController' class, 
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;please type only 'Custom'.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you leave this field empty 'Mypackage_Myextension_IndexController'
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;class will be created automatically.

Model creation
------------
* Type \<e>
<br>
<br>
Define **Entity name**:
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the entity name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This name will be the model class name.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For example to create 'Mypackage_Myextension_Model_Mymodel' class,
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;please type 'mymodel' or 'Mymodel'.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To create subfolders you can use <_> or </> in your model name
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; > *Example: 'Mysubfolder_Mymodel' or 'Mysubfolder/Mymodel'*
<br>
<br>
Define **Table name** : 
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the table name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This name will be the database table name.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In the config.xml file this corresponds to the table node:
```
<entities>
    <mymodel>
         <table>my_table_name</table>
    </mymodel>
</entities>
```
Observer creation 
----
* Type \<o>
<br>
<br>
Define **Area name**: 
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type <g> for global, <f> for frontend or <a> for adminhtml.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This value defines the observer scope.
<br>
<br>
Define **Event name**: 
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the event name to observe.
<br>
<br>
Define **Observer name**: 
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the observer name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you leave this field empty 'Mypackage_Myextension_Model_Observer' class
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;will be created automatically.
<br>
<br>
Define **Method name** :
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type the method name without special characters.
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This name will be the observer method name that will be fired on event.

THE ABBREVATIONS
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
