package
{
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensyTimeline;
	
	import fl.motion.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SlideShowontroller{
		
		[Embed(source='font.swf', fontName='Gotham Book')]
  		public static var font:Class;
		var targetContainer:DisplayObjectContainer;
		var xmlLoader:XMLloader;
		
		//コンストラクタ
		public function SlideShowontroller(container:DisplayObjectContainer, url:String){
			targetContainer = container;	
			//XMLファイルを読み込む
			var isUnicode:Boolean = false;//ShiftJISに対応
			xmlLoader = new XMLloader(url, isUnicode);
			//読み込みが完了したらcontainerに背景を読み込むなど始める
			xmlLoader.addEventListener(XMLloader.LOAD_COMPLETE, onXMLloaded);
		}
		
		function onSingleXMLloaded(event:Event):void{
			loadImageNo(1);
		}
		
		public function loadImageNo(imgNo:int):void{
			//まずはXMLを取り出す
			photoXml = xmlLoader.getXML();	
			var element:XML = photoXml.page[imgNo - 1];
			var bgurl = photoPath +element.@bg;
			caption = element.@caption;
			title= element.title.toString();	
			contents = new Array();
			for each(var ele:XML in element..content){
				contents.push(ele.toString());
			}
			//写真の読み込み〜フェードイン表示
			loadImage(targetContainer, bgurl, 0,0); 
		}
		
		public function loadImage(container:DisplayObjectContainer,url:String,x:Number,y:Number):void{
			//loader作成をコンテナに追加(イメージを追加するための子コンテナー(MC)をさらに追加した方がいいかもしれない。今回bgなので直接追加)
			container.addChildAt(imgLoader,0);
			//ロードが終わったら開始するイベントリスナーを追加しておく（画像のリサイズ、Tweenの開始など）
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			//読み込み開始
			var urlReq:URLRequest=new URLRequest(url);//URL
			imgLoader.load(urlReq);//読み込まれたSWFやイメージファイルがloaderの子表示オブジェクトとなる（loader.content）
		}
		
		//ロード完了
		function onLoaded(event:Event):void {
			//titleFld = new TextField();
			//読み込んだ背景画像の大きさを調整
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			//背景画像のTween
			var timeline:TweensyTimeline;
			timeline = Tweensy.fromTo(imgLoader, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0,null,null,null);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
				// 関数 onStageResize の定義
		public function onStageResize(evt:Event):void {
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
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