using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class NumberFactory extends Ui.PickerFactory {
    hidden var start;
    hidden var stop;
    hidden var increment;
    hidden var formatString;
    hidden var font;

    function getIndex(value) {
        var index = (value / increment) - start;
        return index;
    }

    function initialize(start, stop, increment, options) {
        PickerFactory.initialize();

        self.start = start;
        self.stop = stop;
        self.increment = increment;

        if(options != null) {
            formatString = options.get(:format);
            font = options.get(:font);
        }

        if(font == null) {
            font = Gfx.FONT_NUMBER_HOT;
        }

        if(formatString == null) {
            formatString = "%d";
        }
    }

    function getDrawable(index, selected) {
        return new Ui.Text( { :text=>getValue(index).format(formatString), :color=>Gfx.COLOR_WHITE, :font=> font, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER } );
    }

    function getValue(index) {
        return start + (index * increment);
    }

    function getSize() {
        return ( stop - start ) / increment + 1;
    }

}
