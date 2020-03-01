package {
	import flash.display.*;
	import flash.events.*;

	public class Player extends Sprite{
		// Player information
		private var playerName:String;
		private var playerScore:int;
		private var playerMoney:int;
		private var playerNumber:int;
		
		public var horses:Array;
		public var curLoc:Array;
		public var curIndex:int;
		public var finCount:int;
		
		public var weapon:Boolean;
		public var shield:Boolean;
		public var shoes:Boolean;
		public var confused:Array;
		
		public var arrow_array:Array;
		public var confuse_array:Array;
		
		public function Player(Name:String, who:int){
			playerName = Name;
			playerScore = 0;
			playerMoney = 0;
			playerNumber = who;
			
			addEventListener(Event.ADDED, added);
		}
		
		private function added(e:Event){
			removeEventListener(Event.ADDED, added);
			
			horses = new Array();
			curLoc = new Array();
			confused = new Array();
			
			arrow_array = new Array();
			confuse_array = new Array();
		}
		
		private function moveNext(e:MouseEvent){
			if(Board(this.parent).getPlayerNum() == playerNumber &&
			   Board(this.parent).getGameState() == 1){
				for(var i:int = 0; i < GameScreen.numberOfHorse; i++)
					if(e.target == MovieClip(horses[i]).valueOf()){
						curIndex = i;
					}
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function removeHorse(num:int, isFin:Boolean){
				MovieClip(horses[num]).x = -50;
				MovieClip(horses[num]).y = -50;
				MovieClip(arrow_array[num]).x = -50;
				MovieClip(arrow_array[num]).y = -50;
				MovieClip(confuse_array[num]).x = -50;
				MovieClip(confuse_array[num]).y = -50;
				
				confused[num] = 0;
				
				if(isFin)
					curLoc[num] = -2;
				else
					curLoc[num] = -1;
		}
		
		public function changeState(){
			if(Board(this.parent).getPlayerNum() == playerNumber &&
			   Board(this.parent).getGameState() == 1)
				for(var i:int = 0; i < GameScreen.numberOfHorse; i++)
					MovieClip(horses[i]).buttonMode = true;
			else
				for(i = 0; i < GameScreen.numberOfHorse; i++)
					MovieClip(horses[i]).buttonMode = false;
		}
		
		public function init(Name:String){
			playerName = Name;
			playerScore = 0;
			curIndex = 0;
			finCount = 0;
			
			weapon = false;
			shield = false;
			shoes = false;
			
			if(horses.length != 0)
				for(var i:int = horses.length - 1; i >= 0; i--){
					if(Board(this.parent).boardImage.contains(MovieClip(horses[i])))
						Board(this.parent).boardImage.removeChild(MovieClip(horses[i]));
					horses.pop();
				}
			
			if(arrow_array.length != 0)
				for(i = arrow_array.length - 1; i >= 0; i--){
					if(Board(this.parent).boardImage.contains(MovieClip(arrow_array[i])))
						Board(this.parent).boardImage.removeChild(MovieClip(arrow_array[i]));
					arrow_array.pop();
				}
			
			if(confuse_array.length != 0)
				for(i = confuse_array.length - 1; i >= 0; i--){
					if(Board(this.parent).boardImage.contains(MovieClip(confuse_array[i])))
						Board(this.parent).boardImage.removeChild(MovieClip(confuse_array[i]));
					confuse_array.pop();
				}
			
			for(i = 0; i < GameScreen.numberOfHorse; i++){
				if(playerNumber == 1){
					horses.push(new blueHorse_image());
					MovieClip(horses[i]).scaleX = 1.2;
					MovieClip(horses[i]).scaleY = 1.2;
					MovieClip(horses[i]).stop();
				}
				else if(playerNumber == 2){
					horses.push(new redHorse_image());
					MovieClip(horses[i]).scaleX = 1.7;
					MovieClip(horses[i]).scaleY = 1.7;
				}
					
				MovieClip(horses[i]).x = -50;
				MovieClip(horses[i]).y = -50;
				MovieClip(horses[i]).addEventListener(MouseEvent.CLICK, moveNext);
				
				curLoc[i] = -1;
				confused[i] = 0;
				
				var arr_index:MovieClip = new arrow_index();
				arr_index.width = 50;
				arr_index.height = 50;
				arr_index.x = -50;
				arr_index.y = -50;
				arrow_array.push(arr_index);
				
				var confuse_index:MovieClip = new confused_index();
				confuse_index.x = -50;
				confuse_index.y = -50;
				confuse_array.push(confuse_index);
			}
		}
		
		public function getScore():int{
			return playerScore;
		}
		
		public function addScore(score:int){
			playerScore += score;
		}
		
		public function subtractScore(score:int){
			playerScore -= score;
			
			if(playerScore < 0)
				playerScore = 0;
		}
	}
}