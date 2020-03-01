package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.geom.Rectangle;
	
	public class PlayerBoard extends Sprite{
		const BUT_WIDTH:Number = Vocagame.screenWidth / 20; // exit button width
		const BUT_HEIGHT:Number = Vocagame.screenWidth / 30; // exit button Height
		private var pbWidth:Number;
		private var pbHeight:Number;
		private var bg_color:uint = 0xD9E5FF;
		private var gap:Number;
		
		private var rect:MovieClip;
		public var blueHorses:Array;
		public var redHorses:Array;
		
		public var arr_index1:MovieClip;
		public var arr_index2:MovieClip;
		
		public var curBlueIndex:int;
		public var curRedIndex:int;

		// GUI
		private var textformat1:TextFormat;
		private var textformat2:TextFormat;
		private var textformat3:TextFormat;
		private var p1Name:TextField;
		private var p2Name:TextField;
		public var turnText:TextField;
		public var itemArray:Array;
		public var itemNum:int;
		
		// Button sound
		public static var canUseBtn:Boolean;
		private var backBtn:MovieClip; // goToMain Button
		private var btnOverSnd:Sound;
		private var btnClickSnd:Sound;
		
		public function PlayerBoard(){
			addEventListener(Event.ADDED, added);
			canUseBtn = true;
			itemNum = 3;
			
			btnOverSnd = new onBtn_sound();
			btnClickSnd = new clickBtn_sound();
		}

		public function createScreen(){
			rect = new MovieClip();
			rect.graphics.clear();
			rect.graphics.beginFill(bg_color, 0.95);
			rect.graphics.drawRect(0, 0, pbWidth - gap / 4, pbHeight);
			rect.graphics.endFill();
			
			addChild(rect);
			
			textformat1 = new TextFormat();
			textformat1.size = 30;
			textformat1.color = 0x4374D9;
			textformat1.align = "center";
			
			textformat2 = new TextFormat();
			textformat2.size = 30;
			textformat2.color = 0xFF5E00;
			textformat2.align = "center";
			
			textformat3 = new TextFormat();
			textformat3.size = 30;
			textformat3.color = 0x000000;
			textformat3.align = "center";
			
			// textfield of showing player1 name
			p1Name = new TextField();
			p1Name.antiAliasType = AntiAliasType.ADVANCED;
			p1Name.autoSize = TextFieldAutoSize.LEFT;
			p1Name.background = false;
			p1Name.x = gap / 2;
			p1Name.y = pbHeight / 13;
			p1Name.selectable = false;
			p1Name.defaultTextFormat = textformat1;
			
			addChild(p1Name);
			
			arr_index1 = new arrow_index();
			arr_index1.width = 35;
			arr_index1.height = 35;
			arr_index1.x = p1Name.x + p1Name.width;
			arr_index1.y = p1Name.y + p1Name.height;
			
			// textfield of showing player2 name
			p2Name = new TextField();
			p2Name.antiAliasType = AntiAliasType.ADVANCED;
			p2Name.autoSize = TextFieldAutoSize.LEFT;
			p2Name.background = false;
			p2Name.x = pbWidth / 2 + gap / 2;
			p2Name.y = pbHeight / 13;
			p2Name.selectable = false;
			p2Name.defaultTextFormat = textformat2;
			
			// textfield of showing turn
			turnText = new TextField();
			turnText.antiAliasType = AntiAliasType.ADVANCED;
			turnText.autoSize = TextFieldAutoSize.CENTER;
			turnText.background = true;
			turnText.backgroundColor = 0xB2CCFF;
			turnText.border = true;
			turnText.borderColor = 0x6799FF;
			turnText.selectable = false;
			turnText.defaultTextFormat = textformat3;
			turnText.text = " " + String(GameScreen.turn) + " 턴";
			turnText.x = pbWidth / 2 - turnText.width;
			turnText.y = pbHeight / 13;
			addChild(turnText);
			
			arr_index2 = new arrow_index();
			arr_index2.width = 35;
			arr_index2.height = 35;
			arr_index2.x = p2Name.x + p2Name.width;
			arr_index2.y = p2Name.y + p2Name.height;
			
			backBtn = new backBtn_image();
			backBtn.width = BUT_WIDTH;
			backBtn.height = BUT_HEIGHT;
			backBtn.x = GameScreen(this.parent).getBdWidth() - backBtn.width * 1.2;
			backBtn.y = backBtn.height / 15;
			backBtn.buttonMode = true;
			backBtn.alpha = 0.95;
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			backBtn.addEventListener(MouseEvent.CLICK, goToStage);
			addChild(backBtn);
			
			itemArray = new Array();
			for(var i:int = 0; i < 2; ++i)
				for(var j:int = 0; j < itemNum; ++j){
					var item:Sprite;
					var borText:TextField = new TextField();
					switch(j){
						case 0:
							item = new weapon();
							break;
						case 1:
							item = new shield();
							break;
						case 2:
							item = new shoes();
							break;
					}
					item.addEventListener(MouseEvent.CLICK, useItem);
					item.width = turnText.height;
					item.height = turnText.height;
					item.alpha = 0.1;
					item.y = turnText.y;
					
					if(i == 0)
						item.x = turnText.x - (3 - j) * item.width - (gap / 3) * ((2 - j) + 4);
					else
						item.x = backBtn.x - (3 - j) * item.width - (gap / 3) * ((2 - j) + 2);
					
					itemArray.push(item);
					
					borText.width = item.width;
					borText.height = item.height;
					borText.background = true;
					borText.backgroundColor = 0xF6F6F6;
					borText.border = true;
					borText.borderColor = 0xBDBDBD;
					borText.selectable = false;
					borText.x = item.x;
					borText.y = item.y;
					
					addChild(borText);
					addChild(item);
				}
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			pbWidth = GameScreen(this.parent).getBdWidth();
			pbHeight = Vocagame.screenHeight / 15;
			gap = 30;
			
			blueHorses = new Array();
			redHorses = new Array();
			
			createScreen();
		}
		
		public function init(){
			p1Name.text = GameScreen.player1_name + ":";
			p2Name.text = GameScreen.player2_name + ":";
			
			arr_index1.x = p1Name.x + p1Name.width * 1.1;
			arr_index1.y = p1Name.y + p1Name.height / 2.9;
			arr_index2.x = p2Name.x + p2Name.width * 1.1;
			arr_index2.y = p2Name.y + p2Name.height / 2.9;
			
			
			if(blueHorses.length != 0)
				for(var i:int = blueHorses.length - 1; i >= 0; i--){
					if(this.contains(blueHorses[i]))
						removeChild(blueHorses[i]);
					blueHorses.pop();
				}
				
			if(redHorses.length != 0)
				for(i = redHorses.length - 1; i >= 0; i--){
					if(this.contains(redHorses[i]))
						removeChild(redHorses[i]);
					redHorses.pop();
				}
			
			for(i = 0; i < itemNum * 2; ++i){
				Sprite(itemArray[i]).alpha = 0.1;
				Sprite(itemArray[i]).buttonMode = false;
			}
			
			if(contains(arr_index1))
				removeChild(arr_index1);
			
			if(contains(arr_index2))
				removeChild(arr_index2);
			
			for(i = 0; i < GameScreen.numberOfHorse; i++){
				blueHorses.push(new blueHorse_image());
				
				MovieClip(blueHorses[i]).y = pbHeight - pbHeight / 2;
				MovieClip(blueHorses[i]).width = pbWidth / 45;
				MovieClip(blueHorses[i]).height = (7 * pbHeight) / 13;
				MovieClip(blueHorses[i]).stop();
				MovieClip(blueHorses[i]).addEventListener(MouseEvent.CLICK, newEnterA);
				
				addChild(blueHorses[i]);
				
				redHorses.push(new redHorse_image());
				
				MovieClip(redHorses[i]).width = pbWidth / 35;
				MovieClip(redHorses[i]).height = (7 * pbHeight) / 13;
				MovieClip(redHorses[i]).y = pbHeight - pbHeight / 2 - MovieClip(redHorses[i]).height / 2;
				MovieClip(redHorses[i]).addEventListener(MouseEvent.CLICK, newEnterB);
			}
			
			for(i = 0; i < GameScreen.numberOfHorse; i++){
				if(i == 0)
					MovieClip(blueHorses[i]).x = p1Name.x + p1Name.width + gap;
				else
					MovieClip(blueHorses[i]).x = MovieClip(blueHorses[0]).x + gap * i;
					
				MovieClip(blueHorses[i]).buttonMode = false;
				MovieClip(blueHorses[i]).alpha = 0.95;	
					
				if(i == 0)
					MovieClip(redHorses[i]).x = p2Name.x + p2Name.width + gap - MovieClip(redHorses[i]).width / 2;
				else
					MovieClip(redHorses[i]).x = MovieClip(redHorses[0]).x + gap * i;
					
				MovieClip(redHorses[i]).buttonMode = false;
				MovieClip(redHorses[i]).alpha = 0.95;
				
				if(this.contains(redHorses[i])){
					removeChild(p2Name);
					removeChild(redHorses[i]);
				}
				
				if(GameScreen.gameMode == 2){
					addChild(p2Name);
					addChild(redHorses[i]);
				}
			}
		}
		
		private function useItem(num:int){
			
		}
		
		public function resetItem(){
			var count = 0;
			if(GameScreen(this.parent).board.player1.weapon)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
			++count;
			if(GameScreen(this.parent).board.player1.shield)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
			++count;
			if(GameScreen(this.parent).board.player1.shoes)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
			++count;
			if(GameScreen(this.parent).board.player2.weapon)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
			++count;
			if(GameScreen(this.parent).board.player2.shield)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
			++count;
			if(GameScreen(this.parent).board.player2.shoes)
				itemArray[count].alpha = 0.95;
			else
				itemArray[count].alpha = 0.1;
		}
		
		private function newEnterA(e:MouseEvent){
			if(GameScreen(this.parent).gameState == GameScreen(this.parent).STATE_PLAYER &&
			   GameScreen(this.parent).whoseTurn == 1 && GameScreen(this.parent).getRulResult() != -1){
				var enter:Boolean = false;
				for(var i:int = 0; i < GameScreen.numberOfHorse; i++)
					if(e.target == blueHorses[i].valueOf() &&
					   GameScreen(this.parent).getPlayer1Loc()[i] == -1){
						curBlueIndex = i;
					    enter = true;
					}
					
				if(enter){
					MovieClip(e.target).alpha = 0.1;
					MovieClip(e.target).buttonMode = false;
					GameScreen(this.parent).horseIndex = curBlueIndex;
					GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_HORSE;
					GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
					GameScreen(this.parent).board.focusOnHorse(GameScreen(this.parent).board.player1.horses[curBlueIndex].y);
				}
			}
		}
		
		private function newEnterB(e:MouseEvent){
			if(GameScreen(this.parent).gameState == GameScreen(this.parent).STATE_PLAYER &&
			   GameScreen(this.parent).whoseTurn == 2 && GameScreen(this.parent).getRulResult() != -1){
				var enter:Boolean = false;
				for(var i:int = 0; i < GameScreen.numberOfHorse; i++)
					if(e.target == redHorses[i].valueOf() &&
					   GameScreen(this.parent).getPlayer2Loc()[i] == -1){
						curRedIndex = i;
					    enter = true;
					}
					
				if(enter){
					MovieClip(e.target).alpha = 0.1;
					MovieClip(e.target).buttonMode = false;
					GameScreen(this.parent).horseIndex = curRedIndex;
					GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_HORSE;
					GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
					GameScreen(this.parent).board.focusOnHorse(GameScreen(this.parent).board.player2.horses[curRedIndex].y);
				}
			}
		}
		
		public function returnHorse(which:int, num:int){
			if(which == 1){
				MovieClip(blueHorses[num]).alpha = 0.95;
				MovieClip(blueHorses[num]).buttonMode = false;
			}
			else{
				MovieClip(redHorses[num]).alpha = 0.95;
				MovieClip(redHorses[num]).buttonMode = false;
			}
		}
		
		public function resetTurn(){
			turnText.text = " " + String(GameScreen.turn) + " 턴";
			turnText.x = pbWidth / 2 - turnText.width;
		}
		
		public function changeState(){
			// When it is playerTurn
			if(GameScreen(this.parent).gameState == GameScreen(this.parent).STATE_PLAYER){
				if(GameScreen(this.parent).whoseTurn == 1){
					if(!GameScreen(this.parent).player1On){
						for(var i:int = 0; i < GameScreen.numberOfHorse; i++)
							if(GameScreen(this.parent).getPlayer1Loc()[i] == -1)
								MovieClip(blueHorses[i]).buttonMode = true;
								
						addChild(arr_index1);
					}
				}
				else{
					if(!GameScreen(this.parent).player2On){
						for(i = 0; i < GameScreen.numberOfHorse; i++)
							if(GameScreen(this.parent).getPlayer2Loc()[i] == -1)
								MovieClip(redHorses[i]).buttonMode = true;
								
						addChild(arr_index2);
					}
				}
			}
			else{
				for(i = 0; i < GameScreen.numberOfHorse; i++){
					MovieClip(blueHorses[i]).buttonMode = false;
					MovieClip(redHorses[i]).buttonMode = false;
				}
				
				if(this.contains(arr_index1))
				   removeChild(arr_index1);
				   
				if(this.contains(arr_index2))
				   removeChild(arr_index2);
			}
		}
		
		private function overHandler(e:MouseEvent){
			if(canUseBtn){
				btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
				var btn:MovieClip = e.target as MovieClip;
				new Tween(btn, "width", Strong.easeOut, BUT_WIDTH, BUT_WIDTH + BUT_WIDTH / 8, 1, true);
				new Tween(btn, "height", Strong.easeOut, BUT_HEIGHT, BUT_HEIGHT + BUT_HEIGHT / 8, 1, true);
			}
		}

		private function outHandler(e:MouseEvent){
			if(canUseBtn){
				var btn:MovieClip = e.target as MovieClip;
				new Tween(btn, "width", Strong.easeOut, BUT_WIDTH + BUT_WIDTH / 8, BUT_WIDTH, 1, true);
				new Tween(btn, "height", Strong.easeOut, BUT_HEIGHT + BUT_HEIGHT / 8, BUT_HEIGHT, 1, true);
			}
		}
		
		private function goToStage(e:MouseEvent){
			if(canUseBtn){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
			
				Vocagame.gameState = 1;
				GameScreen(this.parent).goToMenu();
			}
		}
	}
}