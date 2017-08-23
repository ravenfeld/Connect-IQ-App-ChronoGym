using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;


class NumberPicker extends Ui.Picker {

	hidden var property;
    function initialize(titleS,property) {
		self.property=property;
        var title = new Ui.Text({:text=>titleS, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});

        var factories = new [1];
        factories[0] = new NumberFactory(1, 59, 1, {});
        
        var defaults = new [factories.size()];
        defaults[0] = factories[0].getIndex(App.getApp().getProperty(property).toNumber());
            
        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class NumberPickerDelegate extends Ui.PickerDelegate {

	hidden var property;
    function initialize(property) {
    	self.property=property;
        PickerDelegate.initialize();
    }

    function onCancel() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }

    function onAccept(values) {
        App.getApp().setProperty(property, values[0]);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
