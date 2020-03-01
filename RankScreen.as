package  {
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.text.*;
	
	public class RankScreen extends Sprite{
		const BUT_WIDTH:Number = Vocagame.screenWidth / 9; // exit button width
		const BUT_HEIGHT:Number = Vocagame.screenWidth / 20; // exit button Height
		private var gap_x:Number; // Gap_X between stage buttons
		private var gap_y:Number; // Gap_y between stage buttons
		
		// GUI
		private var textformat:TextFormat;
		private var textformat2:TextFormat;
		private var textformat3:TextFormat;
		private var textformat4:TextFormat;
		private var textformat5:TextFormat;
		
		private var backBtn:Sprite; // goToMain Button
		private var rankScreen:Sprite; // Rank screen image
		private var subject_text:TextField;
		private var sub_order:TextField;
		private var sub_name:TextField;
		private var sub_score:TextField;
		public var show_order:Array = new Array();
		public var show_name:Array = new Array();
		public var show_score:Array = new Array();
		public var maxNum:int; // The number of lines to show
		
		// Button sound
		private var btnOverSnd:Sound;
		private var btnClickSnd:Sound;
		
		public function RankScreen(){
			gap_x = Vocagame.screenWidth / 9;
			gap_y = Vocagame.screenHeight / 9;
			maxNum = 5;
			
			btnOverSnd = new onBtn_sound();
			btnClickSnd = new clickBtn_sound();

			createScreen();
		}
		
		private function createScreen(){
			// Put rank image on rank screen
			rankScreen = new rank_image();
			rankScreen.width = Vocagame.screenWidth;
			rankScreen.height = Vocagame.screenHeight;
			addChild(rankScreen);
			
			backBtn = new backBtn_image();
			backBtn.width = BUT_WIDTH;
			backBtn.height = BUT_HEIGHT;
			backBtn.x = Vocagame.screenWidth - gap_x * 1.5;
			backBtn.y = gap_y / 2;
			backBtn.buttonMode = true;
			backBtn.alpha = 0.7;
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			backBtn.addEventListener(MouseEvent.CLICK, goToMain);
			addChild(backBtn);
			
			var order_width:Number = Vocagame.screenWidth / 12;
			var name_width:Number = Vocagame.screenWidth / 12;
			var score_width:Number = Vocagame.screenWidth / 12;
			var text_Height:Number = Vocagame.screenWidth / 30;
			
			var subject_x:Number = gap_x;
			var order_x:Number = gap_x;
			var name_x:Number = order_x + order_width + gap_x * 2;
			var score_x:Number = name_x + name_width + gap_x * 2;
			var text_y:Number = gap_y * 2;
			
			textformat = new TextFormat();
			textformat.size = 30;
			textformat.color = 0x000000;
			textformat.align = "center";
			
			// For subject text
			textformat2 = new TextFormat();
			textformat2.size = 70;
			textformat2.color = 0xA566FF;
			textformat2.align = "center";
			
			textformat3 = new TextFormat();
			textformat3.size = 30;
			textformat3.color = 0x4374D9;
			textformat3.align = "center";
			
			textformat4 = new TextFormat();
			textformat4.size = 30;
			textformat4.color = 0x2F9D27;
			textformat4.align = "center";
			
			textformat5 = new TextFormat();
			textformat5.size = 30;
			textformat5.color = 0xEAEAEA;
			textformat5.align = "center";
			
			// textfield of showing subject
			subject_text = new TextField();
			subject_text.antiAliasType = AntiAliasType.ADVANCED;
			subject_text.autoSize = TextFieldAutoSize.LEFT;
			subject_text.background = false;
			subject_text.x = subject_x;
			subject_text.y = gap_y / 2;
			subject_text.defaultTextFormat = textformat2;
			subject_text.text = "- Ranking -";
			subject_text.selectable = false;
			addChild(subject_text);
			
			// textfield of showing order
			sub_order = new TextField();
			sub_order.antiAliasType = AntiAliasType.ADVANCED;
			sub_order.width = order_width;
			sub_order.height = text_Height;
			sub_order.background = false;
			sub_order.x = order_x;
			sub_order.y = text_y;
			sub_order.defaultTextFormat = textformat;
			sub_order.text = "Order";
			sub_order.border = true;
			sub_order.borderColor = 0x8C8C8C;
			sub_order.selectable = false;
			addChild(sub_order);
			
			// textfield of showing name
			sub_name = new TextField();
			sub_name.antiAliasType = AntiAliasType.ADVANCED;
			sub_name.width = name_width;
			sub_name.height = text_Height;
			sub_name.background = false;
			sub_name.x = name_x;
			sub_name.y = text_y;
			sub_name.defaultTextFormat = textformat;
			sub_name.text = "Name";
			sub_name.border = true;
			sub_name.borderColor = 0x8C8C8C;
			sub_name.selectable = false;
			addChild(sub_name);
			
			// textfield of showing score
			sub_score = new TextField();
			sub_score.antiAliasType = AntiAliasType.ADVANCED;
			sub_score.width = score_width;
			sub_score.height = text_Height;
			sub_score.background = false;
			sub_score.x = score_x;
			sub_score.y = text_y;
			sub_score.defaultTextFormat = textformat;
			sub_score.text = "Score";
			sub_score.border = true;
			sub_score.borderColor = 0x8C8C8C;
			sub_score.selectable = false;
			addChild(sub_score);
			
			// Create rank gui
			for(var i = 1; i <= maxNum; i++){
				var temp_order:TextField = new TextField();
				var temp_name:TextField = new TextField();
				var temp_score:TextField = new TextField();
				
				temp_order.x = sub_order.x;
				temp_order.y = sub_order.y + gap_y * i;
				temp_order.width = sub_order.width;
				temp_order.height = sub_order.height;
				temp_order.antiAliasType = AntiAliasType.ADVANCED;
				temp_order.background = false;
				temp_order.defaultTextFormat = textformat3;
				temp_order.text = i;
				temp_order.selectable = false;
				show_order.push(temp_order);
				addChild(temp_order);
				
				temp_name.x = sub_name.x;
				temp_name.y = sub_name.y + gap_y * i;
				temp_name.width = sub_name.width;
				temp_name.height = sub_name.height;
				temp_name.antiAliasType = AntiAliasType.ADVANCED;
				temp_name.background = false;
				temp_name.defaultTextFormat = textformat4;
				temp_name.text = "-";
				temp_name.selectable = false;
				show_name.push(temp_name);
				addChild(temp_name);
				
				temp_score.x = sub_score.x;
				temp_score.y = sub_score.y + gap_y * i;
				temp_score.width = sub_score.width;
				temp_score.height = sub_score.height;
				temp_score.antiAliasType = AntiAliasType.ADVANCED;
				temp_score.background = false;
				temp_score.defaultTextFormat = textformat5;
				temp_score.text = "0";
				temp_score.selectable = false;
				show_score.push(temp_score);
				addChild(temp_score);
			}
			
			init();
		}
		
		private function init(){
			
		}
		
		public function saveData(){
			Vocagame.so.data.rank1Name = show_name[0].text.toString();
			Vocagame.so.data.rank1Score = show_score[0].text.toString();
			Vocagame.so.data.rank2Name = show_name[1].text.toString();
			Vocagame.so.data.rank2Score = show_score[1].text.toString();
			Vocagame.so.data.rank3Name = show_name[2].text.toString();
			Vocagame.so.data.rank3Score = show_score[2].text.toString();
			Vocagame.so.data.rank4Name = show_name[3].text.toString();
			Vocagame.so.data.rank4Score = show_score[3].text.toString();
			Vocagame.so.data.rank5Name = show_name[4].text.toString();
			Vocagame.so.data.rank5Score = show_score[4].text.toString();
		}
		
		public function loadData(){
			show_name[0].text = String(Vocagame.so.data.rank1Name);
			show_score[0].text = String(Vocagame.so.data.rank1Score);
			show_name[1].text = String(Vocagame.so.data.rank2Name);
			show_score[1].text = String(Vocagame.so.data.rank2Score);
			show_name[2].text = String(Vocagame.so.data.rank3Name);
			show_score[2].text = String(Vocagame.so.data.rank3Score);
			show_name[3].text = String(Vocagame.so.data.rank4Name);
			show_score[3].text = String(Vocagame.so.data.rank4Score);
			show_name[4].text = String(Vocagame.so.data.rank5Name);
			show_score[4].text = String(Vocagame.so.data.rank5Score);
		}
		
		private function overHandler(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
			var btn:Sprite = e.target as Sprite;
			new Tween(btn, "width", Strong.easeOut, BUT_WIDTH, BUT_WIDTH + BUT_WIDTH / 7, 1, true);
			new Tween(btn, "height", Strong.easeOut, BUT_HEIGHT, BUT_HEIGHT + BUT_HEIGHT / 7, 1, true);
		}

		private function outHandler(e:MouseEvent){
			var btn:Sprite = e.target as Sprite;
			new Tween(btn, "width", Strong.easeOut, BUT_WIDTH + BUT_WIDTH / 7, BUT_WIDTH, 1, true);
			new Tween(btn, "height", Strong.easeOut, BUT_HEIGHT + BUT_HEIGHT / 7, BUT_HEIGHT, 1, true);
		}
		
		private function goToMain(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
					
			Vocagame.gameState = Vocagame(this.parent).STATE_MAIN;
			this.parent.removeChild(this);
		}
		
		public function setRank(){
			var tempName:String;
			var tempScore:String;
			var userName:String;
			var userScore:int;
			
			var remainNum:int;
			var isRemain:Boolean = false;
			if(GameScreen.whoWin == 1){
				userName = GameScreen.player1_name;
				userScore = GameScreen.player1_score + 100;
			}
			else{
				userName = GameScreen.player2_name;
				userScore = GameScreen.player2_score + 100;
			}
			for(var i:int = 0; i < maxNum; i++){
				if(int(TextField(show_score[i]).text.toString()) < userScore){
					tempName = TextField(show_name[i]).text;
					tempScore = TextField(show_score[i]).text;
				    TextField(show_name[i]).text = userName
				    TextField(show_score[i]).text = String(userScore);
					
					isRemain = true;
					remainNum = i + 1;
					break;
				}
			}
			
			if(isRemain){
				var tempName2:String;
				var tempScore2:String;
				
				for(i = remainNum; i < maxNum; i++){
					tempName2 = TextField(show_name[i]).text;
					tempScore2 = TextField(show_score[i]).text;
					
					TextField(show_name[i]).text = tempName;
				    TextField(show_score[i]).text = tempScore;
					
					tempName = tempName2;
					tempScore = tempScore2;
				}
			}
		}
	}
}