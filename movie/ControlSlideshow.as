package movie
{
	import flash.events.MouseEvent;
	import movie.ControlSlideshow;
	import com.flashdynamix.motion.Tweensy;
	
	public class ControlSlideshow
	{
		var ss:StartSlideShow;
		public function ControlSlideshow(start:StartSlideShow)
		{
			ss = start;
		}

		public function goNext(event:MouseEvent):void{
			ss.currentNo = ss.currentNo+1;
			Tweensy.stop();
			var Timeline:TweensyTimeline = Tweensy.to([imgLoader,titleField,subtitleField,contentField,captionField], {alpha:0},1);
			Timeline.onComplete = ctlXMLloaded; 
			ss.loadCurrentPage(ss.currentNo);
			
		}
		
		public function goPrev(event:MouseEvent):void{
			ss.currentNo = ss.currentNo-1;
			Tweensy.stop();
			ss.loadCurrentPage(ss.currentNo);
		}
	}
}