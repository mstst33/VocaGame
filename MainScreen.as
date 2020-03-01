package  {
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.ui.*;
	import flash.text.*;
	
	public class MainScreen extends Sprite{
		const BUT_WIDTH:Number = Vocagame.screenWidth / 7; // Stage button width
		const BUT_HEIGHT:Number = Vocagame.screenWidth / 15; // Stage button Height
		const BUT_ROW:uint = 1;
		const BUT_COL:uint = 5;
		
		private var gap_x:Number; // Gap_X between buttons
		private var gap_y:Number; // Gap_y between buttons
		
		// Button sound
		private var btnOverSnd:Sound;
		private var btnClickSnd:Sound;
		
		private var textformat:TextFormat;
		private var noticeText:TextField;
		
		private var mainScreen:MovieClip; // Main screen image
		private var onePlayBtn:MovieClip;
		private var twoPlayBtn:MovieClip;
		private var rankShowBtn:MovieClip;
		private var settingBtn:MovieClip;
		private var endGameBtn:MovieClip;
		
		private var popup:Popup;
		
		public function MainScreen(){
			gap_x = (Vocagame.screenWidth - BUT_WIDTH * BUT_COL) / (BUT_COL + 1);
			gap_y = (Vocagame.screenHeight - BUT_HEIGHT * BUT_ROW) / (BUT_ROW + 1);

			btnOverSnd = new onBtn_sound();
			btnClickSnd = new clickBtn_sound();	
			
			createScreen();
		}
		
		private function createScreen(){
			// Put main image on main screen
			mainScreen = new main_image();
			mainScreen.width = Vocagame.screenWidth;
			mainScreen.height = Vocagame.screenHeight;
			addChild(mainScreen);
			
			onePlayBtn = new oneBtn();
			onePlayBtn.width = BUT_WIDTH;
			onePlayBtn.height = BUT_HEIGHT;
			onePlayBtn.x = gap_x;
			onePlayBtn.y = (3 * Vocagame.screenHeight) / 4;
			onePlayBtn.buttonMode = true;
			onePlayBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler2);
			onePlayBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler2);
			onePlayBtn.addEventListener(MouseEvent.CLICK, openPopup);
			addChild(onePlayBtn);
			
			twoPlayBtn = new twoBtn();
			twoPlayBtn.width = BUT_WIDTH;
			twoPlayBtn.height = BUT_HEIGHT;
			twoPlayBtn.x = onePlayBtn.x + gap_x + BUT_WIDTH;
			twoPlayBtn.y = onePlayBtn.y;
			twoPlayBtn.buttonMode = true;
			twoPlayBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			twoPlayBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			twoPlayBtn.addEventListener(MouseEvent.CLICK, openPopup);
			addChild(twoPlayBtn);
			
			rankShowBtn = new rankBtn();
			rankShowBtn.width = BUT_WIDTH;
			rankShowBtn.height = BUT_HEIGHT;
			rankShowBtn.x = twoPlayBtn.x + gap_x + BUT_WIDTH;
			rankShowBtn.y = onePlayBtn.y;
			rankShowBtn.buttonMode = true;
			rankShowBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			rankShowBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			rankShowBtn.addEventListener(MouseEvent.CLICK, showRank);
			addChild(rankShowBtn);
			
			settingBtn = new setBtn();
			settingBtn.width = BUT_WIDTH;
			settingBtn.height = BUT_HEIGHT;
			settingBtn.x = rankShowBtn.x + gap_x + BUT_WIDTH;
			settingBtn.y = onePlayBtn.y;
			settingBtn.buttonMode = true;
			settingBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			settingBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			settingBtn.addEventListener(MouseEvent.CLICK, showSetting);
			addChild(settingBtn);
			
			endGameBtn = new finishBtn();
			endGameBtn.width = BUT_WIDTH;
			endGameBtn.height = BUT_HEIGHT;
			endGameBtn.x = settingBtn.x + gap_x + BUT_WIDTH;
			endGameBtn.y = onePlayBtn.y;
			endGameBtn.buttonMode = true;
			endGameBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			endGameBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			endGameBtn.addEventListener(MouseEvent.CLICK, endGame);
			addChild(endGameBtn);
			
			textformat = new TextFormat();
			textformat.size = 30;
			textformat.color = 0xFFC19E;
			textformat.align = "center";
			
			// textfield of showing name
			noticeText = new TextField();
			noticeText.antiAliasType = AntiAliasType.ADVANCED;
			noticeText.autoSize = TextFieldAutoSize.LEFT;
			noticeText.background = false;
			noticeText.x = Vocagame.screenWidth / 40;
			noticeText.y = Vocagame.screenHeight / 40;
			noticeText.text = "이 보드 게임은 상업용이 아닌 연구 목적으로 개발 되었습니다.\n무단 배포시 저작권 문제가 발생 될 수 있습니다.";
			noticeText.selectable = false;
			noticeText.setTextFormat(textformat);
			addChild(noticeText);
			
			// Create popup object
			popup = new Popup();
			popup.addEventListener(Event.REMOVED, goToSelectStage);
		}
		
		private function goToSelectStage(e:Event){
			if(popup.isCompleted){
				popup.isCompleted = false;
				
				Vocagame.gameState = Vocagame(this.parent).STATE_SELECT_STAGE;
				this.parent.removeChild(this);
			}
		}
		
		private function overHandler(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
			new Tween(MovieClip(e.target), "width", Strong.easeOut, BUT_WIDTH, BUT_WIDTH * 1.3, 1, true);
			new Tween(MovieClip(e.target), "height", Strong.easeOut, BUT_HEIGHT, BUT_HEIGHT * 1.3, 1, true);
		}

		private function outHandler(e:MouseEvent){
			new Tween(MovieClip(e.target), "width", Strong.easeOut, BUT_WIDTH * 1.3, BUT_WIDTH, 1, true);
			new Tween(MovieClip(e.target), "height", Strong.easeOut, BUT_HEIGHT * 1.3, BUT_HEIGHT, 1, true);
		}
		
		private function overHandler2(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
			new Tween(MovieClip(e.target), "width", Strong.easeOut, BUT_WIDTH, BUT_WIDTH * 1.3, 1, true);
			new Tween(MovieClip(e.target), "height", Strong.easeOut, BUT_HEIGHT, BUT_HEIGHT * 1.3, 1, true);
		}

		private function outHandler2(e:MouseEvent){
			new Tween(MovieClip(e.target), "width", Strong.easeOut, BUT_WIDTH * 1.3, BUT_WIDTH, 1, true);
			new Tween(MovieClip(e.target), "height", Strong.easeOut, BUT_HEIGHT * 1.3, BUT_HEIGHT, 1, true);
		}
		
		private function openPopup(e:MouseEvent){
			if(!this.contains(popup)){
				if(e.target == onePlayBtn.valueOf())
					GameScreen.gameMode = 1;
				else
					GameScreen.gameMode = 2;
				
				btnClickSnd.play(0, 0, Vocagame.effectTrans);			
				addChild(popup);
			}
		}
		
		private function showRank(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			
			Vocagame.gameState = Vocagame(this.parent).STATE_SHOW_RANK;
			this.parent.removeChild(this);
		}
		
		private function showSetting(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			
			Vocagame.gameState = Vocagame(this.parent).STATE_SETTING;
			this.parent.removeChild(this);
		}
		
		private function endGame(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);	
			
			Vocagame.gameState = Vocagame(this.parent).STATE_END_GAME;
			this.parent.removeChild(this);
		}
	}
}

	import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
		class Popup extends Sprite{
			private var popup_width:uint;
			private var popup_height:uint;
			private var bg_color:uint = 0xD4F4FA;
			private var bor_color:uint = 0x3DB7CC;
			
			public var isCompleted:Boolean;
			private var gapX:Number;
			private var gapY:Number;
			
			// GUI
			private var textformat:TextFormat;
			private var textformat2:TextFormat;
			
			private var show_name:TextField;
			private var input_name:TextField;
			private var show_alert:TextField;		
			private var show_name2:TextField;
			private var input_name2:TextField;
			private var show_alert2:TextField;
			private var show_gameMode:TextField;
			private var input_gameMode:TextField;
			
			private var close_pop:TextField;		
			private var confirm_btn:TextField;
			private var btnClickSnd:Sound;
			
			private var location_x:Number;
			private var location_y:Number;
			
			public function Popup(){
				popup_width = 450;
				popup_height = 195;
				location_x = Vocagame.screenWidth / 2 - popup_width / 2;
				location_y = Vocagame.screenHeight / 2 - popup_height / 2;
				isCompleted = false;
				gapX = 40;
				gapY = 40;
				
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
				
				// textfield of showing name
				show_name = new TextField();
				show_name.antiAliasType = AntiAliasType.ADVANCED;
				show_name.autoSize = TextFieldAutoSize.LEFT;
				show_name.background = false;
				show_name.x = location_x + popup_width / 17;
				show_name.y = location_y + popup_height / 17;
				show_name.text = "Player1 Name:";
				show_name.selectable = false;
				show_name.setTextFormat(textformat);
				addChild(show_name);
				
				// textfield of input name
				input_name = new TextField();
				input_name.antiAliasType = AntiAliasType.ADVANCED;
				input_name.width = popup_width / 2.5;
				input_name.height = show_name.height;
				input_name.background = false;
				input_name.x = show_name.x + gapX + popup_width / 2.5;
				input_name.y = show_name.y;
				input_name.border = true;
				input_name.borderColor = bor_color;
				input_name.type = TextFieldType.INPUT;
				input_name.defaultTextFormat = textformat2;
				input_name.addEventListener(TextEvent.TEXT_INPUT, inputText);
				addChild(input_name);
				
				// textfield of showing alert
				show_alert = new TextField();
				show_alert.antiAliasType = AntiAliasType.ADVANCED;
				show_alert.width = popup_width / 2.5;
				show_alert.height = show_name.height / 2;
				show_alert.background = false;
				show_alert.x = input_name.x;
				show_alert.y = show_name.y + input_name.height;
				show_alert.visible = false;
				show_alert.selectable = false;
				show_alert.addEventListener(TextEvent.TEXT_INPUT, inputText);
				addChild(show_alert);
				
				// textfield of showing name2
				show_name2 = new TextField();
				show_name2.antiAliasType = AntiAliasType.ADVANCED;
				show_name2.autoSize = TextFieldAutoSize.LEFT;
				show_name2.background = false;
				show_name2.x = location_x + popup_width / 17;
				show_name2.y = show_name.y + show_alert.height + gapY;
				show_name2.text = "Player2 Name:";
				show_name2.selectable = false;
				show_name2.setTextFormat(textformat);
				
				// textfield of input name2
				input_name2 = new TextField();
				input_name2.antiAliasType = AntiAliasType.ADVANCED;
				input_name2.width = popup_width / 2.5;
				input_name2.height = show_name2.height;
				input_name2.background = false;
				input_name2.x = show_name2.x  + gapX + popup_width / 2.5;
				input_name2.y = show_name2.y;
				input_name2.border = true;
				input_name2.borderColor = bor_color;
				input_name2.type = TextFieldType.INPUT;
				input_name2.defaultTextFormat = textformat2;
				input_name2.addEventListener(TextEvent.TEXT_INPUT, inputText);
				
				// textfield of showing alert2
				show_alert2 = new TextField();
				show_alert2.antiAliasType = AntiAliasType.ADVANCED;
				show_alert2.width = popup_width / 2.5;
				show_alert2.height = show_name2.height / 2;
				show_alert2.background = false;
				show_alert2.x = input_name2.x;
				show_alert2.y = show_name2.y + input_name2.height;
				show_alert2.visible = false;
				show_alert2.selectable = false;
				show_alert2.addEventListener(TextEvent.TEXT_INPUT, inputText);
				
				// textfield of showing gameMode
				show_gameMode = new TextField();
				show_gameMode.antiAliasType = AntiAliasType.ADVANCED;
				show_gameMode.autoSize = TextFieldAutoSize.LEFT;
				show_gameMode.background = false;
				show_gameMode.x = location_x + popup_width / 17;
				show_gameMode.y = show_name2.y + show_alert.height;
				show_gameMode.text = "Game Mode:";
				show_gameMode.selectable = false;
				show_gameMode.setTextFormat(textformat);
				addChild(show_gameMode);
				
				// textfield of input gameMode
				input_gameMode = new TextField();
				input_gameMode.antiAliasType = AntiAliasType.ADVANCED;
				input_gameMode.width = popup_width / 2.5;
				input_gameMode.height = show_gameMode.height;
				input_gameMode.background = false;
				input_gameMode.borderColor = bor_color;
				input_gameMode.x = show_gameMode.x + gapX + popup_width / 2.5;
				input_gameMode.y = show_gameMode.y;
				input_gameMode.selectable = false;
				input_gameMode.border = true;
				input_gameMode.defaultTextFormat = textformat2;
				addChild(input_gameMode);
				
				// Confirm button
				confirm_btn = new TextField();
				confirm_btn.antiAliasType = AntiAliasType.ADVANCED;
				confirm_btn.autoSize = TextFieldAutoSize.LEFT;
				confirm_btn.background = true;
				confirm_btn.borderColor = bor_color;
				confirm_btn.text = "Next";
				confirm_btn.setTextFormat(textformat);
				confirm_btn.x = show_gameMode.x + show_name.width - confirm_btn.width;
				confirm_btn.y = show_gameMode.y + gapY;
				confirm_btn.border = true;
				confirm_btn.selectable = false;
				confirm_btn.addEventListener(MouseEvent.CLICK, goToNext);
				addChild(confirm_btn);
				
				// Close button
				close_pop = new TextField();
				close_pop.antiAliasType = AntiAliasType.ADVANCED;
				close_pop.autoSize = TextFieldAutoSize.LEFT;
				close_pop.background = true;
				close_pop.borderColor = bor_color;
				close_pop.x = input_gameMode.x;
				close_pop.y = confirm_btn.y ;
				close_pop.text = "Cancel";
				close_pop.border = true;
				close_pop.selectable = false;
				close_pop.setTextFormat(textformat);
				close_pop.addEventListener(MouseEvent.CLICK, close_clickHandler);
				addChild(close_pop);
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
					if(this.contains(show_name2)){
						removeChild(show_name2);
						removeChild(input_name2);
						removeChild(show_alert2);
					}
					
					popup_height = 195;
					draw(popup_width, popup_height, bg_color);
					
					show_gameMode.y = show_name.y + show_alert.height + gapY;
					input_gameMode.y = show_gameMode.y
					confirm_btn.y = show_gameMode.y + show_alert.height + gapY;
					close_pop.y = confirm_btn.y ;
					
					input_gameMode.text = "Single";
				}
				else{
					popup_height = 245;
					draw(popup_width, popup_height, bg_color);
					
					show_gameMode.y = show_name2.y + show_alert.height + gapY;
					input_gameMode.y = show_gameMode.y
					confirm_btn.y = show_gameMode.y + show_alert.height + gapY;
					close_pop.y = confirm_btn.y ;
					
					input_gameMode.text = "Multi";
					
					if(!this.contains(show_name2)){
						addChild(show_name2);
						addChild(input_name2);
						addChild(show_alert2);
					}
				}
				
				stage.focus = input_name;
			}
			
			private function close_clickHandler(event:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				
				input_name.text = "";
				show_alert.visible = false;
				
				input_name2.text = "";
				show_alert2.visible = false;
				
				this.parent.removeChild(this);
				
				addEventListener(Event.ADDED, added);
			}
			
			private function goToNext(e:MouseEvent){
				btnClickSnd.play(0, 0, Vocagame.effectTrans);
				
				var doneCount:int = 0;
				
				if(input_name.text.toString() == ""){
					show_alert.text = "Please, input your name";
					show_alert.visible = true;
				}
				else
					doneCount++;
				
				if(input_name2.text.toString() == ""){
					show_alert2.text = "Please, input your name";
					show_alert2.visible = true;
				}
				else
					doneCount++;
				
				if(GameScreen.gameMode == 1 && doneCount == 1 || GameScreen.gameMode == 2 && doneCount == 2){
					isCompleted = true;
					
					GameScreen.player1_name = input_name.text.toString();
					input_name.text = "";
					show_alert.visible = false;
					
					GameScreen.player2_name = input_name2.text.toString();
					input_name2.text = "";
					show_alert2.visible = false;
					
					this.parent.removeChild(this);
					addEventListener(Event.ADDED, added);
				}
			}
			
			private function inputText(e:TextEvent){
				if(input_name.text.length > 5){
					show_alert.text = "Under 5 spellings";
					show_alert.visible = true;
					input_name.text = "";
				}
				
				if(input_name2.text.length > 5){
					show_alert2.text = "Under 5 spellings";
					show_alert2.visible = true;
					input_name2.text = "";
				}
			}
		}