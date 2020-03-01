package  {
	//import flash.utils.Timer;
    //import flash.utils.getTimer;
    //import flash.events.TimerEvent;
    import flash.display.MovieClip;
	
	import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;


	//import flash.display.Sprite;

	public class Animate {

        var timer:Timer; // = new Timer(1,1);
		var cnt:int;
		var noOfTotalSteps:int = 20;
		var targetMC: MovieClip;
		var _startx, _starty, _endx, _endy, _startFrameId, _endFrameId:int;
		var _midx, _midy:int;
		var _parentMovieClip:MovieClip;
		
		public function Animate(parentMovieClip:MovieClip) {
			// constructor code
			_parentMovieClip = parentMovieClip;
			timer = new Timer(1);
		
			timer.addEventListener(TimerEvent.TIMER, doAnimate);
           
		}
		
		public function init(mc:MovieClip, startx:int, starty:int, endx:int, endy:int,
				startFrameId:int, endFrameId:int, duration:int): void {
		    cnt = 0;
			targetMC = mc;
			_startx = startx;
			_starty = starty;
			_endx = endx;
			_endy = endy;
		    _startFrameId = startFrameId;
			_endFrameId = endFrameId;
			
			_midx = (startx + endx)/2;
			_midy = (starty < endy) ? (starty - 40) : (endy - 40);
			
			timer.delay = duration/noOfTotalSteps;
			
		}
		
		public function run(mc:MovieClip, startx:int, starty:int, endx:int, endy:int,
				startFrameId:int, endFrameId:int, duration:int): void {
					
		    init(mc, startx, starty, endx, endy, startFrameId, endFrameId, duration);
			
			timer.start();
			// _parentMovieClip.waiting = true;
		}
		
		
        function doAnimate(event:TimerEvent):void {
			//움직임을 나태는 프레임이 Frame  _startFrameId+1 ~ Frame  _startFrameId+2 인 경우임.
			
			var index:int =  _startFrameId + (_endFrameId - _startFrameId) *
			    ((Number)(cnt) / noOfTotalSteps);
			targetMC.gotoAndStop(index);
			
			var pos:Array = calPosition();
			targetMC.x = pos[0]; targetMC.y = pos[1];
			
			cnt++;
			if(cnt > noOfTotalSteps) {
			    timer.stop();
				targetMC.gotoAndStop( _startFrameId);  //정지 프레임임
				// _parentMovieClip.waiting = false;
			}
           // trace("runMany() called @ " + getTimer() + " ms");
        }

		
        function doAnimateTwo(event:TimerEvent):void {
			//움직임을 나태는 프레임이 Frame  _startFrameId+1 ~ Frame  _startFrameId+2 인 경우임.
			if(cnt < noOfTotalSteps) 
			    targetMC.gotoAndStop( _startFrameId + 1);
			else
			    targetMC.gotoAndStop( _startFrameId + 2);
			
			var pos:Array = calPosition();
			targetMC.x = pos[0]; targetMC.y = pos[1];
			
			cnt++;
			if(cnt > noOfTotalSteps) {
			    timer.stop();
				targetMC.gotoAndStop( _startFrameId);  //정지 프레임임
				// _parentMovieClip.waiting = false;
			}
           // trace("runMany() called @ " + getTimer() + " ms");
        }
		
		
		function calPosition() : Array {
			var t:Number = cnt/(Number)(noOfTotalSteps);

			var mx:int = (1 - t)*(1-t)*_startx + 2*(1-t)*t*_midx + t*t*_endx;
			var my:int = (1 - t)*(1-t)*_starty + 2*(1-t)*t*_midy + t*t*_endy;
			
			return [mx, my];
			
		}
		

	}
	
}
