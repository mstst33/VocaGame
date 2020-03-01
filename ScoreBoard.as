package  {
	import flash.display.*
	import flash.events.*
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.utils.*;
	
	public class ScoreBoard extends Sprite{
		private var scWidth:Number;
		private var scHeight:Number;
		private var gap:Number;
		private var whoseTurn:int;
		private var isClickedRullet:Boolean;
		
		// GUI
		private var textformat1:TextFormat;
		private var textformat2:TextFormat;
		private var textformat3:TextFormat;
		private var textformat4:TextFormat;
		private var textformat5:TextFormat;
		
		private var p1Name:TextField;
		private var p2Name:TextField;
		private var p1Score:TextField;
		private var p2Score:TextField;
		private var p1Scores:Sprite;
		private var p2Scores:Sprite;
		private var p1ScoreShow:TextField;
		private var p2ScoreShow:TextField;
		
		private var showAddScore:TextField;
		private var showP1Name:TextField;
		private var showP2Name:TextField;
		
		private var showP1Turn:TextField;
		private var showP2Turn:TextField;
		
		private var character1:Sprite;
		private var character2:Sprite;
		
		private var carrotGraphic:Sprite;
		private var flyGraphic:Sprite;
		
		// Sound
		private var addScoreSnd:Sound;
		private var soundChannel:SoundChannel;
		
		// ScoreBoard & addScore
		private var scoreBoard:MovieClip;
		public var addScore1:MovieClip;
		public var addScore2:MovieClip;
		
		public function ScoreBoard(){
			addEventListener(Event.ADDED, added);
		}
		
		private function createScreen(){
			scoreBoard = new score_Board();
			scoreBoard.width =  scWidth;
			scoreBoard.height = scHeight;
			scoreBoard.x = SideBoard(this.parent).getLocationX();
			scoreBoard.y = SideBoard(this.parent).smallMap.getSmHeight() + gap * 2;
			scoreBoard.alpha = 0.9;
			
			// textfield of showing player1 turn
			showP1Turn = new TextField();
			showP1Turn.antiAliasType = AntiAliasType.ADVANCED;
			showP1Turn.width = scWidth + 5;
			showP1Turn.height = scHeight / 2 + 5;
			showP1Turn.background = false;
			showP1Turn.x = scoreBoard.x - 5;
			showP1Turn.y = scoreBoard.y - 5;
			showP1Turn.selectable = false;
			showP1Turn.border = true;
			showP1Turn.borderColor = 0xFF0000;
			
			// textfield of showing player2 turn
			showP2Turn = new TextField();
			showP2Turn.antiAliasType = AntiAliasType.ADVANCED;
			showP2Turn.width = scWidth + 5;
			showP2Turn.height = scHeight / 2;
			showP2Turn.background = false;
			showP2Turn.x = scoreBoard.x - 5;
			showP2Turn.y = scoreBoard.y + showP1Turn.height - 5;
			showP2Turn.selectable = false;
			showP2Turn.border = true;
			showP2Turn.borderColor = 0xFF0000;
			
			character1 = new ch_rabbit();
			character1.width =  scWidth / 4.5;
			character1.height = scWidth / 3.8;
			character1.x = SideBoard(this.parent).getLocationX() + gap * 6.1;
			character1.y = SideBoard(this.parent).smallMap.getSmHeight() + gap * 2;
			character1.alpha = 0.9;
			
			character2 = new ch_frog();
			character2.width =  scWidth / 4.5;
			character2.height = scWidth / 3.8;
			character2.x = SideBoard(this.parent).getLocationX() + gap * 6.1;
			character2.y = SideBoard(this.parent).smallMap.getSmHeight() + scoreBoard.height / 2 + gap * 3;
			character2.alpha = 0.9;
			
			addScore1 = new scoreUP_image();
			addScore1.width = scWidth / 13;
			addScore1.height = scWidth / 13;
			addScore1.x = scoreBoard.x + scWidth - addScore1.width * 1.5;
			addScore1.y = scoreBoard.y + gap;
			addScore1.alpha = 0.2;
			addScore1.buttonMode = false;
			addScore1.addEventListener(MouseEvent.CLICK, addScore1Handler);
			addScore1.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addScore1.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			addScore2 = new scoreUP_image();
			addScore2.width = scWidth / 13;
			addScore2.height = scWidth / 13;
			addScore2.x = scoreBoard.x + scWidth - addScore2.width * 1.5;
			addScore2.y = scoreBoard.y + scHeight / 2 + gap * 2;
			addScore2.alpha = 0.2;
			addScore2.buttonMode = false;
			addScore2.addEventListener(MouseEvent.CLICK, addScore2Handler);
			addScore2.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addScore2.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			addChild(scoreBoard);
			addChild(character1);
			addChild(addScore1);
			
			textformat1 = new TextFormat();
			textformat1.size = 20;
			textformat1.color = 0x4374D9;
			textformat1.align = "center";
			
			textformat2 = new TextFormat();
			textformat2.size = 20;
			textformat2.color = 0xFF5E00;
			textformat2.align = "center";
			
			textformat3 = new TextFormat();
			textformat3.size = 20;
			textformat3.color = 0x22741C;
			textformat3.align = "center";
			
			textformat4 = new TextFormat();
			textformat4.size = 20;
			textformat4.color = 0x000000;
			textformat4.align = "center";
			
			textformat5 = new TextFormat();
			textformat5.size = 15;
			textformat5.color = 0x0054FF;
			textformat5.align = "center";
			
			// textfield of showing player1 name
			p1Name = new TextField();
			p1Name.antiAliasType = AntiAliasType.ADVANCED;
			p1Name.autoSize = TextFieldAutoSize.LEFT;
			p1Name.background = false;
			p1Name.x = scoreBoard.x + scWidth / 2 + 2;
			p1Name.y = scoreBoard.y + gap;
			p1Name.selectable = false;
			p1Name.defaultTextFormat = textformat1;
			
			addChild(p1Name);
			
			// textfield of showing score string
			p1ScoreShow = new TextField();
			p1ScoreShow.antiAliasType = AntiAliasType.ADVANCED;
			p1ScoreShow.autoSize = TextFieldAutoSize.LEFT;
			p1ScoreShow.background = false;
			p1ScoreShow.x = scoreBoard.x + scWidth / 4 + gap * 7;
			p1ScoreShow.y = scoreBoard.y + scHeight / 4 - gap;
			p1ScoreShow.selectable = false;
			p1ScoreShow.border = true;
			p1ScoreShow.borderColor = 0x6799FF;
			p1ScoreShow.defaultTextFormat = textformat4;
			p1ScoreShow.text = "Score:";
			
			//addChild(p1ScoreShow);
			
			// textfield of showing player1 score
			/*
			p1Score = new TextField();
			p1Score.antiAliasType = AntiAliasType.ADVANCED;
			p1Score.autoSize = TextFieldAutoSize.LEFT;
			p1Score.background = false;
			p1Score.x = scoreBoard.x + scWidth / 2 + gap * 7;
			p1Score.y = scoreBoard.y + scHeight / 4 - gap;
			p1Score.selectable = false;
			p1Score.defaultTextFormat = textformat4;
			
			addChild(p1Score);*/
			
			carrotGraphic = new carrot();
			carrotGraphic.width = scWidth / 12;
			carrotGraphic.height = scHeight / 6;
			carrotGraphic.x = scoreBoard.x + scWidth / 4 + gap * 7;
			carrotGraphic.y = scoreBoard.y + scHeight / 4 - gap;
			
			p1Scores = NumberSpriteGeneration.getInst().generateNumber(0, 0);
			p1Scores.height = p1Scores.height / 1.4;
			p1Scores.x = carrotGraphic.x + carrotGraphic.width * 1.5;
			p1Scores.y = scoreBoard.y + scHeight / 4 - gap * 1.3;
			
			addChild(carrotGraphic);
			addChild(p1Scores);
			
			// textfield of showing player2 name
			p2Name = new TextField();
			p2Name.antiAliasType = AntiAliasType.ADVANCED;
			p2Name.autoSize = TextFieldAutoSize.LEFT;
			p2Name.background = false;
			p2Name.x = scoreBoard.x + scWidth / 2 + gap;
			p2Name.y = scoreBoard.y + scHeight / 2 + gap * 2;
			p2Name.selectable = false;
			p2Name.defaultTextFormat = textformat2;
			
			// textfield of showing score string
			p2ScoreShow = new TextField();
			p2ScoreShow.antiAliasType = AntiAliasType.ADVANCED;
			p2ScoreShow.autoSize = TextFieldAutoSize.LEFT;
			p2ScoreShow.background = false;
			p2ScoreShow.x = scoreBoard.x + scWidth / 4 + gap * 7;
			p2ScoreShow.y = scoreBoard.y + (3 * scHeight) / 4 + gap;
			p2ScoreShow.selectable = false;
			p2ScoreShow.border = true;
			p2ScoreShow.borderColor = 0x6799FF;
			p2ScoreShow.defaultTextFormat = textformat4;
			p2ScoreShow.text = "Score:";
			
			// textfield of showing player1 score
			/*
			p2Score = new TextField();
			p2Score.antiAliasType = AntiAliasType.ADVANCED;
			p2Score.autoSize = TextFieldAutoSize.LEFT;
			p2Score.background = false;
			p2Score.x = scoreBoard.x + scWidth / 2 + gap * 7;
			p2Score.y = scoreBoard.y + (3 * scHeight) / 4 + gap;
			p2Score.selectable = false;
			p2Score.defaultTextFormat = textformat4;*/
			
			flyGraphic = new carrot();
			flyGraphic.width = scWidth / 12;
			flyGraphic.height = scHeight / 6;
			flyGraphic.x = scoreBoard.x + scWidth / 4 + gap * 7;;
			flyGraphic.y = scoreBoard.y + (3 * scHeight) / 4 + gap;
			
			p2Scores = NumberSpriteGeneration.getInst().generateNumber(0, 0);
			p2Scores.height = p2Scores.height / 1.4;
			p2Scores.x = flyGraphic.x + flyGraphic.width * 1.5;
			p2Scores.y = scoreBoard.y + (3 * scHeight) / 4 + gap * 0.5;
			
			// textfield of showing addScore string
			showAddScore = new TextField();
			showAddScore.antiAliasType = AntiAliasType.ADVANCED;
			showAddScore.autoSize = TextFieldAutoSize.LEFT;
			showAddScore.background = false;
			showAddScore.x = scoreBoard.x;
			showAddScore.y = scoreBoard.y + scHeight;
			showAddScore.selectable = false;
			showAddScore.border = true;
			showAddScore.borderColor = 0x3DB7CC;
			showAddScore.defaultTextFormat = textformat5;
			showAddScore.text = "- Add Score -";
			
			addChild(showAddScore);
			
			// textfield of showing player1 string
			showP1Name = new TextField();
			showP1Name.antiAliasType = AntiAliasType.ADVANCED;
			showP1Name.autoSize = TextFieldAutoSize.LEFT;
			showP1Name.background = false;
			showP1Name.x = scoreBoard.x + showAddScore.width * 1.2;
			showP1Name.y = showAddScore.y;
			showP1Name.selectable = false;
			showP1Name.defaultTextFormat = textformat5;
			showP1Name.text = "Player1:";
			
			addChild(showP1Name);
			
			addScore1.x = showP1Name.x + showP1Name.width * 1.2;
			addScore1.y = showAddScore.y;
			
			// textfield of showing player2 string
			showP2Name = new TextField();
			showP2Name.antiAliasType = AntiAliasType.ADVANCED;
			showP2Name.autoSize = TextFieldAutoSize.LEFT;
			showP2Name.background = false;
			showP2Name.x = addScore1.x + addScore1.width * 1.2;
			showP2Name.y = showAddScore.y;
			showP2Name.selectable = false;
			showP2Name.defaultTextFormat = textformat5;
			showP2Name.text = "Player2:";
			
			addScore2.x = showP2Name.x + showP2Name.width * 1.2;
			addScore2.y = showAddScore.y;
		}
		
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			gap = 5;
			scWidth = SideBoard(this.parent).getSbWidth() - gap;
			scHeight = (1 * Vocagame.screenHeight) / 5;
			
			addScoreSnd = new addScore_sound();
			
			createScreen();
		}
		
		public function init(){
			p1Name.text = GameScreen.player1_name;
			p2Name.text = GameScreen.player2_name;
			
			whoseTurn = 0;
			isClickedRullet = false;
			resetScore();
			
			// p1Score.text = SideBoard(this.parent).getPlayer1Score().toString();
			// p2Score.text = SideBoard(this.parent).getPlayer2Score().toString();
			
			if(this.contains(p2Name)){
				removeChild(p2Name);
				removeChild(p2Scores);
				removeChild(flyGraphic);
				//removeChild(p2ScoreShow);
				removeChild(showP2Name);
				removeChild(addScore2);
				removeChild(character2);
			}
			
			if(GameScreen.gameMode == 2){
				addChild(p2Name);
				addChild(p2Scores);
				addChild(flyGraphic);
				//addChild(p2ScoreShow);
				addChild(showP2Name);
				addChild(addScore2);
				addChild(character2);
			}
		}
		
		private function addScore1Handler(e:MouseEvent){
			if(addScore1.buttonMode){
				addScoreSnd.play(0, 0, Vocagame.effectTrans);
				
				SideBoard(this.parent).setPlayer1Score();
				// p1Score.text = SideBoard(this.parent).getPlayer1Score().toString();
				resetScore();
				addScore1.alpha = 0.2;
				addScore1.buttonMode = false;
				
				new Tween(addScore1, "width", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
				new Tween(addScore1, "height", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
			}
		}
		
		private function addScore2Handler(e:MouseEvent){
			if(addScore2.buttonMode){
				addScoreSnd.play(0, 0, Vocagame.effectTrans);
				
				SideBoard(this.parent).setPlayer2Score();
				// p2Score.text = SideBoard(this.parent).getPlayer2Score().toString();
				resetScore();
				addScore2.alpha = 0.2;
				addScore2.buttonMode = false;
				
				new Tween(addScore2, "width", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
				new Tween(addScore2, "height", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
			}
		}
		
		private function overHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			if(btn.buttonMode == true){
				new Tween(btn, "width", Strong.easeOut, scWidth / 13, scWidth / 13 * 1.2, 1, true);
				new Tween(btn, "height", Strong.easeOut, scWidth / 13, scWidth / 13 * 1.2 , 1, true);
			}
		}

		private function outHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			
			if(btn.buttonMode == true){
				new Tween(btn, "width", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
				new Tween(btn, "height", Strong.easeOut, scWidth / 13 * 1.2 , scWidth / 13, 1, true);
			}
		}
		
		public function showWhoseTurn(whoseTurn:int){
			this.whoseTurn = whoseTurn;
			
			var showTimer:Timer = new Timer(500, 0);
			showTimer.addEventListener(TimerEvent.TIMER, showTimerHandler);
			showTimer.start();
		}
		
		// show Handler
		private function showTimerHandler(e:TimerEvent){
			if(whoseTurn == 1){
				if(this.contains(showP2Turn))
				    removeChild(showP2Turn);
					
				if(this.contains(showP1Turn))
				    removeChild(showP1Turn);
				else
					addChildAt(showP1Turn, this.numChildren);
			}
			else{
				if(this.contains(showP1Turn))
				    removeChild(showP1Turn);
				
				if(this.contains(showP2Turn))
				    removeChild(showP2Turn);
				else
					addChildAt(showP2Turn, this.numChildren);
			}
			
			if(isClickedRullet){
				if(whoseTurn == 1){
					if(!this.contains(showP1Turn))
						addChildAt(showP1Turn, this.numChildren);
						
					if(this.contains(showP2Turn))
						removeChild(showP2Turn);
				}
				else{
					if(!this.contains(showP2Turn))
						addChildAt(showP2Turn, this.numChildren);
						
					if(this.contains(showP1Turn))
						removeChild(showP1Turn);
				}
				
				Timer(e.target).stop();
			}
		}
		
		public function resetScore(){
			if(this.contains(p1Scores))
				removeChild(p1Scores);
			
			p1Scores = NumberSpriteGeneration.getInst().generateNumber(0, SideBoard(this.parent).getPlayer1Score());
			p1Scores.height = p1Scores.height / 1.4;
			p1Scores.x = carrotGraphic.x + carrotGraphic.width * 1.5;
			p1Scores.y = scoreBoard.y + scHeight / 4 - gap * 1.3;;
			addChild(p1Scores);
			
			if(GameScreen.gameMode == 2){
				if(this.contains(p2Scores))
			   		removeChild(p2Scores);
				
				p2Scores = NumberSpriteGeneration.getInst().generateNumber(0, SideBoard(this.parent).getPlayer2Score());
				p2Scores.height = p2Scores.height / 1.4;
				p2Scores.x = flyGraphic.x + flyGraphic.width * 1.5;
				p2Scores.y = scoreBoard.y + (3 * scHeight) / 4 + gap * 0.5;
				addChild(p2Scores);
			}
			
			// p1Score.text = SideBoard(this.parent).getPlayer1Score().toString();
			// p2Score.text = SideBoard(this.parent).getPlayer2Score().toString();
		}
		
		public function getScHeight():Number{
			return scHeight;
		}
		
		public function setIsClickedRullet(){
			if(isClickedRullet)
				isClickedRullet = false;
			else
				isClickedRullet = true;
		}
	}	
}