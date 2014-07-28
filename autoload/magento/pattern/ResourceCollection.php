<?php

class {modulename}_Model_Resource_{entity}_Collection extends Mage_Core_Model_Resource_Db_Collection_Abstract{

    protected function _construct()
    {
            $this->_init('{lmodulename}/{lentity}');
    }

}
