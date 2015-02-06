<?php

class {modulename}_Block_Adminhtml_{entity}_Grid extends Mage_Adminhtml_Block_Widget_Grid
{
    /**
     * Get collection object
     * @access public
     * @return {modulename}_Model_Resource_{entity}_Collection
     */
    public function getCollection()
    {
        if (!parent::getCollection()) {
            $collection = Mage::getResourceModel('{lmodulename}/{lentity}_collection');
            $this->setCollection($collection);
        }

        return parent::getCollection();
    }

    /**
     * Prepare columns
     * @access protected
     * @return {modulename}_Block_Adminhtml_{entity}_Grid
     */
    protected function _prepareColumns()
    {
        
        $this->addColumn('entity_id',
                array(
                        'header'=> Mage::helper('{lmodulename}')->__('ID'),
                        'width' => '50px',
                        'type'  => 'number',
                        'index' => 'entity_id',
                ));
        
        $this->addColumn('name',
                array(
                        'header'=> Mage::helper('{lmodulename}')->__('Name'),
                        'index' => 'name',
                ));
        
        return parent::_prepareColumns();
    }
    
    /**
     * short_description_here
     * @access public
     * @return
     */
    public function getRowUrl($row)
    {
        return $this->getUrl('*/*/edit', array(
                '{lentity}'=>$this->getRequest()->getParam('{lentity}'),
                'id'=>$row->getId())
        );
    }
}
