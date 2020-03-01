package  {
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.text.*;
	
	public class StageScreen extends Sprite {
		// Game stage
		const EXIT_BUT_WIDTH:Number = Vocagame.screenWidth / 15; // exit button width
		const EXIT_BUT_HEIGHT:Number = Vocagame.screenWidth / 25; // exit button Height
		const BUT_WIDTH:Number = Vocagame.screenWidth / 15; // Stage button width
		const BUT_HEIGHT:Number = Vocagame.screenWidth / 15; // Stage button Height
		const STAGE_NUM:uint = STAGE_ROW * STAGE_COL; // The number of stages
		const STAGE_ROW:uint = 4;
		const STAGE_COL:uint = 5;
		
		private var gap_x:Number; // Gap_X between stage buttons
		private var gap_y:Number; // Gap_y between stage buttons
		
		private var stageBtn:Array = new Array(); // Stages array
		private var stageText:Array = new Array(); // Stages text array
		private var backBtn:MovieClip; // goToMain Button
		private var stageScreen:MovieClip; // Main screen image
		
		// GUI
		private var textformat:TextFormat;
		private var subject_text:TextField;
		private var aid_text:TextField;
		
		// Button sound
		private var btnOverSnd:Sound;
		private var btnClickSnd:Sound;
		
		var wordSet:WordSet;
		public function StageScreen(){
			btnOverSnd = new onBtn_sound();
			btnClickSnd = new clickBtn_sound();

			createScreen();
		}
		
		private function createScreen(){
			// Put main image on main screen
			stageScreen = new stageScreen_image();
			stageScreen.width = Vocagame.screenWidth;
			stageScreen.height = Vocagame.screenHeight;
			addChild(stageScreen);
			
			textformat = new TextFormat();
			textformat.size = 30;
			textformat.color = 0x4374D9;
			textformat.align = "center";
			
			wordSet = WordSet.getInst();
			
			// textfield of showing subject
			subject_text = new TextField();
			subject_text.antiAliasType = AntiAliasType.ADVANCED;
			subject_text.autoSize = TextFieldAutoSize.CENTER;
			subject_text.background = true;
			subject_text.backgroundColor = 0xF6F6F6;
			subject_text.border = true;
			subject_text.borderColor = 0xF6F6F6;
			subject_text.defaultTextFormat = textformat;
			subject_text.text = "원하는 스테이지를 선택 하세요";
			subject_text.x = Vocagame.screenWidth / 2 - subject_text.width / 2;
			subject_text.y = subject_text.height / 2;
			subject_text.selectable = false;
			addChild(subject_text);
			
			gap_x = (Vocagame.screenWidth - BUT_WIDTH * STAGE_COL) / (STAGE_COL + 1);
			gap_y = (Vocagame.screenHeight - BUT_HEIGHT * STAGE_ROW) / (STAGE_ROW + 1);
			
			var countBtn:int = 0;
			stageBtn = [new stage1_button(), new stage2_button(), new stage3_button(), new stage4_button(), new stage5_button(),
						new stage6_button(), new stage7_button(), new stage8_button(), new stage9_button(), new stage10_button(),
						new stage1_button(), new stage2_button(), new stage3_button(), new stage4_button(), new stage5_button(),
						new stage6_button(), new stage7_button(), new stage8_button(), new stage9_button(), new stage10_button()];
			
			// Create stage buttons
			for(var i = 0; i < STAGE_ROW; i++)
				for(var j = 0; j < STAGE_COL; j++){
					if(j == 0)
						MovieClip(stageBtn[countBtn]).x = gap_x;
					else
						MovieClip(stageBtn[countBtn]).x = gap_x + (gap_x + BUT_WIDTH) * j;
					
					if(i == 0)
						MovieClip(stageBtn[countBtn]).y = gap_y + subject_text.height;
					else
						MovieClip(stageBtn[countBtn]).y = gap_y + subject_text.height + (gap_y + BUT_HEIGHT) * i;
					
					// textfield of showing aid
					aid_text = new TextField();
					aid_text.antiAliasType = AntiAliasType.ADVANCED;
					aid_text.autoSize = TextFieldAutoSize.CENTER;
					aid_text.background = false;
					aid_text.border = true;
					aid_text.borderColor = 0xF6F6F6;
					aid_text.defaultTextFormat = textformat;
					aid_text.selectable = false;
					
					MovieClip(stageBtn[countBtn]).alpha = 0.9;
					MovieClip(stageBtn[countBtn]).width = BUT_WIDTH;
					MovieClip(stageBtn[countBtn]).height = BUT_HEIGHT;
					if(countBtn < 1){
					MovieClip(stageBtn[countBtn]).buttonMode = true;
					MovieClip(stageBtn[countBtn]).addEventListener(MouseEvent.MOUSE_OVER, overHandler);
					MovieClip(stageBtn[countBtn]).addEventListener(MouseEvent.MOUSE_OUT, outHandler);
					MovieClip(stageBtn[countBtn]).addEventListener(MouseEvent.CLICK, goToGame);
					
					aid_text.text = wordSet.getDescript(countBtn);
					aid_text.x = MovieClip(stageBtn[countBtn]).x;
					aid_text.y = MovieClip(stageBtn[countBtn]).y + BUT_HEIGHT * 1.2;
					}
					
					stageText.push(aid_text);
					
					addChild(MovieClip(stageBtn[countBtn]));
					addChild(stageText[countBtn]);
					
					countBtn++;
				}
				
			backBtn = new backBtn_image();
			backBtn.width = EXIT_BUT_WIDTH;
			backBtn.height = EXIT_BUT_HEIGHT;
			backBtn.x = Vocagame.screenWidth - backBtn.width * 1.2;
			backBtn.y = subject_text.y;
			backBtn.buttonMode = true;
			backBtn.alpha = 0.7;
			backBtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			backBtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			backBtn.addEventListener(MouseEvent.CLICK, goToMain);
			addChild(backBtn);
		}
		
		private function overHandler(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
			if(e.target != backBtn.valueOf()){
				new Tween(e.target, "width", Strong.easeOut, BUT_WIDTH, BUT_WIDTH + BUT_WIDTH / 7, 1, true);
				new Tween(e.target, "height", Strong.easeOut, BUT_HEIGHT, BUT_HEIGHT + BUT_HEIGHT / 7, 1, true);
			
				for(var i = 0; i < STAGE_NUM; i++)
				if(e.target == stageBtn[i].valueOf()){
					subject_text.text = wordSet.getDescript(i);
					subject_text.x = Vocagame.screenWidth / 2 - subject_text.width / 2;
				}
			}
			else{
				new Tween(e.target, "width", Strong.easeOut, EXIT_BUT_WIDTH, EXIT_BUT_WIDTH + EXIT_BUT_WIDTH / 7, 1, true);
				new Tween(e.target, "height", Strong.easeOut, EXIT_BUT_HEIGHT, EXIT_BUT_HEIGHT + EXIT_BUT_HEIGHT / 7, 1, true);
			}

		}

		private function outHandler(e:MouseEvent){
			if(e.target != backBtn.valueOf()){
				new Tween(e.target, "width", Strong.easeOut, BUT_WIDTH + BUT_WIDTH / 7, BUT_WIDTH, 1, true);
				new Tween(e.target, "height", Strong.easeOut, BUT_HEIGHT + BUT_HEIGHT / 7, BUT_HEIGHT, 1, true);
			}
			else{
				new Tween(e.target, "width", Strong.easeOut, EXIT_BUT_WIDTH + EXIT_BUT_WIDTH / 7, EXIT_BUT_WIDTH, 1, true);
				new Tween(e.target, "height", Strong.easeOut, EXIT_BUT_HEIGHT + EXIT_BUT_HEIGHT / 7, EXIT_BUT_HEIGHT, 1, true);
			}
		}
		
		private function goToMain(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			subject_text.text = "원하는 스테이지를 선택 하세요";
					
			Vocagame.gameState = Vocagame(this.parent).STATE_MAIN;
			this.parent.removeChild(this);
		}
		
		private function goToGame(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			subject_text.text = "원하는 스테이지를 선택 하세요";
			
			for(var i = 0; i < STAGE_NUM; i++)
				if(e.target == stageBtn[i].valueOf())
					GameScreen.stageLv = i + 1;
					
			Vocagame.gameState = Vocagame(this.parent).STATE_START_GAME;
			this.parent.removeChild(this);
		}
	}
}
