package {	
	import com.flashdynamix.motion.*;
	
	import fl.motion.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;




	
	public class SlideShow extends Sprite
	{	
		public function SlideShow()
		{
			//ステージの初期設定
//stage.scaleMode=StageScaleMode.NO_SCALE; // ムービー全体の拡大縮小をなしにする
//stage.align=StageAlign.TOP_LEFT;// ステージの左上を基準として整列
			
			var mc :MovieClip = new MovieClip();
			mc.x = 0;
			mc.y = 30;
			addChild(mc);
			
			var nb:MovieClip = new MovieClip();
			var pb:MovieClip = new MovieClip();
			
			var sst :SlideshowByTweensy = new SlideshowByTweensy(mc,nb,pb, "xml/pagelist.xml");
			
			//stageに背景のリサイズリスナーを登録（イベント:リサイズ，実行関数:onStageResize）
//addEventListener(Event.RESIZE,slideObj.onStageResize);
		}
	}
}

	
	
	
	
	