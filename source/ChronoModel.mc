using Toybox.Application as App;
using Toybox.Timer as Timer;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as ActivityRecording;
using Toybox.Sensor as Sensor;
using Toybox.Time as Time;

class ChronoModel{

	var restTime;
	var prepTime;
	var workTime;
	var roundTotal;
	var counter;
	var round = 0;
	var phase = :Prep;
	var status;
	var session = ActivityRecording.createSession({:sport => ActivityRecording.SPORT_TRAINING, :subSport => ActivityRecording.SUB_SPORT_CARDIO_TRAINING, :name => Ui.loadResource(Rez.Strings.Sport)});
	var menuVisible=false;
	hidden var refreshTimer = new Timer.Timer();
	hidden var displayTimer = new Timer.Timer();
	hidden var sensors = Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);

	function initialize(){
        restTime = App.getApp().getProperty("restTime");
        workTime = App.getApp().getProperty("intervalTime");
        roundTotal = App.getApp().getProperty("round");
		prepTime = restTime;
		counter = prepTime;
	}

	function startSession(){
		status=:Start;
		session.start();
		refreshTimer.stop();
		displayTimer.stop();
		refreshTimer.start(method(:refresh), 1000, true);
		startBuzz();
		Ui.requestUpdate();
	}
	
	function stopSession(beep){
		if (model.status != :Stop) {
			status=:Pause;
			if (beep) {
				stopBuzz();
			}
		}
		session.stop();
		refreshTimer.stop();
        displayTimer.stop();
        displayTimer.start(method(:displayMenu), 3000, false);
        Ui.requestUpdate();
	}
	
	function displayMenu(){
		if(!menuVisible){
			if (model.status==:Pause) {	
  	        	Ui.pushView(new Rez.Menus.PauseMenu(), new PauseEndMenuDelegate(),  Ui.SLIDE_LEFT );
        	} else {  	
  	        	Ui.pushView(new Rez.Menus.EndMenu(), new PauseEndMenuDelegate(),  Ui.SLIDE_LEFT );
        	}
        }
	}
	
	function resetSession(){
		phase = :Prep;
		counter = prepTime;
		round=0;
		startSession();
	}

	function refresh(){
		status=:Work;
		if (counter > 1) {
			counter--;
			if (counter <= 5) {
				buzz();
			}
		} else {
			if (phase == :Prep) {
				phase = :Work;
				counter = workTime;
				round++;
				intervalBuzz();
			} else if (phase == :Work) {
				phase = :Rest;
				counter = restTime;
				intervalBuzz();
			}	else if (phase == :Rest) {
				if (round == roundTotal){
					status=:Stop;
					stopSession(false);
					endBuzz();
				} else {
					phase = :Work;
					counter = workTime;
					round++;
					intervalBuzz();
				}
			}
		}
		Ui.requestUpdate();
	}

	function saveSession() {
		refreshTimer.stop();
		session.stop();
		session.save();
	}

	function startBuzz() {
		if(App.getApp().getProperty("beep")){
			beep(Attention.TONE_START);
		}
		vibrate(1500);
		
	}

	function stopBuzz() {
		if(App.getApp().getProperty("beep")){
			beep(Attention.TONE_STOP);
		}
		vibrate(1500);
	}

	function endBuzz() {
		if(App.getApp().getProperty("beep")){
			beep(Attention.TONE_SUCCESS);
		}
		vibrate(1500);
	}
	
	function buzz() {
		if(App.getApp().getProperty("beep") && App.getApp().getProperty("beep5s")){
			beep(Attention.TONE_LOUD_BEEP);
		}
	}

	function intervalBuzz() {
		if(App.getApp().getProperty("beep")){
			beep(Attention.TONE_INTERVAL_ALERT);
		}
		vibrate(1000);
	}
	
	function vibrate(duration) {
		if(Attention has :vibrate && App.getApp().getProperty("vibrate")){
			var vibrateData = [ new Attention.VibeProfile(  100, duration ) ];
			Attention.vibrate( vibrateData );
		}
	}

	function beep(tone) {
		if( Attention has :playTone ){
			Attention.playTone(tone);
		}
	}

	function dropSession() {
		refreshTimer.stop();
		displayTimer.stop();
		session.stop();
		session.discard();
	}

}
