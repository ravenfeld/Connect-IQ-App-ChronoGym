using Toybox.WatchUi as Ui;

class ChronoDelegate extends Ui.BehaviorDelegate {
	
    function initialize() {
        BehaviorDelegate.initialize();
    }

	function onSelect() {
		if (model.status == null || model.status == :Pause) {
			model.startSession();
		}else {
			model.stopSession(true);
		}
	}

	function onBack() {
		model.dropSession();
	}
}
