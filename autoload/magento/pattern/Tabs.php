<?php

class {modulename}_Block_Adminhtml_{entity}_Edit_Tabs extends Mage_Adminhtml_Block_Widget_Tabs
{
    /**
     * Main Constructor
     * @access public
     * @retun void
     */
    public function __construct()
    {
        parent::__construct();
        $this->setId('{lentity}_info_tabs');
        $this->setDestElementId('{lentity}_edit_form');
        $this->setTitle(Mage::helper('{lmodulename}')->__('{entity} Information'));
    }
    
    protected function _prepareLayout()
    {
        $this->addTab('general', array(
                        'label'     => Mage::helper('{lmodulename}')->__('General'),
                        'content'   => $this->_translateHtml($this->getLayout()
                                        ->createBlock('{lmodulename}/adminhtml_{lentity}_edit_tab_general')->toHtml()),
        ));
    }
    
    /**
     * Translate html content
     *
     * @param string $html
     * @return string
     */
    protected function _translateHtml($html)
    {
        Mage::getSingleton('core/translate_inline')->processResponseBody($html);
        return $html;
    }

}
