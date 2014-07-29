<?php
class {package}_{modulename}_{controllername}Controller extends Mage_Core_Controller_Front_Action{

    public function indexAction()
    {
        $this->loadLayout();

        $this->renderLayout();
    }

}
