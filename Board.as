package {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.geom.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	
	import org.as3wavsound.WavSound;
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;
	
	public class Board extends MovieClip implements IBitmapDrawable{
		const EFFECT_REMOVE = 1;
		
		private var bdWidth:Number;
		private var bdHeight:Number;
		private var bg_color:uint = 0xFFFFFF;
		
		public var scr_gauge:Number; // Scroll gauge
		private var scr_max:Number; // Scroll max gauge
		public var effectState:int;
		public var effectSpeed:Number;
		public var horseIndex:int;
		public var horseColor:int;
		
		public var originalY:Number; 
		public var goodEventArray:Array; // Good Event Deck
		public var badEventArray:Array; // Bad Event Deck
		public var goodEventNum:int;
		public var badEventNum:int;
		public var happendEventNum:int;
		public var detailEventNum:int;
		public var numYouChose:int;
		public var missionHappendNum:int;
		public var isCardEventHappend:Boolean;
		
		public var itemArray:Array;
		public var currentItemNum:int;
		
		// Set timer & timeLimitBar
		public var timeLimitBar:MovieClip;
		public var limitTime:Number;
		public var timer:Timer;
		public var startTime:Number;
		
		// Set another timer & timeLimit
		public var anLimitTime:Number;
		public var anTimer:Timer;
		public var anStartTime:Number;
		
		// Record
		private var recorder:MicRecorder;
		private var wavPlayer:WavSound;
		private var _file:FileReference;
		public var voiceVolCircle:MovieClip;
		private var voiceListen:MovieClip;
		public var micSetting:MovieClip;
		private var micGraphic:Sprite;
		
		private var micText:TextField;
		
		// Sound
		private var wordSnd:Sound;
		// private var wordURL:URLRequest;
		// private var mpURL:String;
		private var movingSnd:Sound;
		public var eventSnd:Sound;
		private var eventHappenSnd:Sound;
		
		// Text
		private var textArray:Array; // This has an array of boardImage texts
		private var textformat:TextFormat;
		private var textformat1:TextFormat;
		private var textformat2:TextFormat;
		private var textformat3:TextFormat;
		private var textformat4:TextFormat;
		private var textformat5:TextFormat;
		private var textformat6:TextFormat;
		private var isListen:TextField;
		public var isMicSetting:TextField;
		private var textSay:TextField;
		private var showPicture:Sprite;
		public var textSayAnother:TextField;
		public var textSayDescript:TextField;
		public var _display:TextField;
		
		public var showingTextTime:int;
		public var addEventTextTime:int;
		private var textChangeBtn:MovieClip;
		public var isTextChanged:TextField;
		
		// Board & WordSet & Player & MainPopup
		public var boardImage:MovieClip;
		public var mainPopup:MainPopup;
		public var wordSet:WordSet;
		public var player1:Player;
		public var player2:Player;
		public var popup:Popup;
		public var popupConsider:PopupConsider;
		public var popupBackground:PopupBackground;
		
		public function Board(){
			bdWidth = (7 * Vocagame.screenWidth) / 9;
			bdHeight = Vocagame.screenHeight * 2.0;
			scr_max = bdHeight - Vocagame.screenHeight;
			scr_gauge = 0;
			limitTime = 2.5; // normal 3
			anLimitTime = 2500; // normal 2500
			showingTextTime = 2500; // normal 2500
			addEventTextTime = 300; // normal 300
			
			wordSet = WordSet.getInst();
			goodEventNum = 6;
			badEventNum = 7;
			
			movingSnd = new moving_sound();
			eventSnd = new event_sound();
			eventHappenSnd = new eventHappen_sound();
			
			addEventListener(Event.ADDED, added);
			addEventListener(Event.RENDER, rendering);
		}
		
		public function createEventArray(){
			badEventArray = new Array();
			for(var i:int = 0; i < badEventNum; ++i){
				badEventArray.push(i);
			}
			
			goodEventArray = new Array();
			for(i = 100; i < 100 + goodEventNum; ++i){
				goodEventArray.push(i);
			}
			
			var temp:int;
			
			var randNum1:int = int(Math.random() * 7);
			var randNum2:int = int(Math.random() * 6);
			
			for(i = 0; i < 50; ++i){
				temp = badEventArray[randNum1];
				badEventArray[randNum1] = badEventArray[i % 7];
				badEventArray[i % 7] = temp;
				
				temp = goodEventArray[randNum2];
				goodEventArray[randNum2] = goodEventArray[i % 6];
				goodEventArray[i % 6] = temp;
			}
		}
		
		// Create board
		private function createScreen(){
			boardImage = new back_image();
			boardImage.width = bdWidth;
			boardImage.height = bdHeight;
			boardImage.addEventListener(MouseEvent.MOUSE_WHEEL, scrolling);
			boardImage.addEventListener(MouseEvent.MOUSE_DOWN, dragging);
			
			textformat = new TextFormat();
			textformat.size = 25;
			textformat.color = 0x000000;
			textformat.align = "center";
			
			textformat1 = new TextFormat();
			textformat1.size = 15;
			textformat1.color = 0x000000;
			textformat1.align = "center";
			
			textformat2 = new TextFormat();
			textformat2.size = 300;
			textformat2.color = 0x000000;
			textformat2.align = "center";
			
			textformat3 = new TextFormat();
			textformat3.size = 80;
			textformat3.color = 0xFF5E00;
			textformat3.align = "center";
			
			textformat4 = new TextFormat();
			textformat4.size = 20;
			textformat4.color = 0x0054FF;
			textformat4.align = "left";
			
			textformat5 = new TextFormat();
			textformat5.size = 55;
			textformat5.color = 0x0054FF;
			textformat5.align = "center";
			
			textformat6 = new TextFormat();
			textformat6.size = 40;
			textformat6.color = 0x000000;
			textformat6.align = "left";
			
			timer = new Timer(25, 0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted);
			
			anTimer = new Timer(1000, 0);
			anTimer.addEventListener(TimerEvent.TIMER, anTimerHandler);
			anTimer.addEventListener(TimerEvent.TIMER_COMPLETE, anTimerCompleted);
			
			timeLimitBar = new timeLimit_image();
			timeLimitBar.width = (99 * bdWidth) / 100;
			timeLimitBar.height = Vocagame.screenHeight / 15;
			timeLimitBar.x = bdWidth / 200;
			timeLimitBar.y =(14 * Vocagame.screenHeight) / 15;
			timeLimitBar.mcMask.scaleX = 0;
			
			micGraphic = new mic2();
			micGraphic.scaleX = 0.4;
			micGraphic.scaleY = 0.4;
			micGraphic.x = timeLimitBar.x + micGraphic.width / 2;
			micGraphic.y = timeLimitBar.y + timeLimitBar.height / 2.5;
			
			micText = new TextField();
			micText.selectable = false;
			micText.antiAliasType = AntiAliasType.ADVANCED;
			micText.autoSize = TextFieldAutoSize.LEFT;
			micText.x = micGraphic.x + micGraphic.width / 2;
			micText.y = micGraphic.y - micText.height * 3.5;
			micText.defaultTextFormat = textformat6;
			micText.text = "이 단어를 말해 보아요";
			
			voiceListen = new listenBtn_image();
			voiceListen.width = bdWidth / 25;
			voiceListen.height = bdWidth / 25;
			voiceListen.x = (24 * bdWidth) / 25;
			voiceListen.y = bdHeight / 15;
			voiceListen.alpha = 0.9;
			voiceListen.buttonMode = true;
			voiceListen.addEventListener(MouseEvent.CLICK, isListenHandler);
			voiceListen.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			voiceListen.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			// textfield of showing isListen
			isListen = new TextField();
			isListen.antiAliasType = AntiAliasType.ADVANCED;
			isListen.autoSize = TextFieldAutoSize.LEFT;
			isListen.background = false;
			isListen.selectable = false;
			isListen.defaultTextFormat = textformat1;
			isListen.text = "발음 끄기";
			
			micSetting = new micBtn_image();
			micSetting.width = bdWidth / 25;
			micSetting.height = bdWidth / 25;
			micSetting.x = (24 * bdWidth) / 25;
			micSetting.y = voiceListen.y  + voiceListen.height + isListen.height;
			micSetting.buttonMode = true;
			micSetting.addEventListener(MouseEvent.CLICK, isMicSettingHandler);
			micSetting.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			micSetting.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			if(GameScreen.micFlag)
				micSetting.alpha = 0.9;
			else
				micSetting.alpha = 0.2;
			
			// textfield of showing isMicSetting
			isMicSetting = new TextField();
			isMicSetting.antiAliasType = AntiAliasType.ADVANCED;
			isMicSetting.autoSize = TextFieldAutoSize.LEFT;
			isMicSetting.background = false;
			isMicSetting.selectable = false;
			isMicSetting.defaultTextFormat = textformat1;
			isMicSetting.text = "녹음 켜기";
			
			textChangeBtn = new textChange();
			textChangeBtn.width = bdWidth / 25;
			textChangeBtn.height = bdWidth / 25;
			textChangeBtn.x = (24 * bdWidth) / 25;
			textChangeBtn.y = micSetting.y + micSetting.height + isMicSetting.height;
			textChangeBtn.alpha = 0.9;
			textChangeBtn.buttonMode = true;
			textChangeBtn.addEventListener(MouseEvent.CLICK, isTextChangeHandler);
			textChangeBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			textChangeBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			// textfield of showing isTextChange
			isTextChanged = new TextField();
			isTextChanged.antiAliasType = AntiAliasType.ADVANCED;
			isTextChanged.autoSize = TextFieldAutoSize.LEFT;
			isTextChanged.background = false;
			isTextChanged.selectable = false;
			isTextChanged.defaultTextFormat = textformat1;
			isTextChanged.text = "단어 감추기";
			
			player1 = new Player(GameScreen.player1_name, 1);
			player2 = new Player(GameScreen.player2_name, 2);
			player1.addEventListener(Event.COMPLETE, moveOnMap);
			player2.addEventListener(Event.COMPLETE, moveOnMap);
			
			addChild(boardImage);
			
			addChild(player1);
			addChild(player2);
			
			addChild(voiceListen);
			addChild(micSetting);
			addChild(textChangeBtn);
			
			// Texts in the circles on board
			textArray = new Array();
			for(var i:int = 0; i < wordSet.wordsNum; i++){
				var subText:TextField = new TextField();
				subText.antiAliasType = AntiAliasType.ADVANCED;
				subText.autoSize = TextFieldAutoSize.CENTER;
				subText.background = false;
				subText.selectable = false;
				subText.defaultTextFormat = textformat;
				
				textArray.push(subText);
			}
			
			// textfield of showing textSay
			textSay = new TextField();
			textSay.antiAliasType = AntiAliasType.ADVANCED;
			textSay.autoSize = TextFieldAutoSize.CENTER;
			textSay.background = false;
			textSay.selectable = false;
			textSay.x = bdWidth / 2;
			textSay.y = Vocagame.screenHeight / 2.5;
			textSay.defaultTextFormat = textformat2;
			textSay.alpha = 0.9;
			
			// textfield of showing textSayAnother
			textSayAnother = new TextField();
			textSayAnother.antiAliasType = AntiAliasType.ADVANCED;
			textSayAnother.autoSize = TextFieldAutoSize.CENTER;
			textSayAnother.background = true;
			textSayAnother.backgroundColor = 0xFAE0D4;
			textSayAnother.selectable = false;
			textSayAnother.x = bdWidth / 2;
			textSayAnother.y = Vocagame.screenHeight / 1.5;
			textSayAnother.defaultTextFormat = textformat3;
			textSayAnother.alpha = 0.8;
			
			// textfield of showing textSayAnother
			textSayDescript = new TextField();
			textSayDescript.antiAliasType = AntiAliasType.ADVANCED;
			textSayDescript.autoSize = TextFieldAutoSize.CENTER;
			textSayDescript.background = true;
			textSayDescript.backgroundColor = 0xD9E5FF;
			textSayDescript.selectable = false;
			textSayDescript.x = bdWidth / 2;
			textSayDescript.y = Vocagame.screenHeight / 2.5;
			textSayDescript.defaultTextFormat = textformat5;
			textSayDescript.alpha = 0.8;
			
			// Circle to show scale of sound volume incoming into mic
			voiceVolCircle = new voiceVolumeBar();
			voiceVolCircle.x = bdWidth / 12;
			voiceVolCircle.y = Vocagame.screenHeight / 6;
			voiceVolCircle.scaleX = 1.0;
			voiceVolCircle.scaleY = 1.0;
			voiceVolCircle.alpha = 0.8;
			
			// When recorded, display this text
			_display = new TextField();
			_display.selectable = false;
			_display.antiAliasType = AntiAliasType.ADVANCED;
			_display.autoSize = TextFieldAutoSize.LEFT;
			_display.x = voiceVolCircle.x + voiceVolCircle.width * 2;
			_display.y = voiceVolCircle.y - _display.height * 3;
			_display.defaultTextFormat = textformat4;
			_display.alpha = 0.8;
			
			mainPopup = new MainPopup();
			mainPopup.addEventListener(Event.COMPLETE, finishMission);
			
			addChild(mainPopup);
			
			// Create popup object
			popup = new Popup();
			popup.addEventListener(Event.REMOVED, goToNext);
			
			// Create popupConsider object
			popupConsider = new PopupConsider();
			popupConsider.addEventListener(Event.REMOVED, goToResult);
			
			popupBackground = new PopupBackground();
			popupBackground.addEventListener(Event.COMPLETE, getEventNumResult);
			
			var itemNum = 5;
			itemArray = new Array();
			for(i = 0; i < itemNum; ++i){
				var item:Sprite;
				switch(i){
					case 0:
						item = new weapon();
						break;
					case 1:
						item = new shield();
						break;
					case 2:
						item = new shoes();
						break;
					case 3:
						item = new carrot();
						break;
					case 4:
						// item = new fly();
						item = new carrot();
						break;
				}
				item.width = 30;
				item.height = 30;
				item.alpha = 0.95;
					
				itemArray.push(item);
			}
		}
		
		// After boardImage is added
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			createScreen();
		}
		
		public function init(){
			happendEventNum = -1;
			detailEventNum = -1;
			scr_gauge = 0;
			currentItemNum = -1;
			numYouChose = -1;
			focusOnHorse(0);
			missionHappendNum = 0;
			isCardEventHappend = false;
			
			// Create horses on map outside
			for(var i:int = 0; i < GameScreen.numberOfHorse; i++){
				boardImage.addChild(MovieClip(player1.horses[i]));
				boardImage.addChild(MovieClip(player2.horses[i]));
			}
			
			createEventArray();
		}
		
		public function loadData(){
			if(!GameScreen.soundFlag){
				isListen.text = "발음 켜기";
				voiceListen.alpha = 0.2;
			}
			else{
				isListen.text = "발음 끄기";
				voiceListen.alpha = 0.9;
			}
			
			if(!GameScreen.textFlag){		
				isTextChanged.text = "단어 보이기";
				textChangeBtn.alpha = 0.2;
			}
			else{
				isTextChanged.text = "단어 감추기";
				textChangeBtn.alpha = 0.9;
			}
		}
		
		public function getItem(itemNum:int){
			currentItemNum = itemNum;
			if(GameScreen(this.parent).whoseTurn == 1){
				itemArray[itemNum].x = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).x - itemArray[itemNum].width / 2;
				itemArray[itemNum].y = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).y - itemArray[itemNum].height / 2;
			}
			else{
				itemArray[itemNum].x = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).x +
									   MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).width / 2 - itemArray[itemNum].width / 2;
				itemArray[itemNum].y = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).y + 
									   MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).height / 2 - itemArray[itemNum].height / 2;
			}
			boardImage.addChild(itemArray[itemNum]);
			new Tween(itemArray[itemNum], "y", Strong.easeOut, itemArray[itemNum].y, itemArray[itemNum].y - 50, 15, false);
			
			var itemTimer:Timer = new Timer(showingTextTime, 1);
			itemTimer.addEventListener(TimerEvent.TIMER, itemTimerHandler);
			itemTimer.addEventListener(TimerEvent.TIMER_COMPLETE, itemTimerCompleted);
			itemTimer.start();
		}
		
		// Item Timer Handler
		private function itemTimerHandler(e:TimerEvent){
		}
		
		// When item timer is completed
		private function itemTimerCompleted(e:TimerEvent){
			boardImage.removeChild(itemArray[currentItemNum]);
		}
		
		// When mission on mainPopup is finished
		private function finishMission(e:Event){
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_RULLET;
			GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		// On Recording using wav recorder
		private function onRecording(e:RecordingEvent){
			if(GameScreen(this.parent).mic != null && !GameScreen(this.parent).mic.muted && GameScreen.micFlag)
				_display.text = "녹음 경과시간: " + e.time / 1000 + " 초";
		}

		// When recording finished using wav recorder
		private function onRecordComplete(e:Event){
			if(GameScreen(this.parent).mic != null && !GameScreen(this.parent).mic.muted && GameScreen.micFlag){
				_display.text = "동그라미를 클릭하면 여러분의 발음 들을 수 있어요!";
				wavPlayer = new WavSound(recorder.output);
			
				voiceVolCircle.buttonMode = true;
				voiceVolCircle.addEventListener(MouseEvent.CLICK, playRecorded);
			
				// _file.save(recorder.output, "recorded.wav");
			}
		}
		
		// To play recorded wav sound using wav recorder
		public function playRecorded(e:MouseEvent){
			wavPlayer.play();
		}
		
		// Timer Handler
		private function timerHandler(e:TimerEvent){
			voiceVolCircle.scaleX = 1.0;
			voiceVolCircle.scaleY = 1.0;
			
			var nowTime:Number = getTimer();
			timeLimitBar.mcMask.scaleX = (nowTime - startTime) / (limitTime * 1000);
			
			if(GameScreen(this.parent).mic != null && !GameScreen(this.parent).mic.muted && GameScreen.micFlag)
				var changeScale = GameScreen(this.parent).mic.activityLevel;
			
			// trace("changeScale: ", GameScreen(this.parent).mic.activityLevel);
			
			voiceVolCircle.scaleX += changeScale / 50;
			voiceVolCircle.scaleY += changeScale / 50;
			
			if(timeLimitBar.mcMask.scaleX >= 1.1){
				timeLimitBar.mcMask.scaleX = 1.0;
				voiceVolCircle.scaleX = 1.0;
				voiceVolCircle.scaleY = 1.0;
				
				Timer(e.target).reset();
				Timer(e.target).dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
		
		// When timer is completed
		private function timerCompleted(e:TimerEvent){
			removeChild(timeLimitBar);
			// removeChild(textSay);
			removeChild(showPicture);
			removeChild(micGraphic);
			removeChild(micText);
			
			timeLimitBar.mcMask.scaleX = 0;
				
			if(GameScreen(this.parent).mic != null && !GameScreen(this.parent).mic.muted && GameScreen.micFlag)
				recorder.stop();
			
			startEvent();
		}
		
		public function startEvent(){
			trace("EventNumber: ", wordSet.isEvent(GameScreen(this.parent).curLocIndex));
			
			if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 1 && GameScreen.miniFlag && !GameScreen(this.parent).isTwiceEvent){
				var randEventNum:int = Math.random() * 10;
				isCardEventHappend = true;
				
				if(missionHappendNum < mainPopup.realNum && randEventNum < 3){
					addChild(textSayDescript);
					addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
					textSayDescript.text = "임무 수행이에요 ^_^";
					new v_04().play(0, 0, Vocagame.effectTrans);
					eventHappenSnd.play(0, 0, Vocagame.effectTrans);
					++missionHappendNum;
				
					var thirdTextTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
					thirdTextTimer.addEventListener(TimerEvent.TIMER, thirdTextTimerHandler);
					thirdTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, thirdTextTimerCompleted);
					thirdTextTimer.start();
				}
				else{
						// addChild(textSayDescript);
						// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
						textSayDescript.text = "카드한장 선택해주세요";
				
						if(Vocagame.bgName != "eventBG"){
							Vocagame.bgName = "eventBG";
							SoundMixer.stopAll();
							Vocagame.bgChannel = eventSnd.play(0, 1000000, Vocagame.bgTrans);
						}
					
						new v_05().play(0, 0, Vocagame.effectTrans);
						eventHappenSnd.play(0, 0, Vocagame.effectTrans);
				
						var fourthTextTimer:Timer = new Timer(showingTextTime - 1000, 1);
						fourthTextTimer.addEventListener(TimerEvent.TIMER, fourthTextTimerHandler);
						fourthTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fourthTextTimerCompleted);
						fourthTextTimer.start();
				}
			}
			else if(1 < wordSet.isEvent(GameScreen(this.parent).curLocIndex)
					&& wordSet.isEvent(GameScreen(this.parent).curLocIndex) < 6 && GameScreen.miniFlag){
					var alreadyHad:Boolean = false;
					new gainSomething_sound().play(0, 0, Vocagame.effectTrans);
					
					if(GameScreen(this.parent).whoseTurn == 1){
						if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 2){
							player1.addScore(25);
							GameScreen(this.parent).resetScore();
							GameScreen(this.parent).addScoreSnd.play(0, 0, Vocagame.effectTrans);
							showTextAnother("먹이 +25");
							getItem(3);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 3 && !player1.weapon){
							player1.weapon = true;
							showTextAnother("무기 획득");
							getItem(0);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 4 && !player1.shield){
							player1.shield = true;
							showTextAnother("방패 획득");
							getItem(1);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 5 && !player1.shoes){
							player1.shoes = true;
							showTextAnother("신발 획득");
							getItem(2);
						}
						else{
							showTextAnother("이미 가지고 있어요");
							alreadyHad = true;
						}
					}
					else{
						if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 2){
							player2.addScore(25);
							GameScreen(this.parent).resetScore();
							GameScreen(this.parent).addScoreSnd.play(0, 0, Vocagame.effectTrans);
							showTextAnother("먹이 +25");
							getItem(4);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 3 && !player2.weapon){
							player2.weapon = true;
							showTextAnother("무기 획득");
							getItem(0);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 4 && !player2.shield){
							player2.shield = true;
							showTextAnother("방패 획득");
							getItem(1);
						}
						else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 5 && !player2.shoes){
							player2.shoes = true;
							showTextAnother("신발 획득");
							getItem(2);
						}
						else{
							showTextAnother("이미 가지고 있어요");
							alreadyHad = true;
						}
					}
					
					if(!alreadyHad){
						wordSet.removeEvent(GameScreen(this.parent).curLocIndex);
						GameScreen(this.parent).resetItem();
					}
					
				Vocagame.bgChannel.soundTransform = Vocagame.bgTrans;
				GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_RULLET;
				GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
			}
			else if(wordSet.isEvent(GameScreen(this.parent).curLocIndex) == 6){
				if(Vocagame.bgName != "eventBG"){
					Vocagame.bgName = "eventBG";
					SoundMixer.stopAll();
					Vocagame.bgChannel = eventSnd.play(0, 1000000, Vocagame.bgTrans);
				}
				
				eventHappenSnd.play(0, 0, Vocagame.effectTrans);
				
				happendEventNum = -1;
				detailEventNum = Math.random() * 3;
				textSayDescript.text = getProperText();
			
				// addChild(textSayDescript);
				// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
				var eventText2Timer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
				eventText2Timer.addEventListener(TimerEvent.TIMER, eventText2TimerHandler);
				eventText2Timer.addEventListener(TimerEvent.TIMER_COMPLETE, eventText2TimerCompleted);
				eventText2Timer.start();
			}
			else{
				GameScreen(this.parent).isTwiceEvent = false;
				Vocagame.bgChannel.soundTransform = Vocagame.bgTrans;
				GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_RULLET;
				GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
			}
		}
		
		private function getEventNumResult(e:Event){
			numYouChose = popupBackground.numResult;
			getHappenedEventNum();
			textSayDescript.text = getProperText();
			
			removeChild(popupBackground);
			removeChild(textSayDescript);
			
			var eventText2Timer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
			eventText2Timer.addEventListener(TimerEvent.TIMER, eventText2TimerHandler);
			eventText2Timer.addEventListener(TimerEvent.TIMER_COMPLETE, eventText2TimerCompleted);
			eventText2Timer.start();
		}
		
		// third text Timer Handler
		private function thirdTextTimerHandler(e:TimerEvent){
		}
		
		// When third timer is completed
		private function thirdTextTimerCompleted(e:TimerEvent){
			removeChild(popupBackground);
			removeChild(textSayDescript);
			textSayDescript.text = "";
			
			mainPopup.getEvent();
		}
		
		// fourth text Timer Handler
		private function fourthTextTimerHandler(e:TimerEvent){
		}
		
		// When fourth timer is completed
		private function fourthTextTimerCompleted(e:TimerEvent){
			textSayDescript.text = "";
			
			addChild(textSayDescript);
			addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			popupBackground.getCardEvent();
		}
		
		// evemt text Timer Handler
		private function eventText2TimerHandler(e:TimerEvent){
		}
		
		// When event timer is completed
		private function eventText2TimerCompleted(e:TimerEvent){
			textSayDescript.text = "";
			// removeChild(popupBackground);
			
			processEvent();
		}
		
		// Save happenedEventNum in variable
		public function getHappenedEventNum(){
			if(badEventArray.length == 0 || goodEventArray.length == 0)
				createEventArray();
			
			if(numYouChose == 0){
				happendEventNum = badEventArray.pop();
			}
			else if(0 < numYouChose && numYouChose < 8){
				var randNum:int = Math.random() * 10;
				
				switch(numYouChose){
					case 1:
						if(randNum < 7)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 2:
						if(randNum < 6)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 3:
						if(randNum < 5)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 4:
						if(randNum < 4)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 5:
						if(randNum < 3)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 6:
						if(randNum < 2)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
					case 7:
						if(randNum < 1)
							happendEventNum = badEventArray.pop();
						else
							happendEventNum = goodEventArray.pop();
					break;
				}
			}
			else{
				happendEventNum = goodEventArray.pop();
			}
		}
		
		// Get proper text to say
		public function getProperText():String{
			var string:String;
			trace("happendEventNum: ", happendEventNum);
			
			if(0 <= happendEventNum && happendEventNum < 3){
					new badEvent_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 0){
						string = "아.. 흘러나오는 음악에\n반했어요 (1턴 휴식)";
						Vocagame.bgChannel.stop();
						new v_11().play(0, 0, Vocagame.effectTrans);
						new goodMusic_sound().play(0, 0, Vocagame.effectTrans);
					}
					else if(happendEventNum == 1){
						new v_12().play(0, 0, Vocagame.effectTrans);
						string = "다리 아파 더 이상\n못 가겠어요 T.T (1턴 휴식)";
					}
					else{
						new v_13().play(0, 0, Vocagame.effectTrans);
						string = "감기에 걸렸네요.. 훌쩍 T.T\n(1턴 휴식)";
					}
			}
			else if(2 < happendEventNum && happendEventNum < 7){
					new scared_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 3){
						new v_20().play(0, 0, Vocagame.effectTrans);
						string = "산 길을 걷다 미끄러졌어요 T.T\n(한칸 뒤로)";
					}
					else if(happendEventNum == 4){
						new v_21().play(0, 0, Vocagame.effectTrans);
						string = "미친 개가 쫓아와요 T.T\n(한칸 뒤로)";
					}
					else if(happendEventNum == 5){
						new v_22().play(0, 0, Vocagame.effectTrans);
						string = "가까이에 맹수 울음\n소리가 들려요 T.T (한칸 뒤로)";
					}
					else{
						new v_23().play(0, 0, Vocagame.effectTrans);
						string = "저기 먹이가 떨어져 있네요\n(한칸 뒤, 먹이 +15)";
					}
			}
			else if(99 < happendEventNum && happendEventNum < 104){
					new getPower_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 100){
						new v_28().play(0, 0, Vocagame.effectTrans);
						string = "오늘은 소풍가는 날 :)\n(한 칸 앞으로)";
					}
					else if(happendEventNum == 101){
						new v_29().play(0, 0, Vocagame.effectTrans);
						string = "오늘 저녁 식사는\n제가 좋아하는 메뉴에요\n(한칸 앞으로)";
					}
					else if(happendEventNum == 102){
						new v_30().play(0, 0, Vocagame.effectTrans);
						string = "오늘 왠지 기분이 좋네요 ^^\n(한칸 앞으로)";
					}
					else{
						new v_31().play(0, 0, Vocagame.effectTrans);
						string = "오늘 날씨 참 좋죠?\n(한칸 앞으로)";
					}
			}
			else if(103 < happendEventNum && happendEventNum < 106){
					new special_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 104){
						new v_32().play(0, 0, Vocagame.effectTrans);
						string = "하늘에서 사이렌이 울려요\n(한 턴 더)";
					}
					else if(happendEventNum == 105){
						new v_33().play(0, 0, Vocagame.effectTrans);
						string = "여기 먹이가 떨어져 있는데..?\n(주울 것인지 고민)";
					}
					//else
						//string = "우와! 비밀상점을 발견했어요!\n(아이템 구입 가능)";
			}
			else{
					new meetThief_sound().play(0, 0, Vocagame.effectTrans);
					
					if(detailEventNum == 0){
						new v_17().play(0, 0, Vocagame.effectTrans);
						string = "저기서 깡패가 부르네요 T.T\n(먹이 -20, 격퇴시 먹이 +10)";
					}
					else if(detailEventNum == 1){
						new v_18().play(0, 0, Vocagame.effectTrans);
						string = "산적과 마주쳤어요 T.T\n(먹이 -25, 격퇴시 먹이 +15)";
					}
					else{
						new v_19().play(0, 0, Vocagame.effectTrans);
						string = "강도가 칼을 들고 위협하네요 T.T\n(먹이 -30, 격퇴시 먹이 +20)";
					}
			}
			
			return string;
		}
		
		public function processEvent(){
			var goAhead:Boolean = true;
			
			if(0 <= happendEventNum && happendEventNum < 3){
					new confused_sound().play(0, 0, Vocagame.effectTrans);
					if(GameScreen(this.parent).whoseTurn == 1){
						player1.confused[GameScreen(this.parent).horseIndex] = 1;
						player1.confuse_array[GameScreen(this.parent).horseIndex].x = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).x;
						player1.confuse_array[GameScreen(this.parent).horseIndex].y = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).y - 
											 								  MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).height / 2;
																			  
						boardImage.addChild(player1.confuse_array[GameScreen(this.parent).horseIndex]);
					}
					else{
						player2.confused[GameScreen(this.parent).horseIndex] = 1;
						player2.confuse_array[GameScreen(this.parent).horseIndex].x = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).x + 
											 									  MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).width / 2;
						player2.confuse_array[GameScreen(this.parent).horseIndex].y = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).y;
						
						boardImage.addChild(player2.confuse_array[GameScreen(this.parent).horseIndex]);
					}
					
					if(happendEventNum == 0){
						new v_35().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "계속 듣고 있고 싶네요";
					}
					else{
						new v_36().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "좀 쉬어야 할 거 같아요 :(";
					}
					showTextAnother("1턴 휴식");
			}
			else if(2 < happendEventNum && happendEventNum < 7){
					if(happendEventNum == 3){
						new v_46().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "조심해야 겠네요.. T.T";
						showTextAnother("한칸 뒤로");
					}
					else if(happendEventNum == 4){
						new v_47().play(0, 0, Vocagame.effectTrans);
						new dog_sound().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "너무 무서워요 -_-";
						showTextAnother("한칸 뒤로");
					}
					else if(happendEventNum == 5){
						new v_48().play(0, 0, Vocagame.effectTrans);
						new tiger_sound().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "얼른 도망 가야 겠어요 ;";
						showTextAnother("한칸 뒤로");
					}
					else{
						if(GameScreen(this.parent).whoseTurn == 1){
							player1.addScore(15);
							getItem(3);
						}
						else{
							player2.addScore(15);
							getItem(4);
						}
						
						new v_49().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "뒤로 가길 잘 했죠?";
						showTextAnother("먹이 +15, 한칸 뒤로");
						GameScreen(this.parent).addScoreSnd.play(0, 0, Vocagame.effectTrans);
					}
					
					// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
					
					goAhead = false;
					GameScreen(this.parent).resetScore();
					GameScreen(this.parent).isMoveBack = true;
					moveShort();
			}
			else if(99 < happendEventNum && happendEventNum < 104){
					new getPower_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 100){
						new v_51().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "생각만 해도 신나네요 :)";
					}
					else if(happendEventNum == 101){
						new v_52().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "무척 기대되네요 :)";
					}
					else if(happendEventNum == 102){
						new v_53().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "좋은 일이 생길 것만 같아요 :)";
					}
					else{
						new v_54().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "이대로 어디 놀러가고 싶네요 :)";
					}
					
					// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
					
					goAhead = false;
					showTextAnother("한칸 앞으로");
					GameScreen(this.parent).isMoveBack = false;
					moveShort();
			}
			else if(103 < happendEventNum && happendEventNum < 106){
					new special_sound().play(0, 0, Vocagame.effectTrans);
					
					if(happendEventNum == 104){
						new v_55().play(0, 0, Vocagame.effectTrans);
						textSayDescript.text = "신기한 소리에 이상한\n힘이 생기네요";
						echoSiren();
					}
					else if(happendEventNum == 105){
						PlayerBoard.canUseBtn = false;
						addChild(popupConsider);
						showTextAnother("어떻게 할까요?");
					}
					//else
						//goToShop();
					
					goAhead = false;
			}
			else{
					if(GameScreen(this.parent).whoseTurn == 1){
						if(player1.weapon){
							new attackThief_sound().play(0, 0, Vocagame.effectTrans);
							player1.weapon = false;
							
							var soundEventTimer:Timer = new Timer(600, 1);
							soundEventTimer.addEventListener(TimerEvent.TIMER, soundEventTimerHandler);
							soundEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, soundEventTimerCompleted);
							soundEventTimer.start();
							
							getItem(3);
							
							if(detailEventNum == 0){
								player1.addScore(20);
								new v_40().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "깡패를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +20");
							}
							else if(detailEventNum == 1){
								player1.addScore(25);
								new v_41().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "산적를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +25");
							}
							else{
								new v_42().play(0, 0, Vocagame.effectTrans);
								player1.addScore(30);
								textSayDescript.text = "강도를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +30");
							}
							
							wordSet.removeEvent(GameScreen(this.parent).curLocIndex);
						}
						else{
							new robbed_sound().play(0, 0, Vocagame.effectTrans);
							
							if(detailEventNum == 0){
								player1.subtractScore(20);
								new v_43().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "깡패에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -20");
							}
							else if(detailEventNum == 1){
								player1.subtractScore(25);
								new v_44().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "산적에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -25");
							}
							else{
								player1.subtractScore(30);
								new v_45().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "강도에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -30");
							}
						}
					}
					else{
						if(player2.weapon){
							new attackThief_sound().play(0, 0, Vocagame.effectTrans);
							player2.weapon = false;
							
							soundEventTimer = new Timer(600, 1);
							soundEventTimer.addEventListener(TimerEvent.TIMER, soundEventTimerHandler);
							soundEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, soundEventTimerCompleted);
							soundEventTimer.start();
							
							getItem(4);
							
							if(detailEventNum == 0){
								player2.addScore(10);
								new v_40().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "깡패를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +10");
							}
							else if(detailEventNum == 1){
								player2.addScore(15);
								new v_41().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "산적를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +15");
							}
							else{
								player2.addScore(20);
								new v_42().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "강도를 보기좋게 격퇴했어요!";
								showTextAnother("먹이 +20");
							}
							
							wordSet.removeEvent(GameScreen(this.parent).curLocIndex);
						}
						else{
							new robbed_sound().play(0, 0, Vocagame.effectTrans);
							
							if(detailEventNum == 0){
								player2.subtractScore(20);
								new v_43().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "깡패에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -20");
							}
							else if(detailEventNum == 1){
								player2.subtractScore(25);
								new v_44().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "산적에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -25");
							}
							else{
								player2.subtractScore(30);
								new v_45().play(0, 0, Vocagame.effectTrans);
								textSayDescript.text = "강도에게 먹이를 뺏겼어요 T.T\n무기가 있으면 좋을텐데..";
								showTextAnother("먹이 -30");
							}
						}
					}
					
					GameScreen(this.parent).resetScore();
			}
			
			if(goAhead){
				// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
				
				var eventFinishTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
				eventFinishTimer.addEventListener(TimerEvent.TIMER, eventFinishTimerHandler);
				eventFinishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, eventFinishTimerCompleted);
				eventFinishTimer.start();
			}
		}
		
		// event finish Timer Handler
		private function eventFinishTimerHandler(e:TimerEvent){
		}
		
		// When finish timer is completed
		private function eventFinishTimerCompleted(e:TimerEvent){
			// removeChild(popupBackground);
			// removeChild(textSayDescript);
			textSayDescript.text = "";
			
			if(Vocagame.bgName != "gameBG"){
				Vocagame.bgName = "gameBG";
				Vocagame.bgChannel.stop();
				Vocagame.bgChannel = getGameBGSnd().play(0, 1000000, Vocagame.bgTrans);
			}
			
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_RULLET;
			GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		public function moveShort(){
			GameScreen(this.parent).skippedMove = true;
			
			var waitEventTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
			waitEventTimer.addEventListener(TimerEvent.TIMER, waitEventTimerHandler);
			waitEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waitEventTimerCompleted);
			waitEventTimer.start();
		}
		
		// event wait Timer Handler
		private function waitEventTimerHandler(e:TimerEvent){
		}
		
		// When wait timer is completed
		private function waitEventTimerCompleted(e:TimerEvent){
			// removeChild(popupBackground);
			// removeChild(textSayDescript);
			textSayDescript.text = "";
			
			if(Vocagame.bgName != "gameBG"){
				Vocagame.bgName = "gameBG";
				Vocagame.bgChannel.stop();
				Vocagame.bgChannel = getGameBGSnd().play(0, 1000000, Vocagame.bgTrans);
			}
			
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_HORSE;
			GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		// event sound Timer Handler
		private function soundEventTimerHandler(e:TimerEvent){
			new defeatMan_sound().play(0, 0, Vocagame.effectTrans);
		}
		
		// When sound timer is completed
		private function soundEventTimerCompleted(e:TimerEvent){
			GameScreen(this.parent).addScoreSnd.play(0, 0, Vocagame.effectTrans);
		}
		
		public function goToShop(){
			var eventFinishTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
			eventFinishTimer.addEventListener(TimerEvent.TIMER, eventFinishTimerHandler);
			eventFinishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, eventFinishTimerCompleted);
			eventFinishTimer.start();
		}
		
		public function goToResult(e:Event){
			var res:Boolean = popupConsider.whichBtn; // true = gain, false = pass
			var randNum:int = Math.random() * 10;
			
			if(res){
				if(randNum < 6){
					new trap_sound().play(0, 0, Vocagame.effectTrans);
					new confused_sound().play(0, 0, Vocagame.effectTrans);
					new v_56().play(0, 0, Vocagame.effectTrans);
					
					textSayDescript.text = "악, 덫에 걸렸다 T.T";
					showTextAnother("한턴 휴식");
					
					if(GameScreen(this.parent).whoseTurn == 1){
						player1.confused[GameScreen(this.parent).horseIndex] = 1;
						player1.confuse_array[GameScreen(this.parent).horseIndex].x = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).x;
						player1.confuse_array[GameScreen(this.parent).horseIndex].y = MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).y - 
											 								  MovieClip(player1.horses[GameScreen(this.parent).horseIndex]).height / 2;
						
						boardImage.addChild(player1.confuse_array[GameScreen(this.parent).horseIndex]);
					}
					else{
						player2.confused[GameScreen(this.parent).horseIndex] = 1;
						player2.confuse_array[GameScreen(this.parent).horseIndex].x = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).x + 
											 									  MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).width / 2;
						player2.confuse_array[GameScreen(this.parent).horseIndex].y = MovieClip(player2.horses[GameScreen(this.parent).horseIndex]).y;
						
						boardImage.addChild(player2.confuse_array[GameScreen(this.parent).horseIndex]);
					}
				}
				else{
					new gainSomething_sound().play(0, 0, Vocagame.effectTrans);
					new v_57().play(0, 0, Vocagame.effectTrans);
					
					textSayDescript.text = "냠냠 맛있는 먹이 획득";
					showTextAnother("먹이 +30");
					
					if(GameScreen(this.parent).whoseTurn == 1){
						player1.addScore(30);
						getItem(3);
					}
					else{
						player2.addScore(30);
						getItem(4);
					}
					
					GameScreen(this.parent).resetScore();
					GameScreen(this.parent).addScoreSnd.play(0, 0, Vocagame.effectTrans);
				}
			}
			else{
				new v_58().play(0, 0, Vocagame.effectTrans);
				textSayDescript.text = "만사 신중해야지..";
			}
			
			
			// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
			var eventFinishTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
			eventFinishTimer.addEventListener(TimerEvent.TIMER, eventFinishTimerHandler);
			eventFinishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, eventFinishTimerCompleted);
			eventFinishTimer.start();
		}
		
		public function echoSiren(){
			Vocagame.bgChannel.stop();
			new siren_sound().play(0, 0, Vocagame.bgTrans);
			
			GameScreen.oneMoreTurn = true;
			showTextAnother("한턴 더");
			
			// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
			var eventFinishTimer:Timer = new Timer(showingTextTime + addEventTextTime, 1);
			eventFinishTimer.addEventListener(TimerEvent.TIMER, eventFinishTimerHandler);
			eventFinishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, eventFinishTimerCompleted);
			eventFinishTimer.start();
		}
		
		// Move horse on map
		private function moveOnMap(e:Event){
			if(GameScreen(this.parent).whoseTurn == 1){
				GameScreen(this.parent).horseIndex = player1.curIndex;
				
				if(this.contains(player1.arrow_array[player1.curIndex]))
					boardImage.removeChild(player1.arrow_array[player1.curIndex]);
			}
			else{
				GameScreen(this.parent).horseIndex = player2.curIndex;
				
				if(this.contains(player2.arrow_array[player2.curIndex]))
					boardImage.removeChild(player2.arrow_array[player2.curIndex]);
			}
			
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_HORSE;
			this.parent.addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		public function showArrow(){
			if(GameScreen(this.parent).whoseTurn == 1)
				for(var i:int = 0; i < GameScreen.numberOfHorse; i++){
					MovieClip(player1.arrow_array[i]).x = MovieClip(player1.horses[i]).x;
					MovieClip(player1.arrow_array[i]).y = MovieClip(player1.horses[i]).y - MovieClip(player1.horses[i]).height / 2;
					boardImage.addChild(player1.arrow_array[i]);
				}
			else
				for(i = 0; i < GameScreen.numberOfHorse; i++){
					MovieClip(player2.arrow_array[i]).x = MovieClip(player2.horses[i]).x + MovieClip(player2.horses[i]).width / 2;
					MovieClip(player2.arrow_array[i]).y = MovieClip(player2.horses[i]).y;
					boardImage.addChild(player2.arrow_array[i]);
				}
		}
		
		// VoiceListen Button listener
		private function isListenHandler(e:MouseEvent){
			if(GameScreen.soundFlag){
				isListen.text = "발음 켜기";
				GameScreen.soundFlag = false;
				voiceListen.alpha = 0.2;
			}
			else{
				isListen.text = "발음 끄기";
				GameScreen.soundFlag = true;
				voiceListen.alpha = 0.9;
			}
		}
		
		// MicSetting Button Listener
		public function isMicSettingHandler(e:MouseEvent){
			if(GameScreen(this.parent).mic != null){
				if(!GameScreen(this.parent).mic.muted){
					if(GameScreen.micFlag){
						GameScreen(this.parent).mic.setSilenceLevel(100, 1000);
						trace("setSilenceLevel: ", GameScreen(this.parent).mic.silenceLevel);
						
						isMicSetting.text = "녹음 켜기";
						GameScreen.micFlag = false;
						micSetting.alpha = 0.2;
					}
					else{
						GameScreen(this.parent).mic.setSilenceLevel(40, 1000);
						trace("setSilenceLevel: ", GameScreen(this.parent).mic.silenceLevel);
						
						isMicSetting.text = "녹음 끄기";
						GameScreen.micFlag = true;
						micSetting.alpha = 0.9;
					}
				}
				else{
					isMicSetting.text = "녹음 비허용";
					GameScreen.micFlag = false;
					micSetting.alpha = 0.2;
				}
			}
			else{
				isMicSetting.text = "마이크 없음";
				GameScreen.micFlag = false;
				micSetting.alpha = 0.2;
			}
		}
		
		// TextChange Button listener
		private function isTextChangeHandler(e:MouseEvent){
			if(GameScreen.textFlag){
				delocateTexts();
				
				isTextChanged.text = "단어 보이기";
				GameScreen.textFlag = false;
				textChangeBtn.alpha = 0.2;
			}
			else{
				locateTexts();
				
				isTextChanged.text = "단어 감추기";
				GameScreen.textFlag = true;
				textChangeBtn.alpha = 0.9;
			}
		}
		
		private function overHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			new Tween(btn, "width", Strong.easeOut, bdWidth / 25, bdWidth / 25 * 1.3, 1, true);
			new Tween(btn, "height", Strong.easeOut, bdWidth / 25, bdWidth / 25 * 1.3 , 1, true);
			
			if(voiceListen.valueOf() == e.target){
				if(GameScreen.soundFlag)
					isListen.text = "발음 끄기";
				else
					isListen.text = "발음 켜기";
					
				isListen.x = voiceListen.x - voiceListen.width * 0.8;
				isListen.y = voiceListen.y + voiceListen.height / 1.5;
				addChild(isListen);
			}
			else if(micSetting.valueOf() == e.target){
				if(GameScreen.micFlag)
					isMicSetting.text = "녹음 끄기";
				else
					isMicSetting.text = "녹음 켜기";
				
				isMicSetting.x = micSetting.x - micSetting.width * 0.8;
				isMicSetting.y = micSetting.y + micSetting.height / 1.5;
				addChild(isMicSetting);
			}
			else if(textChangeBtn.valueOf() == e.target){
				if(GameScreen.textFlag)
					isTextChanged.text = "단어 감추기";
				else
					isTextChanged.text = "단어 보이기";
				
				isTextChanged.x = textChangeBtn.x - textChangeBtn.width / 1.1;
				isTextChanged.y = textChangeBtn.y + textChangeBtn.height / 1.5;
				addChild(isTextChanged);
			}
		}
		
		private function outHandler(e:MouseEvent){
			if(voiceListen.valueOf() == e.target)
				removeChild(isListen);
			else if(micSetting.valueOf() == e.target)
				removeChild(isMicSetting);
			else if(textChangeBtn.valueOf() == e.target)
				removeChild(isTextChanged);
			
			var btn:MovieClip = e.target as MovieClip;
			new Tween(btn, "width", Strong.easeOut, bdWidth / 25 * 1.3 , bdWidth / 25, 1, true);
			new Tween(btn, "height", Strong.easeOut, bdWidth / 25 * 1.3 , bdWidth / 25, 1, true);
		}
		
		// Mouse wheel Handler
		private function scrolling(e:MouseEvent){
			var scr_gap:Number = 20 * e.delta;
			scr_gauge -= scr_gap;
			
			if(scr_gauge < 0)
				scr_gauge = 0;
			else if(scr_gauge > scr_max)
				scr_gauge = scr_max;
			
			new Tween(boardImage, "y", Strong.easeOut, boardImage.y, -scr_gauge, 5, false);
			GameScreen(this.parent).setMapGauge(scr_gauge * (GameScreen(this.parent).getSmHeight() / bdHeight));
		}
		
		// Mouse click Handler
		private function dragging(e:MouseEvent){
			originalY = e.stageY;
			
			boardImage.removeEventListener(MouseEvent.MOUSE_DOWN, dragging);
			boardImage.addEventListener(MouseEvent.MOUSE_MOVE, moving);
			boardImage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		// Mouse move Handler
		private function moving(e:MouseEvent){
			var deltaY:Number = (e.stageY - originalY) / 10;
			scr_gauge -= deltaY;
			
			if(scr_gauge < 0)
				scr_gauge = 0;
			else if(scr_gauge > scr_max)
				scr_gauge = scr_max;
			
			new Tween(boardImage, "y", Strong.easeOut, boardImage.y, -scr_gauge, 5, false);
			GameScreen(this.parent).setMapGauge(scr_gauge * (GameScreen(this.parent).getSmHeight() / bdHeight));
		}
		
		// Mouse up Handler
		private function stopDragging(e:MouseEvent){
			boardImage.removeEventListener(MouseEvent.MOUSE_MOVE, moving);
			boardImage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			boardImage.addEventListener(MouseEvent.MOUSE_DOWN, dragging);
		}
		
		// Focus on horse
		public function focusOnHorse(to:Number){
			scr_gauge = to - (scr_max / 2);
			
			if(scr_gauge < 0)
				scr_gauge = 0;
			else if(scr_gauge > scr_max)
				scr_gauge = scr_max;
			
			new Tween(boardImage, "y", Strong.easeOut, boardImage.y, -scr_gauge, 12, false);
			GameScreen(this.parent).setMapGauge(scr_gauge * (GameScreen(this.parent).getSmHeight() / bdHeight));
		}
		
		// if there is some changes in boardImage
		private function rendering(e:Event){
			var bitmapData:BitmapData = new BitmapData(bdWidth, bdHeight, true, 0xFFFFFF);
			bitmapData.draw(boardImage, new Matrix(), null, null, null, false);
			
			GameScreen(this.parent).updateSmallMap(bitmapData);
		}
		
		public function updateSmallMap(){
			var bitmapData:BitmapData = new BitmapData(bdWidth, bdHeight, true, 0xFFFFFF);
			bitmapData.draw(boardImage, new Matrix(), null, null, null, false);

			GameScreen(this.parent).updateSmallMap(bitmapData);
		}
		
		// Move Rabbit
		public function moveHorse(obj:MovieClip, from_x, from_y, to_x, to_y){
			new Tween(obj, "x", Strong.easeOut, from_x, to_x, GameScreen(this.parent).movingSpeed / 1000, true);
			new Tween(obj, "y", Strong.easeOut, from_y, to_y, GameScreen(this.parent).movingSpeed / 1000, true);
			
			movingSnd.play(0, 0, Vocagame.effectTrans);
		}
		
		// Move Frog
		public function moveHorse2(obj:MovieClip, from_x, from_y, to_x, to_y){
			to_x -= obj.width / 2;
			to_y -= obj.height / 2;
			
			var amin:Animate = new Animate(this);
			var deltaX = to_x - from_x;
			var deltaY = to_y - from_y;
			var deltaValue = Math.abs(deltaX) - Math.abs(deltaY);
			var resultNum = 0;
			
			if(deltaX > 0 && deltaValue > 0)
				resultNum = 2;
			else if(deltaX > 0 && deltaValue <= 0)
				if(deltaY > 0)
					resultNum = 3;
				else
					resultNum = 4;
			else if(deltaX <= 0 && deltaValue > 0)
				resultNum = 1;
			else if(deltaX <= 0 && deltaValue <= 0)
				if(deltaY > 0)
					resultNum = 3;
				else
					resultNum = 4;
				
			switch(resultNum){
				case 1:
					amin.run(obj, from_x, from_y, to_x, to_y, 9, 11, GameScreen(this.parent).movingSpeed); // Frame 9 - 11: jump left
					break;
				case 2:
			   		amin.run(obj, from_x, from_y, to_x, to_y, 13, 15, GameScreen(this.parent).movingSpeed); // Frame 13 - 15: jump right
					break;
				case 3:
					amin.run(obj, from_x, from_y, to_x, to_y, 1, 3, GameScreen(this.parent).movingSpeed); // Frame 1 - 3: jump down
					break;
				case 4:
					amin.run(obj, from_x, from_y, to_x, to_y, 5, 7, GameScreen(this.parent).movingSpeed); // Frame 5 - 7: jump up
					break;
			}
				
			movingSnd.play(0, 0, Vocagame.effectTrans);
		}
		
		// Apply effect
		public function applyEffect(e:Event){
			switch(effectState){
				case EFFECT_REMOVE:
					removingEffect();
					break;
			}
		}
		
		public function removingEffect(){
			if(horseColor == 1){
				MovieClip(player1.horses[horseIndex]).alpha -= effectSpeed;
			
				if(MovieClip(player1.horses[horseIndex]).alpha <= 0){
					removeEventListener(Event.ENTER_FRAME, applyEffect);
					
					MovieClip(player1.horses[horseIndex]).alpha = 1;
				}
			}
			else{
				MovieClip(player2.horses[horseIndex]).alpha -= effectSpeed;
			
				if(MovieClip(player2.horses[horseIndex]).alpha <= 0){
					removeEventListener(Event.ENTER_FRAME, applyEffect);
					
					MovieClip(player2.horses[horseIndex]).alpha = 1;
				}
			}
		}
		
		// When game is asked to pause for ms
		public function sleep(ms:uint){
			var startingTime:uint = getTimer();
			while(true){
				if(getTimer() - startingTime >= ms)
					break;
			}
		}
		
		public function locateWords(){
			var curLocMap:Array = wordSet.getWordsLoc();
			var subText:TextField;
			for(var i:int = 0; i < wordSet.wordsNum; i++){
				subText = textArray[i];
				subText.text = wordSet.getWordsText(i);
				subText.x = curLocMap[i][0] - subText.width / 2;
				subText.y = curLocMap[i][1] + subText.height / 1.2;

				boardImage.addChild(wordSet.getWordsImage(i));
				boardImage.addChild(subText);
			}
			
			if(!GameScreen.textFlag)
				delocateTexts();
				
			// Create horses on map outside
			for(i = 0; i < GameScreen.numberOfHorse; i++){
				boardImage.setChildIndex(MovieClip(player1.horses[i]), boardImage.numChildren - 1);
				boardImage.setChildIndex(MovieClip(player2.horses[i]), boardImage.numChildren - 1);
			}
		}
		
		public function locateTexts(){
			var subText:TextField;
			for(var i:int = 0; i < wordSet.wordsNum; i++){
				subText = textArray[i];
				subText.text = wordSet.getWordsText(i);
			}
		}
		
		public function delocateTexts(){
			var subText:TextField;
			for(var i:int = 0; i < wordSet.wordsNum; i++){
				subText = textArray[i];
				subText.text = "";
			}
		}
		
		public function removeWords(){
			for(var i:int = 0; i < wordSet.wordsNum; i++){
				boardImage.removeChild(textArray[i]);
				boardImage.removeChild(wordSet.getWordsImage(i));
			}
		}
		
		// get board width
		public function getBdWidth():Number{
			return this.bdWidth;
		}
		
		// Get board height
		public function getBdHeight():Number{
			return this.bdHeight;
		}

		public function setScrGauge(scr_gauge:Number){
			this.scr_gauge = scr_gauge;
			new Tween(boardImage, "y", Strong.easeOut, boardImage.y, -scr_gauge, 10, false);
		}
		
		public function getPlayerNum():int{
			return GameScreen(this.parent).whoseTurn;
		}
		
		public function getGameState():int{
			return GameScreen(this.parent).gameState;
		}
		
		public function getWordIndex():int{
			return GameScreen(this.parent).curLocIndex;
		}
		
		public function getWhoseTurn():int{
			return GameScreen(this.parent).whoseTurn;
		}
		
		public function getGameBGSnd():Sound{
			return GameScreen(this.parent).getGameBGSnd();
		}
		
		public function voiceWord(){
			if(Vocagame.bgChannel.soundTransform.volume > 0.1)
				Vocagame.bgChannel.soundTransform = Vocagame.tempBgTrans;
			
			// textSay.text = wordSet.getWordsText(GameScreen(this.parent).curLocIndex);
			showPicture = wordSet.getWordsCopyImage(GameScreen(this.parent).curLocIndex);
			// addChild(textSayDescript);
			// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
			if(GameScreen.soundFlag){
				
				// Sound Setting
				wordSnd = wordSet.getWordsSound(GameScreen(this.parent).curLocIndex);
				// mpURL = wordSet.getWordsSound(GameScreen(this.parent).curLocIndex);
				// wordURL = new URLRequest(mpURL);
				// wordSnd.load(wordURL);
				
				// new v_01().play(0, 0, Vocagame.effectTrans);
				// textSayDescript.text = "선생님 발음을 잘 들어 보아요";
				/*
				var textTimer:Timer = new Timer(showingTextTime, 1);
				textTimer.addEventListener(TimerEvent.TIMER, textTimerHandler);
				textTimer.addEventListener(TimerEvent.TIMER_COMPLETE, textTimerCompleted);
				textTimer.start();*/
				textSayDescript.text = "";
				wordSnd.play(0, 0, Vocagame.effectTrans);
			
				var voiceTimer:Timer = new Timer(1500, 1);
				voiceTimer.addEventListener(TimerEvent.TIMER, voiceTimerHandler);
				voiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, voiceTimerCompleted);
				voiceTimer.start();
			
				addChild(showPicture);
			}
			else{
				new v_02().play(0, 0, Vocagame.effectTrans);
				textSayDescript.text = "또박또박 발음해 보아요";
			
				var secTextTimer:Timer = new Timer(showingTextTime - 500, 1);
				secTextTimer.addEventListener(TimerEvent.TIMER, secTextTimerHandler);
				secTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, secTextTimerCompleted);
				secTextTimer.start();
			}
		}
		
		// Text Timer Handler
		private function textTimerHandler(e:TimerEvent){
		}
		
		// When text timer is completed
		private function textTimerCompleted(e:TimerEvent){
			textSayDescript.text = "";
			// removeChild(popupBackground);
			
			wordSnd.play(0, 0, Vocagame.effectTrans);
			
			var voiceTimer:Timer = new Timer(1500, 1);
			voiceTimer.addEventListener(TimerEvent.TIMER, voiceTimerHandler);
			voiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, voiceTimerCompleted);
			voiceTimer.start();
			
			addChild(showPicture);
			// addChild(textSay);
		}
		
		// Voice of correcting Timer Handler
		private function voiceTimerHandler(e:TimerEvent){
		}
		
		// When voice of correcting timer is completed
		private function voiceTimerCompleted(e:TimerEvent){
			wordSnd.play(0, 0, Vocagame.effectTrans);
			
			var waitTimer:Timer = new Timer(1000 + addEventTextTime, 1);
			waitTimer.addEventListener(TimerEvent.TIMER, waitTimerHandler);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waitTimerCompleted);
			waitTimer.start();
		}
		
		// Wait Timer Handler
		private function waitTimerHandler(e:TimerEvent){
		}
		
		// When wait timer is completed
		private function waitTimerCompleted(e:TimerEvent){
			removeChild(showPicture);
			
			new v_02().play(0, 0, Vocagame.effectTrans);
			textSayDescript.text = "또박또박 발음해 보아요";
			// addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
			var secTextTimer:Timer = new Timer(showingTextTime -500, 1);
			secTextTimer.addEventListener(TimerEvent.TIMER, secTextTimerHandler);
			secTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, secTextTimerCompleted);
			secTextTimer.start();
		}
		
		// Second text Timer Handler
		private function secTextTimerHandler(e:TimerEvent){
		}
		
		// When Second timer is completed
		private function secTextTimerCompleted(e:TimerEvent){
			afterCorrect();
		}
		
		public function afterCorrect(){
			addChild(timeLimitBar);
			addChild(showPicture);
			addChild(micGraphic);
			addChild(micText);
			// addChild(textSay);
			
			// Starting record using wav recorder
			if(GameScreen(this.parent).mic != null && !GameScreen(this.parent).mic.muted && GameScreen.micFlag){
				trace("Start Record");
				// About recording using wav recorder
				recorder = new MicRecorder(new WaveEncoder());
				recorder.addEventListener(RecordingEvent.RECORDING, onRecording);
				recorder.addEventListener(Event.COMPLETE, onRecordComplete);
				
				recorder.record();
				
				addChild(_display);
				addChild(voiceVolCircle);
			}
			if(this.contains(textSayDescript)){
				textSayDescript.text = "";
				// removeChild(textSayDescript);
				// removeChild(popupBackground);
			}
			
			startTime = getTimer();
			timer.start();
		}
		
		public function showTextAnother(say:String){
			textSayAnother.text = say;
			addChild(textSayAnother);
			anStartTime = getTimer();
			anTimer.start();
		}
		
		// Timer Handler
		private function anTimerHandler(e:TimerEvent){
			var nowTime:Number = getTimer();
			var pastTime:Number = nowTime - anStartTime;
			
			if(pastTime >= anLimitTime){			
				Timer(e.target).reset();
				Timer(e.target).dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
		
		// When timer is completed
		private function anTimerCompleted(e:TimerEvent){
			removeChild(textSayAnother);
		}
		
		public function noticeCannotMove(){
			new v_06().play(0, 0, Vocagame.effectTrans);
			textSayDescript.text = "더 이상 뒤로\n갈 곳이 없어요";
			addChild(textSayDescript);
			addChildAt(popupBackground, getChildIndex(textSayDescript) - 1);
			
			var nextTimer:Timer = new Timer(showingTextTime, 1);
			nextTimer.addEventListener(TimerEvent.TIMER, nextTimerHandler);
			nextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, nextTimerCompleted);
			nextTimer.start();
		}
		
		// next of correcting Timer Handler
		private function nextTimerHandler(e:TimerEvent){
		}
		
		// When next of correcting timer is completed
		private function nextTimerCompleted(e:TimerEvent){
			textSayDescript.text = "";
			removeChild(textSayDescript);
			removeChild(popupBackground);
			
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_RULLET;
			GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		private function goToNext(e:Event){
			if(popup.whichBtn)
				Vocagame.gameState = 0;
			else
				Vocagame.gameState = 3;

			GameScreen(this.parent).goToMenu();
			popup.whichBtn = false;
		}
		
		public function getWhoWin():int{
			return GameScreen(this.parent).getWhoWin();
		}
	}
}


	import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
		class Popup extends MovieClip{
			private var popup_width:uint;
			private var popup_height:uint;
			private var bg_color:uint = 0xD4F4FA;
			private var bor_color:uint = 0x3DB7CC;
			
			public var whichBtn:Boolean;
			private var gapX:Number;
			private var gapY:Number;
			
			// GUI
			private var textformat:TextFormat;
			private var textformat2:TextFormat;
			
			private var show_name:TextField;
			private var input_name:TextField;
			private var show_score:TextField;
			private var input_score:TextField;
			
			private var ranking_pop:TextField;		
			private var main_btn:TextField;
			private var btnClickSnd:Sound;
			private var endSnd:Sound;
			
			private var location_x:Number;
			private var location_y:Number;
			
			public function Popup(){
				popup_width = 310;
				popup_height = 210;
				location_x = ((7 * Vocagame.screenWidth) / 9)  / 2 - popup_width / 2;
				location_y = Vocagame.screenHeight / 2 - popup_height / 2;
				whichBtn = false;
				gapX = 20;
				gapY = 20;
				
				btnClickSnd = new clickBtn_sound();
				endSnd = new end_sound();
				createPopup();
				
				addEventListener(Event.ADDED, added);
			}
			
			private function createPopup(){
				draw(popup_width, popup_height, bg_color);
				
				textformat = new TextFormat();
				textformat.size = 30;
				textformat.color = 0x0054FF;
				textformat.align = "center";
				
				textformat2 = new TextFormat();
				textformat2.size = 30;
				textformat2.color = 0x000000;
				textformat2.align = "center";
				
				// textfield of showing name
				show_name = new TextField();
				show_name.antiAliasType = AntiAliasType.ADVANCED;
				show_name.autoSize = TextFieldAutoSize.LEFT;
				show_name.background = false;
				show_name.x = location_x + popup_width / 17;
				show_name.y = location_y + popup_height / 17;
				show_name.text = "Name:";
				show_name.selectable = false;
				show_name.setTextFormat(textformat);
				addChild(show_name);
				
				// textfield of input name
				input_name = new TextField();
				input_name.antiAliasType = AntiAliasType.ADVANCED;
				input_name.width = popup_width / 2.5;
				input_name.height = show_name.height;
				input_name.background = false;
				input_name.x = show_name.x + gapX + popup_width / 3;
				input_name.y = show_name.y;
				input_name.border = true;
				input_name.borderColor = bor_color;
				input_name.selectable = false;
				input_name.defaultTextFormat = textformat2;
				addChild(input_name);
				
				// textfield of showing gameScore
				show_score = new TextField();
				show_score.antiAliasType = AntiAliasType.ADVANCED;
				show_score.autoSize = TextFieldAutoSize.LEFT;
				show_score.background = false;
				show_score.x = location_x + popup_width / 17;
				show_score.y = show_name.y * 1.2;
				show_score.text = "Score:";
				show_score.selectable = false;
				show_score.setTextFormat(textformat);
				addChild(show_score);
				
				// textfield of input score
				input_score = new TextField();
				input_score.antiAliasType = AntiAliasType.ADVANCED;
				input_score.width = popup_width / 2.5;
				input_score.height = show_score.height;
				input_score.background = false;
				input_score.borderColor = bor_color;
				input_score.x = show_score.x + gapX + popup_width / 3;
				input_score.y = show_score.y;
				input_score.selectable = false;
				input_score.border = true;
				input_score.defaultTextFormat = textformat2;
				addChild(input_score);
				
				// main button
				main_btn = new TextField();
				main_btn.antiAliasType = AntiAliasType.ADVANCED;
				main_btn.autoSize = TextFieldAutoSize.LEFT;
				main_btn.background = true;
				main_btn.borderColor = bor_color;
				main_btn.text = "Main";
				main_btn.setTextFormat(textformat);
				main_btn.x = show_score.x + show_name.width - main_btn.width;
				main_btn.y = show_score.y * 1.2;
				main_btn.border = true;
				main_btn.selectable = false;
				main_btn.addEventListener(MouseEvent.CLICK, goToMain);
				addChild(main_btn);
				
				// ranking button
				ranking_pop = new TextField();
				ranking_pop.antiAliasType = AntiAliasType.ADVANCED;
				ranking_pop.autoSize = TextFieldAutoSize.LEFT;
				ranking_pop.background = true;
				ranking_pop.borderColor = bor_color;
				ranking_pop.x = input_score.x;
				ranking_pop.y = main_btn.y ;
				ranking_pop.text = "Ranking";
				ranking_pop.border = true;
				ranking_pop.selectable = false;
				ranking_pop.setTextFormat(textformat);
				ranking_pop.addEventListener(MouseEvent.CLICK, goToRanking);
				addChild(ranking_pop);
			}
			
			private function draw(w:uint, h:uint, color:uint){
				graphics.clear();
				graphics.beginFill(color, 0.9);
				graphics.drawRoundRect(location_x, location_y, w, h, w / 10, h / 10);
				graphics.endFill();
			}
			
			// For showing text which has "single" or "Multi"
			private function added(e:Event){
				removeEventListener(Event.ADDED, added);
				
				if(GameScreen.gameMode == 1){
					input_name.text = String(GameScreen.player1_name);
					input_score.text = String(Board(this.parent).player1.getScore());
				}
				else{
					if(Board(this.parent).getWhoWin() == 1){
						input_name.text = String(GameScreen.player1_name);
						input_score.text = String(Board(this.parent).player1.getScore());
					}
					else if(Board(this.parent).getWhoWin() == 2){
						input_name.text = GameScreen.player2_name;
						input_score.text = String(Board(this.parent).player2.getScore());
					}
				}
			}
			
			private function goToRanking(event:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				whichBtn = false;
				
				input_name.text = "";
				input_score.text = "";
				
				this.parent.removeChild(this);
				addEventListener(Event.ADDED, added);
			}
			
			private function goToMain(e:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				whichBtn = true;
				
				input_name.text = "";
				input_score.text = "";
					
				this.parent.removeChild(this);
				addEventListener(Event.ADDED, added);
			}
		}
	
		class PopupConsider extends MovieClip{
			private var popup_width:uint;
			private var popup_height:uint;
			private var bg_color:uint = 0xD4F4FA;
			private var bor_color:uint = 0x3DB7CC;
			
			public var whichBtn:Boolean;
			private var gapX:Number;
			private var gapY:Number;
			
			// GUI
			private var textformat:TextFormat;
			private var textformat2:TextFormat;
			
			private var pass_btn:TextField;		
			private var gain_btn:TextField;
			private var btnClickSnd:Sound;
			
			private var location_x:Number;
			private var location_y:Number;
			
			public function PopupConsider(){
				popup_width = 230;
				popup_height = 60;
				location_x = ((7 * Vocagame.screenWidth) / 9)  / 2 - popup_width / 2;
				location_y = Vocagame.screenHeight / 2 - popup_height / 2;
				whichBtn = false;
				gapX = 20;
				gapY = 20;
				
				btnClickSnd = new clickBtn_sound();
				createPopup();
				
				addEventListener(Event.ADDED, added);
			}
			
			private function createPopup(){
				draw(popup_width, popup_height, bg_color);
				
				textformat = new TextFormat();
				textformat.size = 30;
				textformat.color = 0x0054FF;
				textformat.align = "center";
				
				textformat2 = new TextFormat();
				textformat2.size = 30;
				textformat2.color = 0x000000;
				textformat2.align = "center";
				
				// gain button
				gain_btn = new TextField();
				gain_btn.antiAliasType = AntiAliasType.ADVANCED;
				gain_btn.autoSize = TextFieldAutoSize.LEFT;
				gain_btn.background = true;
				gain_btn.borderColor = bor_color;
				gain_btn.text = "줍는다";
				gain_btn.setTextFormat(textformat);
				gain_btn.x = location_x + popup_width / 15;
				gain_btn.y = location_y + popup_height / 7;
				gain_btn.border = true;
				gain_btn.selectable = false;
				gain_btn.addEventListener(MouseEvent.CLICK, goToGain);
				addChild(gain_btn);
				
				// pass button
				pass_btn = new TextField();
				pass_btn.antiAliasType = AntiAliasType.ADVANCED;
				pass_btn.autoSize = TextFieldAutoSize.LEFT;
				pass_btn.background = true;
				pass_btn.borderColor = bor_color;
				pass_btn.x = gain_btn.x + gapX * 1.5 + popup_width / 3;
				pass_btn.y = gain_btn.y ;
				pass_btn.text = "놔눈다";
				pass_btn.border = true;
				pass_btn.selectable = false;
				pass_btn.setTextFormat(textformat);
				pass_btn.addEventListener(MouseEvent.CLICK, goToPass);
				addChild(pass_btn);
			}
			
			private function draw(w:uint, h:uint, color:uint){
				graphics.clear();
				graphics.beginFill(color, 0.9);
				graphics.drawRoundRect(location_x, location_y, w, h, w / 10, h / 10);
				graphics.endFill();
			}
			
			// For showing text which has "single" or "Multi"
			private function added(e:Event){
				removeEventListener(Event.ADDED, added);
			}
			
			private function goToPass(event:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				whichBtn = false;
				
				this.parent.removeChild(this);
				addEventListener(Event.ADDED, added);
			}
			
			private function goToGain(e:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				whichBtn = true;
					
				this.parent.removeChild(this);
				addEventListener(Event.ADDED, added);
			}
		}
		
	
		class PopupBackground extends MovieClip{
			private var popup_width:uint;
			private var popup_height:uint;
			private var bg_color:uint = 0xD9E5FF;
			private var bor_color:uint = 0x3DB7CC;
			
			private var gapX:Number;
			private var gapY:Number;
			private var showingCardNum:int;
			public var numResult;
			private var cardX:int;
			
			// GUI
			private var textformat:TextFormat;
			private var textformat2:TextFormat;
			private var subjectText:TextField;
			private var descriptText:TextField;
			
			private var location_x:Number;
			private var location_y:Number;
			
			private var eventIndex:Sprite;
			private var cardArray:Array;
			private var numList:Array;
			private var selectedMc:MovieClip;
			private var btnClickSnd:Sound;
			private var goodSnd:Sound;
			private var badSnd:Sound;
			
			//숫자 체크 딜레이 타이머 생성
			var t_checkTimer:Timer;
			
			public function PopupBackground(){
				popup_width = 7 * ((7 * Vocagame.screenWidth) / 9) / 8;
				popup_height = Vocagame.screenHeight / 2.5;
				location_x = ((7 * Vocagame.screenWidth) / 9) / 2 - popup_width / 2;
				location_y = Vocagame.screenHeight / 2 - popup_height / 1.7;
				gapX = 20;
				gapY = 20;
				showingCardNum = 5;
				numResult = -1;
				
				createPopup();
				
				t_checkTimer = new Timer(1000, 1);
				t_checkTimer.addEventListener(TimerEvent.TIMER, t_checkTimer_handler);
				t_checkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, t_checkTimer_completed);
				
				addEventListener(Event.ADDED, added);
			}
			
			private function createPopup(){
				draw(popup_width, popup_height, bg_color);
				
				textformat = new TextFormat();
				textformat.size = 30;
				textformat.color = 0x000000;
				textformat.align = "center";
				
				textformat2 = new TextFormat();
				textformat2.size = 20;
				textformat2.color = 0x5D5D5D;
				textformat2.align = "center";
				
				// subject Text
				subjectText = new TextField();
				subjectText.antiAliasType = AntiAliasType.ADVANCED;
				subjectText.width = popup_width - gapX * 2;
				subjectText.height = gapY * 2;
				subjectText.alpha = 0.95;
				subjectText.background = true;
				subjectText.borderColor = bor_color;
				subjectText.text = "대화 상자";
				subjectText.setTextFormat(textformat);
				subjectText.x = location_x + gapX;
				subjectText.y = location_y + gapY;
				subjectText.border = true;
				subjectText.selectable = false;
				addChild(subjectText);
				
				// descript Text
				descriptText = new TextField();
				descriptText.antiAliasType = AntiAliasType.ADVANCED;
				descriptText.width = popup_width - gapX * 2;
				descriptText.height = gapY * 2;
				descriptText.alpha = 0.95;
				descriptText.text = "Tip: 숫자가 높으면 좋은카드 입니다 :)";
				descriptText.setTextFormat(textformat2);
				descriptText.x = subjectText.x;
				descriptText.y = subjectText.y + gapY + subjectText.height;
				descriptText.selectable = false;
				
				eventIndex = new event_index();
				eventIndex.x = subjectText.x + subjectText.width / 2 - descriptText.width / 4 + gapX;
				eventIndex.y = subjectText.y + gapY / 2 + subjectText.height * 2;
				
				numList = new Array();
				cardArray = new Array();
				btnClickSnd = new clickBtn_sound();
				goodSnd = new addScore_sound();
				badSnd = new wrong_sound();
				
				for(var i:int = 0; i < 10; ++i){
					var card:MovieClip = new c_card();
					card.gotoAndStop(1);
					card.buttonMode = true;
					card.num_mc.gotoAndStop(i + 1);
					card.addEventListener(MouseEvent.CLICK, cardClick_handler);
					cardArray.push(card);
				}
				
				cardX = (popup_width - cardArray[0].width * showingCardNum) / (showingCardNum + 1);
			}
			
			private function draw(w:uint, h:uint, color:uint){
				graphics.clear();
				graphics.beginFill(color, 0.95);
				graphics.drawRoundRect(location_x, location_y, w, h, w / 10, h / 10);
				graphics.endFill();
			}
			
			// For showing text which has "single" or "Multi"
			private function added(e:Event){
				removeEventListener(Event.ADDED, added);
			}
			
			public function getCardEvent(){
				addChild(descriptText);
				addChild(eventIndex);
				
				while(numList.length > 0){
					removeChild(cardArray[numList[numList.length - 1]]);
					numList.pop();
				}
				
				var numDeck:Array = new Array();
				for(var i:int = 0; i < showingCardNum; ++i)
					numDeck.push(i);
				
				var	middleDeck:Array = new Array();
				for(i = 3; i < 7; ++i)
					middleDeck.push(i);
				
				for(i = 0; i < showingCardNum; ++i){
					var num:int = Math.random() * (showingCardNum - i);
					switch(numDeck[num]){
						case 0: // negative
							numDeck[num] = int(Math.random() * 3);
							break;
						case (showingCardNum - 1): // positive
							numDeck[num] = int(Math.random() * 3 + 7);
							break;
						default: // middle
							var middleNum:int = Math.random() * (4 - i);
							numDeck[num] = middleDeck[middleNum];
							
							var temp:int = middleDeck[middleNum];
							middleDeck[middleNum] = middleDeck[middleDeck.length - 1];
							middleDeck[middleDeck.length - 1] = temp;
							middleDeck.pop();
							break;
					}
					
					numList.push(numDeck[num]);
					trace("CardNumber: ", numList[i]);
					
					temp = numDeck[num];
					numDeck[num] = numDeck[numDeck.length - 1];
					numDeck[numDeck.length - 1] = temp;
					numDeck.pop();
					
					if(i == 0)
						cardArray[numList[i]].x = location_x + cardX;
					else
						cardArray[numList[i]].x = location_x + cardX * (i + 1) + cardArray[0].width * (i);
					
					cardArray[numList[i]].y = descriptText.y + descriptText.height + gapY;
					addChild(cardArray[numList[i]]);
				}
			}
			
			public function cardClick_handler(e:MouseEvent){
				selectedMc = MovieClip(e.currentTarget);
				
				if(selectedMc.buttonMode){
					btnClickSnd.play(0, 0, Vocagame.effectTrans);
					selectedMc.gotoAndPlay("OPEN_END");
					
					for(var i:int = 0; i < showingCardNum; ++i){
						cardArray[numList[i]].buttonMode = false;
						
						if(selectedMc.valueOf() == cardArray[numList[i]])
							numResult = numList[i];
					}
				
					t_checkTimer.start();
				}
			}
			
			//숫자 체크 딜레이 타이머 리스너
			function t_checkTimer_handler(e:TimerEvent) {
			}
			
			//숫자 체크 딜레이 타이머 리스너
			function t_checkTimer_completed(e:TimerEvent) {
				e.currentTarget.reset();
				selectedMc.gotoAndStop(1);
				selectedMc.num_mc.gotoAndStop(cardArray.indexOf(selectedMc) + 1);
				removeChild(descriptText);
				removeChild(eventIndex);
				
				for(var i:int = 0; i < showingCardNum; ++i)
					cardArray[numList[i]].buttonMode = true;
				
				while(numList.length > 0){
					removeChild(cardArray[numList[numList.length - 1]]);
					numList.pop();
				}
				
				if(numResult <= 2)
					badSnd.play(0, 0, Vocagame.effectTrans);
				else if(numResult > 6)
					goodSnd.play(0, 0, Vocagame.effectTrans);
				
				this.dispatchEvent(new Event(Event.COMPLETE));
				addEventListener(Event.ADDED, added);
			}
		}
		