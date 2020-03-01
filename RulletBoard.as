package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;

	public class RulletBoard extends Sprite{
		const HIDING = 0;
		const SHOWING = 1;
		
		private var rbWidth:Number;
		private var rbHeight:Number;
		private var hidLocX:Number;
		private var hidLocY:Number;
		private var showLocX:Number;
		private var showLocY:Number;
		private var show_gapY:Number;
		
		private var bg_color:uint = 0xD4F4FA;
		private var textFormat:TextFormat;
		
		private var click_show:TextField;
		private var rbState:int;

		public function RulletBoard(){
			addEventListener(Event.ADDED, added);
		}

		public function createScreen(){
			draw(rbWidth, rbHeight, bg_color);
			addEventListener(MouseEvent.CLICK, clickHandler);
			
			textFormat = new TextFormat();
			textFormat.size = 30;
			textFormat.bold = true;
			textFormat.color = 0x000000;
			textFormat.align = "center";

			// Button to show all or to hide
			click_show = new TextField();
			click_show.antiAliasType = AntiAliasType.ADVANCED;
			click_show.width = rbWidth;
			click_show.height = Vocagame.screenHeight / 22;
			click_show.background = false;
			click_show.x = hidLocX;
			click_show.y = hidLocY;
			click_show.text = "Click here to open";
			click_show.selectable = false;
			click_show.setTextFormat(textFormat);
			
			addChild(click_show);
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			rbWidth = GameScreen(this.parent).getBdWidth();
			rbHeight = Vocagame.screenHeight / 2;
			hidLocX = 0;
			hidLocY = (21 * Vocagame.screenHeight) / 22;
			showLocX = 0;
			showLocY = Vocagame.screenHeight / 2;
			show_gapY = hidLocY - showLocY;

			rbState = HIDING;
			
			createScreen();
		}
		
		private function draw(w:uint, h:uint, color:uint){
			alpha = 0.2;

			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(hidLocX, hidLocY, w, h);
			graphics.endFill();
		}
		
		private function clickHandler(e:MouseEvent){
			showOrHide();
		}
		
		// Show or hide rullet board
		public function showOrHide(){
			if(rbState == HIDING){			
				rbState = SHOWING;
				click_show.text = "Click anywhere to close";
				click_show.setTextFormat(textFormat);
				
				new Tween(this, "y", Strong.easeOut, this.y, -show_gapY, 1, true);	
			}
			else{
				rbState = HIDING;
				click_show.text = "Click here to open";
				click_show.setTextFormat(textFormat);
				
				new Tween(this, "y", Strong.easeOut, this.y, 0, 1, true);
			}
		}
		
		public function getRbState():int{
			return rbState;
		}
	}
}