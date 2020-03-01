package  {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.utils.getDefinitionByName;
	import flash.utils.*;
	import flash.media.*;
	import flash.system.*;
	import flash.net.*;
	import flash.display.MovieClip
	
	public class GameScreen extends Sprite{
		const STATE_INIT = 0;
		const STATE_PLAYER = 1;
		const STATE_RULLET = 2;
		const STATE_HORSE = 3;
		const STATE_END = 4;
		
		const EFFECT_REMOVE = 1;
		
		// Game information
		public static var player1_name:String;
		public static var player2_name:String;
		public static var player1_score:int;
		public static var player2_score:int;
		public static var gameMode:int;
		public static var stageLv:int;
		public static var soundFlag:Boolean;
		public static var micFlag:Boolean;
		public static var textFlag:Boolean;
		public static var miniFlag:Boolean;
		public static var turn:int;
		public static var oneMoreTurn:Boolean;
		public static var eventFactor:int; // event modulus
		public static var eventNotHappen:int; // The percentage of not happening event
		public static var eventNum:int; // It has percentage of happening whole event
		public static var missionNum:int; // It has percentage of happening whole missions
		public static var limitTurn:Boolean;
		public static var auto:Boolean;
		public static var isMoreMove:Boolean;
		/* The percentage of happening whole event is 40%
		   The percentage of not happening event is 60% */
		
		public var gameState:int;
		public static var numberOfHorse:int;
		public var whoseTurn:int;
		public var horseIndex:int;
		public var movingSpeed:int;
		public var curLocIndex:int;
		public static var whoWin:int;
		private var curMapLoc:Array;
		private var rulResult:int;
		public var lastTurn:int;
		
		public var isColdGame:Boolean;
		public var player1On:Boolean;
		public var player2On:Boolean;
		public var firstStart:Boolean;
		public var skippedMove:Boolean;
		public var isMoveBack:Boolean;
		public var addingSpeed:Number;
		public var isShield:Boolean;
		public var processCount:int;
		public var isTwiceEvent:Boolean;
		
		// Game score definition
		public var caught:int;
		public var attached:int;
		public var goodVoice:int;
		
		// Sound
		public var addScoreSnd:Sound;
		private var catchOtherSnd:Sound;
		
		
		/* Mic
		/ The reason why I use two mic is
		/ org.wav mic is better than this mic
		/ in recording. but not alone, org.wav
		/ has shortage of functions of mic */
		public var mic:Microphone;
		public var recSound:Sound;
		public var recArray:ByteArray;
		
		public var board:Board;
		private var sideBoard:SideBoard;
		private var playerBoard:PlayerBoard;
		// private var rulletBoard:RulletBoard;
		
		public function GameScreen(){
			gameState = STATE_INIT;
			numberOfHorse = 2;
			movingSpeed = 500; // Duration
			eventFactor = 5;
			eventNotHappen = 60; // 60%
			missionNum = 5 ; // 5% the percentage of happening missions
			eventNum = 35; // 35% the percentage of happening events
			addingSpeed = 1.7;
			lastTurn = 50;
			processCount = 10;
			
			soundFlag = true;
			textFlag = true;
			miniFlag = true;
			limitTurn = true;
			auto = true;
			isMoreMove = false;
			isTwiceEvent = false;
			
			// Set scores users can get when below situations happen
			caught = 25;
			attached = 75;
			goodVoice = 10;
			
			// recArray = new ByteArray();
			// recSound = new Sound();
			mic = Microphone.getMicrophone();
			if(mic != null){
				micFlag = true;
				mic.gain = 70; // Volume of mic
				mic.rate = 44;
				mic.setUseEchoSuppression(true);
				mic.setLoopBack(true);
				mic.setLoopBack(false);
				mic.setSilenceLevel(40, 1000);
				// Security.showSettings(SecurityPanel.MICROPHONE);
				
				mic.addEventListener(StatusEvent.STATUS, onMicStatus);
				mic.addEventListener(ActivityEvent.ACTIVITY, onMicActivity);
				// mic.addEventListener(SampleDataEvent.SAMPLE_DATA, recordData);
				// recSound.addEventListener(SampleDataEvent.SAMPLE_DATA, encodingData);
			}
			else
				micFlag = false;
			
			trace("Mic: ", mic);
			addScoreSnd = new addScore_sound();
			catchOtherSnd = new catchOther_sound();
			
			createScreen();
		}
		
		private function onMicStatus(e:StatusEvent){
			if(e.code == "Microphone.Unmuted"){
				trace("Microphone access was allowed.");
				micFlag = true;
			}
			else if(e.code == "Microphone.Muted"){
				trace("Microphone access was denied.");
				micFlag = false;
			}
		}
		
		private function onMicActivity(e:ActivityEvent){
			trace("Active SilenceLevel: ", mic.silenceLevel);
			trace("Activity Level: ", mic.activityLevel);
		}
		
		public function recordData(e:SampleDataEvent){
			recArray.clear();
			
			while(e.data.bytesAvailable){
        		var s:Number = e.data.readFloat();
       			recArray.writeFloat(s);
   			}
		}
		
		public function encodingData(e:SampleDataEvent){
			if(!recArray.bytesAvailable > 0){
				return;
			}
			
			for(var i:int = 0; i < 8192; ++i){
				if(recArray.bytesAvailable > 0){
					var sample:Number = recArray.readFloat();
					e.data.writeFloat(sample);
					e.data.writeFloat(sample);
				}
			}
		}
		
		private function createScreen(){
			sideBoard = new SideBoard();
			board = new Board();
			playerBoard = new PlayerBoard();
			// rulletBoard = new RulletBoard();		
			
			addChild(sideBoard);
			addChild(board);
			addChild(playerBoard);
			// addChild(rulletBoard);
		}
		
		public function continueGame(e:Event){
			if(mic != null)
				trace("Activity Level: ", mic.activityLevel);
			switch(gameState){
				case STATE_INIT:
					init();
					break;
				case STATE_PLAYER:
					startPlayer();
					break;
				case STATE_RULLET:
					spinRullet();
					break;
				case STATE_HORSE:
					moveHorse();
					break;
				case STATE_END:
					endGame();
					break;
			}
		}
		
		private function init(){
			removeEventListener(Event.ENTER_FRAME, continueGame);
			curMapLoc = board.wordSet.getWordsLoc();
			mic.setSilenceLevel(100);
			
			rulResult = 0;
			whoseTurn = 1;
			horseIndex = -1;
			curLocIndex = 0;
			whoWin = 0;
			player1On = false;
			player2On = false;
			firstStart = true;
			oneMoreTurn = false;
			skippedMove = false;
			isShield = false;
			isColdGame = false;
			isTwiceEvent = false;
			turn = 1;
			trace(turn, "턴");
			
			// Init players
			board.player1.init(player1_name);
			board.player2.init(player2_name);
			board.init();
			board.mainPopup.init();
			board.wordSet.alreadyIn = false;
			board.wordSet.shuffleWords();
			board.locateWords();
			playerBoard.init();
			sideBoard.scoreBoard.init();
			board.updateSmallMap();
			
			PlayerBoard.canUseBtn = true;
			playerBoard.resetTurn();
			sideBoard.rullet.showIndex();
			sideBoard.rullet.initString();
			sideBoard.scoreBoard.showWhoseTurn(whoseTurn);
		}
		
		public function saveData(){
			Vocagame.so.data.soundFlag = soundFlag;
			Vocagame.so.data.textFlag = textFlag;
			Vocagame.so.data.miniFlag = miniFlag;
			Vocagame.so.data.nOfHorse = numberOfHorse;
		}
		
		public function loadData(){
			soundFlag = Vocagame.so.data.soundFlag;
			textFlag = Vocagame.so.data.textFlag;
			miniFlag = Vocagame.so.data.miniFlag;
			numberOfHorse = Vocagame.so.data.nOfHorse;
			
			board.loadData();
		}
		
		private function startPlayer(){
			removeEventListener(Event.ENTER_FRAME, continueGame);
			rulResult = sideBoard.rullet.getRulResult();
			
			if(oneMoreTurn)
				oneMoreTurn = false;
			
			var choseNum:int = -1;
			var foundFocus:Boolean = false;
			var isConfused:Boolean = false;
			var count:int = GameScreen.numberOfHorse;
			// If player is confused, turn over
			if(whoseTurn == 1){
				for(var i:int = 0; i < numberOfHorse; ++i){
					if(player1On && !foundFocus && board.player1.curLoc[i] >= 0){
						foundFocus = true;
						choseNum = i;
						board.focusOnHorse(board.player1.horses[i].y);
					}
					
					if(board.player1.confused[i] > 0){
						new break_sound().play(0, 0, Vocagame.effectTrans);
						--board.player1.confused[i];
						
						--count;
						isConfused = true;
						
						if(board.player1.confused[i] == 0)
							board.boardImage.removeChild(board.player1.confuse_array[i]);
					}
					else if(board.player1.curLoc[i] < 0)
						--count;
				}
					
				if(count == 0 && isConfused)
					board.showTextAnother("토끼는 휴식 중 ^^;");
			}
			else if(whoseTurn == 2 && gameMode == 2){
				for(i = 0; i < numberOfHorse; ++i){
					if(player2On && !foundFocus && board.player2.curLoc[i] >= 0){
						foundFocus = true;
						choseNum = i;
						board.focusOnHorse(board.player2.horses[i].y);
					}
					
					if(board.player2.confused[i] > 0){
						new break_sound().play(0, 0, Vocagame.effectTrans);
						--board.player2.confused[i];
					
						--count;
						isConfused = true;
						
						if(board.player2.confused[i] == 0)
							board.boardImage.removeChild(board.player2.confuse_array[i]);
					}
					else if(board.player2.curLoc[i] < 0)
						--count;
				}
						
				if(count == 0 && isConfused)
					board.showTextAnother("개구리는 휴식 중 ^^;");
			}
			
			if(firstStart)
				firstStart = false;
			
			var isMove:Boolean = true;
			
			if(!isConfused){
				if(rulResult == -1){
					trace("-1");
					// Investigate if horses can move
					count = GameScreen.numberOfHorse;
					for(i = 0; i < GameScreen.numberOfHorse; ++i)
						if(whoseTurn == 1){
							if(board.player1.curLoc[i] + rulResult < 0)
								count--;
						}
						else{
							if(board.player2.curLoc[i] + rulResult < 0)
								count--;
						}
						
					if(count == 0)
						isMove = false;
				}
			
				if(!isMove){
					sideBoard.rullet.initString();
					board.noticeCannotMove();
					skippedMove = false;
					isMoveBack = false;
				}
				else{
					// auto
					if(auto){
						if(foundFocus){
							if(whoseTurn == 1)
								MovieClip(board.player1.horses[choseNum]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							else
								MovieClip(board.player2.horses[choseNum]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						}
						else{
							if(whoseTurn == 1){
								for(i = 0; i < numberOfHorse; ++i)
									if(MovieClip(playerBoard.blueHorses[i]).alpha > 0.5){
										MovieClip(playerBoard.blueHorses[i]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
										break;
									}
							}
							else{
								for(i = 0; i < numberOfHorse; ++i)
									if(MovieClip(playerBoard.redHorses[i]).alpha > 0.5){
										MovieClip(playerBoard.redHorses[i]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
										break;
									}
							}
						}
					}
					else{
						playerBoard.changeState();
						board.player1.changeState();
						board.player2.changeState();
						board.showArrow();
					}
				}
			}
			else{
				sideBoard.rullet.initString();
				
				gameState = STATE_RULLET;
				addEventListener(Event.ENTER_FRAME, continueGame);
			}
		}
		
		private function spinRullet(){
			removeEventListener(Event.ENTER_FRAME, continueGame);
			board.isCardEventHappend = false;
			
			// turn Change
			if(gameMode == 2 && !firstStart && !oneMoreTurn)
				if(whoseTurn == 1)
					whoseTurn = 2;
				else
					whoseTurn = 1;
			
			if(limitTurn){
				if(turn == lastTurn - 1)
					board.showTextAnother("마지막 턴");
				
				if(turn == lastTurn){
					board.showTextAnother("전체 턴 종료");
				
					if(board.player1.getScore() > board.player2.getScore())		
						whoWin = 1;
					else if(board.player1.getScore() < board.player2.getScore())
						whoWin = 2;
					else{
						whoWin = 0;
						isColdGame = true;
					}
				
					var finishTimer:Timer = new Timer(2500, 1);
					finishTimer.addEventListener(TimerEvent.TIMER, finishTimerHandler);
					finishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishTimerCompleted);
					finishTimer.start();
				}
				else{
					++turn;
					PlayerBoard.canUseBtn = true;
					sideBoard.scoreBoard.showWhoseTurn(whoseTurn);
					sideBoard.rullet.changeWheelFlag();
					sideBoard.rullet.showIndex();
				}
			}
			else{
				++turn;
				PlayerBoard.canUseBtn = true;
				sideBoard.scoreBoard.showWhoseTurn(whoseTurn);
				sideBoard.rullet.changeWheelFlag();
				sideBoard.rullet.showIndex();
			}
			
			trace(turn, "턴");
			playerBoard.resetTurn();
			playerBoard.resetItem();
			sideBoard.scoreBoard.resetScore();
		}
		
		private function moveHorse(){
			removeEventListener(Event.ENTER_FRAME, continueGame);
			
			// If player has shoes, use it here
			if(whoseTurn == 1){
				if(board.player1.shoes){
					new shoes_sound().play(0, 0, Vocagame.effectTrans);
					if(rulResult < 3)
						rulResult = 3;
					
					rulResult *= addingSpeed;
					board.player1.shoes = false;
					board.showTextAnother("토끼는 신발을\n신고 달렸다");
					sideBoard.rullet.showString(String(rulResult));
				}
			}
			else if(whoseTurn == 2 && gameMode == 2){
				
				if(board.player2.shoes){
					new shoes_sound().play(0, 0, Vocagame.effectTrans)
					if(rulResult < 3)
						rulResult = 3;
						
					rulResult *= addingSpeed;
					board.player2.shoes = false;
					board.showTextAnother("개구리는 신발을\n신고 달렸다");
					sideBoard.rullet.showString(String(rulResult));
				}
			}
			playerBoard.resetItem();
			
			// User can enter this rootine through moveBackOrForward event
			var isMove:Boolean = true;
			if(!skippedMove){
				PlayerBoard.canUseBtn = false;
				
				if(!auto){
					playerBoard.changeState();
					board.player1.changeState();
					board.player2.changeState();
				}
			}
			else{
				skippedMove = false;
				isMoreMove = true;
				
				if(isMoveBack){
					isMoveBack = false;
					rulResult = -1;
				}
				else
					rulResult = 1;
				
				if(rulResult == -1){
					// Investigate if horses can move
					var count:int = GameScreen.numberOfHorse;
					for(var i:int = 0; i < GameScreen.numberOfHorse; ++i)
						if(whoseTurn == 1){
							if(board.player1.curLoc[i] + rulResult < 0)
								count--;
						}
						else{
							if(board.player2.curLoc[i] + rulResult < 0)
								count--;
						}
						
					if(count == 0){
						isMove = false;
						sideBoard.rullet.initString();
						board.noticeCannotMove();
					}
				}
			}
			
			if(isMove){
				if(whoseTurn == 1){
					player1On = true;
					curLocIndex = board.player1.curLoc[horseIndex];
					if(board.player1.curLoc[horseIndex] + rulResult < board.wordSet.wordsNum){
						board.boardImage.setChildIndex(MovieClip(board.player1.horses[horseIndex]), board.boardImage.numChildren - 1);
						var horseTimer:Timer = new Timer(movingSpeed + 100, Math.abs(rulResult));
						horseTimer.addEventListener(TimerEvent.TIMER, horseTimerHandler);
						horseTimer.addEventListener(TimerEvent.TIMER_COMPLETE, horseTimerCompleted);
						horseTimer.start();
						
						MovieClip(board.player1.horses[horseIndex]).play();
					}
					else{
						player1On = false;
						curLocIndex += rulResult;
						board.player1.removeHorse(horseIndex, true);
						board.player1.finCount++;
						board.player1.addScore(attached);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						board.showTextAnother("토끼가 목표 지점에\n 도착했어요!");
					
						if(board.player1.finCount == numberOfHorse){
							var finishTimer:Timer = new Timer(2500, 1);
							finishTimer.addEventListener(TimerEvent.TIMER, finishTimerHandler);
							finishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishTimerCompleted);
							finishTimer.start();
							
							whoWin = 1;
							gameState = STATE_END;
						}
					
						// update smallMap & process event & reset score
						sideBoard.rullet.initString();
						sideBoard.scoreBoard.resetScore();
						board.updateSmallMap();
					
						processEvent();
					}
				}
				else if(whoseTurn == 2 && gameMode == 2){
					player2On = true;
					curLocIndex = board.player2.curLoc[horseIndex];
					
					if(board.player2.curLoc[horseIndex] + rulResult < board.wordSet.wordsNum){
						board.boardImage.setChildIndex(MovieClip(board.player2.horses[horseIndex]), board.boardImage.numChildren - 1);
						horseTimer = new Timer(movingSpeed + 100, Math.abs(rulResult));
						horseTimer.addEventListener(TimerEvent.TIMER, horseTimerHandler);
						horseTimer.addEventListener(TimerEvent.TIMER_COMPLETE, horseTimerCompleted);
						horseTimer.start();
					}
					else{
						player2On = false;
						curLocIndex += rulResult;
						board.player2.removeHorse(horseIndex, true);
						board.player2.finCount++;
						board.player2.addScore(attached);
						addScoreSnd.play(0, 0, Vocagame.effectTrans);
						board.showTextAnother("개구리가 목표 지점에\n 도착했어요!");
					
						if(board.player2.finCount == numberOfHorse){
							finishTimer = new Timer(2500, 1);
							finishTimer.addEventListener(TimerEvent.TIMER, finishTimerHandler);
							finishTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishTimerCompleted);
							finishTimer.start();
							
							whoWin = 2;
							gameState = STATE_END;
						}
						
						// update smallMap & process event & reset score
						sideBoard.rullet.initString();
						sideBoard.scoreBoard.resetScore();
						board.updateSmallMap();
				
						processEvent();
					}
				}
			}
		}
		
		// Horse Timer Handler
		private function horseTimerHandler(e:TimerEvent){
			if(rulResult > 0)
				++curLocIndex;
			else if(rulResult == 0)
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			else
				--curLocIndex;
			
			if(whoseTurn == 1){
				board.moveHorse(MovieClip(board.player1.horses[horseIndex]),
								MovieClip(board.player1.horses[horseIndex]).x,
								MovieClip(board.player1.horses[horseIndex]).y,
								curMapLoc[curLocIndex][0],
								curMapLoc[curLocIndex][1]);
			}
			else if(whoseTurn == 2 && gameMode == 2){
				board.moveHorse2(MovieClip(board.player2.horses[horseIndex]),
								MovieClip(board.player2.horses[horseIndex]).x,
								MovieClip(board.player2.horses[horseIndex]).y,
								curMapLoc[curLocIndex][0],
								curMapLoc[curLocIndex][1]);
			}
		}
		
		// When horse timer is completed
		private function horseTimerCompleted(e:TimerEvent){
			sideBoard.rullet.initString();
			
			var waitTimer:Timer = new Timer(450, 1);
			waitTimer.addEventListener(TimerEvent.TIMER, waitTimerHandler);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, waitTimerCompleted);
			waitTimer.start();
		}
		
		// Wait Timer Handler
		private function waitTimerHandler(e:TimerEvent){
		}
		
		// When wait timer is completed
		private function waitTimerCompleted(e:TimerEvent){
			if(whoseTurn == 1)
				board.focusOnHorse(board.player1.horses[horseIndex].y);
			else
				board.focusOnHorse(board.player2.horses[horseIndex].y);
			
			afterMoveHorse();
		}
		
		public function afterMoveHorse(){
			if(whoseTurn == 1){
				board.player1.curLoc[horseIndex] = curLocIndex;
				MovieClip(board.player1.horses[horseIndex]).x = curMapLoc[curLocIndex][0];
				MovieClip(board.player1.horses[horseIndex]).y = curMapLoc[curLocIndex][1];
				
				// When blue horse catch red horse
				for(var i:int = 0; i < numberOfHorse; i++)
					if(board.player1.horses[horseIndex].hitTestObject(board.player2.horses[i])){
						if(!board.player2.shield){
							board.effectState = board.EFFECT_REMOVE;
							board.effectSpeed = 0.05;
							board.horseColor = 2;
							board.horseIndex = i;
							board.addEventListener(Event.ENTER_FRAME, board.applyEffect);
						
							board.player2.removeHorse(i, false);
							playerBoard.returnHorse(2, i);
							player2On = false;
							
							board.player1.addScore(caught);
							catchOtherSnd.play(0, 0, Vocagame.effectTrans);
							addScoreSnd.play(0, 0, Vocagame.effectTrans);
							board.showTextAnother("개구리를 잡았어요!");
							
							if(board.boardImage.contains(board.player2.confuse_array[i])){
							   board.boardImage.removeChild(board.player2.confuse_array[i]);
							}
						}
						else{
							new shield_sound().play(0, 0, Vocagame.effectTrans);
							board.showTextAnother("개구리는 방패로 막았다!");
							board.player2.shield = false;
							isShield = true;
							skippedMove = true;
							isMoveBack = true;
							
							gameState = STATE_HORSE;
							addEventListener(Event.ENTER_FRAME, continueGame);
						}
					}
					
				MovieClip(board.player1.horses[horseIndex]).gotoAndStop(4);
			}
			else if(whoseTurn == 2 && gameMode == 2){
				board.player2.curLoc[horseIndex] = curLocIndex;
				MovieClip(board.player2.horses[horseIndex]).x = curMapLoc[curLocIndex][0] - MovieClip(board.player2.horses[horseIndex]).width / 2;
				MovieClip(board.player2.horses[horseIndex]).y = curMapLoc[curLocIndex][1] - MovieClip(board.player2.horses[horseIndex]).height / 2;
				
				// When red horse catch blue horse
				for(i = 0; i < numberOfHorse; i++)
					if(board.player2.horses[horseIndex].hitTestObject(board.player1.horses[i])){
						if(!board.player1.shield){
							board.effectState = board.EFFECT_REMOVE;
							board.effectSpeed = 0.05;
							board.horseColor = 1;
							board.horseIndex = i;
							board.addEventListener(Event.ENTER_FRAME, board.applyEffect);
							
					  		board.player1.removeHorse(i, false);
					    	playerBoard.returnHorse(1, i);
							player1On = false;
							
							board.player2.addScore(caught);
							catchOtherSnd.play(0, 0, Vocagame.effectTrans);
							addScoreSnd.play(0, 0, Vocagame.effectTrans);
							board.showTextAnother("토끼를 잡았어요!");
							
							if(board.boardImage.contains(board.player1.confuse_array[i])){
							   board.boardImage.removeChild(board.player1.confuse_array[i]);
							}
						}
						else{
							new shield_sound().play(0, 0, Vocagame.effectTrans);
							board.showTextAnother("토끼는 방패로 막았다!");
							board.player1.shield = false;
							isShield = true;
							skippedMove = true;
							isMoveBack = true;
							
							gameState = STATE_HORSE;
							addEventListener(Event.ENTER_FRAME, continueGame);
						}
					}
			}
			
			sideBoard.scoreBoard.resetScore();
			
			var updateMapTimer:Timer = new Timer(200, 1);
			updateMapTimer.addEventListener(TimerEvent.TIMER, updateMapTimerHandler);
			updateMapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateMapTimerCompleted);
			updateMapTimer.start();
		}
		
		// updateMap Timer Handler
		private function updateMapTimerHandler(e:TimerEvent){
		}
		
		// When updateMap timer is completed
		private function updateMapTimerCompleted(e:TimerEvent){
			// update smallMap & process event
			board.updateSmallMap();
			
			processEvent();
		}
		
		// When horse is on some word
		public function processEvent(){
			// if(mic != null && !mic.muted)
			//    mic.setLoopBack(true);
			
			// If current horse doesn't arrive at goal point yet
			if(curLocIndex < board.wordSet.wordsNum){
				if(!isShield){
					if(isMoreMove){
						trace("More Move");
						isMoreMove = false;
						isTwiceEvent = true;
						board.startEvent();
					}
					else{
						board.voiceWord();
					}
				}
				else{
					isShield = false;
				}
				
				if(whoseTurn == 1){
					sideBoard.scoreBoard.addScore1.buttonMode = true;
					sideBoard.scoreBoard.addScore1.alpha = 1;
				}
				else{
					sideBoard.scoreBoard.addScore2.buttonMode = true;
					sideBoard.scoreBoard.addScore2.alpha = 1;
				}
			}
			else{
				if(gameState != STATE_END){
					gameState = STATE_RULLET;
					addEventListener(Event.ENTER_FRAME, continueGame);
				}
			}
		}
		
		// Finish Timer Handler
		private function finishTimerHandler(e:TimerEvent){
		}
		
		// When finish timer is completed
		private function finishTimerCompleted(e:TimerEvent){
			if(whoWin == 1)
				board.showTextAnother("토끼 승리 ^^V");
			else if(whoWin == 2)
				board.showTextAnother("개구리 승리 ^^V");
			else{
				board.showTextAnother("서로 비겼어요 !");
			}
			
			if(isColdGame){
				if(Vocagame.bgName != "duduBG"){
					Vocagame.bgName = "duduBG";
					SoundMixer.stopAll();
					Vocagame.bgChannel = new dududu_sound().play(0, 100000, Vocagame.bgTrans);
				}
				
				board.addChild(board.textSayDescript);
				board.addChildAt(board.popupBackground, board.getChildIndex(board.textSayDescript) - 1);
				board.textSayDescript.text = "서로 비겼어요~\n컴퓨터 추첨을 통해\n승자를 뽑겠습니다 !";
				new v_07().play(0, 0, Vocagame.effectTrans);
				
				var coldGameTimer:Timer = new Timer(1100, processCount);
				coldGameTimer.addEventListener(TimerEvent.TIMER, coldGameTimerHandler);
				coldGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, coldGameTimerCompleted);
				coldGameTimer.start();
			}
			else{
				gameState = STATE_END;
				addEventListener(Event.ENTER_FRAME, continueGame);
			}
		}
		
		// When game is over
		public function endGame(){
			trace("End Game");
			removeEventListener(Event.ENTER_FRAME, continueGame);
			
			if(!isColdGame)
				new end_sound().play(0, 0, Vocagame.effectTrans);
			
			PlayerBoard.canUseBtn = false;
			player1_score = board.player1.getScore();
			player2_score = board.player2.getScore();
			Vocagame(this.parent).setRank();
			board.addChild(board.popup);
			
			player1_score = 0;
			player2_score = 0;
		}
		
		// coldGame Timer Handler
		private function coldGameTimerHandler(e:TimerEvent){
			board.showTextAnother(String(processCount--));
		}
		
		// When coldGame timer is completed
		private function coldGameTimerCompleted(e:TimerEvent){
			board.removeChild(board.textSayDescript);
			board.removeChild(board.popupBackground);
			
			var randNum = Math.random() * 2 + 1;
			whoWin = randNum;
			new end_sound().play(0, 0, Vocagame.effectTrans);
			
			if(whoWin == 1)
				board.showTextAnother("토끼 승리 ^^V");
			else
				board.showTextAnother("개구리 승리 ^^V");
			
			if(Vocagame.bgName != "gameBG"){
				Vocagame.bgName = "gameBG";
				Vocagame.bgChannel.stop();
				Vocagame.bgChannel = getGameBGSnd().play(0, 1000000, Vocagame.bgTrans);
			}
			
			gameState = STATE_END;
			addEventListener(Event.ENTER_FRAME, continueGame);
		}
		
		// When game is asked to pause for ms
		public function sleep(ms:uint){
			var startingTime:uint = getTimer();
			while(true){
				if(getTimer() - startingTime >= ms)
					break;
			}
		}
		
		public function getPlayer1Loc():Array{
			return board.player1.curLoc;
		}
		
		public function getPlayer2Loc():Array{
			return board.player2.curLoc;
		}
		
		public function updateSmallMap(bitmpaData:BitmapData){
			sideBoard.setSmallMap(bitmpaData);
		}
		
		public function getBdWidth():Number{
			return board.getBdWidth();
		}
		
		public function getBdHeight():Number{
			return board.getBdHeight();;
		}
		
		public function getSmHeight():Number{
			return sideBoard.smallMap.getSmHeight();
		}
		
		public function setMapGauge(scr_gauge:Number){
			sideBoard.smallMap.setMapGauge(scr_gauge);
		}
		
		public function setScrGauge(scr_gauge:Number){
			board.setScrGauge(scr_gauge);
		}
		
		public function getPlayer1Score():int{
			return board.player1.getScore();
		}
		
		public function getPlayer2Score():int{
			return board.player2.getScore();
		}
		
		public function setPlayer1Score(num:int){
			board.player1.addScore(num);
		}
		
		public function setPlayer2Score(num:int){
			board.player2.addScore(num);
		}
		
		public function getGameBGSnd():Sound{
			return Vocagame(this.parent).gameBGSnd;
		}
		
		public function getWhoWin():int{
			return whoWin;
		}
		
		public function getRulResult():int{
			return rulResult;
		}
		
		public function getP1FinCount():int{
			return board.player1.finCount;
		}
		
		public function getP2FinCount():int{
			return board.player2.finCount;
		}
		
		public function resetScore(){
			sideBoard.scoreBoard.resetScore();
		}
		
		public function resetItem(){
			playerBoard.resetItem();
		}
		
		public function returnHorseToPlayerBoard(num:int, index:int){
			playerBoard.returnHorse(num, index);
		}
		
		public function closeOtherBeforeWheeling(){
			if(sideBoard.scoreBoard.addScore1.buttonMode == true){
				sideBoard.scoreBoard.addScore1.buttonMode = false;
				sideBoard.scoreBoard.addScore1.alpha = 0.2;
			}
			
			if(sideBoard.scoreBoard.addScore2.buttonMode == true){
				sideBoard.scoreBoard.addScore2.buttonMode = false;
				sideBoard.scoreBoard.addScore2.alpha = 0.2;
			}
			
			if(board.contains(board.voiceVolCircle)){
				board.removeChild(board._display);
				board.removeChild(board.voiceVolCircle);
				board.removeEventListener(MouseEvent.CLICK, board.playRecorded);
				board.voiceVolCircle.buttonMode = false;
			}
		}
		
		public function goToMenu(){
			if(Vocagame.bgName != "mainBG"){
				Vocagame.bgName = "mainBG";
				SoundMixer.stopAll();
				Vocagame.bgChannel =  Vocagame(this.parent).mainBGSnd.play(0, 1000000, Vocagame.bgTrans);
			}
			
			gameState = STATE_INIT;
			board.removeWords();
			board.wordSet.resetIndex();
			sideBoard.rullet.changeWheelFlag();
			sideBoard.scoreBoard.setIsClickedRullet();
			
			if(board.contains(board.voiceVolCircle)){
				board.removeChild(board._display);
				board.removeChild(board.voiceVolCircle);
				board.removeEventListener(MouseEvent.CLICK, board.playRecorded);
				board.voiceVolCircle.buttonMode = false;
			}
			
			this.parent.removeChild(this);
		}
	}
}