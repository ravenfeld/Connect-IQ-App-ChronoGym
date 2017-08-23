using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class EditMenuDelegate extends MenuDelegate {
	
	hidden var interval;
	hidden var rest;
	hidden var repeat;
	
    function initialize(menu) {
        MenuDelegate.initialize(menu);
        interval = Ui.loadResource(Rez.Strings.EditInterval);
        rest = Ui.loadResource(Rez.Strings.EditRest);
        repeat = Ui.loadResource(Rez.Strings.EditRepeat);
    }

    function onMenuItem(item) {
    	if(item.id == :Interval){
    		Ui.pushView(new TimePicker(interval,"intervalTime"), new TimePickerDelegate("intervalTime"), Ui.SLIDE_IMMEDIATE);
    	}else if(item.id == :Rest){
    		Ui.pushView(new TimePicker(rest,"restTime"), new TimePickerDelegate("restTime"), Ui.SLIDE_IMMEDIATE);
    	}else if(item.id == :Repeat){
    		Ui.pushView(new NumberPicker(repeat,"round"), new NumberPickerDelegate("round"), Ui.SLIDE_IMMEDIATE);
    	}
    }
}