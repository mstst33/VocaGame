package {
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.net.*;

	public class SettingScreen extends Sprite{
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
		private var textformat6:TextFormat;
		private var textformat7:TextFormat;
		
		private var backBtn:MovieClip; // goToMain Button
		private var settingScreen:MovieClip; // Setting screen image
		private var subject_text:TextField;
		private var bgChange:TextField;
		private var effectChange:TextField;
		private var selHorse:TextField;
		private var number1:TextField;
		private var number2:TextField;
		private var number3:TextField;
		private var number4:TextField;
		private var number5:TextField;
		private var whichNum:int;
		private var isMini:TextField;
		private var onMini:TextField;
		private var offMini:TextField;
		
		private var min1_text:TextField;
		private var max1_text:TextField;
		private var min2_text:TextField;
		private var max2_text:TextField;
		private var dragAreaBG:MovieClip;
		private var dragIndiBG:MovieClip;
		private var dragAreaEffect:MovieClip;
		private var dragIndiEffect:MovieClip;
		private var boundRectBG:Rectangle;
		private var boundRectEF:Rectangle;

		// Button sound
		private var btnOverSnd:Sound;
		private var btnClickSnd:Sound;

		public function SettingScreen(){
			gap_x = Vocagame.screenWidth / 9;
			gap_y = Vocagame.screenHeight / 9;
			whichNum = GameScreen.numberOfHorse;

			btnOverSnd = new onBtn_sound();
			btnClickSnd = new clickBtn_sound();

			createScreen();
		}

		private function createScreen(){
			// Put setting image on setting screen
			settingScreen = new setting_image();
			settingScreen.width = Vocagame.screenWidth;
			settingScreen.height = Vocagame.screenHeight;
			addChild(settingScreen);

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

			var bgChange_width:Number = Vocagame.screenWidth / 5;
			var effectChange_width:Number = Vocagame.screenWidth / 5;
			var selHorse_width:Number = Vocagame.screenWidth / 5;
			var isMini_width:Number = Vocagame.screenWidth / 5;
			var text_Height:Number = Vocagame.screenWidth / 30;

			var subject_x:Number = gap_x;
			var bgChange_y:Number = gap_y * 2;
			var effectChange_y:Number = bgChange_y + text_Height + gap_y;
			var selHorse_y:Number = effectChange_y + text_Height + gap_y;
			var isMini_y:Number = selHorse_y + text_Height + gap_y;

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
			textformat3.size = 25;
			textformat3.color = 0xF361DC;
			textformat3.align = "center";

			textformat4 = new TextFormat();
			textformat4.size = 25;
			textformat4.color = 0x6799FF;
			textformat4.align = "center";

			textformat5 = new TextFormat();
			textformat5.size = 25;
			textformat5.color = 0x47C83E;
			textformat5.align = "center";
			
			textformat6 = new TextFormat();
			textformat6.size = 45;
			textformat6.color = 0xFF5E00;
			textformat6.align = "center";
			
			textformat7 = new TextFormat();
			textformat7.size = 25;
			textformat7.color = 0xFF0000;
			textformat7.align = "center";

			// textfield of showing subject
			subject_text = new TextField();
			subject_text.antiAliasType = AntiAliasType.ADVANCED;
			subject_text.autoSize = TextFieldAutoSize.LEFT;
			subject_text.background = false;
			subject_text.x = subject_x;
			subject_text.y = gap_y / 2;
			subject_text.text = "- Setting -";
			subject_text.selectable = false;
			subject_text.setTextFormat(textformat2);
			addChild(subject_text);
			
			// textfield of showing bgChange
			bgChange = new TextField();
			bgChange.antiAliasType = AntiAliasType.ADVANCED;
			bgChange.width = bgChange_width;
			bgChange.height = text_Height;
			bgChange.background = false;
			bgChange.x = gap_x;
			bgChange.y = bgChange_y;
			bgChange.selectable = false;
			bgChange.text = "Background Sound: ";
			bgChange.setTextFormat(textformat3);
			addChild(bgChange);

			// textfield of showing effectChange
			effectChange = new TextField();
			effectChange.antiAliasType = AntiAliasType.ADVANCED;
			effectChange.width = effectChange_width;
			effectChange.height = text_Height;
			effectChange.background = false;
			effectChange.x = gap_x;
			effectChange.y = effectChange_y;
			effectChange.selectable = false;
			effectChange.text = "Effect Sound: ";
			effectChange.setTextFormat(textformat4);
			addChild(effectChange);

			// textfield of showing selHorse
			selHorse = new TextField();
			selHorse.antiAliasType = AntiAliasType.ADVANCED;
			selHorse.width = selHorse_width;
			selHorse.height = text_Height;
			selHorse.background = false;
			selHorse.x = gap_x;
			selHorse.y = selHorse_y;
			selHorse.selectable = false;
			selHorse.text = "Horse's Number: ";
			selHorse.setTextFormat(textformat5);
			addChild(selHorse);
			
			// textfield of showing isMini
			isMini = new TextField();
			isMini.antiAliasType = AntiAliasType.ADVANCED;
			isMini.width = isMini_width;
			isMini.height = text_Height;
			isMini.background = false;
			isMini.x = gap_x;
			isMini.y = isMini_y;
			isMini.selectable = false;
			isMini.text = "Mini Game: ";
			isMini.setTextFormat(textformat7);
			addChild(isMini);
			
			dragAreaBG = new dragArea;
			dragAreaBG.width = gap_x * 3;
			dragAreaBG.height = gap_y / 8;
			dragAreaBG.x = bgChange.x + gap_x * 3;
			dragAreaBG.y = bgChange.y + dragAreaBG.height;
			addChild(dragAreaBG);
			
			dragAreaEffect = new dragArea;
			dragAreaEffect.width = gap_x * 3;
			dragAreaEffect.height = gap_y / 8;
			dragAreaEffect.x = effectChange.x + gap_x * 3;
			dragAreaEffect.y = effectChange.y + dragAreaEffect.height;
			addChild(dragAreaEffect);
			
			dragIndiBG = new dragIndicator;
			dragIndiBG.x = dragAreaBG.x + dragAreaBG.width;
			dragIndiBG.y = dragAreaBG.y;
			dragIndiBG.buttonMode = true;
			dragIndiBG.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			addChild(dragIndiBG);
			
			dragIndiEffect = new dragIndicator;
			dragIndiEffect.x = dragAreaEffect.x + dragAreaEffect.width;
			dragIndiEffect.y = dragAreaEffect.y;
			dragIndiEffect.buttonMode = true;
			dragIndiEffect.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			addChild(dragIndiEffect);
			
			boundRectBG = new Rectangle(dragAreaBG.x, dragAreaBG.y, dragAreaBG.width, 0);
			boundRectEF = new Rectangle(dragAreaEffect.x, dragAreaEffect.y, dragAreaEffect.width, 0);
			
			// textfield of showing min1
			min1_text = new TextField();
			min1_text.antiAliasType = AntiAliasType.ADVANCED;
			min1_text.autoSize = TextFieldAutoSize.LEFT;
			min1_text.background = false;
			min1_text.selectable = false;
			min1_text.text = "min";
			min1_text.setTextFormat(textformat);
			min1_text.x = dragAreaBG.x;
			min1_text.y = bgChange.y - min1_text.height;
			addChild(min1_text);
			
			// textfield of showing max1
			max1_text = new TextField();
			max1_text.antiAliasType = AntiAliasType.ADVANCED;
			max1_text.autoSize = TextFieldAutoSize.LEFT;
			max1_text.background = false;
			max1_text.selectable = false;
			max1_text.text = "max";
			max1_text.setTextFormat(textformat);
			max1_text.x = dragAreaBG.x + dragAreaBG.width - max1_text.width;
			max1_text.y = bgChange.y - max1_text.height;
			addChild(max1_text);
			
			// textfield of showing min2
			min2_text = new TextField();
			min2_text.antiAliasType = AntiAliasType.ADVANCED;
			min2_text.autoSize = TextFieldAutoSize.LEFT;
			min2_text.background = false;
			min2_text.selectable = false;
			min2_text.text = "min";
			min2_text.setTextFormat(textformat);
			min2_text.x = dragAreaEffect.x;
			min2_text.y = effectChange.y - min2_text.height;
			addChild(min2_text);
			
			// textfield of showing max2
			max2_text = new TextField();
			max2_text.antiAliasType = AntiAliasType.ADVANCED;
			max2_text.autoSize = TextFieldAutoSize.LEFT;
			max2_text.background = false;
			max2_text.selectable = false;
			max2_text.text = "max";
			max2_text.setTextFormat(textformat);
			max2_text.x = dragAreaEffect.x + dragAreaEffect.width - max2_text.width;
			max2_text.y = effectChange.y - max2_text.height;
			addChild(max2_text);
			
			// textfield of showing number1
			number1 = new TextField();
			number1.antiAliasType = AntiAliasType.ADVANCED;
			number1.autoSize = TextFieldAutoSize.LEFT;
			number1.background = true;
			number1.backgroundColor = 0xE5D85C;
			number1.selectable = false;
			number1.border = false;
			number1.borderColor = 0x000000;
			number1.text = "1";
			number1.setTextFormat(textformat6);
			number1.x = selHorse.x + gap_x * 3;
			number1.y = selHorse.y;
			number1.addEventListener(MouseEvent.CLICK, selectHorseNum);
			addChild(number1);
			
			// textfield of showing number2
			number2 = new TextField();
			number2.antiAliasType = AntiAliasType.ADVANCED;
			number2.autoSize = TextFieldAutoSize.LEFT;
			number2.background = true;
			number2.backgroundColor = 0xE5D85C;
			number2.selectable = false;
			number2.border = true;
			number2.borderColor = 0x000000;
			number2.text = "2";
			number2.setTextFormat(textformat6);
			number2.x = number1.x + number1.width * 2;
			number2.y = selHorse.y;
			number2.addEventListener(MouseEvent.CLICK, selectHorseNum);
			addChild(number2);
			
			// textfield of showing number3
			number3 = new TextField();
			number3.antiAliasType = AntiAliasType.ADVANCED;
			number3.autoSize = TextFieldAutoSize.LEFT;
			number3.background = true;
			number3.backgroundColor = 0xE5D85C;
			number3.selectable = false;
			number3.border = false;
			number3.borderColor = 0x000000;
			number3.text = "3";
			number3.setTextFormat(textformat6);
			number3.x = number2.x + number2.width * 2;
			number3.y = selHorse.y;
			number3.addEventListener(MouseEvent.CLICK, selectHorseNum);
			// addChild(number3);
			
			// textfield of showing number4
			number4 = new TextField();
			number4.antiAliasType = AntiAliasType.ADVANCED;
			number4.autoSize = TextFieldAutoSize.LEFT;
			number4.background = true;
			number4.backgroundColor = 0xE5D85C;
			number4.selectable = false;
			number4.border = false;
			number4.borderColor = 0x000000;
			number4.text = "4";
			number4.setTextFormat(textformat6);
			number4.x = number3.x + number3.width * 2;
			number4.y = selHorse.y;
			number4.addEventListener(MouseEvent.CLICK, selectHorseNum);
			// addChild(number4);
			
			// textfield of showing number5
			number5 = new TextField();
			number5.antiAliasType = AntiAliasType.ADVANCED;
			number5.autoSize = TextFieldAutoSize.LEFT;
			number5.background = true;
			number5.backgroundColor = 0xE5D85C;
			number5.selectable = false;
			number5.border = false;
			number5.borderColor = 0x000000;
			number5.text = "5";
			number5.setTextFormat(textformat6);
			number5.x = number4.x + number4.width * 2;
			number5.y = selHorse.y;
			number5.addEventListener(MouseEvent.CLICK, selectHorseNum);
			//addChild(number5);
			
			// textfield of showing onMini
			onMini = new TextField();
			onMini.antiAliasType = AntiAliasType.ADVANCED;
			onMini.autoSize = TextFieldAutoSize.LEFT;
			onMini.background = true;
			onMini.backgroundColor = 0xE5D85C;
			onMini.selectable = false;
			onMini.border = false;
			onMini.borderColor = 0x000000;
			onMini.text = "On";
			onMini.setTextFormat(textformat6);
			onMini.x = isMini.x + gap_x * 3;
			onMini.y = isMini.y;
			onMini.addEventListener(MouseEvent.CLICK, selectMiniGame);
			addChild(onMini);
			
			// textfield of showing offMini
			offMini = new TextField();
			offMini.antiAliasType = AntiAliasType.ADVANCED;
			offMini.autoSize = TextFieldAutoSize.LEFT;
			offMini.background = true;
			offMini.backgroundColor = 0xC4B73B;
			offMini.selectable = false;
			offMini.border = false;
			offMini.borderColor = 0x000000;
			offMini.text = "Off";
			offMini.setTextFormat(textformat6);
			offMini.x = onMini.x + onMini.width + offMini.width / 45;
			offMini.y = isMini.y;
			offMini.addEventListener(MouseEvent.CLICK, selectMiniGame);
			addChild(offMini);
		}
		
		function mouseDown_Handler(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);
			
			if(e.target == dragIndiBG.valueOf()){
				dragIndiBG.startDrag(false, boundRectBG);
				dragIndiBG.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
				addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler1);
			}
			else if(e.target == dragIndiEffect.valueOf()){
				dragIndiEffect.startDrag(false, boundRectEF);
				dragIndiEffect.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
				addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler2);
			}
		}
		
		function mouseUp_Handler1(e:MouseEvent){
			var nPos:Number;
			
			dragIndiBG.stopDrag();
			dragIndiBG.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			nPos = (dragIndiBG.x - dragAreaBG.x) / dragAreaBG.width;
			Vocagame.bgTrans.volume = nPos;
			Vocagame.bgChannel.soundTransform = Vocagame.bgTrans;
			
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler1);
		}
		
		function mouseUp_Handler2(e:MouseEvent){
			var nPos:Number;

			dragIndiEffect.stopDrag();
			dragIndiEffect.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			nPos = (dragIndiEffect.x - dragAreaEffect.x) / dragAreaEffect.width;
			Vocagame.effectTrans.volume = nPos;
			
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler2);
		}
		
		function selectHorseNum(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			
			switch(whichNum){
				case 1:
					number1.border = false;
					break;
				case 2:
					number2.border = false;
					break;
				case 3:
					number3.border = false;
					break;
				case 4:
					number4.border = false;
					break;
				case 5:
					number5.border = false;
					break;
			}
			
			if(e.target == number1){
				whichNum = 1;
				number1.border = true;
				GameScreen.numberOfHorse = 1;
			}
			else if(e.target == number2){
				whichNum = 2;
				number2.border = true;
				GameScreen.numberOfHorse = 2;
			}
			else if(e.target == number3){
				whichNum = 3;
				number3.border = true;
				GameScreen.numberOfHorse = 3;
			}
			else if(e.target == number4){
				whichNum = 4;
				number4.border = true;
				GameScreen.numberOfHorse = 4;
			}
			else if(e.target == number5){
				whichNum = 5;
				number5.border = true;
				GameScreen.numberOfHorse = 5;
			}
			
			trace("The number of horses: ", GameScreen.numberOfHorse);
		}
		
		function selectMiniGame(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);
			
			if(e.target == onMini){
				onMini.backgroundColor = 0xE5D85C;
				offMini.backgroundColor = 0xC4B73B;
				GameScreen.miniFlag = true;
			}
			else if(e.target == offMini){
				offMini.backgroundColor = 0xE5D85C;
				onMini.backgroundColor = 0xC4B73B;
				GameScreen.miniFlag = false;
			}
		}

		private function overHandler(e:MouseEvent){
			btnOverSnd.play(0, 0, Vocagame.effectTrans);

			var btn:MovieClip = e.target as MovieClip;
			new Tween(btn,"width",Strong.easeOut,BUT_WIDTH,BUT_WIDTH + BUT_WIDTH / 7,1,true);
			new Tween(btn,"height",Strong.easeOut,BUT_HEIGHT,BUT_HEIGHT + BUT_HEIGHT / 7,1,true);
		}

		private function outHandler(e:MouseEvent){
			var btn:MovieClip = e.target as MovieClip;
			new Tween(btn,"width",Strong.easeOut,BUT_WIDTH + BUT_WIDTH / 7,BUT_WIDTH,1,true);
			new Tween(btn,"height",Strong.easeOut,BUT_HEIGHT + BUT_HEIGHT / 7,BUT_HEIGHT,1,true);
		}

		private function goToMain(e:MouseEvent){
			btnClickSnd.play(0, 0, Vocagame.effectTrans);

			Vocagame.gameState = Vocagame(this.parent).STATE_MAIN;
			this.parent.removeChild(this);
		}
		
		public function saveData(){
			Vocagame.so.data.indiBG = dragIndiBG.x;
			Vocagame.so.data.indiEF = dragIndiEffect.x;
		}
		
		public function loadData(){
			var nPos:Number;
			dragIndiBG.x = Vocagame.so.data.indiBG;
			nPos = (dragIndiBG.x - dragAreaBG.x) / dragAreaBG.width;
			Vocagame.bgTrans.volume = nPos;
			Vocagame.bgChannel.soundTransform = Vocagame.bgTrans;
			
			dragIndiEffect.x = Vocagame.so.data.indiEF;
			nPos = (dragIndiEffect.x - dragAreaEffect.x) / dragAreaEffect.width;
			Vocagame.effectTrans.volume = nPos;
			
			number4.border = false;
			switch(GameScreen.numberOfHorse){
				case 1:
					whichNum = 1;
					number1.border = true;
					break;
				case 2:
					whichNum = 2;
					number2.border = true;
					break;
				case 3:
					whichNum = 3;
					number3.border = true;
					break;
				case 4:
					whichNum = 4;
					number4.border = true;
					break;
				case 5:
					whichNum = 5;
					number5.border = true;
					break;
			}
			
			if(GameScreen.miniFlag){
				onMini.backgroundColor = 0xE5D85C;
				offMini.backgroundColor = 0xC4B73B;
			}
			else{
				offMini.backgroundColor = 0xE5D85C;
				onMini.backgroundColor = 0xC4B73B;
			}
		}
	}
}