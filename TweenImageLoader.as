﻿package {	//カスタムイベント関連パッケージ	import flash.events.EventDispatcher;	//イメージ読み込み関連パッケージ	import flash.display.DisplayObjectContainer;	import flash.display.MovieClip;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.net.URLRequest;	import flash.events.Event;	//Tween関連パッケージ	import fl.transitions.TweenEvent;	import fl.transitions.Tween;	import fl.transitions.easing.*;	public class TweenImageLoader extends EventDispatcher {		public static const TWEEN_FINISH:String = "tween_finish";		var imgHolder:MovieClip;		//コンストラクタ		function TweenImageLoader(container:DisplayObjectContainer,url:String,x:Number,y:Number) {			//イメージを読み込むコンテナを作る			imgHolder = new MovieClip();			imgHolder.x = x;			imgHolder.y = y;			container.addChild(imgHolder);			//loader作成			var imgLoader:Loader = new Loader();			imgHolder.addChild(imgLoader);			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);			//URL			var urlReq:URLRequest=new URLRequest(url);			//読み込み開始			imgLoader.load(urlReq);		}		//読み込み完了		function onLoaded(event:Event):void {			//フェードして表示			var sec:int = 2;			var imgTween:Tween = new Tween(imgHolder, "alpha", Regular.easeInOut, 0, 1, sec, true);			//他のTween例			//var imgTween:Tween = new Tween(imgHolder, "scaleX", Regular.easeInOut, 0, 1, sec, true);			//var imgTween:Tween = new Tween(imgHolder, "rotation", Regular.easeInOut, -90, 0, sec, true);			imgTween.addEventListener(TweenEvent.MOTION_FINISH, onTweenFinish);		}		//トゥイーン完了		function onTweenFinish(event:TweenEvent):void {			dispatchEvent(new Event(TweenImageLoader.TWEEN_FINISH));		}	}}