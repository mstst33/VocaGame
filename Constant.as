package  {
	// import flash.display3D.IndexBuffer3D;
	import fl.text.ruler.ITabPicker;
	
	public  class Constant {

        //게임 진행중의  화면 효과
        static const HONGDAN: int = 0; 
		static const CHONGDAN: int = 1;
		static const CHODAN:int = 2;
		static const GODORI:int = 3;
		static const TRHEEKWANG:int = 4;
		static const FOURKWANG:int = 5;
		static const FIVEKWANG: int = 6;
		static const PPUK:int = 7; //solsa
		static const JJOK:int = 8;
		static const SWING:int = 9;
		static const SMOKE: int = 10;
		static const GO:int = 11;
		//static const LARGE_NUMBER:int = 12;
		static const DDADAK: int = 12; //따닥
		static const BOMB:int =13;
		static const MISSION_SUCCESS:int = 14;
		static const CHONGTONG: int = 15;
		static const PPUKTWO:int = 16;
		static const PPUKTHREE:int = 17;
		static const PPUK_MOKI:int = 18;
	    static const HUTJIT: int = 19; //패를 내고 아무것도 가져오지 못함
        ////
		
		//화면효과 아이콘(혹 sprite)이 포함된 파일명(BitmapData 클래스명)
		//NEXT 나중에 확인후 필요시 수정 요망
		/*
		static const effectISpriteContainerClass:Array = 
		  [effect1_png,  //0 - HONGDAN 이미지 clip이 담긴 class 이름
		   effect1_png,  //1 - CHONGDAN:
		   effect1_png, 
		   effect1_png, 
		   effect1_png,  //4
		   effect1_png, 
		   effect1_png, 
		   notify1_png, //7 - PPUK
		   effect1_png, //8
		   effect1_png, //9
		   effect1_png, //10 - SMOKE
		   notify1_png, //11 - GO text
		   effect1_png,
		   effect1_png,
		   effect1_png,  //14
		   effect1_png,
		   effect1_png,
		   effect1_png,
		   effect1_png,  //18 PPUK_MOKI
		   emoticon1_png, //19-HUTJIT
		  ];
		  */
		//화면효과 아이콘(혹 sprite)의 파일(BitmapData 클래스)내 위치
		//NEXT 나중에 확인후 필요시 수정 요망
		static const POSWH:Array = 
		[ [713,1, 50, 90], //0 HONGDAN  (x, y, width, height) in image , effect1_png
		  [800,255, 50, 90],  //1 CHONGDAN:
		  [600,270, 50, 90],  //2 CHODAN
		  [250,1, 275, 110],  //3 GODORI
		  [713,1, 50, 90],  //4 3광
		  [713,1, 50, 90],  //5 4광
		  [713,1, 50, 90],  //6 5광
		  [925, 240, 95, 100], //7 // PPUK
		  [713,1, 50, 90],  //8   //JJOK
		  [713,1, 50, 90],  //9   //SWING
		  [150,180, 100, 100],    //10 - SMOKE
		  [270, 420, 90, 70],     //11 - GO text
		  [0,0, 30, 30],  //12 - dummy
		  [0,0, 30, 30],  //13 - dummy
		  [0,0, 30, 30],  //14 - dummy
		  [0,0, 30, 30],  //15 - dummy
		  [0,0, 30, 30],  //16 - dummy
		  [0,0, 30, 30],  //17 - dummy
		  [0,0, 30, 30],  //18 PPUK_MOKI - dummy
		  [356,80, 100,80], //19 - HUTJIT 헛짓
		]; 
		
		//사용안함
		static const effectISpriteContainer:Array = 
		  ["effect1_png",  //0 - HONGDAN 이미지 clip이 담긴 class 이름
		   "effect1_png",  //1 - CHONGDAN:
		   "effect1_png", "effect1_png", "effect1_png",
		   "effect1_png", "effect1_png", 
		   "effect1_png",  //7
		   "effect1_png",  //8
		   "effect1_png",  //9 - SWING
		   "effect1_png", //10 - SMOKE
		   "notify1_png", //11 - GO text
		   //"jumsoo_png" //12 - LARGE NUMBER FILE
		  ];
		

		  
		//player 정보 표시에 대한 화면 위치 (PersonInfo Sprite 내에서의 위치)
		static const namePosition:Array = [200, 10, 200, 200]; //for player T=0, 1
		static const gradePosition:Array = [250, 10, 250, 200]; //for player T=0, 1
		static const cyberMoneyPosition: Array = [200+50, 10, 200+50, 200]; //for player T=0, 1
		
		//여러 player 얼굴 이미지가 담긴 파일(클래스)명, 위치 및 크기들
		static const playerSpriteContainer: String = "no_user_png";
		static const playerSpritePosSizeArray:Array = [0,0, 100, 100, //pos and size for 1st picture
													 0,0, 100, 100,  //pos and size for 2nd picture
													 0,0, 100, 100,  //pos and size for 3rd picture
													 0,0, 100, 100   ////pos and size for 4th picture
													 ]; //NEXT 나중에 확장
													 
		//등급(레벨) 아이콘이 담긴 파일(클래스)명, 레별별 위치 및 크기											 
		static const gradeSpriteContainer:String = "no_user_png";
		static const gradeSpritePosSizeArray:Array = [0,0, 50, 50, //level 1 image 
													 0,0, 50, 50, //level 2  image
													 0, 0, 50, 50, //level 3 image
													 0, 0, 50, 50]; //level 4 image
													 //NEXT 나중에 확장
		//돈 단위
		static const MAN:int = 0;
		static const CHON:int = 1;
		static const UK: int = 2;
		static const NYANG: int = 3;
		
		//돈 단위 아이콘(sprite)이 담긴 파일(클래스), 위치및 크기
		static const moneyUnitSpriteContainer:String = "category1_png";
		static const moneyUnitSpritePosSize:Array = [ //color1
													 100, 100, 20, 20, //만
													 100, 100, 20, 20, //천
		                                             100, 100, 20, 20, //억
													 100, 100, 20, 20,  //냥
													 //color2
													 100, 100, 20, 20, //만
													 100, 100, 20, 20, //천
		                                             100, 100, 20, 20, //억
													 100, 100, 20, 20  //냥
													 ]; 
		
		//작은크기 number들이 담긴 파일(클래스), 위치 및 크기
		static const smallNumberSpriteContainer:String = "category1_png";
		static const smallNumberSpritePosSize:Array = [//color1
													 100, 100, 20, 20, //0
													 100, 100, 20, 20, //1
		                                             100, 100, 20, 20, //2
													 100, 100, 20, 20, //3
													 100, 100, 20, 20, //4
                                                     100, 100, 20, 20, //5
													 100, 100, 20, 20, //6
													 100, 100, 20, 20, //7
													 100, 100, 20, 20, //8
													 100, 100, 20, 20, //9
													 
													 //color2
													 100, 100, 20, 20, //0
													 100, 100, 20, 20, //1
		                                             100, 100, 20, 20, //2
													 100, 100, 20, 20, //3
													 100, 100, 20, 20, //4
                                                     100, 100, 20, 20, //5
													 100, 100, 20, 20, //6
													 100, 100, 20, 20, //7
													 100, 100, 20, 20, //8
													 100, 100, 20, 20, //9
													 
													 ]; 
													 
		//static const largeNumberSpriteContainer:String = "jumsoo_png";
		//큰 숫자들이 모인 파일(클래스명), 위치 및 크기
		static const largeNumberSpriteContainer:Array = [jumsoo_png];
		static const largeNumberSpritePosSize:Array = [
													 //color 1
													 64, 88, 30, 45, //0
													 62,180, 23, 45, //1
		                                             0, 46, 30, 45, //2
													 0, 90, 30, 45, //3
													 93, 46, 33, 45, //4
                                                     30, 0, 30, 45, //5
													 30, 90, 30, 45, //6
													 0, 0, 30, 45, //7
													 30, 46, 30, 45, //8
													 30, 137, 30, 45, //9
													 
													 //color 2
													 64, 88, 30, 45, //0
													 85, 180, 23, 45, //1
		                                             95, 0, 30, 45, //2
													 0, 180, 30, 45, //3
													 95, 90, 30, 45, //4
                                                     65, 0, 30, 45, //5
													 95, 135, 30, 45, //6
													 60, 44, 30, 45, //7
													 0, 135, 30, 45, //8
													 30, 180, 30, 45, //9
													 ]; 
													
		//'점' 텍스트가 담긴 파일(클래스), 위치 및 크기
		static const jumSpriteContainer:String = "category2_png";
		static const jumSpritePosSize:Array = [0,490, 20, 20];
		
		//PlayGoStopClass 화면(sprite)에서
		//점수, 고, 스윙, 뻑수를 나타내는 숫자들의 위치
		static const score_go_swing_ppuk_Pos: Array = [
			   //Player0 - My
			   640, 220, //score
			   640, 245, //go
			   640, 270, //swing
			   640, 295, //ppuk
			   
			   //Player1 Opp
               640, 100, //score
			   640, 125, //go
			   640, 150, //swing
			   640, 175 //ppuk
			   ];
			   
		
		public function Constant() {
			// constructor code
		}

	}
	
}
