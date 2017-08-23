using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class IntervalMenuItem extends MenuItem{

	function initialize (id) {
		MenuItem.initialize(id,  Ui.loadResource(Rez.Strings.Interval));
	}
	
	function onShow () {
		MenuItem.setValue(Utils.timeToString(App.getApp().getProperty("intervalTime"))); 
	}
}