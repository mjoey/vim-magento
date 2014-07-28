<?php

class {modulename}_Model_Resource_{entity} extends Mage_Core_Model_Resource_Db_Abstract{

    protected function _construct()
    {
        $this->_init('{lmodulename}/{lentity}', 'entity_id');
    }

}
