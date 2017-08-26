using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class AlarmMenuDelegate extends MenuDelegate {
		
    function initialize(menu) {
        MenuDelegate.initialize(menu);
    	if(model!=null){
			model.menuVisible = true ;
		}
    }
	
    function onMenuItem(item) {
		if(item.id ==:Beep){
    		if(App.getApp().getProperty("beep")){
    			App.getApp().setProperty("beep",false);
    		}else{
    			App.getApp().setProperty("beep",true);
    		}
    	}else if(item.id ==:Beep5s){
    		if(App.getApp().getProperty("beep5s")){
    			App.getApp().setProperty("beep5s",false);
    		}else{
    			App.getApp().setProperty("beep5s",true);
    		}
    	}else if(item.id ==:Vibrate){
    		if(App.getApp().getProperty("vibrate")){
    			App.getApp().setProperty("vibrate",false);
    		}else{
    			App.getApp().setProperty("vibrate",true);
    		}
    	}
    }
    
    function onBack(){
		if(model!=null){
			model.menuVisible = false ;
			Ui.popView (Ui.SLIDE_LEFT);
			return true;
		}
	}
}