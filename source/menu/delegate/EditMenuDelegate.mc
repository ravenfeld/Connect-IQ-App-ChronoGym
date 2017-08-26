using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class EditMenuDelegate extends MenuDelegate {
	
	hidden var interval;
	hidden var rest;
	hidden var repeat;
	hidden var alarms;
	hidden var bip;
	hidden var bip5S;
	hidden var vibrate;
	
    function initialize(menu) {
        MenuDelegate.initialize(menu);
        interval = Ui.loadResource(Rez.Strings.EditInterval);
        rest = Ui.loadResource(Rez.Strings.EditRest);
        repeat = Ui.loadResource(Rez.Strings.EditRepeat);
        alarms = Ui.loadResource(Rez.Strings.Alarms);
        bip = Ui.loadResource(Rez.Strings.Bip);
        bip5S = Ui.loadResource(Rez.Strings.Bip5s);
        vibrate = Ui.loadResource(Rez.Strings.Vibrate);
    }

    function onMenuItem(item) {
    	if(item.id == :Interval){
    		Ui.pushView(new TimePicker(interval,"intervalTime"), new TimePickerDelegate("intervalTime"), Ui.SLIDE_IMMEDIATE);
    	}else if(item.id == :Rest){
    		Ui.pushView(new TimePicker(rest,"restTime"), new TimePickerDelegate("restTime"), Ui.SLIDE_IMMEDIATE);
    	}else if(item.id == :Repeat){
    		Ui.pushView(new NumberPicker(repeat,"round"), new NumberPickerDelegate("round"), Ui.SLIDE_IMMEDIATE);
    	}else if ( item.id == :Alarms){
    	    var menuItems = new [3];
		    menuItems[0]=new StateMenuItem (:Beep,bip,"beep");
		    menuItems[1]=new StateMenuItem (:Beep5s,bip5S,"beep5s");
		    menuItems[2]=new StateMenuItem (:Vibrate,vibrate,"vibrate");
		    var menu = new Menu (menuItems, alarms);
	
            Ui.pushView(menu,new AlarmMenuDelegate(menu) ,  Ui.SLIDE_LEFT );
    	}
    }
}