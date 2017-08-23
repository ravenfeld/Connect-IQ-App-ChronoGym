using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class TimePicker extends Ui.Picker {

	hidden var property;
    function initialize(titleS,property) {
		self.property=property;
        var title = new Ui.Text({:text=>titleS, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
 
        var factories = new [3];
        factories[0] = new NumberFactory(0, 59, 1, {});
        factories[1] = new Ui.Text({:text=>":", :font=>Gfx.FONT_MEDIUM, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        factories[2] = new NumberFactory(0, 55, 5, {:format=>"%02d"});

        var defaults = splitStoredTime(factories.size());
        defaults[0] = factories[0].getIndex(defaults[0].toNumber());
        defaults[2] = factories[2].getIndex(defaults[2].toNumber());
        
        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function splitStoredTime(arraySize) {
        var storedValue = App.getApp().getProperty(property);
        var defaults = new [arraySize];
        var seconds = storedValue % 60;
		var minutes = (storedValue / 60) % 60;
		defaults[0] = minutes;
		defaults[2]= seconds;
        return defaults;
    }
}

class TimePickerDelegate extends Ui.PickerDelegate {

	hidden var property;
    function initialize(property) {
    	self.property=property;
        PickerDelegate.initialize();
    }

    function onCancel() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }

    function onAccept(values) {
        var time = values[0] *60+ values[2];
        App.getApp().setProperty(property, time);

        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
