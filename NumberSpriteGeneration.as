package  {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;
    import flash.geom.Point;


	
	public class NumberSpriteGeneration {

        public static var inst:NumberSpriteGeneration = null;

		public function NumberSpriteGeneration() {
			// constructor code
		}
		
		
		public static function getInst():NumberSpriteGeneration {
			if(inst == null)
			    inst = new NumberSpriteGeneration();
				
			return inst;
		}
		
		public function generateMoneyAmount(T:int, num:int):Sprite {
			return null;
		}
		
		public function generateNumber(T:int, num:int):Sprite {
			var tmpSprite:Sprite = new Sprite();
			var numSprite:Sprite = new Sprite();
			var res:int = num;
			var moth:int = num;
			var nnArr:Array = new Array();
			do{
				res = moth % 10;
				moth = moth/10;
				nnArr.push(res);
			} while(moth > 0);
			
			var totalwidth:int = 0;
			for(i=0; i < nnArr.length; i++)
			    totalwidth += Constant.largeNumberSpritePosSize[T*40+nnArr[i]*4+2];
			
			var myParentSquareBitmap:BitmapData = new BitmapData(totalwidth, 45, true, 0x00ffffff); 
            var myParentSquareContainer:Bitmap = new Bitmap(myParentSquareBitmap); 

			var tmpBitmapData:BitmapData;
			tmpBitmapData = new Constant.largeNumberSpriteContainer[0](); //ImageFileLoading.getInst().get_BitmapData(Constant.LARGE_NUMBER); //Constant.largeNumberSpriteContainer);
			tmpSprite.graphics.beginBitmapFill(tmpBitmapData);
			
		    var i:int;
			var no:int;
			var accX:int = 0;
			for(i=0; i < nnArr.length; i++) {
				no = nnArr[nnArr.length-1-i];
			    myParentSquareBitmap.copyPixels(tmpBitmapData, 
                 new Rectangle(Constant.largeNumberSpritePosSize[T*40+no*4],
					 Constant.largeNumberSpritePosSize[T*40+no*4+1],
					 Constant.largeNumberSpritePosSize[T*40+no*4+2],
					 Constant.largeNumberSpritePosSize[T*40+no*4+3]),
			        new Point(accX, 0));
				accX += Constant.largeNumberSpritePosSize[T*40+no*4+2];
		       
			}
			tmpSprite.graphics.endFill(); //beginBitmapFill(tmpBitmapData);
			
			myParentSquareContainer.x = 0;
			myParentSquareContainer.y = 0;
			numSprite.addChild(myParentSquareContainer);

            //tmpBitmapData = null; //garbage collection?
            return numSprite;
		}
	}
}
