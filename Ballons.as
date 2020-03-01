package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle; // new
	import flash.media.Sound; //new
	import flash.text.*; //new
	import flash.system.*;
	import flash.net.LocalConnection;
	import flash.external.ExternalInterface;
	
	public class Ballons extends  flash.display.MovieClip{
		
		public static const STATE_INIT:int = 10;
		public static const STATE_PLAY:int = 20;
		public static const STATE_END_GAME:int = 30;
		
		public var gameState:int = 0;
		public var score:int = 0; //chnaged from clicks to score
		public var chances:int = 0; //new
		
		public var bg:MovieClip; //new
		public var enemies:Array; //new
		public var player:MovieClip; //new
		public var level:Number = 0; //new
		
		//text
		public var textformat:TextFormat = new TextFormat();
		public var textformat2:TextFormat = new TextFormat();
		public var scoreLabel:TextField = new TextField();
		public var levelLabel:TextField = new TextField();
		public var chancesLabel:TextField = new TextField();
		public var scoreText:TextField = new TextField();
		public var levelText:TextField = new TextField();
		public var chancesText:TextField = new TextField();
		
		private var lc:LocalConnection;
		public var eventNum:int;
		public var whoseTurn:int;
		
		public const SCOREBOARD_Y:Number = 370;
		
		public function Ballons() {
			/*
			lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS, onstatus);
			lc.allowDomain("*");
			Security.allowDomain("*");*/
			
			// addEventListener(Event.ENTER_FRAME, gameLoop);
			bg = new BackImage2();
			addChild(bg); //new
			textformat = new TextFormat();
			textformat.size = 25;
			textformat.color = 0x0054FF;
			textformat.align = "left";
			
			textformat2 = new TextFormat();
			textformat2.size = 25;
			textformat2.color = 0x002266;
			textformat2.align = "left";
			
			scoreLabel.antiAliasType = AntiAliasType.ADVANCED;
			scoreLabel.autoSize = TextFieldAutoSize.LEFT;
			scoreLabel.defaultTextFormat = textformat;
			
			levelLabel.antiAliasType = AntiAliasType.ADVANCED;
			levelLabel.autoSize = TextFieldAutoSize.LEFT;
			levelLabel.defaultTextFormat = textformat;
			
			chancesLabel.antiAliasType = AntiAliasType.ADVANCED;
			chancesLabel.autoSize = TextFieldAutoSize.LEFT;
			chancesLabel.defaultTextFormat = textformat;
			
			scoreText.antiAliasType = AntiAliasType.ADVANCED;
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			scoreText.defaultTextFormat = textformat2;
			
			levelText.antiAliasType = AntiAliasType.ADVANCED;
			levelText.autoSize = TextFieldAutoSize.LEFT;
			levelText.defaultTextFormat = textformat2;
			
			chancesText.antiAliasType = AntiAliasType.ADVANCED;
			chancesText.autoSize = TextFieldAutoSize.LEFT;
			chancesText.defaultTextFormat = textformat2;
			
			scoreLabel.text = "Score:";
			levelLabel.text = "Level:";
			chancesLabel.text ="Life:"
			scoreText.text ="0";
			levelText.text ="1";
			chancesText.text ="3";
			
			scoreLabel.y = SCOREBOARD_Y;
			levelLabel.y = SCOREBOARD_Y;
			chancesLabel.y = SCOREBOARD_Y;
			scoreText.y = SCOREBOARD_Y;
			levelText.y = SCOREBOARD_Y;
			chancesText.y = SCOREBOARD_Y;
			scoreLabel.x = 5;
			scoreText.x  = scoreLabel.x + scoreLabel.width;
			chancesLabel.x = 105;
			chancesText.x = chancesLabel.x + chancesLabel.width;
			levelLabel.x = 180;
			levelText.x = levelLabel.x + levelLabel.width;
			
			addChild(scoreLabel);
			addChild(levelLabel);
			addChild(chancesLabel);
			addChild(scoreText);
			addChild(levelText);
			addChild(chancesText);
			
			gameState = STATE_INIT;
		}
		
		private function onstatus(e:StatusEvent){
			switch(e.level){
				case "status":
					trace("Local sended");
					break;
				case "error":
					trace("Local failed");
					break;
			}
		}
		
		public function gameLoop(e:Event):void {
			switch(gameState) {				
				case STATE_INIT :
					initGame();
					break
				case STATE_PLAY:
					playGame();
					break;
				case STATE_END_GAME:
					endGame();
					break;	
			}
		}		
		
		public function initGame():void {
			//stage.addEventListener(MouseEvent.CLICK, onMouseClickEvent); removed
			score = 0; //chnaged from clicks to score
			chances = 3;
			eventNum = 1;
			
			whoseTurn = MainPopup(this.parent).getWhoseTurn();
			if(whoseTurn == 1){
				player = new blueHorse_image();
				player.gotoAndStop(3);
			}
			else if(whoseTurn == 2){
				player = new redHorse_image();
				player.gotoAndStop(1);
			}
			else{
				player = new PlayerImage2();
			}
			
			enemies = new Array();
			level = 1;
			levelText.text = level.toString();
			addChild(player);
			player.startDrag(true,new flash.geom.Rectangle(0,0,550,400));
			gameState = STATE_PLAY;
		}
		
		public function playGame():void {
			//player.rotation+=15;
			makeEnemies();
			moveEnemies();
			testCollisions();
			testForEnd();
		}
		
		public function makeEnemies():void {
			var chance:Number = Math.floor(Math.random() *100);
			var tempEnemy:MovieClip;
			if (chance < 5 + level) {
				tempEnemy = new EnemyImage2()
				tempEnemy.speed = 6 + level * 2;
				tempEnemy.gotoAndStop(Math.floor(Math.random()*5)+1);
				tempEnemy.y = 420;
				tempEnemy.x = Math.floor(Math.random()*515)
				addChild(tempEnemy);
				enemies.push(tempEnemy);
			}
		}
		
		
		public function moveEnemies():void {
			var tempEnemy:MovieClip;
			for (var i:int = enemies.length-1;i>=0;i--) {
				tempEnemy = enemies[i];
				tempEnemy.y-=tempEnemy.speed;					
				if (tempEnemy.y < -35) {
					chances--;			
					chancesText.text = chances.toString();
					enemies.splice(i,1);		
					removeChild(tempEnemy);
				}
			}
		}
		
		public function testCollisions():void {
			var sound:Sound = new Pop();
			var tempEnemy:MovieClip;
			for (var i:int =enemies.length-1;i>=0;i--) {
				tempEnemy = enemies[i];
				if (tempEnemy.hitTestObject(player)) {
					score++;
					scoreText.text = score.toString();
					sound.play();
					enemies.splice(i,1);		
					removeChild(tempEnemy);
				}
			}
		}
		
		public function testForEnd():void {
			if (chances < 1 || level >= 3) {
				gameState = STATE_END_GAME;
			} else if(score > level*20) {
				level ++;
				levelText.text = level.toString();
			}
		}
		
		public function endGame():void {
			this.removeEventListener(Event.ENTER_FRAME, gameLoop);
			player.stopDrag();
			
			for(var i:int = 0; i< enemies.length; i++) {
				removeChild(enemies[i]);
				enemies =[];		
			}
			
			MainPopup(this.parent).eventNum = eventNum;
			MainPopup(this.parent).resultGame = level;
			this.dispatchEvent(new Event(Event.COMPLETE));
			gameState = STATE_INIT;
			
			//var eventNum:int = 1;
			//lc.send("MissionGame", "onComp", level, eventNum);
		}
	}
}