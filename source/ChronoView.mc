using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ChronoView extends Ui.View {

	hidden var prep;
	hidden var go;
	hidden var rest;
	hidden var text_width_10;
	hidden var text_width_1;
	hidden var text_width_point;
	hidden var cx;
	hidden var cy;
	
    function initialize () {
        View.initialize();
        prep = Ui.loadResource( Rez.Strings.Prep);
        go = Ui.loadResource( Rez.Strings.Go);
        rest = Ui.loadResource( Rez.Strings.Rest);
    }

	function onShow () {
		if(model.status==:Pause || model.status==:Stop) {
			model.stopSession(false);
		}
	}
    
    function onLayout(dc) {
		cx = dc.getWidth() / 2;
		cy = dc.getHeight() / 2;
    	text_width_10 = dc.getTextWidthInPixels("88",Gfx.FONT_NUMBER_THAI_HOT);
    	text_width_1 = dc.getTextWidthInPixels("8",Gfx.FONT_NUMBER_THAI_HOT);
    	text_width_point = dc.getTextWidthInPixels(":",Gfx.FONT_NUMBER_THAI_HOT);
    }
    function onUpdate (dc) {
  	    bgColor(dc, model.phase);
  	    
  	  	drawTime(model.counter, dc);
    	bottomText("" + model.round + "/" + model.roundTotal, dc);
		if (model.phase == :Prep) {
			topText(prep, dc);
		}else if (model.phase == :Rest) {
			topText(rest, dc);
		}else if (model.phase == :Work) {
			topText(go, dc);
    	}
    	
    	if(model.status==:Start) {
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        	dc.setPenWidth(4);
        	dc.drawLine(cx-30-2,cy-40-2,cx+50+4,cy);
        	dc.drawLine(cx+50+4,cy,cx-30-2,cy+40+4);
        	dc.drawLine(cx-30-2,cy-40-2,cx-30-2,cy+40+4);
    		var triangle = [ [cx-30,cy-40], [cx+50,cy],[cx-30,cy+40] ];
    		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        	dc.fillPolygon(triangle);
        	if(cx==cy){
        		dc.setPenWidth(5);
        		dc.drawCircle(cx,cy,cx); 
        	}
    	}else if(model.status==:Pause || model.status==:Stop){
        	var size = 80;
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        	dc.setPenWidth(4);
        	dc.drawRectangle(cx-size/2-2, cy-size/2-2, size+4, size+4);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.fillRectangle(cx-size/2, cy-size/2, size, size);
        	if(cx==cy){
        		dc.setPenWidth(5);
        		dc.drawCircle(cx,cy,cx); 
        	}
        }
    }

	
    function bgColor (dc, phase) {
  	    if (phase == :Work) {
  		    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
  	    } else {
  		    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
  	    }
        dc.clear();
    }

    function topText (text, dc) {
        dc.drawText(dc.getWidth()/2, dc.getHeight()*0.1, Gfx.FONT_LARGE, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function bottomText (text, dc) {
  	    dc.drawText(dc.getWidth()/2, dc.getHeight()*0.8, Gfx.FONT_LARGE, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function drawTime(long, dc) {
		var seconds = long % 60;
		var minutes = (long / 60) % 60;
		var start_x;
		var start_point;
		if (minutes>=10) {
			start_x=(dc.getWidth()-(text_width_10+text_width_point+text_width_10+4))/2;
			start_point=start_x+text_width_10+2;
		}else{
			start_x=(dc.getWidth()-(text_width_1+text_width_point+text_width_10+4))/2;
			start_point=start_x+text_width_1+2;
		}
		
        dc.drawText(start_x, cy, Gfx.FONT_NUMBER_THAI_HOT, minutes, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
        
        
        dc.drawText(start_point, cy, Gfx.FONT_NUMBER_THAI_HOT, ":", Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
        
        var start_seconds=start_point+text_width_point+2;
        dc.drawText(start_seconds, cy, Gfx.FONT_NUMBER_THAI_HOT, seconds.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
    }
}
