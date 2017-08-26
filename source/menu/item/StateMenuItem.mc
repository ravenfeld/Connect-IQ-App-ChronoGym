using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class StateMenuItem extends MenuItem{

	hidden var property;
	hidden var enable;
	hidden var disable;
	
	function initialize (id,value,property) {
		MenuItem.initialize(id,value);
		self.property=property;
		enable = Ui.loadResource(Rez.Strings.Enable);
		disable = Ui.loadResource(Rez.Strings.Disable);
	}
		
	function drawHighlightedLabel (dc, _y) {
		var height = 60;
		var x = dc.getWidth()-18;
		var y = dc.getHeight()/2-height/2;
		var radius = 7;
		
		var active=App.getApp().getProperty(property);
		if(active){
			MenuItem.setValue(enable);
			dc.setColor(Gfx.COLOR_GREEN,Gfx.COLOR_BLACK);
			dc.fillRoundedRectangle(x-radius, y,radius*2+1,height,radius);
			dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_WHITE);
			dc.fillCircle(x, y+radius, radius);
			dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_WHITE);
			dc.drawRoundedRectangle(x-radius, y,radius*2+1,height,radius);
			dc.drawCircle(x, y+radius, radius);
		}else{
			dc.drawRoundedRectangle(x-radius, y,radius*2+1,height,radius);
			dc.drawCircle(x, y+height-radius, radius);
			MenuItem.setValue(disable);

		}
		MenuItem.drawHighlightedLabel (dc, _y);
	}
}