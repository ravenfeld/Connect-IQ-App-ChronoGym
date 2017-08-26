using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class StartMenuDelegate extends MenuDelegate {
	
    hidden var alarms;
    hidden var edit;
    function initialize(menu) {
        MenuDelegate.initialize(menu);
        edit = Ui.loadResource(Rez.Strings.Edit);
        alarms = Ui.loadResource(Rez.Strings.Alarms);
    }

    function onMenuItem(item) {
    	if(item.id ==:Start){
    	    model = new ChronoModel();
      		Ui.pushView(new ChronoView(), new ChronoDelegate(), Ui.SLIDE_IMMEDIATE );
    	}else if(item.id ==:Edit){
            var menuItems = new [4];
            menuItems[0]=new IntervalMenuItem (:Interval);
            menuItems[1]=new RestMenuItem (:Rest);
		    menuItems[2]=new RoundMenuItem (:Repeat);
		    menuItems[3]=new MenuItem (:Alarms,alarms);
		    var menu = new Menu (menuItems, edit);
	
            Ui.pushView(menu,new EditMenuDelegate(menu) ,  Ui.SLIDE_LEFT );
    	}
    }
}