package com.flashdynamix.motion.easing {

	/**	 * The CustomEasing Class allows for you to create your own custom ease equations<BR>	 * 'precalculated' allows for an Array of precalculated points describing an ease equation.<BR>	 * 'curve' allows for a bezier curve describing an ease eequation.	 */	public class CustomEasing {

		/**		 * Use this function if requiring a custom precalculated easing equation.<BR>
		 * In order to use this equation it requires additional parameters that can be defined using the <a href="http://www.mosessupposes.com/Fuse/fuse2docs/release-notes-2.1.html#customeasingtool" target="_blank">FuseKit Custom Ease Tool</a><BR>
		 * To apply the ease parameters to the equation use the easeParams property on the TweensyTimeline instance.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline#easeParams TweensyTimeline.easeParams		 */		public static function precalculated(t : Number,b : Number,c : Number,d : Number, ...params : Array) : Number {			return b + c * params[Math.round(t / d * params.length)];		}

		/**		 * Use this function if requiring a custom curve easing equation.
		 * In order to use this equation it requires additional parameters that can be defined using the <a href="http://www.mosessupposes.com/Fuse/fuse2docs/release-notes-2.1.html#customeasingtool" target="_blank">FuseKit Custom Ease Tool
		 * To apply the ease parameters to the equation use the easeParams property on the TweensyTimeline instance.
		 * 
		 * @see com.flashdynamix.motion.TweensyTimeline#easeParams TweensyTimeline.easeParams		 */		public static function curve(t : Number,b : Number,c : Number,d : Number, ...params : Array) : Number {			var r : Number = 200 * t / d;			var i : Number = -1;			var e : Object;						while (params[++i].Mx <= r) e = params[i];						var Px : Number = e.Px;			var Py : Number = e.Py;			var Nx : Number = e.Nx;			var Ny : Number = e.Ny;			var Mx : Number = e.Mx;			var My : Number = e.My;						var s : Number = (Px == 0) ? -(Mx - r) / Nx : (-Nx + Math.sqrt(Nx * Nx - 4 * Px * (Mx - r))) / (2 * Px);						return (b - c * ((My + Ny * s + Py * s * s) / 200));		}	}}