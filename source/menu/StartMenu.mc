using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class StartMenu extends Menu {

	function initialize (menuArray) {
		Menu.initialize (menuArray,"");
	}
	
	function onShow() {
	    var round = App.getApp().getProperty("round");
        var interval = Utils.timeToString(App.getApp().getProperty("intervalTime"));
        var rest = Utils.timeToString(App.getApp().getProperty("restTime"));
        var title = Ui.loadResource(Rez.Strings.StartTitle);
		Menu.setTitle(Lang.format(title,[round,interval,rest]));
		Menu.onShow();
	}	
}