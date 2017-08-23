module Utils{

	function timeToString(long){
		var seconds = long % 60;
		var minutes = (long / 60) % 60;
		return minutes+":"+seconds.format("%02d");
	}
}