using Toybox.Application as App;
using Toybox.WatchUi as Ui;


var model;
	
class ChronoGymApp extends App.AppBase {
	hidden var start;
	hidden var edit;
	
	function initialize() {
        AppBase.initialize();
        start = Ui.loadResource(Rez.Strings.Start);
        edit = Ui.loadResource(Rez.Strings.Edit);
    }

    function getInitialView() {
        var menuItems = new [2];
        menuItems[0] = new MenuItem (:Start,start);
        menuItems[1] = new MenuItem (:Edit, edit);
        
		var menu = new StartMenu (menuItems);
        return [ menu,new StartMenuDelegate(menu) ];
    }

}
