class {package}_{modulename}_{controllername}Controller extends Mage_Core_Controller_Front_Action
{
    public function indexAction()
    {
        // Layout
        $this->loadLayout();

        // Render
        $this->renderLayout();
    }
}
