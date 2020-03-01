package {
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.geom.*;

	class SmallMap extends Sprite{
		private var smWidth:Number;
		private var smHeight:Number;
		private var rectHeight:Number;
		private var scr_gauge:Number;
		private var scr_max:Number;
		private var bg_color:uint = 0xD4F4FA;
		private var originalY:Number;
		
		private var bitmap:Bitmap;
		private var rect:Sprite;

		public function SmallMap(){
			addEventListener(Event.ADDED, added);
		}

		private function createScreen(){
			rect = new Sprite();
			rect.graphics.clear();
			rect.graphics.beginFill(bg_color, 0.5);
			rect.graphics.drawRect(SideBoard(this.parent).getLocationX(), 0, smWidth, rectHeight - 5);
			rect.graphics.endFill();
			rect.addEventListener(MouseEvent.MOUSE_WHEEL, scrolling);
			rect.addEventListener(MouseEvent.MOUSE_DOWN, dragging);
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			smWidth = SideBoard(this.parent).getSbWidth();
			smHeight = (2 * Vocagame.screenHeight) / 5;
			rectHeight = Vocagame.screenHeight * (smHeight / SideBoard(this.parent).getBdHeight());
			scr_gauge = 0;
			scr_max = smHeight - rectHeight;
			
			createScreen();
		}

		public function updateSmallMap(bitmapData:BitmapData){
			if(bitmap != null){
				bitmap.removeEventListener(MouseEvent.MOUSE_WHEEL, scrolling);
				removeChild(bitmap);
				removeChild(rect);
			}
				
			bitmap = new Bitmap(bitmapData, "auto", false);
			bitmap.width = smWidth + 25;
			bitmap.height = smHeight + 8;
			bitmap.x = SideBoard(this.parent).getLocationX();
			bitmap.y = 0;
			
			addChild(bitmap);
			addChild(rect);
			addEventListener(MouseEvent.MOUSE_WHEEL, scrolling);
		}
		
		private function scrolling(e:MouseEvent){
			var scr_gap:Number = 5 * e.delta;
			scr_gauge -= scr_gap;
			
			if(scr_gauge < 0)
				scr_gauge = 0;
			else if(scr_gauge > scr_max)
				scr_gauge = scr_max;
			
			new Tween(rect, "y", Strong.easeOut,rect.y, scr_gauge, 5, false);
			SideBoard(this.parent).setScrGauge(scr_gauge / (smHeight / (SideBoard(this.parent).getBdHeight())));
		}
		
		// Mouse down Handler
		private function dragging(e:MouseEvent){
			originalY = e.localY;
			
			rect.removeEventListener(MouseEvent.MOUSE_DOWN, dragging);
			rect.addEventListener(MouseEvent.MOUSE_MOVE, moving);
			rect.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			addEventListener(MouseEvent.MOUSE_OUT, stopDragging);
		}
		
		// Mouse move Handler
		private function moving(e:MouseEvent){
			var deltaY:Number = (originalY - e.localY) / 3;
			scr_gauge -= deltaY;
			
			if(scr_gauge < 0)
				scr_gauge = 0;
			else if(scr_gauge > scr_max)
				scr_gauge = scr_max;
			
			new Tween(rect, "y", Strong.easeOut,rect.y, scr_gauge, 5, false);
			SideBoard(this.parent).setScrGauge(scr_gauge / (smHeight / (SideBoard(this.parent).getBdHeight())));
		}
		
		// Mouse up Handler
		private function stopDragging(e:MouseEvent){
			if(!rect.hasEventListener(MouseEvent.MOUSE_DOWN)){
				removeEventListener(MouseEvent.MOUSE_OUT, stopDragging);
				rect.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
				rect.removeEventListener(MouseEvent.MOUSE_MOVE, moving);
				rect.addEventListener(MouseEvent.MOUSE_DOWN, dragging);
			}
		}
		
		public function setMapGauge(scr_gauge:Number){
			this.scr_gauge = scr_gauge;
			new Tween(rect, "y", Strong.easeOut, rect.y, scr_gauge, 10, false);
		}
		
		public function getSmHeight():Number{
			return smHeight;
		}
	}
}