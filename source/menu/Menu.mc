using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class MenuItem
{
	hidden const LABEL_FONT = Gfx.FONT_SMALL;
	hidden const SELECTED_LABEL_FONT = Gfx.FONT_LARGE;
	hidden const VALUE_FONT = Gfx.FONT_MEDIUM;
	hidden const PAD = 0;

	var	id;
    hidden var label;
    hidden var value;
	var index;
	
	function initialize (id, label) {
		self.id = id;
		self.label = label;
	}

	function setValue (value) {
		self.value = value;
	}
	
	function onShow(){
	
	}
	
	function draw (dc, y, highlight) {
		if (highlight) {
			setHighlightColor (dc);
			drawHighlightedLabel (dc, y);
		} else {
			setColor (dc);
			drawLabel (dc, y);
		}
	}
	
	function setHighlightColor (dc) {
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function setColor (dc) {
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function drawLabel (dc, y) {
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = label.toString ();
		var labDims = dc.getTextDimensions (lab, LABEL_FONT);
		var yL = y + (h3 - labDims[1]) / 2;

		dc.drawText (width / 2, yL, LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function drawHighlightedLabel (dc, y) {
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = label.toString ();
		var labDims = dc.getTextDimensions (lab, SELECTED_LABEL_FONT);
		var yL, yV, h;

		if (value != null) {
			// Show label and value.
			var val = value.toString ();
			var valDims = dc.getTextDimensions (val, VALUE_FONT);

			h = labDims[1] + valDims[1] + PAD;
			yL = y + (h3 - h) / 2;
			yV = yL + labDims[1] + PAD;
			dc.drawText (width / 2, yV, VALUE_FONT, val, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			yL = y + (h3 - labDims[1]) / 2;
		}
		dc.drawText (width / 2, yL, SELECTED_LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}
}

class Menu extends Ui.View {
	var menuArray;
	var title;
	var index;
	var nextIndex;
	var drawMenu;
	
	function initialize (menuArray,title) {
	    self.menuArray = menuArray;
		index = 0;
		nextIndex = 0;
		self.title = title;
		View.initialize ();
	}
	
	function setTitle(menuTitle) {
		title = menuTitle;
	}
	
	function onShow () {
		drawMenu = new DrawMenu ();
		for (var idx = 0; idx < menuArray.size (); idx++) {
			menuArray[idx].onShow();
		}
		
	}
	
	function onHide () {
		drawMenu = null;
	}

	function itemWithId (id)
	{
		for (var idx = 0; idx < menuArray.size (); idx++) {
			if (menuArray[idx].id == id) {
				menuArray[idx].index = idx;
				return menuArray[idx];
			}
		}
		return null;
	}
	
	const ANIM_TIME = 0.3;
	function updateIndex (offset) {
		if (menuArray.size () <= 1) {
			return;
		}
		
		nextIndex = index + offset;
		// Cope with a 'feature' in modulo operator not handling -ve numbers as desired.
		nextIndex = nextIndex < 0 ? menuArray.size() + nextIndex : nextIndex;
		
		nextIndex = nextIndex % menuArray.size();
				
		if ((offset == 1 && menuArray.size()-1!=index) ||(index==0 && offset==-1)) {
			drawMenu.t = 1000;
			Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, 1000, 0, ANIM_TIME, method(:requestUpdate));
		} else {
			drawMenu.t = -1000;
			Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, -1000, 0, ANIM_TIME, method(:requestUpdate));
		}

        requestUpdate();
        index = nextIndex;
	}
	
	function requestUpdate() {
		Ui.requestUpdate();
	}
    
	function selectedItem () {
		menuArray[index].index = index;
		return menuArray[index];
	}
	
	function onUpdate (dc) {
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, width, height);

		// Draw the menu items.
		drawMenu.index = index;
		drawMenu.nextIndex = nextIndex;
		drawMenu.menu = self;
		
		drawMenu.draw (dc);
		
		// Draw the decorations.
		var h3 = height / 3;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth (2);
		dc.drawLine (0, h3-5, width, h3-5);
		dc.drawLine (0, h3 * 2+5, width, h3 * 2+5);
		
		drawArrows (dc);
	}
	
	const GAP = 5;
	const TS = 5;
	
	// The arrows are drawn with lines as polygons don't give different sized triangles depending
	// on their orientation.
	function drawArrows (dc) {
		var x = dc.getWidth () / 2;
		var y;

		dc.setPenWidth (1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		
		if (nextIndex != 0) {
			y = GAP;
			
			for (var i = 0; i < TS; i++) {
				dc.drawLine (x - i, y + i, x + i + 1, y + i);
			}
		}	

		if (nextIndex != menuArray.size () - 1) {
			y = dc.getHeight () - TS - GAP;
			
			var d;
			for (var i = 0; i < TS; i++) {
				d = TS - 1 - i;
				dc.drawLine (x - d, y + i, x + d + 1, y + i);
			}
		}	
	}	
}

// Done as a class so it can be animated.
class DrawMenu extends Ui.Drawable
{
	const TITLE_FONT = Gfx.FONT_SMALL;

	var t = 0;
	var index;
    var nextIndex;
    var menu;
			
	function initialize () {
		Drawable.initialize ({});
	}
	
	function draw (dc) {
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		var h3 = height / 3;
		var items = menu.menuArray.size ();
		
		nextIndex = menu.nextIndex;

		// y for the middle of the three items.  
		var y = h3 + (t / 1000.0) * h3;
		
		// Depending on where we are in the menu and in the animation some of 
		// these will be unnecessary but it is easier to draw everything and
		// rely on clipping to avoid unnecessary drawing calls.
		drawTitle (dc, y - nextIndex * h3 - h3);
		var hight=0;
		if (t > 0) {
			hight=-1;		
		} else if (t < 0) {
			hight=1;
		}
		for (var i = -2; i < 3; i++) {
			drawItem (dc, nextIndex + i, y + h3 * i, i == hight);
		}
	}
	
	function drawTitle (dc, y) {		
		
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;

		// Check if any of the title is visible., 
		if (y < -h3) {
			return;
		}
        dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle (0, y, width, h3-5);

		if (menu.title != null) {
			var dims = dc.getTextDimensions (menu.title, TITLE_FONT);
			var h = (h3 - dims[1]) / 2;
			dc.setColor (Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.drawText (width / 2, y + h, TITLE_FONT, menu.title, Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
	
	// highlight is the selected menu item that can optionally show a value.
	function drawItem (dc, idx, y, highlight) {
		var h3 = dc.getHeight () / 3;

		// Cannot see item if it doesn't exist or will not be visible.
		if (idx < 0 || idx >= menu.menuArray.size () 
            || menu.menuArray[idx] == null || y > dc.getHeight () || y < -h3) {
			return;
		}
		
		menu.menuArray[idx].draw (dc, y, highlight);
	}
}

class MenuDelegate extends Ui.BehaviorDelegate {
	hidden var menu;
	
	function initialize (menu) {
		self.menu = menu;
		BehaviorDelegate.initialize ();
	}
	
	function onNextPage () {
		menu.updateIndex (1);
		return true;
	}
	
	function onPreviousPage () {
		menu.updateIndex (-1);
		return true;		
	}
	
	function onSelect () {
		onMenuItem (menu.selectedItem ());
		Ui.requestUpdate();
		return true;
	}
	
	function onMenuItem(item){
	
	}
	
    function onBack () {
        Ui.popView (Ui.SLIDE_RIGHT);
		return true;
    }
}
