package
{
	import com.flashdynamix.motion.*;
	
	import fl.motion.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SlideshowByTweensyOrg
	{
		var targetContainer:DisplayObjectContainer;
		var titleFld:TextField;
		var xmlLoader:XMLloader;
		var imgHolder:MovieClip;
		var photoXml:XML;
		
		var currentNo:int;
		var photoPath = "photo/"
		
		public function SlideshowByTweensyOrg(container:DisplayObjectContainer, url:String){			
			targetContainer = container;
			//タイトル用のテキストフィールドを作る
			creatCaptionFld();
			var isUnicode:Boolean = false;//ShiftJISに対応
			//XMLファイルを読み込む
			xmlLoader = new XMLloader(url, isUnicode);
			//読み込みが完了したらonXMLloadedを実行
			xmlLoader.addEventListener(XMLloader.LOAD_COMPLETE, onXMLloaded);
			currentNo = 0;
		}
		

		//XML読み込み完了
		function onXMLloaded(event:Event):void {
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
		public function loadImageNo(imgNo:int):void{
			var element:XML = photoXml.photo[imgNo - 1];
			//タイトルを表示する
			titleFld.text = element.toString();		
			//ファイル名を取り出す
			var url:String = photoPath + element.@fname;
			//写真の読み込み〜フェードイン表示
			TwImageLoader(targetContainer, url, 0,0);
			//フェードイン終了イベントにリスナー登録する
			//imgLoader.addEventListener(TweenImageLoader.TWEEN_FINISH, onTweenFinish);
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
		
		//読み込み完了
		function onLoaded(event:Event):void {
			Tweensy.fromTo(imgHolder, {alpha:0}, {alpha:1}, 3, Sine.easeOut,0.5,null,null,null);
			/*
			//フェードして表示
			var sec:int = 2;
			var imgTween:Tween = new Tween(imgHolder, "alpha", Regular.easeInOut, 0, 1, sec, true);
			//他のTween例
			//var imgTween:Tween = new Tween(imgHolder, "scaleX", Regular.easeInOut, 0, 1, sec, true);
			//var imgTween:Tween = new Tween(imgHolder, "rotation", Regular.easeInOut, -90, 0, sec, true);
			*/
			//imgTween.addEventListener(TweenEvent.MOTION_FINISH, onTweenFinish);
		}
		
		//タイトル用のテキストフィールドを作る
		function creatCaptionFld():void{
			titleFld = new TextField();
			titleFld.autoSize = TextFieldAutoSize.LEFT;//左揃えで拡大縮小
			//テキストのフォーマットを指定
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 24;
			titleFld.defaultTextFormat = textFormat;
			//stageにテキストフィールドを追加
			targetContainer.stage.addChild(titleFld);
			//テキストフィールドの位置を指定する　(親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの 座標)
			titleFld.x = 0;
			titleFld.y = (targetContainer.stage.height)/2;	
		}	
		
		
		//tweensy動作テスト用　後で消しましょう
		public function TweensyTest(mc:MovieClip):void{
			Tweensy.fromTo(mc, {alpha:1}, {alpha:0}, 3, Sine.easeOut,0.5,null,null,null);
		}
	}
}