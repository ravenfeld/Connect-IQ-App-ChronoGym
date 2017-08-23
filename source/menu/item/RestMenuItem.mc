using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class RestMenuItem extends MenuItem{

	function initialize (id) {
		MenuItem.initialize(id, Ui.loadResource(Rez.Strings.Rest));
	}
	
	function onShow () {
		MenuItem.setValue(Utils.timeToString(App.getApp().getProperty("restTime"))); 
	}
}