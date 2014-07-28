<?php

try {

/* @var $installer Mage_Core_Model_Resource_Setup */
$installer = $this;
$installer->startSetup();

/*
$installer->run(
            "CREATE TABLE IF NOT EXISTS {$installer->getTable('{lmodulename}/{lentity}')} 
            (`entity_id` int(10) unsigned NOT NULL auto_increment,
            `name` varchar(255) default NULL,
            PRIMARY KEY  (`entity_id`)
            )ENGINE=InnoDB DEFAULT CHARSET=utf8;"
            );
*/

$installer->endSetup();

} catch (Exception $e) {
}
