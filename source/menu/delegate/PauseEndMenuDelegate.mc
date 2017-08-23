using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PauseEndMenuDelegate extends Ui.MenuInputDelegate {
	
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
 		if (item == :Continue) {
            model.startSession();
		}else if (item == :Save) {
            model.saveSession();
            Toybox.System.exit();
        }else if (item == :Ignore) {
        	model.dropSession();
            Toybox.System.exit();
        }else if (item == :Restart) {
            model.resetSession();
         }
    }
}