/**
.______                                                              __          ___     
/\__  _\                                                           /'__`\      /'___`\   
\/_/\ \/  __  __  __     __      __     ___      ____   __  __    /\ \/\ \    /\_\ /\ \  
...\ \ \ /\ \/\ \/\ \  /'__`\  /'__`\ /' _ `\   /',__\ /\ \/\ \   \ \ \ \ \   \/_/// /__ 
....\ \ \\ \ \_/ \_/ \/\  __/ /\  __/ /\ \/\ \ /\__, `\\ \ \_\ \   \ \ \_\ \ __  // /_\ \
.....\ \_\\ \___x___/'\ \____\\ \____\\ \_\ \_\\/\____/ \/`____ \   \ \____//\_\/\______/
......\/_/ \/__//__/   \/____/ \/____/ \/_/\/_/ \/___/   `/___/> \   \/___/ \/_/\/_____/ 
............................................................/\___/                       
............................................................\/__/................. Tweening since 1998 ..................................................................................
 */
package com.flashdynamix.motion {
	import com.flashdynamix.motion.TweensyGroup;
	import com.flashdynamix.motion.TweensyTimeline;	
	/**
	 * TweensySequence Class allows for complex animations which occur one after another.
	 * This can of course be done with the TweensyGroup or Tweensy class but the TweensySequence class helps
	 * you by calculating the delayStarts for each tween as it's pushed into the sequence queue.
	 * 
	 * @see com.flashdynamix.motion.Tweensy
	 * @see com.flashdynamix.motion.TweensyGroup
	 * @see com.flashdynamix.motion.TweensyTimeline
	 */
	public class TweensySequence {
		/**
		 * Executed when the TweensySequence animation is complete.
		 * 
		 * @see com.flashdynamix.motion.TweensySequence.onCompleteParams
		 */
		public var onComplete : Function;
		/**
		 * Parameters applied to the onComplete Function.
		 * 
		 * @see com.flashdynamix.motion.TweensySequence.onComplete
		 */
		public var onCompleteParams : Array;
		/**
		 * Defines the repeat type for the animation. By default this is TweensyTimeline.NONE<BR><BR>
		 * Options include :
		 * <ul>
		 * <li>TweensyTimeline.NONE</li>
		 * <li>TweensyTimeline.REPLAY</li>
		 * <li>TweensyTimeline.LOOP</li>
		 * </ul>
		 * 
		 * @see com.flashdynamix.motion.TweensySequence.repeats
		 * @see com.flashdynamix.motion.TweensySequence.repeatCount
		 * @see com.flashdynamix.motion.TweensyTimeline.NONE
		 * @see com.flashdynamix.motion.TweensyTimeline.REPLAY
		 * @see com.flashdynamix.motion.TweensyTimeline.LOOP
		 */
		public var repeatType : String;
		/**
		 * The number of repeats to use. If -1 is used then the animation will repeat indefinitely.
		 * 
		 * @see com.flashdynamix.motion.TweensySequence.repeats
		 * @see com.flashdynamix.motion.TweensySequence.repeatType
		 */
		public var repeats : int = -1;
		/**
		 * The count of the number of repeats which have occured.
		 * 
		 * @see com.flashdynamix.motion.TweensySequence.repeats
		 * @see com.flashdynamix.motion.TweensySequence.repeatType
		 */
		public var repeatCount : int = 0;
		private var tween : TweensyGroup;
		private var queue : Array;		private var disposed : Boolean = false;
		/**
		 * @param lazyMode whether the tween manager will automatically remove confilcting tweens. This is not the most efficient method
		 * for using Tweensy. If lazy mode is turned off then it's the responsibility of the developer to ensure that conflicting tweens don't 
		 * occur by using the stop method on the instance. As well in lazy mode Tweensy will not use Object pooling decreasing it's overall performance.
		 * @param refreshType of the timing mode it can be either "time" or "frame" by default it's Tweensy.TIME. Tweensy.TIME will ensure that your animations finish in
		 * the time you specify. Tweensy.FRAME allows you to set the seconds to update per frame by default it's set to 30 FPS which equals
		 * in SPF  = 0.033333333 or 1/30.
		 */
		public function TweensySequence() {
			queue = [];
			
			tween = new TweensyGroup(true, false);
			tween.onComplete = done;
		}
		/**
		 * Adds an animation after the last animation in the sequence.
		 * 
		 * @param instance The instance Object to be tweened or multiple instances if using the type Array e.g. [item1, item2]
		 * @param to An Object containing the properties you would like to tween to e.g. {x:50, y:25}
		 * or this can be relative e.g. {x:'50', y:'-25'} or can be a random position e.g. {x:'-50, 50', y:'-25, 25'}
		 * @param duration The time in secs you would like the tween to run.
		 * @param ease The ease equation you would like to use e.g. Quintic.easeOut.
		 * @param delayStart The delay you would like to use at the beginning of the tween and every subsequent repeat of a tween.
		 * @param update This param is used when tweening a property in an Object which needs to be applied onto another Object each time
		 * the tween occurs.<BR>
		 * For example to(new DropShadowFilter(), {alpha:0}, myDisplayItem); Will apply the tweening DropShadowFilter onto the DisplayObject 'myDisplayItem'.
		 * @param onComplete The onComplete event handler you would like to fire once the tween is complete.
		 * @param onCompleteParams The params applied to the onComplete handler.
		 * 
		 * @return An instance of the TweensyTimeline which can used to manage this tween.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline
		 */
		public function push(instance : Object, to : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, delayEnd : Number = 0, update : Object = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
						var timeline : TweensyTimeline = new TweensyTimeline();
			timeline.duration = duration;
			if(ease != null) timeline.ease = ease;
			timeline.delayStart = delayStart;			timeline.delayEnd = delayEnd;
			timeline.onComplete = onComplete;
			timeline.onCompleteParams = onCompleteParams;			
			timeline.to(instance, to, update);
			
			if(last) timeline.delayStart += last.totalDuration;
			
			queue[queue.length] = timeline;
		}
		/**
		 * Adds an animation before the first animation in the sequence.
		 *
		 * @param instance The instance Object to be tweened or multiple instances if using the type Array e.g. [item1, item2]
		 * @param to An Object containing the properties you would like to tween to e.g. {x:50, y:25}
		 * or this can be relative e.g. {x:'50', y:'-25'} or can be a random position e.g. {x:'-50, 50', y:'-25, 25'}
		 * @param duration The time in secs you would like the tween to run.
		 * @param ease The ease equation you would like to use e.g. Quintic.easeOut.
		 * @param delayStart The delay you would like to use at the beginning of the tween and every subsequent repeat of a tween.
		 * @param update This param is used when tweening a property in an Object which needs to be applied onto another Object each time
		 * the tween occurs.<BR>
		 * For example to(new DropShadowFilter(), {alpha:0}, myDisplayItem); Will apply the tweening DropShadowFilter onto the DisplayObject 'myDisplayItem'.
		 * @param onComplete The onComplete event handler you would like to fire once the tween is complete.
		 * @param onCompleteParams The params applied to the onComplete handler.
		 * 
		 * @return An instance of the TweensyTimeline which can used to manage this tween.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline
		 */
		public function unshift(instance : Object, to : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, delayEnd : Number = 0, update : Object = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			var i : int, len : int = queue.length;
			
			var timeline : TweensyTimeline = new TweensyTimeline();
			timeline.duration = duration;
			if(ease != null) timeline.ease = ease;
			timeline.delayStart = delayStart;
			timeline.delayEnd = delayEnd;
			timeline.onComplete = onComplete;
			timeline.onCompleteParams = onCompleteParams;			
			timeline.to(instance, to, update);
			
			for(i = 0;i < len;i++) item(i).delayStart += timeline.totalDuration;
			
			queue.unshift(timeline);
		}
		/**
		 * Adds an animation to the specified index position in the animation sequence.
		 *
		 * @param index The index to insert this animation into the sequence
		 * @param instance The instance Object to be tweened or multiple instances if using the type Array e.g. [item1, item2]
		 * @param to An Object containing the properties you would like to tween to e.g. {x:50, y:25}
		 * or this can be relative e.g. {x:'50', y:'-25'} or can be a random position e.g. {x:'-50, 50', y:'-25, 25'}
		 * @param duration The time in secs you would like the tween to run.
		 * @param ease The ease equation you would like to use e.g. Quintic.easeOut.
		 * @param delayStart The delay you would like to use at the beginning of the tween and every subsequent repeat of a tween.
		 * @param update This param is used when tweening a property in an Object which needs to be applied onto another Object each time
		 * the tween occurs.<BR>
		 * For example to(new DropShadowFilter(), {alpha:0}, myDisplayItem); Will apply the tweening DropShadowFilter onto the DisplayObject 'myDisplayItem'.
		 * @param onComplete The onComplete event handler you would like to fire once the tween is complete.
		 * @param onCompleteParams The params applied to the onComplete handler.
		 * 
		 * @return An instance of the TweensyTimeline which can used to manage this tween.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline
		 */
		public function addAt(index : int, instance : Object, to : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, delayEnd : Number = 0, update : Object = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			var i : int, len : int = queue.length;
			
			var timeline : TweensyTimeline = new TweensyTimeline();
			timeline.duration = duration;
			if(ease != null) timeline.ease = ease;
			timeline.delayStart = delayStart;
			timeline.delayEnd = delayEnd;
			timeline.onComplete = onComplete;
			timeline.onCompleteParams = onCompleteParams;			
			timeline.to(instance, to, update);
			
			for(i = index;i < len;i++) item(i).delayStart += timeline.totalDuration;
			
			if( item(index - 1) ) timeline.delayStart += item(index - 1).totalDuration;
			
			queue.splice(index, 0, timeline);
		}
		/**
		 * Removes an animation from the sequence at the specified position.
		 */
		public function removeAt(index : int) : void {
			queue.splice(index, 1);
		}
		/**
		 * Starts playing the TweensySequence.
		 */
		public function start() : void {
			stop();
			
			var i : int, len : int = queue.length;
			for(i = 0;i < len; i++) tween.add(item(i));
		}
		/**
		 * Stops playing the TweensySequence.
		 */
		public function stop() : void {
			tween.stopAll();
		}
		/**
		 * Pauses playback of the TweensySequence.
		 */
		public function pause() : void {
			tween.pause();
		}
		/**
		 * Whether the TweensySequence is paused.
		 */
		public function get paused() : Boolean {
			return tween.paused;
		}
		/**
		 * Resumes playback of the TweensySequence.
		 */
		public function resume() : void {
			tween.resume();
		}
		public function yoyo() : void {
			var i : int, len : int = queue.length, delays : Array = [], timeline : TweensyTimeline;
			
			for(i = 0;i < len; i++) delays.unshift(item(i).delayStart);
						
			for(i = 0;i < len; i++) {
				timeline = item(i);
				timeline.delayStart = delays[i];
				timeline.yoyo();
			}
						
			queue.reverse();
			
			repeatCount++;
			start();
		}
		/**
		 * Plays a timeline animation at its start position.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline#repeats
		 * @see com.flashdynamix.motion.TweensyTimeline#repeatCount
		 * @see com.flashdynamix.motion.TweensyTimeline#NONE
		 * @see com.flashdynamix.motion.TweensyTimeline#YOYO
		 * @see com.flashdynamix.motion.TweensyTimeline#REPLAY
		 */		public function replay() : void {
			var i : int, len : int = queue.length;
			
			for(i = len - 1;i >= 0; i--) item(i).replay();
			
			repeatCount++;
			start();
		}
		public function set smartRotate(flag : Boolean) : void {			tween.smartRotate = flag;
		}				/**		 * Whether the timelines contained within the TweensyGroup class will use smart rotation or not.<BR>		 * Using smart rotation will ensure that when tweening the 'rotation' property it will turn in the shortest rotation direction.<BR>		 * This fixes what may otherwise appear as a visual glitch even though mathimatically it is correct.		 */		public function get smartRotate() : Boolean {			return tween.smartRotate;		}		public function set snapToClosest(flag : Boolean) : void {			tween.snapToClosest = flag;		}				/**		 * Whether the timelines contained within the TweensyGroup class will snap tweened properties to the closest whole number.		 */		public function get snapToClosest() : Boolean {			return tween.snapToClosest;		}
		/**
		 * Defines whether the TweensyTimeline repeats.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline#repeats
		 * @see com.flashdynamix.motion.TweensyTimeline#repeatCount
		 * @see com.flashdynamix.motion.TweensyTimeline#NONE
		 * @see com.flashdynamix.motion.TweensyTimeline#YOYO
		 * @see com.flashdynamix.motion.TweensyTimeline#REPLAY
		 */		public function get canRepeat() : Boolean {
			return (repeatType != TweensyTimeline.NONE && (repeatCount < repeats || repeats == -1));
		}
		/**
		 * The timing system currently in use.<BR>
		 * This can be either :
		 * <ul>
		 * <li>Tweensy.TIME</li>
		 * <li>Tweensy.FRAME</li>
		 * </ul>
		 * 
		 * @see com.flashdynamix.motion.Tweensy#FRAME
		 * @see com.flashdynamix.motion.Tweensy#TIME
		 * @see com.flashdynamix.motion.TweensyGroup#secondsPerFrame
		 */		public function set refreshType(type : String) : void {
			tween.refreshType = type;
		}
		public function get refreshType() : String {
			return tween.refreshType;
		}		private function item(index : int) : TweensyTimeline {			return queue[index];		}
		private function done() : void {
			if(canRepeat) {
				switch(repeatType) {
					case TweensyTimeline.YOYO :  
						yoyo();
						break;
					case TweensyTimeline.REPLAY : 
						replay();
						break;
				}
			} else {
				if(onComplete != null) onComplete.apply(this, onCompleteParams);
			}
		}
		private function get last() : TweensyTimeline {
			return item(queue.length - 1);
		}
		/**
		 * Disposes the TweensySequence Class ready for garbage collection.
		 */
		public function dispose() : void {
			if(disposed) return;
			
			disposed = true;
			
			tween.dispose();
			
			tween = null;
			queue = null;
			onComplete = null;
			onCompleteParams = null;
		}
	}
}
