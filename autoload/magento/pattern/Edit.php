<?php

class {modulename}_Block_Adminhtml_{entity}_Edit extends Mage_Adminhtml_Block_Template
{
    /**
     * Main Constructor
     * @access public
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
        $this->setTemplate('{lmodulename}/{lentity}/edit.phtml');
        $this->setId('{lentity}_edit');
        
    }
    
    /**
     * Retrieve currently edited {lentity} object
     *
     * @return Mage_Core_Model_Abstract
     */
    public function get{entity}()
    {
        return Mage::registry('current_{lentity}');
    }
    
    public function get{entity}Id()
    {
        return $this->get{entity}()->getId();
    }
    
    

    protected function _prepareLayout()
    {
        $this->setChild('back_button',
                $this->getLayout()->createBlock('adminhtml/widget_button')
                    ->setData(array(
                        'label'     => Mage::helper('{lmodulename}')->__('Back'),
                        'onclick'   => 'setLocation(\''.$this->getUrl('*/*/', array('{lentity}'=>$this->getRequest()->getParam('{lentity}', 0))).'\')',
                        'class' => 'back'
                    ))
            );
        
        $this->setChild('save_button',
                        $this->getLayout()->createBlock('adminhtml/widget_button')
                        ->setData(array(
                                        'label'     => Mage::helper('{lmodulename}')->__('Save'),
                                        'onclick'   => '{lentity}Form.submit()',
                                        'class' => 'save'
                        ))
        );
        
        $this->setChild('delete_button',
                $this->getLayout()->createBlock('adminhtml/widget_button')
                        ->setData(array(
                            'label'     => Mage::helper('{lmodulename}')->__('Delete'),
                            'onclick'   => 'confirmSetLocation(\''.Mage::helper('{lmodulename}')->__('Are you sure?').'\', \''.$this->getDeleteUrl().'\')',
                            'class'  => 'delete'
                        ))
         );
        
        $this->setChild('save_and_edit_button',
                        $this->getLayout()->createBlock('adminhtml/widget_button')
                        ->setData(array(
                                        'label'     => Mage::helper('{lmodulename}')->__('Save and Continue Edit'),
                                        'onclick'   => 'saveAndContinueEdit(\''.$this->getSaveAndContinueUrl().'\')',
                                        'class' => 'save'
                        ))
        );
        
        return parent::_prepareLayout();
    }
    
    public function getBackButtonHtml()
    {
        return $this->getChildHtml('back_button');
    }
    
    public function getSaveButtonHtml()
    {
        return $this->getChildHtml('save_button');
    }
    
    public function getSaveAndEditButtonHtml()
    {
        return $this->getChildHtml('save_and_edit_button');
    }
    
    public function getDeleteButtonHtml()
    {
        return $this->getChildHtml('delete_button');
    }
    
    public function getDeleteUrl()
    {
        return $this->getUrl('*/*/delete', array('_current'=>true));
    }
    
    public function getSaveUrl()
    {
        return $this->getUrl('*/*/save', array('_current'=>true, 'back'=>null));
    }
    
    public function getSaveAndContinueUrl()
    {
        return $this->getUrl('*/*/save', array(
                        '_current'   => true,
                        'back'       => 'edit',
        ));
    }
    
    /**
     * The header
     * @access public
     * @return string
     */
    public function getHeader()
    {
        if ($this->get{entity}()->getId()) {
                $header = 'Edit {entity}: ' . $this->get{entity}()->getName();
        } else {
                $header = 'New {entity}';
        }
        return $this->__($header);
    }
    
    /**
     * Retrieve the product
     * @access protected
     * @return Mage_Core_Model_Abstract
     */
    protected function _getObject()
    {
        return Mage::registry('current_{lentity}');
    }
}
