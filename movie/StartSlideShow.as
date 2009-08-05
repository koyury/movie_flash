package movie
{
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensyTimeline;
	
	import fl.motion.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	
	public class StartSlideShow
	{
		var targetContainer:DisplayObjectContainer;
		public var currentNo:uint;
		var xmlLoader:XMLloader;
		var pageXml;
		var pageElement:XML;
		
		var photoPath = "photo/"
		var imgLoader:Loader;
		
		var textTween:TextTween;
		
		var prev_btn:MovieClip;
		var next_btn:MovieClip;
		
		//コンストラクタ（XMLの読み込みなど）
		public function StartSlideShow(container:DisplayObjectContainer, url:String, texts:TextTween, next:MovieClip,prev:MovieClip){
			currentNo = 0;
			targetContainer = container;
			textTween = texts;
			prev_btn= prev;
			next_btn= next;
			//XMLファイルの読み込み
			var isUnicode:Boolean = false;//ShiftJISに対応
			xmlLoader = new XMLloader(url, isUnicode);
			
			
			//読み込みが完了したらcontainerに背景を読み込むなど始めるリスナー登録
			xmlLoader.addEventListener(XMLloader.LOAD_COMPLETE, XMLloaded);
		}	
		
		function XMLloaded(event:Event):void{
			this.loadCurrentPage();
		}
		
		
		//ページの読み込み開始処理
		public function loadCurrentPage():void{
			pageXml = xmlLoader.getXML();	//まずはXMLを取り出す
			pageElement = pageXml.page[currentNo];
			var bgurl:String = photoPath +pageElement.@bg;		
			
			textTween.getPageElement(pageElement);
				
			//写真の読み込み〜フェードイン表示
			loadBgImage(bgurl);
		}	
		//背景の読み込み
		function loadBgImage(url:String){
			trace(url+"=photo url");
			imgLoader= new Loader();
			//loader作成をコンテナに追加(イメージを追加するための子コンテナー(MC)をさらに追加した方がいいかもしれない。今回bgなので直接追加)
			targetContainer.addChildAt(imgLoader,0);
			//ロードが終わったら開始するイベントリスナーを追加しておく（画像のリサイズ、Tweenの開始など）
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBGLoaded);
			//読み込み開始
			var urlReq:URLRequest=new URLRequest(url);//URL
			imgLoader.load(urlReq);//読み込まれたSWFやイメージファイルがloaderの子表示オブジェクトとなる（loader.content）
		}
		//背景の読み込み終了後の処理
		function onBGLoaded(event:Event):void{
			//読み込んだ背景画像の大きさを調整
			//var controlStage:ControlStage = new ControlStage(imgLoader);
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			
			//背景画像のTween
			var timeline:TweensyTimeline;
			timeline = Tweensy.fromTo(imgLoader, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0,null,null,null);
			
			textTween.createTextFields();
			timeline.onComplete = textTween.allTween;
		}
		
		
		//ページのコントロール
		public function goNext(event:MouseEvent):void{
			currentNo = currentNo+1;
			Tweensy.stop();
			
			
			
			var Timeline:TweensyTimeline = Tweensy.to([imgLoader,textTween.captionHolder,textTween.contentHolder,textTween.subtitleHolder,textTween.titleHolder], {alpha:0},1);
			Timeline.onComplete =loadCurrentPage;
			
		}
		
		public function goPrev(event:MouseEvent):void{
			currentNo = currentNo-1;
			Tweensy.stop();
			
			if(currentNo==0){
				//ボタンのイベントリスナーを外す
				prev_btn.removeEventListener(MouseEvent.CLICK,goPrev);
			}
			
			var Timeline:TweensyTimeline = Tweensy.to([imgLoader,textTween.captionHolder,textTween.contentHolder,textTween.subtitleHolder,textTween.titleHolder], {alpha:0},1);
			Timeline.onComplete =loadCurrentPage;
		}
		
		
		
		
		// 関数 resizeBack_mc の定義 ->もしかすると移動するかも　to ControlStage
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