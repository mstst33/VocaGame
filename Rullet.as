package {
	import flash.display.*
	import flash.events.*
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.media.Sound;
	import flash.text.*;

	public class Rullet extends Sprite{
		private var rulWidth:Number;
		private var rulHeight:Number;
		private var bg_color:uint = 0xD4F4FA;
		private var gap:Number;
		
		private var speed:Number;
		private var rulResult:int;
		private var paddles:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var lastPaddle:String;
		private var wheelFlag:Boolean;
		private var index:MovieClip;
		private var textformat:TextFormat;
		private var showFigure:TextField;
		
		// Sound
		private var rotateSnd:Sound;
		private var duduSnd:Sound;
		private var tickSnd:Sound;
		
		private var wheel:MovieClip;
		private var indicator:MovieClip;

		public function Rullet(){
			addEventListener(Event.ADDED, added);
		}
		
		private function createScreen(){
			wheel = new Wheel_Image();
			wheel.x = SideBoard(this.parent).getLocationX() + rulWidth / 2;
			wheel.y = SideBoard(this.parent).smallMap.getSmHeight() +
					  SideBoard(this.parent).scoreBoard.getScHeight() + gap * 5 + rulHeight / 2;
			wheel.scaleX = 1.1;
			wheel.scaleY = 1.1;
			wheel.buttonMode = true;
			wheel.addEventListener(MouseEvent.CLICK, spinWheel);
			
			indicator = new Indicator_Image();
			indicator.width = rulWidth / 14;
			indicator.height = rulHeight / 7;
			indicator.x = SideBoard(this.parent).getLocationX() + rulWidth / 2;
			indicator.y = SideBoard(this.parent).smallMap.getSmHeight() +
					  	  SideBoard(this.parent).scoreBoard.getScHeight() + gap * 8;
			
			wheelFlag = true;
			paddles.push(wheel.p1, wheel.p2, wheel.p3, wheel.p4, wheel.p5, wheel.p6, wheel.p7, wheel.p8, wheel.p9, wheel.p10);
			
			index = new arrow_index();
			index.width = 60;
			index.height = 60;
			index.x = SideBoard(this.parent).getLocationX() + index.width / 1.7;
			index.y = SideBoard(this.parent).smallMap.getSmHeight() +
					  SideBoard(this.parent).scoreBoard.getScHeight() + gap * 5 + index.height / 1.3;
			
			
			textformat = new TextFormat();
			textformat.size = 45;
			textformat.color = 0x000000;
			textformat.align = "center";
			
			showFigure = new TextField();
			showFigure.antiAliasType = AntiAliasType.ADVANCED;
			showFigure.autoSize = TextFieldAutoSize.CENTER;
			showFigure.background = false;
			showFigure.x = wheel.x;
			showFigure.y = wheel.y - gap * 5;
			showFigure.selectable = false;
			showFigure.defaultTextFormat = textformat;
			
			addChild(showFigure);
			addChild(wheel);
			addChild(indicator);
			
			this.setChildIndex(showFigure, 2);
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			rulWidth = SideBoard(this.parent).getSbWidth();
			rulHeight = (2 * Vocagame.screenHeight) / 5;
			gap = 5;
			
			rotateSnd = new rotating_sound();
			duduSnd = new dududu_sound();
			tickSnd = new tick_sound();
			
			createScreen();
		}
		
		public function showIndex(){
			if(!contains(index))
				addChild(index);
		}
		
		public function spinWheel(e:MouseEvent){
			if(wheelFlag){
				trace("In wheel");
				removeChild(index);
				
				
				PlayerBoard.canUseBtn = false;
				SideBoard(this.parent).closeOtherBeforeWheeling();
				SideBoard(this.parent).scoreBoard.setIsClickedRullet();
				
				rotateSnd.play(0, 3, Vocagame.effectTrans);
				wheelFlag = false;
				wheel.buttonMode = false;
				speed = 18 + Math.random() * 5;
				addEventListener(Event.ENTER_FRAME, spin);
			}
		}
		
		private function spin(e:Event){
			wheel.rotation += speed;


			for (var i:int = 0; i < 10; i++)
				if (indicator.hArea.hitTestObject(paddles[i]))
					lastPaddle = paddles[i].name;
						
			speed -= 0.2;
			
			if(speed <= 0){
				removeEventListener(Event.ENTER_FRAME, spin);
				
				switch(lastPaddle){
				case 'p1':
					rulResult = 2;
					break;
				case 'p2':
					rulResult = 3;
					break;
				case 'p3':
					rulResult = 4;
					break;
				case 'p4':
					rulResult = 5;
					break;
				case 'p5':
					rulResult = 1;
					break;
				case 'p6':
					rulResult = 2;
					break;
				case 'p7':
					rulResult = 3;
					break;
				case 'p8':
					rulResult = 4;
					break;
				case 'p9':
					rulResult = -1;
					break;
				case 'p10':
					rulResult = 1;
					break;
				}
				
				SideBoard(this.parent).scoreBoard.setIsClickedRullet();
				showFigure.text = String(rulResult);
				tickSnd.play(0, 0, Vocagame.effectTrans);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function initString(){
			showFigure.text = "";
		}
		
		public function showString(string:String){
			showFigure.text = string;
		}
		
		public function changeWheelFlag(){
			wheelFlag = true;
			wheel.buttonMode = true;
		}
		
		public function getRulResult():int{			
			return rulResult;
		}
	}
}