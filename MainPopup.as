package  {
	import flash.display.*
	import flash.events.*
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.Timer;
	import flash.net.*;
	
	public class MainPopup extends Sprite{
		private var mpWidth:Number;
		private var mpHeight:Number;
		private var location_x:Number;
		private var location_y:Number;
		private var bg_color:uint = 0xD4F4FA;
		private var bor_color:uint = 0x3DB7CC;
		public var realNum:int;
		public var missionHappendNum:int;
		
		// GUI
		private var textformat1:TextFormat;
		private var subjectText:TextField;
		
		// Swf to load
		private var lc:LocalConnection;
		private var swfLoader:Loader;
		
		// Sound
		private var addScoreSnd:Sound;
		private var SuccessSnd:Sound;
		private var failSnd:Sound;
		private var duduSnd:Sound;
		private var soundChannel:SoundChannel;
		
		// MiniGames
		public var eventNum:int;
		public var resultGame:int;
		private var shooter:Shooter;
		private var ballons:Ballons;
		
		public function MainPopup(){
			/*
			lc = new LocalConnection();
			lc.client = this;
			lc.connect("MissionGame");
			lc.allowDomain("*");
			Security.allowDomain("*");*/
			
			addScoreSnd = new addScore_sound();
			SuccessSnd = new success_sound();
			failSnd = new fail_sound();
			duduSnd = new dududu_sound();
			
			realNum = 2; // the real number of missions
			
			addEventListener(Event.ADDED, added);
		}
		
		private function createScreen(){
			// draw(mpWidth, mpHeight, bg_color);
			
			textformat1 = new TextFormat();
			textformat1.size = 25;
			textformat1.color = 0x0054FF;
			textformat1.align = "center";
			
			// textfield of subject of swf
			subjectText = new TextField();
			subjectText.antiAliasType = AntiAliasType.ADVANCED;
			subjectText.autoSize = TextFieldAutoSize.LEFT;
			subjectText.background = true;
			subjectText.backgroundColor = 0xF6F6F6;
			subjectText.selectable = false;
			subjectText.border = true;
			subjectText.borderColor = bor_color;
			subjectText.defaultTextFormat = textformat1;
			
			/*
			swfLoader = new Loader();
			swfLoader.scaleX = 0.8;
			swfLoader.scaleY = 0.8;
			swfLoader.x = subjectText.x;
			swfLoader.y = subjectText.y + subjectText.height * 8.5;*/
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			mpWidth = Board(this.parent).getBdWidth() / 2.5;
			mpHeight = Vocagame.screenHeight / 2.5;
			
			location_x = Board(this.parent).getBdWidth() / 2 - mpWidth / 2;
			location_y = Vocagame.screenHeight / 2 - mpHeight / 2;
			
			createScreen();
		}
		
		public function init(){
			missionHappendNum = 0;
			
			ballons = new Ballons();
			ballons.addEventListener(Event.COMPLETE, onComp);
			ballons.scaleX = 1;
			ballons.scaleY = 1;
			ballons.x = Board(this.parent).getBdWidth() / 2 - ballons.width / 2;
			ballons.y = Vocagame.screenHeight / 2 - ballons.height / 2;
			
			shooter = new Shooter();
			shooter.addEventListener(Event.COMPLETE, onComp);
			shooter.scaleX = 1;
			shooter.scaleY = 1;
			shooter.x = Board(this.parent).getBdWidth() / 2 - shooter.width / 2;
			shooter.y = Vocagame.screenHeight / 2 - shooter.height / 2;
		}
		
		private function draw(w:uint, h:uint, color:uint){
			graphics.clear();
			graphics.beginFill(color, 0.9);
			graphics.drawRoundRect(location_x, location_y, w, h, w / 10, h / 10);
			graphics.endFill();
		}
		
		public function onComp(e:Event){
			trace("Result: ", resultGame);
			
			if(Vocagame.bgName != "gameBG"){
				Vocagame.bgName = "gameBG";
				SoundMixer.stopAll();
				Vocagame.bgChannel = Board(this.parent).getGameBGSnd().play(0, 1000000, Vocagame.bgTrans);
			}
			
			removeChild(subjectText);
			switch(eventNum){
				case 1:
					//removeChild(swfLoader);
					// swfLoader.unload();
					
					removeChild(ballons);
					if(resultGame >= 3){
						Board(this.parent).showTextAnother("임무 성공! 먹이 +25");
						SuccessSnd.play(0, 0, Vocagame.effectTrans);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						
						if(Board(this.parent).getWhoseTurn() == 1)
							Board(this.parent).player1.addScore(25);
						else
							Board(this.parent).player2.addScore(25);
					}
					else{
						Board(this.parent).showTextAnother("임무 실패 T.T");
						failSnd.play(0, 0, Vocagame.effectTrans);
					}
					break;
				case 2:
					// removeChild(swfLoader);
					// swfLoader.unload();
					
					removeChild(shooter);
					if(resultGame >= 3){
						Board(this.parent).showTextAnother("임무 성공! 먹이 +30");
						SuccessSnd.play(0, 0, Vocagame.effectTrans);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						
						if(Board(this.parent).getWhoseTurn() == 1)
							Board(this.parent).player1.addScore(30);
						else
							Board(this.parent).player2.addScore(30);
					}
					else{
						Board(this.parent).showTextAnother("임무 실패 T.T");
						failSnd.play(0, 0, Vocagame.effectTrans);
					}
					break;
					/*
				case 3:
					removeChild(swfLoader);
					swfLoader.unload();
					if(resultGame >= 10){
						Board(this.parent).showTextAnother("임무 성공!");
						SuccessSnd.play(0, 0, Vocagame.effectTrans);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						
						if(Board(this.parent).getWhoseTurn() == 1)
							Board(this.parent).player1.addScore(20);
						else
							Board(this.parent).player2.addScore(20);
					}
					else{
						Board(this.parent).showTextAnother("임무 실패 T.T");
						failSnd.play(0, 0, Vocagame.effectTrans);
					}
					break;
				case 4:
					removeChild(swfLoader);
					swfLoader.unload();
					if(resultGame >= 2){
						Board(this.parent).showTextAnother("Mission Succeeded!");
						SuccessSnd.play(0, 0, Vocagame.effectTrans);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						
						if(Board(this.parent).getWhoseTurn() == 1)
							Board(this.parent).player1.addScore(25);
						else
							Board(this.parent).player2.addScore(25);
					}
					else{
						Board(this.parent).showTextAnother("임무 실패 T.T");
						failSnd.play(0, 0, Vocagame.effectTrans);
					}
					break;
					*/
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getEvent(){
			++missionHappendNum;
			
			switch(missionHappendNum){
				case 1:
					subjectText.text = "Mini Ballon Game";
					subjectText.x = ballons.x;
					subjectText.y = ballons.y - subjectText.height * 1.2;
					
					addChild(ballons);
					ballons.addEventListener(Event.ENTER_FRAME, ballons.gameLoop);
					break;
				case 2:
					subjectText.text = "Mini Shooter Game";
					subjectText.x = shooter.x;
					subjectText.y = shooter.y - subjectText.height * 1.2;
					addChild(shooter);
					shooter.addEventListener(Event.ENTER_FRAME, shooter.gameLoop);
					break;
					/*
				case 3:
					swfLoader.load(new URLRequest("AirRaid2.swf"));
					subjectText.text = "Mini AirRaid2 Game";
					addChild(swfLoader);
					break;
				case 4:
					Board(this.parent).showTextAnother("Mission4!!")
					swfLoader.load(new URLRequest("SpaceRocks.swf"));
					subjectText.text = "Mini SpaceRocks Game";
					addChild(swfLoader);
					break;
					*/
			}
			
			if(Vocagame.bgName != "duduBG"){
				Vocagame.bgName = "duduBG";
				SoundMixer.stopAll();
				Vocagame.bgChannel = duduSnd.play(0, 100000, Vocagame.bgTrans);
			}
			
			addChild(subjectText);
		}
		
		private function overHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			if(btn.buttonMode){
				new Tween(btn, "width", Strong.easeOut, mpWidth / 7, mpWidth / 7 + mpWidth / 20, 1, true);
				new Tween(btn, "height", Strong.easeOut, mpHeight / 7, mpHeight / 7 + mpHeight / 20, 1, true);
			}
		}

		private function outHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			if(btn.buttonMode){
				new Tween(btn, "width", Strong.easeOut, mpWidth / 7 + mpWidth / 20, mpWidth / 7, 1, true);
				new Tween(btn, "height", Strong.easeOut, mpHeight / 7 + mpHeight / 20, mpHeight / 7, 1, true);
			}
		}
		
		public function getWhoseTurn():int{
			return Board(this.parent).getPlayerNum();
		}
	}
}
