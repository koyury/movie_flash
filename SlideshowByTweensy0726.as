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
	
	public class SlideshowByTweensy
	{
		[Embed(source='font.swf', fontName='Gotham Book')]
  		public static var font:Class;
		var targetContainer:DisplayObjectContainer;
		var xmlLoader:XMLloader;
		var imgHolder:MovieClip;
		var photoXml:XML;
		var titleFld:TextField;
		var currentNo:int;
		var photoPath = "photo/"
		var textHolder:MovieClip;
		var imgLoader:Loader = new Loader();//Loader < DisplayObjectContainer < InteractiveObject < DisplayObject < EventDispatcher < Object
		var textCaption:String;
		
		//XMLの中身
		var bgurl:String ;
		var caption:String;
		var title:String;	
		var contents:Array;
		
		//textContenerとtextField
		var titleHolder:MovieClip;
		var contentHolder:MovieClip;
		var captionHolder:MovieClip;
		var titleField:TextField;
		var contentField:TextField;
				
		public function SlideshowByTweensy(container:DisplayObjectContainer, url:String){			
			targetContainer = container;	
			//XMLファイルを読み込む
			var isUnicode:Boolean = false;//ShiftJISに対応
			xmlLoader = new XMLloader(url, isUnicode);
			//読み込みが完了したらcontainerに背景を読み込むなど始める
			xmlLoader.addEventListener(XMLloader.LOAD_COMPLETE, onSingleXMLloaded);
			createTextField(titleHolder,titleField,targetContainer.stage.stageWidth/2,targetContainer.stage.stageHeight/2,18);
			currentNo = 0;
		}
		
		
		function createTextField(holder:MovieClip,tf:TextField,x:Number,y:Number,textSize:uint):void{//位置を指定するにはコンテナーが必要
			holder = new MovieClip;
			holder.x = x;
			holder.y = y;
			targetContainer.addChild(holder);
			
			tf = new TextField;
			tf.alpha = 0;
			tf.selectable = false;
			tf.embedFonts = true;
			
			//テキストのフォーマットを指定
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = textSize;
			textFormat.font = "Gotham Book";
			titleFld.defaultTextFormat = textFormat;
			
			//stageにテキストフィールドを追加
			holder.addChild(tf);
		}
		
		//タイトル用のテキストフィールドを作っておく
		function creatCaptionFld(titleFld:TextField):void{
			
			
			
			textHolder = new MovieClip();
			targetContainer.addChild(textHolder);
			textHolder.alpha = 0;
			
			titleFld = new TextField();
			//titleFld.autoSize = TextFieldAutoSize.LEFT;//左揃えで拡大縮小
			titleFld.text = "自然のめぐみで命かがやかそう";//以下仮にタイトルを挿入

			//テキストのフォーマットを指定
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 24;
			textFormat.font = "Gotham Book";
			titleFld.defaultTextFormat = textFormat;
			
			//テキストフィールドの位置を指定する　(親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの 座標)
			position_text(textHolder.stage.stageWidth,textHolder.stage.stageHeight);
			//stageにテキストフィールドを追加
			textHolder.addChild(titleFld);
			Tweensy.to(textHolder,{alpha:1}, 3, Sine.easeOut,0,null,null,null);
		}
	
		
		function position_text(stageW:uint,stageHeight:uint):void{
		
		};

	
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
			titleField.text = title;
			trace(titleField.text);
		}
		
		//写真をコンテナに読み込む
		public function loadImage(container:DisplayObjectContainer,url:String,x:Number,y:Number):void{
			//loader作成をコンテナに追加(イメージを追加するための子コンテナー(MC)をさらに追加した方がいいかもしれない。今回bgなので直接追加)
			container.addChildAt(imgLoader,0);
			//ロードが終わったら開始するイベントリスナーを追加しておく（画像のリサイズ、Tweenの開始など）
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBGLoaded);
			//読み込み開始
			var urlReq:URLRequest=new URLRequest(url);//URL
			imgLoader.load(urlReq);//読み込まれたSWFやイメージファイルがloaderの子表示オブジェクトとなる（loader.content）
		}
	

		
		
		//XML読み込み完了後
		function onXMLloaded(event:Event):void {
			//まずはXMLを取り出す
			photoXml = xmlLoader.getXML();		
			
			//XMLの一つ目の写真を取り出す TODO 二枚目以降のループ
			/*
			var element:XML = photoXml.photo[0];	
			var url:String = photoPath + element.@fname; //ファイル名を取り出す
			loadImage(targetContainer, url, 0,0); //写真の読み込み->フェードイン表示
			//titleFld.text = element.toString();	//タイトルを表示する
			*/

			for each (var element:XML in photoXml..page){
				var url:String = photoPath +element.@bg;
				var caption:String = element.@caption;
				var title:String= element.title.toString();
				
				var contents:Array = new Array();
				for each(var ele:XML in element..content){
					contents.push(ele.toString());
				}
				
				loadImage(targetContainer, url, 0,0); //写真の読み込み->フェードイン表示
				
				textCaption = caption;
			}
		}
		
		function onBGLoaded(evebt:Event):void{
			//読み込んだ背景画像の大きさを調整
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			
			//背景画像のTween
			var timeline:TweensyTimeline;
			timeline = Tweensy.fromTo(imgLoader, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0,null,null,null);
			
			timeline.onComplete = BGcompleteTween;
		}
		
		function BGcompleteTween():void{
			Tweensy.fromTo(titleField, {alpha:0},{alpha:1}, 10, Sine.easeOut,0,null,null,null);
		}
		
		//ロード完了
		function onLoaded(event:Event):void {
			//titleFld = new TextField();
			//読み込んだ背景画像の大きさを調整
			resizeBack_mc(targetContainer.stage.stageWidth,targetContainer.stage.stageHeight);
			//背景画像のTween
			var timeline:TweensyTimeline;
			timeline = Tweensy.fromTo(imgLoader, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0,null,null,null);
			
			
			//タイトル用のテキストフィールドを作る creatCaptionFld(titleFld);	
			textHolder = new MovieClip();
			//テキストのフォーマットを指定
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 24;
			textFormat.font = "Gotham Book";
			
			titleFld = new TextField();	
			titleFld.defaultTextFormat = textFormat;
			titleFld.selectable = false;
			titleFld.embedFonts = true;
			titleFld.alpha = 0;
			//titleFld.autoSize = TextFieldAutoSize.LEFT;//左揃えで拡大縮小
			//titleFld.text = "nature";//以下仮にタイトルを挿入
			titleFld.text = textCaption;
			
			trace(titleFld.text);
			textHolder.addChild(titleFld);
			//stageにテキストフィールドを追加
			targetContainer.addChild(textHolder);
			
			
			//テキストフィールドの位置を指定する　(親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの 座標)
			position_text(textHolder.stage.stageWidth,textHolder.stage.stageHeight);
			timeline.onComplete = completeTween;			
		}
		
		function completeTween():void {
			Tweensy.fromTo(titleFld, {alpha:0},{alpha:1}, 10, Sine.easeOut,0,null,null,null);			
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
		
		
		
		
		
		
		
		
		
			
			

		
		
		
		//XML読み込み完了
		function onXMLloadedOrg(event:Event):void {
			//まずはXMLを取り出す
			photoXml = xmlLoader.getXML();
			
			var delay:int = 8000;
			//playSlideShow(delay);
			playTween(delay);
		}	
		//tweenの開始
		public function playTween(delay:int):void{
			//一枚目の処理
			if(currentNo == 0){
				currentNo = 1;
				loadImageNo(1);
			}
			//二枚目以降の処理		
		}


		public function TwImageLoader(container:DisplayObjectContainer,url:String,x:Number,y:Number):void{
			//イメージを読み込むコンテナを作る
			imgHolder = new MovieClip();
			imgHolder.x = x;
			imgHolder.y = y;
			container.addChild(imgHolder);
			//loader作成
			var imgLoader:Loader = new Loader();
			imgHolder.addChild(imgLoader);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			//URL
			var urlReq:URLRequest=new URLRequest(url);
			//読み込み開始
			imgLoader.load(urlReq);
		}
		
		//tweensy動作テスト用　後で消しましょう
		public function TweensyTest(mc:MovieClip):void{
			Tweensy.fromTo(mc, {alpha:1}, {alpha:0}, 3, Sine.easeOut,0.5,null,null,null);
		}
	}
}