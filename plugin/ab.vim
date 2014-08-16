" File:          ab.vim
" Author:        Michael Joseph
" Website:       michael-joseph.me
" Contact:	 vim@michael-joseph.me
" Version:       0.1.3

"line log
ab llog$ Mage::log(__CLASS__.' : '.__LINE__);
"function log
ab flog$ Mage::log(__CLASS__.' : '.__FUNCTION__);
"simple log
ab log$ Mage::log();<ESC>1ba<ESC>
"Current date
ab dat$ Mage::app()->getLocale()->date()->toString('HH:mm')
"Store configuration - core_config_data_table
ab sconf$ Mage::getStoreConfig();<ESC>1ba<ESC>

