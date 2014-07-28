<?php

class {modulename}_Block_Adminhtml_{entity} extends Mage_Adminhtml_Block_Widget_Grid_Container
{
    /**
     * Constructor Override
     * @access protected
     * @return {modulename}_Block_Adminhtml_{entity}
     */
    protected function _construct()
    {
        parent::_construct();

        $this->_blockGroup = '{lmodulename}';
        $this->_controller = 'adminhtml_{lentity}';
        $this->_headerText = $this->__('Grid of {entity}');

        return $this;
    }

    /**
     * Prepare Layout
     * @access protected
     * @return {modulename}_Block_Adminhtml_{entity}
     */
    protected function _prepareLayout()
    {
        //$this->_removeButton('add');
        return parent::_prepareLayout();
    }
}
