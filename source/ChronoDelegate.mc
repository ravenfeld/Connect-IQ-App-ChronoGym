using Toybox.WatchUi as Ui;

class ChronoDelegate extends Ui.BehaviorDelegate {
	
	hidden var alarms;
	hidden var bip;
	hidden var bip5S;
	hidden var vibrate;
	
    function initialize() {
        BehaviorDelegate.initialize();
        alarms = Ui.loadResource(Rez.Strings.Alarms);
        bip = Ui.loadResource(Rez.Strings.Bip);
        bip5S = Ui.loadResource(Rez.Strings.Bip5s);
        vibrate = Ui.loadResource(Rez.Strings.Vibrate);
    }

	function onSelect() {
		if (model.status == null || model.status == :Pause) {
			model.startSession();
		}else {
			model.stopSession(true);
		}
	}

	function onMenu(){
		var menuItems = new [3];
		menuItems[0]=new StateMenuItem (:Beep,bip,"beep");
		menuItems[1]=new StateMenuItem (:Beep5s,bip5S,"beep5s");
		menuItems[2]=new StateMenuItem (:Vibrate,vibrate,"vibrate");
		var menu = new Menu (menuItems, alarms);

		Ui.pushView(menu,new AlarmMenuDelegate(menu) ,  Ui.SLIDE_RIGHT );
	}
	
	function onBack() {
		model.dropSession();
	}
}
