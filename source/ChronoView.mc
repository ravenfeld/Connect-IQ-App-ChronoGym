using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ChronoView extends Ui.View {

	hidden var prep;
	hidden var go;
	hidden var rest;
	
    function initialize () {
        View.initialize();
        prep = Ui.loadResource( Rez.Strings.Prep);
        go = Ui.loadResource( Rez.Strings.Go);
        rest = Ui.loadResource( Rez.Strings.Rest);
    }

	function onShow () {
		if(model.status==:Pause || model.status==:Stop) {
			model.stopSession();
		}
	}
    
    function onUpdate (dc) {
  	    bgColor(dc, model.phase);
  	    
  	  	largeText(Utils.timeToString(model.counter), dc);
    	bottomText("" + model.round + "/" + model.roundTotal, dc);
		if (model.phase == :Prep) {
			topText(prep, dc);
		}else if (model.phase == :Rest) {
			topText(rest, dc);
		}else if (model.phase == :Work) {
			topText(go, dc);
    	}
    	
    	if(model.status==:Start) {
    		var cx = dc.getWidth() / 2;
        	var cy = dc.getHeight() / 2;
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        	dc.setPenWidth(4);
        	dc.drawLine(cx-30-2,cy-40-2,cx+50+4,cy);
        	dc.drawLine(cx+50+4,cy,cx-30-2,cy+40+4);
        	dc.drawLine(cx-30-2,cy-40-2,cx-30-2,cy+40+4);
    		var triangle = [ [cx-30,cy-40], [cx+50,cy],[cx-30,cy+40] ];
    		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        	dc.fillPolygon(triangle);
        	dc.setPenWidth(5);
        	dc.drawCircle(cx,cy,cy); 
    	}else if(model.status==:Pause || model.status==:Stop){
        	
        	var cx = dc.getWidth() / 2;
        	var cy = dc.getHeight() / 2;
        	var size = 80;
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        	dc.setPenWidth(4);
        	dc.drawRectangle(cx-size/2-2, cy-size/2-2, size+4, size+4);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.fillRectangle(cx-size/2, cy-size/2, size, size);
        	dc.setPenWidth(5);
        	dc.drawCircle(cx,cy,cx); 
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

    function largeText(text, dc) {
        dc.drawText(dc.getWidth()/2, dc.getHeight()*0.25, Gfx.FONT_NUMBER_THAI_HOT, text, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
