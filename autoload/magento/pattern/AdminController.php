<?php

class {package}_{modulename}_Adminhtml_{controllername}Controller extends Mage_Adminhtml_Controller_Action
{
    /**
     * Pre dispatch
     * @access public
     * @return void
     */
    public function preDispatch()
    {
        // Title
        $this->_title($this->__('Manage {entity}'));

        return parent::preDispatch();
    }

    /**
     * List
     * @access void
     * @return void
     */
    public function indexAction()
    {
        $this->_forward('grid');
    }

    /**
     * Grid
     * @access public
     * @return void
     */
    public function gridAction()
    {
        // Layout
        $this->loadLayout();

        // Title
        $this->_title($this->__('Grid'));

        // Content
        $grid = $this->getLayout()->createBlock('{lmodulename}/adminhtml_{lentity}', 'grid');
        $this->_addContent($grid);

        // Render
        $this->renderLayout();
    }

    /**
     * New {entity}
     * @access public
     * @return void
     */
    public function newAction()
    {
        $this->_forward('edit');
    }
        
    /**
     * Initialize {lentity} from request parameters
     *
     * @return 
     */
     protected function _init{entity}()
     {
        ${entity}Id  = (int) $this->getRequest()->getParam('id');
        ${entity}    = Mage::getModel('{lmodulename}/{lentity}')->load(${entity}Id);

        Mage::register('current_{lentity}', ${entity});
                
        return ${entity};
      }
          
    /**
     * {entity} edit form
     */
    public function editAction()
    {
        ${lentity} = $this->_init{entity}();
                
        // Layout
        $this->loadLayout();
        
        // Title
        if (${lentity}->getId()) {
                $this->_title($this->__('Edit {entity}:').${lentity}->getName());
        } else {
                $this->_title($this->__('New {entity}'));
        }
                
        // Render
        $this->renderLayout();
    }

    /**
     * Save {entity}
     * @access public
     * @return void
     */
    public function saveAction()
    {
        // Object
        $id     = $this->getRequest()->getParam('id', false);
        $object = Mage::getModel('{lmodulename}/{lentity}')->load($id);

        // Save it
        try {
            $object->addData($this->getRequest()->getPost());
            $object->save();
        } catch (Mage_Core_Exception $e) {
            $this->_getSession()->addError($this->__('An error occurred.'));
            $this->_redirectReferer();
            return;
        }

        // Success
        $this->_getSession()->addSuccess($this->__('{entity} saved successfully.'));
        $this->_redirect('*/*/index');
    }

    /**
     * Delete store
     * @access public
     * @return void
     */
    public function deleteAction()
    {
        // Object
        $id     = $this->getRequest()->getParam('id', false);
        $object = Mage::getModel('{lmodulename}/{lentity}')->load($id);

        // No object?
        if (!$object->getId()) {
            $this->_getSession()->addError($this->__('{entity} not found.'));
            $this->_redirectReferer();
            return;
        }

        // Delete it
        try {
            $object->delete();
        } catch (Mage_Core_Exception $e) {
            $this->_getSession()->addError($this->__('An error occurred.'));
            $this->_redirectReferer();
            return;
        }

        // Success
        $this->_getSession()->addSuccess($this->__('{entity} deleted successfully.'));
        $this->_redirect('*/*/index');
    }

}
