package  {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.media.*;
	
	public class WordSet{
		public var wordSet:Array;
		public var stageNum:int;
		public var wordsNum:int;
		public var eventNum:int;
		
		private var textformat:TextFormat;
		public var textArray:Array;
		public var eventIndexArray:Array;
		
		public var alreadyIn:Boolean;
		private var normalNum:int;
		private var normalEventNum:int;
		private var hardNum:int;
		private var hardEventNum:int;
		
		private var normalLevel:Array;
		private var hardLevel:Array;
		private var scaleOfX:Number;
		private var scaleOfY:Number
		
		private var tempDeck:Array;
		private var eventDeck:Array;
		
		public static var inst:WordSet = null;
		
		public function WordSet(){
			stageNum = 20;
			wordsNum = 24;
			scaleOfX = 1.45;
			scaleOfY = 1.5;
			
			makeWords();
		}
		
		public static function getInst():WordSet {
			if(inst == null)
			    inst = new WordSet();
				
			return inst;
		}
		
		public function getWordsImage(num:int):Sprite{
			return SubWordSet(wordSet[GameScreen.stageLv - 1]).words[num];
		}
		
		public function getWordsCopyImage(num:int):Sprite{
			return SubWordSet(wordSet[GameScreen.stageLv - 1]).showWords[num];
		}
		
		public function getWordsLoc():Array{
			return SubWordSet(wordSet[GameScreen.stageLv - 1]).locs;
		}
		
		public function getWordsText(num:int):String{
			return SubWordSet(wordSet[GameScreen.stageLv - 1]).texts[num];
		}
		
		public function getWordsSound(num:int):Sound{
			return SubWordSet(wordSet[GameScreen.stageLv - 1]).sounds[num];
		}
		
		public function isEvent(num:int):int{
			if(SubWordSet(wordSet[GameScreen.stageLv - 1]).events[num] != 0){
				if(SubWordSet(wordSet[GameScreen.stageLv - 1]).words[num].contains(eventIndexArray[num]) && GameScreen.miniFlag){
				    return SubWordSet(wordSet[GameScreen.stageLv - 1]).events[num];
				}
				else{
					return 0;
				}
			}
			else{
				return 0;
			}
		}
		
		public function getDescript(num:int){
			return SubWordSet(wordSet[num]).description;
		}
				
		public function resetIndex(){
			for(var i:int = 0; i < wordsNum; i++)
				if(SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].contains(eventIndexArray[i]) && GameScreen.miniFlag)
				   SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].removeChild(eventIndexArray[i])
		}
		
		public function removeEvent(num:int){
			if(SubWordSet(wordSet[GameScreen.stageLv - 1]).words[num].contains(eventIndexArray[num]) && GameScreen.miniFlag)
				   SubWordSet(wordSet[GameScreen.stageLv - 1]).words[num].removeChild(eventIndexArray[num])
		}
		
		public function shuffleWords(){
			var randWordNum1:int;
			var randWordNum2:int;
			var randEventNum:int;
			
			var tempWord:Sprite;
			var tempX:int;
			var tempY:int;
			var tempText:String;
			var tempSound:Sound;
			var tempLoc:int;
			var tempEvent:int;
			var tempImage:Sprite;
			
			// Shuffle words
			for(var i:int = 0; i < wordsNum * 5; i++){
				randWordNum1 = int(Math.random() * wordsNum);
				randWordNum2 = int(Math.random() * wordsNum);
				
				tempWord = Sprite(SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1] = Sprite(SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2] = tempWord;
				
				tempWord = Sprite(SubWordSet(wordSet[GameScreen.stageLv - 1]).showWords[randWordNum1]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).showWords[randWordNum1] = Sprite(SubWordSet(wordSet[GameScreen.stageLv - 1]).showWords[randWordNum2]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).showWords[randWordNum2] = tempWord;
				
				tempX = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1].x;
				tempY = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1].y;
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1].x = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2].x;
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum1].y = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2].y;
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2].x = tempX;
				SubWordSet(wordSet[GameScreen.stageLv - 1]).words[randWordNum2].y = tempY;
				
				tempText = SubWordSet(wordSet[GameScreen.stageLv - 1]).texts[randWordNum1];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).texts[randWordNum1] = SubWordSet(wordSet[GameScreen.stageLv - 1]).texts[randWordNum2];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).texts[randWordNum2] = tempText;
				
				tempSound = Sound(SubWordSet(wordSet[GameScreen.stageLv - 1]).sounds[randWordNum1]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).sounds[randWordNum1] = Sound(SubWordSet(wordSet[GameScreen.stageLv - 1]).sounds[randWordNum2]);
				SubWordSet(wordSet[GameScreen.stageLv - 1]).sounds[randWordNum2] = tempSound;
			}
			
			// Shuffle events
			for(i = 0; i < 100; ++i){
				randEventNum = int(Math.random() * 12);
				
				tempEvent = SubWordSet(wordSet[GameScreen.stageLv - 1]).events[randEventNum];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).events[randEventNum] = SubWordSet(wordSet[GameScreen.stageLv - 1]).events[i % 12];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).events[i % 12] = tempEvent;
					
				tempImage = eventIndexArray[randEventNum];
				eventIndexArray[randEventNum] = eventIndexArray[i % 12];
				eventIndexArray[i % 12] = tempImage;
			}
			
			for(i = 0; i < 100; ++i){
				randEventNum = 12 + int(Math.random() * 12);
					
				tempEvent = SubWordSet(wordSet[GameScreen.stageLv - 1]).events[randEventNum];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).events[randEventNum] = SubWordSet(wordSet[GameScreen.stageLv - 1]).events[12 + i % 12];
				SubWordSet(wordSet[GameScreen.stageLv - 1]).events[12 + i % 12] = tempEvent;
					
				tempImage = eventIndexArray[randEventNum];
				eventIndexArray[randEventNum] = eventIndexArray[12 + i % 12];
				eventIndexArray[12 + i % 12] = tempImage;
			}
			
			// Take positions of events
			for(i = 0; i < wordsNum; i++){
				if(SubWordSet(wordSet[GameScreen.stageLv - 1]).events[i] == 1 ){
					eventIndexArray[i].x = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].width / 2;
					eventIndexArray[i].y = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].height / 2;
				}
				else if(SubWordSet(wordSet[GameScreen.stageLv - 1]).events[i] == 6){
					// eventIndexArray[i].x = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].width / 20;
					// eventIndexArray[i].y = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].height / 100 - 10;
					eventIndexArray[i].x = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].width / 2.5;
					eventIndexArray[i].y = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].height / 2.5;
				}
				else{
					eventIndexArray[i].x = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].width / 3;
					eventIndexArray[i].y = SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].height / 3;
				}
				
				if(SubWordSet(wordSet[GameScreen.stageLv - 1]).events[i] != 0){
					SubWordSet(wordSet[GameScreen.stageLv - 1]).words[i].addChild(eventIndexArray[i]);
				}
			}
		}
		
		public function makeWords(){
			var count:int = 0;
			wordSet = new Array();
			eventIndexArray = new Array();
			
			for(var i:int = 0; i < stageNum; i++){
				var subWordSet:SubWordSet = new SubWordSet();
				wordSet.push(subWordSet);
			}
			
			// Add event images
			for(i = 0; i < wordsNum; ++i){
				eventIndexArray.push(new event_index());
			}
				
			eventIndexArray[3] = new carrot();
			eventIndexArray[3].width = 22;
			eventIndexArray[3].height = 34;
			
			eventIndexArray[4] = new weapon();
			eventIndexArray[4].width = 34;
			eventIndexArray[4].height = 34;
			
			eventIndexArray[5] = new shield();
			eventIndexArray[5].width = 34;
			eventIndexArray[5].height = 34;
			
			eventIndexArray[6] = new shoes();
			eventIndexArray[6].width = 34;
			eventIndexArray[6].height = 34;
			
			eventIndexArray[7] = new dog_image();
			eventIndexArray[7].width = 34;
			eventIndexArray[7].height = 34;
			eventIndexArray[7].stop();
			
			eventIndexArray[15] = new carrot();
			eventIndexArray[15].width = 22;
			eventIndexArray[15].height = 34;
			
			eventIndexArray[16] = new weapon();
			eventIndexArray[16].width = 34;
			eventIndexArray[16].height = 34;
			
			eventIndexArray[17] = new shield();
			eventIndexArray[17].width = 34;
			eventIndexArray[17].height = 34;
			
			eventIndexArray[18] = new shoes();
			eventIndexArray[18].width = 34;
			eventIndexArray[18].height = 34;
			
			eventIndexArray[19] = new dog_image();
			eventIndexArray[19].width = 34;
			eventIndexArray[19].height = 34;
			eventIndexArray[19].stop();
			
			
			var showWordsX:Number = ((7 * Vocagame.screenWidth) / 9) / 2;
			var showWordsY:Number = Vocagame.screenHeight / 2;
			
			// stageLv1 초성 ㄱ
			var words:Array = [new mirror1(), new meat1(), new guyl1(), new gim1(), new gasi1(), new gam1(), new gaji1(), new gajae1(), 
							   new frog1(), new egg1(), new ear1(), new dog1(), new chilli1, new cat1(), new bear1(), new ball1(),
							   new bag1(), new ant1(), new whale1(), new turtle1(), new sweet_potato1(), new spider1(), new sissors1(), new potato1()];
			var showWords:Array = [new mirror1(), new meat1(), new guyl1(), new gim1(), new gasi1(), new gam1(), new gaji1(), new gajae1(), 
							   new frog1(), new egg1(), new ear1(), new dog1(), new chilli1, new cat1(), new bear1(), new ball1(),
							   new bag1(), new ant1(), new whale1(), new turtle1(), new sweet_potato1(), new spider1(), new sissors1(), new potato1()];
			var texts:Array = ["거울", "고기", "귤", "김", "가시", "감", "가지", "가재",
							   "개구리", "계란", "귀", "개", "고추", "고양이", "곰", "공",
							   "가방", "개미", "고래", "거북이", "고구마", "거미", "가위", "감자"];
			var sounds:Array = [new 거울(), new 고기(), new 귤(), new 김(), new 가시(), new 감(), new 가지(), new 가재(),
								new 개구리(), new 계란(), new 귀(), new 개(), new 고추(), new 고양이(), new 곰(), new 공(),
								new 가방(), new 개미(), new 고래(), new 거북이(), new 고구마(), new 거미(), new 가위(), new 감자()];
			var locs:Array = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
							  [456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
							  [633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			var events:Array = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			var descript:String = "초성 ㄱ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], Sound(sounds[i]), locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			/*
			// stageLv2 초성 ㄷ
			words = [new moon2(), new money2(), new mandu2(), new gudu2(), new grape2(), new feet2(), new eagle2(), new dudeogy2(), 
					 new dotori2(), new doma2(), new dalpanyi2(), new cyda2(), new cigarette2(), new chicken2(), new carrot2(), new calendar2(),
					 new bridge2(), new ax2(), new tofu2(), new squirrel2(), new sea2(), new pig2(), new paldae2(), new net2()];
			showWords = [new moon2(), new money2(), new mandu2(), new gudu2(), new grape2(), new feet2(), new eagle2(), new dudeogy2(), 
					 new dotori2(), new doma2(), new dalpanyi2(), new cyda2(), new cigarette2(), new chicken2(), new carrot2(), new calendar2(),
					 new bridge2(), new ax2(), new tofu2(), new squirrel2(), new sea2(), new pig2(), new paldae2(), new net2()];
			texts = ["달", "돈", "만두", "구두", "포도", "다리", "독수리", "두더지",
					 "도토리", "도마", "달팽이", "사이다", "담배", "닭", "당근", "달력",
					 "다리", "도끼", "두부", "다람쥐", "바다", "돼지", "빨대", "둥지"];
			sounds = [new 달(), new 돈(), new 만두(), new 구두(), new 포도(), new 다리(), new 독수리(), new 두더지(),
					  new 도토리(), new 도마(), new 달팽이(), new 사이다(), new 담배(), new 닭(), new 당근(), new 달력(),
					  new 다리(), new 도끼(), new 두부(), new 다람쥐(), new 바다(), new 돼지(), new 빨대(), new 둥지()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㄷ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv3 초성 ㄹ
			words = [new ribbon3(), new robot3(), new rocket3(), new tiger3(), new triangle3(), new truck3(), new whale3(), new block3(), 
					 new camera3(), new chelo3(), new coala3(), new cola3(), new crayong3(), new squirrel3(), new dinosaurs3(), new egg3(),
					 new fry_pan3(), new heater3(), new lighter3(), new melon3(), new miggurumtle3(), new forkrane3(), new radio3(), new ramen3()];
			showWords = [new ribbon3(), new robot3(), new rocket3(), new tiger3(), new triangle3(), new truck3(), new whale3(), new block3(), 
					 new camera3(), new chelo3(), new coala3(), new cola3(), new crayong3(), new squirrel3(), new dinosaurs3(), new egg3(),
					 new fry_pan3(), new heater3(), new lighter3(), new melon3(), new miggurumtle3(), new forkrane3(), new radio3(), new ramen3()];
			texts = ["리본", "로봇", "로켓", "호랑이", "트롸앵글", "트럭", "고래", "블럭",
					 "카메라", "첼로", "코알라", "콜라", "크레파스", "다람쥐", "공룡", "계란",
					 "후라이팬", "난로", "라이터", "멜론", "미끄럼틀", "포크레인", "라디오", "라면"];
			sounds = [new 리본(), new 로봇(), new 로켓(), new 호랑이, new 트롸앵글(), new 트럭(), new 고래(), new 블럭(),
					  new 카메라(), new 첼로(), new 코알라(), new 콜라(), new 크레파스(), new 다람쥐(), new 공룡(), new 계란(),
					  new 후라이팬(), new 난로(), new 라이터(), new 멜론(), new 미끄럼틀(), new 포크레인(), new 라디오(), new 라면()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㄹ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv4 초성 ㅂ
			words = [new bam(), new banana(), new bee(), new belly(), new bus(), new butterfly(), new cabbage(), new cigarette(), 
					 new comb(), new dubu(), new fire(), new fisherman(), new foot, new pants(), new peer(), new plane(),
					 new rain(), new rice(), new ring(), new ship(), new snake(), new soap(), new star(), new wheel()];
			showWords = [new bam(), new banana(), new bee(), new belly(), new bus(), new butterfly(), new cabbage(), new cigarette(), 
					 new comb(), new dubu(), new fire(), new fisherman(), new foot, new pants(), new peer(), new plane(),
					 new rain(), new rice(), new ring(), new ship(), new snake(), new soap(), new star(), new wheel()];
			texts = ["밤", "바나나", "벌", "배", "버스", "나비", "배추", "담배",
					 "참빗", "두부", "불", "어부", "발", "바지", "배", "비행기",
					 "비", "밥", "반지", "배", "뱀", "비누", "별", "바퀴"];
			sounds = [new 밤(), new 바나나(), new 벌(), new 배(), new 버스(), new 나비(), new 배추(), new 담배(),
					  new 참빗(), new 두부(), new 불(), new 어부(), new 발(), new 바지(), new 배(), new 비행기(),
					  new 비(), new 밥(), new 반지(), new 배(), new 뱀(), new 비누(), new 별(), new 바퀴()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅂ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv5 초성 ㅈ
			words = [new rose5(), new shell5(), new sleepness5(), new telephone5(), new vest5(), new wallet5(), new bell5(), new bicycle5(), 
					 new bulb5(), new chopstics5(), new dish5(), new gloves5(), new house5(), new ja5(), new jajjangmyeon5(), new jam5(),
					 new jamjari5(), new janggu5(), new juice5(), new jujeonja5(), new dice5(), new jusagi5(), new juz5(), new mouse5()];
			showWords = [new rose5(), new shell5(), new sleepness5(), new telephone5(), new vest5(), new wallet5(), new bell5(), new bicycle5(), 
					 new bulb5(), new chopstics5(), new dish5(), new gloves5(), new house5(), new ja5(), new jajjangmyeon5(), new jam5(),
					 new jamjari5(), new janggu5(), new juice5(), new jujeonja5(), new dice5(), new jusagi5(), new juz5(), new mouse5()];
			texts = ["장미", "조개껍질", "잠", "전화기", "조끼", "지갑", "종", "자전거",
					 "전구", "젓가락", "접시", "장갑", "집", "자", "자장면", "잼",
					 "잠자리", "장구", "주스", "주전자", "주사위", "주사기", "젖", "쥐"];
			sounds = [new 장미(), new 조개껍질(), new 잠(), new 전화기(), new 조끼(), new 지갑(), new 종(), new 자전거(),
					  new 전구(), new 젓가락(), new 접시(), new 장갑(), new 집(), new 자(), new 자장면(), new 잼(),
					  new 잠자리(), new 장구(), new 주스(), new 주전자(), new 주사위(), new 주사기(), new 젖(), new 쥐()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅈ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv6 초성 ㅊ
			words = [new toothbrush6(), new toothpaste6(), new train6(), new uchiwon6(), new vegetable6(), new vinegar6(), new apron6(), new baechu6(), 
					 new bed6(), new buchae6(), new book6(), new candle6(), new car6(), new chamwhae6(), new checkjang6(), new chelo6(),
					 new chilli6(), new chocolate6(), new danchu6(), new dental_place6(), new desk6(), new note6(), new gun6(), new skirt6()];
			showWords = [new toothbrush6(), new toothpaste6(), new train6(), new uchiwon6(), new vegetable6(), new vinegar6(), new apron6(), new baechu6(), 
					 new bed6(), new buchae6(), new book6(), new candle6(), new car6(), new chamwhae6(), new checkjang6(), new chelo6(),
					 new chilli6(), new chocolate6(), new danchu6(), new dental_place6(), new desk6(), new note6(), new gun6(), new skirt6()];
			texts = ["칫솔", "치약", "기차", "유치원", "야채", "식초", "앞치마", "배추",
					 "침대", "부채", "책", "양초", "자동차", "참외", "책장", "첼로",
					 "고추", "초콜릿", "단추", "치과", "책상", "공책", "총", "치마"];
			sounds = [new 칫솔(), new 치약(), new 기차(), new 유치원(), new 야채(), new 식초(), new 앞치마(), new 배추(),
					  new 침대(), new 부채(), new 책(), new 양초(), new 자동차(), new 참외(), new 책장(), new 첼로(),
					  new 고추(), new 초콜릿(), new 단추(), new 치과(), new 책상(), new 공책(), new 총(), new 치마()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅊ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv7 초성 ㅋ
			words = [new harmonica7(), new fork7(), new elephant7(), new curtain7(), new cup7(), new computer7(), new cola7(), new coffee7(), 
					 new clip7(), new casette7(), new card7(), new camera7(), new cake7(), new cablecar7(), new bean7(), new tank7(),
					 new skate7(), new popcone7(), new nuts7(), new nose7(), new kongnamul7(), new coala7(), new kiwi7(), new knife7()];
			showWords = [new harmonica7(), new fork7(), new elephant7(), new curtain7(), new cup7(), new computer7(), new cola7(), new coffee7(), 
					 new clip7(), new casette7(), new card7(), new camera7(), new cake7(), new cablecar7(), new bean7(), new tank7(),
					 new skate7(), new popcone7(), new nuts7(), new nose7(), new kongnamul7(), new coala7(), new kiwi7(), new knife7()];
			texts = ["하모니카", "포크", "코끼리", "커튼", "컵", "컴퓨터", "콜라", "커피",
					 "클립", "카세트", "카드", "카메라", "케이크", "케이블카", "콩", "탱크",
					 "스케이트", "팝콘", "땅콩", "코", "콩나물", "코알라", "키위", "칼"];
			sounds = [new 하모니카(), new 포크(), new 코끼리(), new 커튼(), new 컵(), new 컴퓨터(), new 콜라(), new 커피(),
					  new 클립(), new 카세트(), new 카드(), new 카메라(), new 케이크(), new 케이블카(), new 콩(), new 탱크(),
					  new 스케이트(), new 팝콘(), new 땅콩(), new 코(), new 콩나물(), new 코알라(), new 키위(), new 칼()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅋ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv8 초성 ㅌ
			words = [new tap8(), new taxi8(), new tent8(), new top8(), new tuk8(), new washingmachine8(), new apartments8(), new autobicycle8(), 
					 new candy8(), new curtain8(), new dotori8(), new envelope8(), new baltop8(), new fur8(), new helicopter8(), new paint8(),
					 new skate8(), new taegukgi8(), new taekwondo8(), new tajo8(), new tabletennis8(), new tal8(), new tamberin8(), new tank8()];
			showWords = [new tap8(), new taxi8(), new tent8(), new top8(), new tuk8(), new washingmachine8(), new apartments8(), new autobicycle8(), 
					 new candy8(), new curtain8(), new dotori8(), new envelope8(), new baltop8(), new fur8(), new helicopter8(), new paint8(),
					 new skate8(), new taegukgi8(), new taekwondo8(), new tajo8(), new tabletennis8(), new tal8(), new tamberin8(), new tank8()];
			texts = ["탑", "택시", "텐트", "톱", "턱", "세탁기", "아파트", "오토바이",
					 "캔디", "커튼", "도토리", "봉투", "발톱", "깃털", "헬리콥터", "페인트",
					 "스케이트", "태극기", "태권도", "타조", "탁구", "탈", "탬버린", "탱크"];
			sounds = [new 탑(), new 택시(), new 텐트(), new 톱(), new 턱(), new 세탁기(), new 아파트(), new 오토바이(),
					  new 캔디(), new 커튼(), new 도토리(), new 봉투(), new 발톱(), new 깃털(), new 헬리콥터(), new 페인트(),
					  new 스케이트(), new 태극기(), new 태권도(), new 타조(), new 탁구(), new 탈(), new 탬버린(), new 탱크()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅌ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv9 초성 ㅍ
			words = [new popcorn9(), new porklane9(), new pul9(), new pungsun9(), new puzzle9(), new spinner9(), new underwear9(), new arm9(), 
					 new armring9(), new blood9(), new fly9(), new glue9(), new grape9(), new letter9(), new pa9(), new paint9(),
					 new penguin9(), new perm9(), new piano9(), new pimang9(), new pin9(), new pineapple9(), new piri9(), new pizza9()];
			showWords = [new popcorn9(), new porklane9(), new pul9(), new pungsun9(), new puzzle9(), new spinner9(), new underwear9(), new arm9(), 
					 new armring9(), new blood9(), new fly9(), new glue9(), new grape9(), new letter9(), new pa9(), new paint9(),
					 new penguin9(), new perm9(), new piano9(), new pimang9(), new pin9(), new pineapple9(), new piri9(), new pizza9()];
			texts = ["팝콘", "포크레인", "수풀", "풍선", "퍼즐", "팽이", "팬티", "팔",
					 "팔찌", "피", "파리", "풀", "포도", "편지", "파", "페인트",
					 "펭귄", "파마", "피아노", "피망", "핀", "파인애플", "피리", "피자"];
			sounds = [new 팝콘(), new 포크레인(), new 수풀(), new 풍선(), new 퍼즐(), new 팽이(), new 팬티(), new 팔(),
					  new 팔찌(), new 피(), new 파리(), new 풀(), new 포도(), new 편지(), new 파(), new 페인트(),
					  new 펭귄(), new 파마(), new 피아노(), new 피망(), new 핀(), new 파인애플(), new 피리(), new 피자()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅍ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv10 초성 ㄴ
			words = [new sister10(), new snow10(), new soap10(), new teacher10(), new tree10(), new you10(), new banana10(), new butterfly10(), 
					 new eye10(), new grandmother10(), new gune10(), new hamonica10(), new na10(), new nambi10(), new namby10(), new napal10(),
					 new nemo10(), new piano10(), new snow10(), new gune10(), new napal10(), new nemo10(), new tree10(), new hamonica10()];
			showWords = [new sister10(), new snow10(), new soap10(), new teacher10(), new tree10(), new you10(), new banana10(), new butterfly10(), 
					 new eye10(), new grandmother10(), new gune10(), new hamonica10(), new na10(), new nambi10(), new namby10(), new napal10(),
					 new nemo10(), new piano10(), new snow10(), new gune10(), new napal10(), new nemo10(), new tree10(), new hamonica10()];
			texts = ["누나", "눈", "비누", "선생님", "나무", "너", "바나나", "나비",
					 "눈", "할머니", "그네", "하모니카", "나", "냄비", "냄비", "나팔",
					 "네모", "피아노", "눈", "그네", "나팔", "네모", "나무", "하모니카"];
			sounds = [new 누나(), new 눈(), new 비누(), new 선생님(), new 나무(), new 너(), new 바나나(), new 나비(),
					  new 눈(), new 할머니(), new 그네(), new 하모니카(), new 나(), new 냄비(), new 냄비(), new 나팔(),
					  new 네모(), new 피아노(), new 눈(), new 그네(), new 나팔(), new 네모(), new 나무(), new 하모니카()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㄴ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv11 초성 ㅁ
			words = [new mando11(), new manhwa11(), new mom11(), new mosquito11(), new mu11(), new neck11(), new nemo11(), new rose11(), 
					 new rose11(), new skirt11(), new spider11(), new sweetpotato11(), new tomato11(), new water11(), new ant11(), new aunt11(),
					 new cap11(), new doma11(), new door11(), new grandmother11(), new helmet11(), new hippo11(), new horse11(), new maemi11()];
			showWords = [new mando11(), new manhwa11(), new mom11(), new mosquito11(), new mu11(), new neck11(), new nemo11(), new rose11(), 
					 new perm11(), new skirt11(), new spider11(), new sweetpotato11(), new tomato11(), new water11(), new ant11(), new aunt11(),
					 new cap11(), new doma11(), new door11(), new grandmother11(), new helmet11(), new hippo11(), new horse11(), new maemi11()];
			texts = ["만두", "만화", "엄마", "모기", "무", "목", "네모", "장미",
					 "파마", "치마", "거미", "고구마", "토마토", "물", "개미", "이모",
					 "모자", "도마", "문", "할머니", "헬멧", "하마", "말", "매미"];
			sounds = [new 만두(), new 만화(), new 엄마(), new 모기(), new 무(), new 목(), new 네모(), new 장미(),
					  new 파마(), new 치마(), new 거미(), new 고구마(), new 토마토(), new 물(), new 개미(), new 이모(),
					  new 모자(), new 도마(), new 문(), new 할머니(), new 헬멧(), new 하마(), new 말(), new 매미()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅁ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv12 초성 ㅅ
			words = [new sugun12(), new sungnyang12(), new suninjang12(), new teacher12(), new washingmachine12(), new watermelon12(), new apple12(), new candy12(), 
					 new deer12(), new gift12(), new lion12(), new picture12(), new nemo12(), new sandwitch12(), new sausage12(), new semo12(),
					 new skate12(), new skechbook12(), new ski12(), new sobangcha12(), new sofa12(), new sofo12(), new somsatang12(), new spoon12()];
			showWords = [new sugun12(), new sungnyang12(), new suninjang12(), new teacher12(), new washingmachine12(), new watermelon12(), new apple12(), new candy12(), 
					 new deer12(), new gift12(), new lion12(), new picture12(), new nemo12(), new sandwitch12(), new sausage12(), new semo12(),
					 new skate12(), new skechbook12(), new ski12(), new sobangcha12(), new sofa12(), new sofo12(), new somsatang12(), new spoon12()];
			texts = ["수건", "성냥", "선인장", "선생님", "세탁기", "수박", "사과", "사탕",
					 "사슴", "선물", "사자", "사진", "색종이", "샌드위치", "소시지", "세모",
					 "스케이트", "스케치북", "스키", "소방차", "소파", "소포", "솜사탕", "스푼"];
			sounds = [new 수건(), new 성냥(), new 선인장(), new 선생님(), new 세탁기(), new 수박(), new 사과(), new 사탕(),
					  new 사슴(), new 선물(), new 사자(), new 사진(), new 색종이(), new 샌드위치(), new 소시지(), new 세모(),
					  new 스케이트(), new 스케치북(), new 스키(), new 소방차(), new 소파(), new 소포(), new 솜사탕(), new 스푼()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅅ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv13 초성 ㅎ
			words = [new hippo13(), new jamsuham13(), new nurse13(), new school13(), new sun13(), new tongue13(), new uhang13(), new angry13(), 
					 new belt13(), new bow13(), new doll13(), new grandfather13(), new grandmother13(), new ham13(), new hamonica13(), new hanbok13(),
					 new hard13(), new hard13(), new doll13(), new bow13(), new belt13(), new sun13(), new school13(), new nurse13()];
			showWords = [new hippo13(), new jamsuham13(), new nurse13(), new school13(), new sun13(), new tongue13(), new uhang13(), new angry13(), 
					 new belt13(), new bow13(), new doll13(), new grandfather13(), new grandmother13(), new ham13(), new hamonica13(), new hanbok13(),
					 new hard13(), new hard13(), new doll13(), new bow13(), new belt13(), new sun13(), new school13(), new nurse13()];
			texts = ["하마", "잠수함", "간호사", "학교", "해", "혀", "어항", "화",
					 "허리띠", "활", "인형", "할아버지", "할머니", "햄", "하모니카", "한복",
					 "하드", "하드", "인형", "활", "허리띠", "해", "학교", "간호사"];
			sounds = [new 하마(), new 잠수함(), new 간호사(), new 학교(), new 해(), new 혀(), new 어항(), new 화(),
					  new 허리띠(), new 활(), new 인형(), new 할아버지(), new 할머니(), new 햄(), new 하모니카(), new 한복(),
					  new 하드(), new 하드(), new 인형(), new 활(), new 허리띠(), new 해(), new 학교(), new 간호사()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㅎ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv14 초성 ㄸ
			words = [new tam14(), new tuk14(), new tong14(), new tukbokyi14(), new tugaejil14(), new tuggung14(), new belt14(), new takdaguri14(), 
					 new hairpin14(), new metugi14(), new nuts14(), new otugi14(), new strawberry14(), new strawberryjam14(), new taesugun14(), new tam14(),
					 new tuk14(), new tugaejil14(), new tukbokyi14(), new tuggung14(), new takdaguri14(), new hairpin14(), new nuts14(), new otugi14()];
			showWords = [new tam14(), new tuk14(), new tong14(), new tukbokyi14(), new tugaejil14(), new tuggung14(), new belt14(), new takdaguri14(), 
					 new hairpin14(), new metugi14(), new nuts14(), new otugi14(), new strawberry14(), new strawberryjam14(), new taesugun14(), new tam14(),
					 new tuk14(), new tugaejil14(), new tukbokyi14(), new tuggung14(), new takdaguri14(), new hairpin14(), new nuts14(), new otugi14()];
			texts = ["땀", "떡", "똥", "떡볶이", "뜨개질", "뚜껑", "허리띠", "딱따구리",
					 "머리띠", "메뚜기", "땅콩", "오뚝이", "딸기", "딸기쨈", "때수건", "땀",
					 "떡", "뜨개질", "떡볶이", "뚜껑", "딱따구리", "머리띠", "땅콩", "오뚝이"];
			sounds = [new 땀(), new 떡(), new 똥(), new 떡볶이(), new 뜨개질(), new 뚜껑(), new 허리띠(), new 딱따구리(),
					  new 머리띠(), new 메뚜기(), new 땅콩(), new 오뚝이(), new 딸기(), new 딸기쨈(), new 때수건(), new 땀(),
					  new 떡(), new 뜨개질(), new 떡볶이(), new 뚜껑(), new 딱따구리(), new 머리띠(), new 땅콩(), new 오뚝이()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "초성 ㄸ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv15 종성 ㄱ
			words = [new bat15(), new book15(), new camel15(), new checkjang15(), new dak15(), new corn15(), new dakgogi15(), new desk15(), 
					 new drum15(), new guksu15(), new soup15(), new medicine15(), new mixer15(), new modori15(), new nakhasan15(), new neck15(),
					 new peach15(), new saekyeonphil15(), new sikcho15(), new tabletennis15(), new taxi15(), new tuk15(), new watermelon15(), new yakguk15()];
			showWords = [new bat15(), new book15(), new camel15(), new checkjang15(), new dak15(), new corn15(), new dakgogi15(), new desk15(), 
					 new drum15(), new guksu15(), new soup15(), new medicine15(), new mixer15(), new modori15(), new nakhasan15(), new neck15(),
					 new peach15(), new saekyeonphil15(), new sikcho15(), new tabletennis15(), new taxi15(), new tuk15(), new watermelon15(), new yakguk15()];
			texts = ["박쥐", "책", "낙타", "책장", "닭", "옥수수", "닭고기", "책상",
					 "북", "국수", "국", "약", "믹서", "목도리", "낙하산", "목",
					 "복숭아", "색연필", "식초", "탁구", "택시", "떡", "수박", "약국"];
			sounds = [new 박쥐(), new 책(), new 낙타(), new 책장(), new 닭(), new 옥수수(), new 닭고기(), new 책상(),
					  new 북(), new 국수(), new 국(), new 약(), new 믹서(), new 목도리(), new 낙하산(), new 목(),
					  new 복숭아(), new 색연필(), new 식초(), new 탁구(), new 택시(), new 떡(), new 수박(), new 약국()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㄱ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv16 종성 ㄴ
			words = [new bulb16(), new doll16(), new door16(), new eye16(), new gift16(), new glasses16(), new hanbok16(), new hand16(), 
					 new kite16(), new mando16(), new manhwa16(), new money16(), new monkey16(), new nurse16(), new pencil16(), new pin16(),
					 new ring16(), new sandwitch16(), new santa16(), new shoes16(), new sonsugun16(), new telephone16(), new trafficlight16(), new umbrella16()];
			showWords = [new bulb16(), new doll16(), new door16(), new eye16(), new gift16(), new glasses16(), new hanbok16(), new hand16(), 
					 new kite16(), new mando16(), new manhwa16(), new money16(), new monkey16(), new nurse16(), new pencil16(), new pin16(),
					 new ring16(), new sandwitch16(), new santa16(), new shoes16(), new sonsugun16(), new telephone16(), new trafficlight16(), new umbrella16()];
			texts = ["전구", "인형", "문", "눈", "선물", "안경", "한복", "손",
					 "연", "만두", "만화", "돈", "원숭이", "간호사", "연필", "핀",
					 "반지", "샌드위치", "산타", "신발", "손수건", "전화기", "신호등", "우산"];
			sounds = [new 전구(), new 인형(), new 문(), new 눈(), new 선물(), new 안경(), new 한복(), new 손(),
					  new 연(), new 만두(), new 만화(), new 돈(), new 원숭이(), new 간호사(), new 연필(), new 핀(),
					  new 반지(), new 샌드위치(), new 산타(), new 신발(), new 손수건(), new 전화기(), new 신호등(), new 우산()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㄴ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv17 종성 ㄷ
			words = [new bobsot17(), new brush17(), new candle17(), new saltytaste17(), new chocolate17(), new chopstics17(), new clothes17(), new comb17(), 
					 new flower17(), new flowerbase17(), new juk17(), new mushroom17(), new nail17(), new not17(), new robot17(), new roket17(),
					 new sinmat17(), new spoon17(), new bittertaste17(), new toothbrush17(), new mushroom17(), new nail17(), new brush17(), new bobsot17()];
			showWords = [new bobsot17(), new brush17(), new candle17(), new saltytaste17(), new chocolate17(), new chopstics17(), new clothes17(), new comb17(), 
					 new flower17(), new flowerbase17(), new juk17(), new mushroom17(), new nail17(), new not17(), new robot17(), new roket17(),
					 new sinmat17(), new spoon17(), new bittertaste17(), new toothbrush17(), new mushroom17(), new nail17(), new brush17(), new bobsot17()];
			texts = ["밥솥", "붓", "촛불", "짠맛", "초콜릿", "젓가락", "옷", "빗",
					 "꽃", "꽃병", "젖", "버섯", "못", "낫", "로봇", "로켓",
					 "신맛", "숟가락", "쓴맛", "칫솔", "버섯", "못", "붓", "밥솥"];
			sounds = [new 밥솥(), new 붓(), new 촛불(), new 짠맛(), new 초콜릿(), new 젓가락(), new 옷(), new 빗(),
					  new 꽃(), new 꽃병(), new 젖(), new 버섯(), new 못(), new 낫(), new 로봇(), new 로켓(),
					  new 신맛(), new 숟가락(), new 쓴맛(), new 칫솔(), new 버섯(), new 못(), new 붓(), new 밥솥()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㄷ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv18 종성 ㄹ
			words = [new bbul18(), new bee18(), new calendar18(), new chulbong18(), new clip18(), new coke18(), new dalpengyi18(), new egg18(), 
					 new foot18(), new glue18(), new gyul18(), new helmet18(), new horse18(), new knife18(), new moon18(), new mulgam18(),
					 new paldae18(), new pul18(), new strawberry18(), new television18(), new tal18(), new water18(), new alchol18(), new arm18()];
			showWords = [new bbul18(), new bee18(), new calendar18(), new chulbong18(), new clip18(), new coke18(), new dalpengyi18(), new egg18(), 
					 new foot18(), new glue18(), new gyul18(), new helmet18(), new horse18(), new knife18(), new moon18(), new mulgam18(),
					 new paldae18(), new pul18(), new strawberry18(), new television18(), new tal18(), new water18(), new alchol18(), new arm18()];
			texts = ["뿔", "벌", "달력", "철봉", "클립", "콜라", "달팽이", "알",
					 "발", "풀", "귤", "헬멧", "말", "칼", "달", "물감",
					 "빨대", "풀", "딸기", "텔레비전", "탈", "물", "술", "팔"];
			sounds = [new 뿔(), new 벌(), new 달력(), new 철봉(), new 클립(), new 콜라(), new 달팽이(), new 알(),
					  new 발(), new 풀(), new 귤(), new 헬멧(), new 말(), new 칼(), new 달(), new 물감(),
					  new 빨대(), new 풀(), new 딸기(), new 텔레비전(), new 탈(), new 물(), new 술(), new 팔()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㄹ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv19 종성 ㅁ
			words = [new potato19(), new salt19(), new shampoo19(), new snake19(), new somsatang19(), new strawberryjam19(), new bam19(), new bbam19(), 
					 new bear19(), new bed19(), new cigarrette19(), new deer19(), new film19(), new gam19(), new ggum19(), new gim19(),
					 new goat19(), new cloud19(), new ham19(), new hamburger19(), new jamjari19(), new jamsuham19(), new mulgam19(), new nambi19()];
			showWords = [new potato19(), new salt19(), new shampoo19(), new snake19(), new somsatang19(), new strawberryjam19(), new bam19(), new bbam19(), 
					 new bear19(), new bed19(), new cigarrette19(), new deer19(), new film19(), new gam19(), new ggum19(), new gim19(),
					 new goat19(), new cloud19(), new ham19(), new hamburger19(), new jamjari19(), new jamsuham19(), new mulgam19(), new nambi19()];
			texts = ["감자", "소금", "샴푸", "뱀", "솜사탕", "딸기쨈", "밤", "뺨",
					 "곰", "침대", "담배", "사슴", "필름", "감", "껌", "김",
					 "염소", "구름", "햄", "햄버거", "잠자리", "잠수함", "물감", "냄비"];
			sounds = [new 감자(), new 소금(), new 샴푸(), new 뱀(), new 솜사탕(), new 딸기쨈(), new 밤(), new 뺨(),
					  new 곰(), new 침대(), new 담배(), new 사슴(), new 필름(), new 감(), new 껌(), new 김(),
					  new 염소(), new 구름(), new 햄(), new 햄버거(), new 잠자리(), new 잠수함(), new 물감(), new 냄비()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㅁ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			// stageLv20 종성 ㅇ
			words = [new puppy20(), new river20(), new socks20(), new somsatang20(), new spinner20(), new uhang20(), new ball20(), new bean20(), 
					 new bell20(), new bread20(), new bucket20(), new byung20(), new carrot20(), new castle20(), new dragon20(), new gloves20(),
					 new gun20(), new jangoo20(), new hospital20(), new kangaroo20(), new penguin20(), new king20(), new princess20(), new ballon20()];
			showWords = [new puppy20(), new river20(), new socks20(), new somsatang20(), new spinner20(), new uhang20(), new ball20(), new bean20(), 
					 new bell20(), new bread20(), new bucket20(), new byung20(), new carrot20(), new castle20(), new dragon20(), new gloves20(),
					 new gun20(), new jangoo20(), new hospital20(), new kangaroo20(), new penguin20(), new king20(), new princess20(), new ballon20()];
			texts = ["강아지", "강", "양말", "솜사탕", "팽이", "어항", "공", "콩",
					 "종", "빵", "양동이", "병", "당근", "성", "용", "장갑",
					 "총", "장구", "병원", "캥거루", "펭귄", "왕", "공주", "풍선"];
			sounds = [new 강아지(), new 강(), new 양말(), new 솜사탕(), new 팽이(), new 어항(), new 공(), new 콩(),
					  new 종(), new 빵(), new 양동이(), new 병(), new 당근(), new 성(), new 용(), new 장갑(),
					  new 총(), new 장구(), new 병원(), new 캥거루(), new 펭귄(), new 왕(), new 공주(), new 풍선()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㅇ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			
			/*
			// stageLv15 종성 ㄱ
			words = [new (), new (), new (), new (), new (), new (), new (), new (), 
					 new (), new (), new (), new (), new (), new (), new (), new (),
					 new (), new (), new (), new (), new (), new (), new (), new ()];
			showWords = [new (), new (), new (), new (), new (), new (), new (), new (), 
					 new (), new (), new (), new (), new (), new (), new (), new (),
					 new (), new (), new (), new (), new (), new (), new (), new ()];
			texts = ["", "", "", "", "", "", "", "",
					 "", "", "", "", "", "", "", "",
					 "", "", "", "", "", "", "", ""];
			sounds = [new (), new (), new (), new (), new (), new (), new (), new (),
					  new (), new (), new (), new (), new (), new (), new (), new (),
					  new (), new (), new (), new (), new (), new (), new (), new ()];
			locs = [[192, 192], [335, 147], [483, 173], [620, 227], [723, 335], [802, 467], [738, 620], [601, 675], 
					[456, 695], [310, 685], [168, 655], [93, 790], [105, 945], [208, 1058], [352, 1090], [490, 1035],
					[633, 999], [776, 1039], [793, 1197], [761, 1356], [623, 1415], [474, 1408], [328, 1393], [190, 1356]];
			events = [1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 1, 1, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0];
			descript = "종성 ㄱ";
							  
			for(i = 0; i < wordsNum; i++){
				SubWordSet(wordSet[count]).setWords(Sprite(words[i]), Sprite(showWords[i]), texts[i], sounds[i], locs[i][0], locs[i][1], events[i], descript);
				
				SubWordSet(wordSet[count]).words[i].x = locs[i][0];
				SubWordSet(wordSet[count]).words[i].y = locs[i][1];
				SubWordSet(wordSet[count]).words[i].scaleX = 0.56;
				SubWordSet(wordSet[count]).words[i].scaleY = 0.61;
				
				SubWordSet(wordSet[count]).showWords[i].x = showWordsX;
				SubWordSet(wordSet[count]).showWords[i].y = showWordsY;
				SubWordSet(wordSet[count]).showWords[i].scaleX = scaleOfX;
				SubWordSet(wordSet[count]).showWords[i].scaleY = scaleOfY;
			}
			count++;
			*/
		}
	}
}

import flash.display.*;
import flash.media.*;

class SubWordSet{
		public var words:Array;
		public var showWords:Array;
		public var texts:Array;
		public var sounds:Array;
		public var locs:Array;
		public var events:Array;
		public var description:String;
		
		public function SubWordSet(){
			words = new Array();
			showWords = new Array();
			texts = new Array();
			sounds = new Array();
			locs = new Array();
			events = new Array();
			description = new String();
		}
		
		public function setWords(image:Sprite, showImage:Sprite, wordText:String, wordSound:Sound, locX:int, locY:int, suddenEvent:int, descript:String){
			words.push(image);
			showWords.push(showImage);
			texts.push(wordText);
			sounds.push(wordSound);
			locs.push([locX, locY]);
			events.push(suddenEvent);
			description = descript;
		}
}