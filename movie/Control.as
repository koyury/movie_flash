package movie
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Control
	{
		var next_btn:MovieClip;
		var prev_btn:MovieClip;
		var slideshow:StartSlideShow;
		
		
		public function Control(next:MovieClip,prev:MovieClip,start:StartSlideShow)
		{
			next_btn = next;
			prev_btn = prev;
			slideshow = start;
		}
		
		public function removeNext(){
			next_btn.removeEventListener(MouseEvent.CLICK,slideshow.goNext);
		}
		
		public function removePrev(){
			prev_btn.removeEventListener(MouseEvent.CLICK,slideshow.goPrev);
			
		}

	}
}