<?php

class {modulename}_Block_Adminhtml_{entity}_Edit_Tab_General extends Mage_Adminhtml_Block_Widget_Form
{
     /**
     * Main Constructor
     * @access public
     * @return void
     */
    public function __construct()
    {
        return parent::_construct();
    }
    
    protected function _prepareLayout()
    {
        return parent::_prepareLayout();
    }
    
    protected function _prepareForm()
    {
        ${lentity} = Mage::registry('current_{lentity}');
        
        $form = new Varien_Data_Form();
        $fieldset = $form->addFieldset('general',array('legend'=>Mage::helper('{lmodulename}')->__('General')));
        
        $fieldset->addField('name', 'text', array(
                        'name' => 'name',
                        'label' => Mage::helper('{lmodulename}')->__('Name'),
                        'required'=> true,
                        'value'=> ${lentity}->getName()
        ));
        
        $this->setForm($form);
    }
}
