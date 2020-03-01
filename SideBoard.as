package  {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class SideBoard extends Sprite{
		private var sbWidth:Number;
		private var sbHeight:Number;
		private var gap:Number;
		
		public var smallMap:SmallMap;
		public var scoreBoard:ScoreBoard;
		public var rullet:Rullet;
		
		public function SideBoard() {
			addEventListener(Event.ADDED, added);
		}
		
		private function createScreen(){
			smallMap = new SmallMap();
			scoreBoard = new ScoreBoard();
			rullet = new Rullet();
			rullet.addEventListener(Event.COMPLETE, playerTurn);
			
			addChild(smallMap);
			addChild(scoreBoard);
			addChild(rullet);
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			gap = 5;
			sbWidth = Vocagame.screenWidth - GameScreen(this.parent).getBdWidth() - gap;
			sbHeight = Vocagame.screenHeight;
						
			createScreen();
		}
		
		private function playerTurn(e:Event){
			PlayerBoard.canUseBtn = true;
			GameScreen(this.parent).gameState = GameScreen(this.parent).STATE_PLAYER;
			GameScreen(this.parent).addEventListener(Event.ENTER_FRAME, GameScreen(this.parent).continueGame);
		}
		
		// Get sideboard height
		public function getSbWidth():Number{
			return sbWidth;
		}
		
		// Get board height
		public function getBdHeight():Number{
			return GameScreen(this.parent).getBdHeight();
		}
		
		public function setScrGauge(scr_gauge:Number){
			GameScreen(this.parent).setScrGauge(scr_gauge);
		}
		
		public function setSmallMap(bitmapData:BitmapData){
			smallMap.updateSmallMap(bitmapData);
		}
		
		public function getLocationX():Number{
			return GameScreen(this.parent).getBdWidth() + gap;
		}
		
		public function getPlayer1Score():int{
			return GameScreen(this.parent).getPlayer1Score();
		}
		
		public function setPlayer1Score(){
			GameScreen(this.parent).setPlayer1Score(GameScreen(this.parent).goodVoice);
		}
		
		public function getPlayer2Score():int{
			return GameScreen(this.parent).getPlayer2Score();
		}
		
		public function setPlayer2Score(){
			GameScreen(this.parent).setPlayer2Score(GameScreen(this.parent).goodVoice);
		}
		
		public function closeOtherBeforeWheeling(){
			GameScreen(this.parent).closeOtherBeforeWheeling();
		}
	}
}