using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class RoundMenuItem extends MenuItem{

	function initialize (id) {
		MenuItem.initialize(id, Ui.loadResource(Rez.Strings.Repeat));
	}
	
	function onShow () {
		MenuItem.setValue(App.getApp().getProperty("round")+"x"); 
	}
}