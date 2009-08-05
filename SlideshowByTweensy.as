package
{
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensySequence;
	import com.flashdynamix.motion.TweensyTimeline;
	
	import fl.motion.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SlideshowByTweensy
	{
		[Embed(source='font.swf', fontName='Gotham Book')]
  		public static var font:Class;
		var targetContainer:DisplayObjectContainer;
		var nextBtn:MovieClip;
		var prevBtn:MovieClip;
		var xmlLoader:XMLloader;
		var pageXml:XML;
		var pageElement:XML; 
		var contentsElement:XML
		var currentNo:int;
		var photoPath = "photo/"
		var imgLoader:Loader = new Loader();//Loader < DisplayObjectContainer < InteractiveObject < DisplayObject < EventDispatcher < Object
		
		//XMLの中身
		var bgurl:String ;
		var caption:String;
		var title:String;
		var page:Array;
		var contents:Array;
		var content:Array;
		var subtitle:String;
		
		//textContenerとtextField
		var titleHolder:MovieClip= new MovieClip();
		var subtitleHolder:MovieClip= new MovieClip();
		var contentHolder:MovieClip= new MovieClip();
		var captionHolder:MovieClip= new MovieClip();
		var titleField:TextField= new TextField();
		var subtitleField:TextField= new TextField();
		var contentField:TextField= new TextField();
		var captionField:TextField = new TextField();
				
		public function SlideshowByTweensy(container:DisplayObjectContainer,next_btn:MovieClip,prev_btn:MovieClip, url:String){			
			currentNo = 0;
			targetContainer = container;
			nextBtn = next_btn;
			prevBtn = prev_btn;
				
			//XMLファイルの読み込み
			var isUnicode:Boolean = false;//ShiftJISに対応
			xmlLoader = new XMLloader(url, isUnicode);
				
			//読み込みが完了したらcontainerに背景を読み込むなど始めるリスナー登録
			xmlLoader.addEventListener(XMLloader.LOAD_COMPLETE, onSingleXMLloaded);
			
			//テキストフィールド設置 場所の指定をなくす　代わりに色などの指定
			createTextField(titleHolder,titleField,targetContainer.stage.stageWidth/2,targetContainer.stage.stageHeight/2,18);
			createTextField(subtitleHolder,subtitleField,100,0,12);
			createTextField(contentHolder,contentField,200,0,12);
			createTextField(captionHolder,captionField,300,0,12);
			setTextFildsPosition(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			
		}	
		
		function createTextField(holder:MovieClip,tf:TextField,x:Number,y:Number,textSize:uint):void{//位置を指定するにはコンテナーが必要
			holder.x = x;
			holder.y = y;
			targetContainer.addChild(holder);
			
			tf.alpha = 0;
			tf.selectable = false;
			tf.embedFonts = true;
			
			//テキストのフォーマットを指定
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = textSize;
			textFormat.color= 0xFFFFFF;
			textFormat.font = "Gotham Book";
			tf.defaultTextFormat = textFormat;
			
			//テキストにドロップシャドウ
			// ドロップシャドウ
			var filter :DropShadowFilter = new DropShadowFilter();
			filter.alpha = 0.5;
			filter.angle = 45;
			filter.blurX = 3;
			filter.blurY = 3;
			filter.distance = 2;
			filter.color = 0x000000;
			var myFilters:Array = new Array();
			myFilters.push(filter);
			tf.filters = myFilters;
				
			//stageにテキストフィールドを追加
			holder.addChild(tf);
		}
		
		function onSingleXMLloaded(event:Event):void{
			loadImageNo(currentNo);
		}
		function ctlXMLloaded():void{
			loadImageNo(currentNo);
		}
		
		public function loadImageNo(imgNo:int):void{
			pageXml = xmlLoader.getXML();	//まずはXMLを取り出す
			pageElement = pageXml.page[imgNo];
			trace("inload"+pageElement.toXMLString());
			var bgurl:String = photoPath +pageElement.@bg;
			caption = pageElement.@caption;
			
			//写真の読み込み〜フェードイン表示
			loadBGImage(targetContainer, bgurl, 0,0); 

		}
	
		
		
		
		public function goNext(event:Event):void{
			currentNo =currentNo+1;
			//すべてのトゥイーンストップ
			Tweensy.stop();
			//表示されている背景とテキストフィールドのフェードアウト
			var Timeline:TweensyTimeline = Tweensy.to([imgLoader,titleField,subtitleField,contentField,captionField], {alpha:0},1);
			Timeline.onComplete = ctlXMLloaded; 
			//TODO ctlXMLloaded();　フェードアウトと同時に読み込んでもいいが、写真のローダーを二枚用意しないと写真だけ素早く切り替わり不自然
			//TODO ctl_btnがflash上にあるのでasから操作できないのだが、それも一緒に遷移した方がいい？かも。メニューとともに要検討。
			//TODO XMLの要素の数を記録しておき、次へボタンの無効化をおこなうこと、ビジュアルにも工夫
			
		}
		public function goPrev(event:Event):void{
			currentNo =currentNo-1;
			//すべてのトゥイーンストップ
			Tweensy.stop();
			//背景とテキストフィールドのフェードアウト
			var Timeline:TweensyTimeline = Tweensy.to([imgLoader,titleField,subtitleField,contentField,captionField], {alpha:0},1);
			
			Timeline.onComplete = ctlXMLloaded;	
			
			if (currentNo==0){//なんだかうまくいっていない。nextBtnなどについて調べるべき。
				nextBtn.removeEventListener(MouseEvent.CLICK,goNext);	
			}		
		}
		
		//写真をコンテナに読み込む
		public function loadBGImage(container:DisplayObjectContainer,url:String,x:Number,y:Number):void{
			//loader作成をコンテナに追加(イメージを追加するための子コンテナー(MC)をさらに追加した方がいいかもしれない。今回bgなので直接追加)
			container.addChildAt(imgLoader,0);
			//ロードが終わったら開始するイベントリスナーを追加しておく（画像のリサイズ、Tweenの開始など）
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBGLoaded);
			//読み込み開始
			var urlReq:URLRequest=new URLRequest(url);//URL
			imgLoader.load(urlReq);//読み込まれたSWFやイメージファイルがloaderの子表示オブジェクトとなる（loader.content）
		}
		
		function onBGLoaded(evebt:Event):void{
			//読み込んだ背景画像の大きさを調整
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			
			//背景画像のTween
			var timeline:TweensyTimeline;
			timeline = Tweensy.fromTo(imgLoader, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0,null,null,null);
			
			//timeline.onComplete = BGcompleteTween;
			timeline.onComplete = allTween;
		}
	
	
		//ひとまとめのシークエンスにしてしまう
		function allTween():void{
			var sequence:TweensySequence = new TweensySequence();
			trace(caption);
			if (caption!=""){
				captionField.text = caption;
				sequence.push(captionField, {alpha:1}, 5,Sine.easeOut);
				sequence.push(captionField, {alpha:0}, 5);
			}
			trace (pageElement);
			if(pageElement.contents!=""){
				for each(var contentsEl:XML in pageElement.contents){
					trace(contentsEl.@title);
					if (contentsEl.@title!=""){
						//タイトルのin
						titleField.text =contentsEl.@title;
						sequence.push(titleField,{alpha:1},5);
					}
					for each(var contentEl:XML in contentsEl.content ){
						subtitleField.text = contentEl.@subtitle;
						trace(contentEl.@subtitle);
						contentField.text = contentEl.toString();
						trace(contentEl.toString());
						sequence.push([subtitleField,contentField],{alpha:1},5);
						sequence.push([subtitleField,contentField],{alpha:0},5);	
					}
					sequence.push(titleField,{alpha:0},5);
				}
			}
			sequence.start();
		}
	
	
		public function BGcompleteTween():void{
			//もしキャプションが存在したらキャプションのトゥイーン
			if (caption!=""){
				//キャプションのinout シークエンスを使った方がいいかも and くくりだそうか
				captionField.text = caption;
				//var captionTL:TweensyTimeline = Tweensy.fromTo(captionField, {alpha:0},{alpha:1},5, Sine.easeOut,0,null,null);
				var captionSQ:TweensySequence = new TweensySequence();
				captionSQ.push(captionField, {alpha:1}, 5,Sine.easeOut);
				captionSQ.push(captionField, {alpha:0}, 5);
				captionSQ.start();
				//タイトルの呼び出し
				//captionTL.onComplete = titleTweenIn;
				captionSQ.onComplete = titleTweenIn;
			}else titleTweenIn();	
		}
		
		function titleTweenIn():void{
			trace(pageElement.toXMLString());
			if(pageElement.contents!=""){
				for each( contentsElement in pageElement.contents){
					if (contentsElement.@title!=""){
						//タイトルのin
						titleField.text =contentsElement.@title;
						var titleTL:TweensyTimeline = Tweensy.fromTo(titleField, {alpha:0},{alpha:1},5, Sine.easeOut,0,null,null);
						//comtentsの呼び出し
						titleTL.onComplete = contensTweenInOut;	
					}else contensTweenInOut();
				}
			}
		}
		function contensTweenInOut():void{
			for each(var contentElement:XML in contentsElement.content ){
				subtitleField.text = contentElement.@subtitle;
				contentField.text = contentElement.toString();
				Tweensy.fromTo(subtitleField, {alpha:0},{alpha:1},5, Sine.easeOut,0,null,null);
				Tweensy.fromTo(contentField, {alpha:0},{alpha:1},5, Sine.easeOut,0,null,null);	
			}
		}
	
	
	
		
		public function setTextFildsPosition(stageW:uint,stageH:uint):void{
			
			titleHolder.x = stageW/4;
			titleHolder.y = stageH/5;
			
			subtitleHolder.x = stageW*3/4;
			subtitleHolder.y = stageH/6;
			
			contentHolder.x = stageW*3/4;
			contentHolder.y = stageH/4;
						
			captionHolder.x = stageW/2;
			captionHolder.y = stageH/2;
		}
		

		// 関数 resizeBack_mc の定義
		public function resizeBack_mc(stageW:int,stageH:int):void {			
			// 「back_mc」 の縦横の初期サイズを記録
			var backW:Number=imgLoader.content.width;
			var backH:Number=imgLoader.content.height;
			// もしステージの縦横が背景画像より横長であれば
			if (stageH/stageW<backH/backW) {
				imgLoader.content.width=stageW;// 「back_mc」の幅をステージの幅に合わせる
				imgLoader.content.height=stageW*backH/backW;// 「back_mc」の縦をステージの幅を基準に算出
			// もしステージの縦横が背景画像より縦長であれば
			} else {
			imgLoader.content.width=stageH*backW/backH;// 「back_mc」の幅をステージの縦を基準に算出
			imgLoader.content.height=stageH;// 「back_mc」の縦をステージの縦に合わせる
			}
		}

	}
}