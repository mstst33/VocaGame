package {
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.system.*;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.*;
	
	public class Vocagame extends Sprite{
		// Game state
		const STATE_MAIN:int = 0;
		const STATE_SELECT_STAGE = 1;
		const STATE_START_GAME:int = 2;
		const STATE_SHOW_RANK:int = 3;
		const STATE_END_GAME:int = 4;
		const STATE_SETTING:int = 5;
		
		public static var gameState:int;
		public static var screenWidth:Number;
		public static var screenHeight:Number;
		public static var so:SharedObject
		
		// Screens
		private var mainScreen:MainScreen;
		private var stageScreen:StageScreen;
		private var gameScreen:GameScreen;
		private var rankScreen:RankScreen;
		private var settingScreen:SettingScreen;
		
		// Sound
		public var mainBGSnd:Sound;
		public var gameBGSnd:Sound;
		public static var bgName:String;
		public static var bgChannel:SoundChannel;
		public static var bgTrans:SoundTransform;
		public static var tempBgTrans:SoundTransform;
		public static var effectTrans:SoundTransform;
		public static var URLStr:String;
		
		public function Vocagame(){
			screenWidth = stage.stageWidth;
			screenHeight = stage.stageHeight;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			// stage.showDefaultContextMenu = false; // Show or not menu when you right-click
			URLStr = "http://220.67.128.16/index.php";
			
			// Init sounds
			mainBGSnd = new mainBg_sound();
			gameBGSnd = new gameBg_sound();
			bgTrans = new SoundTransform(1.0, 0);
			tempBgTrans = new SoundTransform(0.1, 0);
			effectTrans = new SoundTransform(1.0, 0);
			bgChannel = new SoundChannel();
			
			gameState = STATE_MAIN;
			createScreen();
			
			var saveTimer:Timer = new Timer(30000, 0);
			saveTimer.addEventListener(TimerEvent.TIMER, saveTimerHandler);
			saveTimer.start();
			
			// loadData();
			
			// connect();
			
			addEventListener(Event.ENTER_FRAME, GameLoop);
		}
		
		private function loadData(){
			so = SharedObject.getLocal("vocagameData");
			
			if (so.size == 0){
   				 // Shared object doesn't exist. 
   				 trace("created..."); 
   				 // so.data.now = new Date().time; 
			}
			else{
				gameScreen.loadData();
				settingScreen.loadData();
				rankScreen.loadData();
			}
			// trace(so.data.now);
			trace("SharedObject is " + so.size + " bytes");
			
			for(var i:String in so.data){
				trace(i + ":\t" + so.data[i]);
			}
			
			so.flush();
		}
		/*
		public function connect(){
			// We will use URLRequest to post our variables to a
    		// PHP file which will return variables back
    
  	  		// Set the location of your PHP file
    		var urlReq:URLRequest = new URLRequest(URLStr);
			
    		// Set the method to POST
    		urlReq.method = URLRequestMethod.POST; 

    		// Define the variables to post    
    		var urlVars:URLVariables = new URLVariables(); 
			urlVars.usercmd = "join";
    		urlVars.username = "Kicher";
			urlVars.userid = "mstst";
			urlVars.userpw = "hufs";
			urlVars.userage = 28;
			urlVars.usergender = 1;
			urlVars.userscore = 3300;
			urlVars.usermoney = 1000;
			urlVars.usersuccess = "false";
			urlVars.userstate = "-1";
			urlVars.blanked = "blank";
    		
    		// Add the variables to the URLRequest
    		urlReq.data = urlVars;
                
    		// Add the URLRequest data to a new Loader
   		 	var loader:URLLoader = new URLLoader(urlReq); 
 
    		// Set a listener function to run when completed
    		loader.addEventListener(Event.COMPLETE, onConnectComplete); 
 
    		// Set the loader format to variables and post to the PHP
    		loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
    		loader.load(urlReq);
		}
		
		public function onConnectComplete(event:Event){
    		//retrieve success variable from our PHP
			// I don't know why this 'blanked' is needed but must have this line!!
			var blanked = URLLoader(event.target).data.blanked;
			trace("blanked: ", usersuccess);
			
			var usersuccess = URLLoader(event.target).data.usersuccess;
			trace("usersuccess: ", usersuccess);
			
    		if(usersuccess == "true"){
        		trace("Login Complete");
				
				var userstate = URLLoader(event.target).data.userstate;
				trace("userstate: ", userstate);
				
				switch(userstate){
					// Join
					case "0":
						var username = URLLoader(event.target).data.username;
						var userid = URLLoader(event.target).data.userid;
						var userpw = URLLoader(event.target).data.userpw;
						var userage = URLLoader(event.target).data.userage;
						var usergender = URLLoader(event.target).data.usergender;
						var userscore = URLLoader(event.target).data.userscore;
						var usermoney = URLLoader(event.target).data.usermoney;
				
						trace("username: ", username);
						trace("userid: ", userid);
						trace("userpw: ", userpw);
						trace("userage: ", userage);
						trace("usergender: ", usergender);
						trace("userscore: ", userscore);
						trace("usermoney: ", usermoney);
						break;
					// ID is not corrected with pw 
					case "1":
						trace("ID is not corrected with pw ");
						break;
					// ID not found
					case "2":
						trace("ID you input is not found");
						break;
				}
			}
			else
				trace("Login Failed");
				
			// This line also is needed to get values normally and I don't know the reason
			var usercmd = URLLoader(event.target).data.usercmd;
			trace("usercmd: ", usercmd);
		}*/
		
		private function GameLoop(e:Event){
			switch(gameState){
				case STATE_MAIN:
					displayMain();
					break;
				case STATE_SELECT_STAGE:
					selectStage();
					break;
				case STATE_START_GAME:
					startGame();
					break;
				case STATE_SHOW_RANK:
					showRank();
					break;
				case STATE_END_GAME:
					endGame();
					break;
				case STATE_SETTING:
					settingGame();
					break;
			}
		}
		
		private function createScreen(){
			mainScreen = new MainScreen();
			gameScreen = new GameScreen();
			rankScreen = new RankScreen();
			settingScreen = new SettingScreen();
			stageScreen = new StageScreen();
			
			mainScreen.addEventListener(Event.REMOVED_FROM_STAGE, GameLoop);
			stageScreen.addEventListener(Event.REMOVED_FROM_STAGE, GameLoop);
			gameScreen.addEventListener(Event.REMOVED_FROM_STAGE, GameLoop);
			rankScreen.addEventListener(Event.REMOVED_FROM_STAGE, GameLoop);
			settingScreen.addEventListener(Event.REMOVED_FROM_STAGE, GameLoop);
		}
		
		private function displayMain(){
			removeEventListener(Event.ENTER_FRAME, GameLoop);
			addChild(mainScreen);
			
			// Play gameBG Sound
			if(bgName != "mainBG"){
				bgName = "mainBG";
				SoundMixer.stopAll();
				bgChannel = mainBGSnd.play(0, 1000000, bgTrans);
			}
		}
				
		private function selectStage(){
			removeEventListener(Event.ENTER_FRAME, GameLoop);
			addChild(stageScreen);
		}
		
		private function startGame(){
			addChild(gameScreen);
			gameScreen.addEventListener(Event.ENTER_FRAME, gameScreen.continueGame);
			
			// Play gameBG Sound
			if(bgName != "gameBG"){
				bgName = "gameBG";
				SoundMixer.stopAll();
				bgChannel = gameBGSnd.play(0, 1000000, bgTrans);
			}
		}
		
		private function showRank(){
			removeEventListener(Event.ENTER_FRAME, GameLoop);
			addChild(rankScreen);
		}
		
		private function settingGame(){
			removeEventListener(Event.ENTER_FRAME, GameLoop);
			addChild(settingScreen);
		}
		
		private function endGame(){
			saveData();
			
			SoundMixer.stopAll();
			fscommand("quit");
		}
		
		// save Timer Handler
		private function saveTimerHandler(e:TimerEvent){
			// saveData();
		}
		
		private function saveData(){
			settingScreen.saveData();
			rankScreen.saveData();
			gameScreen.saveData();
		}
		
		public function setRank(){
			rankScreen.setRank();
		}
	}
}