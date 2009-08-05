package com.flashdynamix.motion.extras {	import flash.display.DisplayObject;	import flash.geom.Matrix;	import flash.geom.Point;	
	public class MatrixTransform {
		public var instance : DisplayObject;
		private var registrationPt : Point = new Point();		private var _innerRegistrationPt : Point = new Point();
		private var _skewX : Number = 0;		private var _skewY : Number = 0;		private var _scaleX : Number = 0;		private var _scaleY : Number = 0;		private var _tXOffset : Number = 0;		private var _tYOffset : Number = 0;
		private var degreeRads : Number = (Math.PI / 180);		private var radsDegree : Number = (180 / Math.PI);
		/**		 * Allows for Matrix transformations to be applied to DisplayObjects.<BR>		 * These transformations extend the native Matrix functionality by allowing rotation, skew and scale		 * around a registration point.<BR>		 * By default the registration point is set to the top left hand corner.		 * 		 * @see com.flashdynamix.motion.extras.MatrixTransform#registrationX		 * @see com.flashdynamix.motion.extras.MatrixTransform#registrationY		 */		public function MatrixTransform(instance : DisplayObject) {			var mtx : Matrix = instance.transform.matrix;			this.instance = instance;						_skewX = Math.atan2(-mtx.c, mtx.d);			_skewY = Math.atan2(mtx.b, mtx.a);			_scaleX = Math.sqrt(mtx.a * mtx.a + mtx.b * mtx.b);			_scaleY = Math.sqrt(mtx.c * mtx.c + mtx.d * mtx.d);						registrationX = instance.x;			registrationY = instance.y;		}
		public function set registrationX(pixels : Number) : void {			registrationPt.x = pixels;			_innerRegistrationPt.x = (registrationPt.x - instance.x);		}
		/**		 * Sets and returns the x registration for the DisplayObject in pixels.<BR>		 * The scope for the registration point is the DisplayObject's container.		 */		public function get registrationX() : Number {			return registrationPt.x;		}
		public function set registrationY(pixels : Number) : void {			registrationPt.y = pixels;			_innerRegistrationPt.y = (registrationPt.y - instance.y);		}
		/**		 * Sets and returns the y registration for the DisplayObject in pixels.<BR>		 * The scope for the registration point is the DisplayObject's container.		 */		public function get registrationY() : Number {			return registrationPt.y;		}
		public function set tx(offset : Number) : void {			_tXOffset = offset;						updateRegistration();		}
		/**		 * Sets and returns a x translation in pixels to offset the DisplayObject from the registration point.		 */		public function get tx() : Number {			return _tXOffset;		}
		public function set ty(offset : Number) : void {			_tYOffset = offset;						updateRegistration();		}
		/**		 * Sets and returns a y translation in pixels to offset the DisplayObject from the registration point.		 */		public function get ty() : Number {			return _tYOffset;		}
		public function set degree(value : Number) : void {			rotation = value * degreeRads;		}
		/**		 * Sets and returns the rotation for the DisplayObject in degrees		 */		public function get degree() : Number {			return instance.rotation;		}
		public function set rotation(rads : Number) : void {			skewY = rads;			skewX = rads;		}
		/**		 * Sets and returns the rotation for the DisplayObject in radians		 */		public function get rotation() : Number {			return instance.rotation * degreeRads;		}
		public function set scaleX(amount : Number) : void {			_scaleX = amount;						var mtx : Matrix = instance.transform.matrix;						mtx.a = _scaleX * Math.cos(_skewY);			mtx.b = _scaleX * Math.sin(_skewY);			instance.transform.matrix = mtx;						updateRegistration();		}
		/**		 * Sets and returns the scaleX for the DisplayObject in a percentage.<BR>		 * i.e. 1 is normal x scale, 2 is double x scale, -1 is inverted x scale.		 */		public function get scaleX() : Number {			return _scaleX;		}
		public function set scaleY(amount : Number) : void {			_scaleY = amount;						var mtx : Matrix = instance.transform.matrix;						mtx.c = _scaleY * -Math.sin(_skewX);			mtx.d = _scaleY * Math.cos(_skewX);			instance.transform.matrix = mtx;						updateRegistration();		}
		/**		 * Sets and returns the scaleY for the DisplayObject in a percentage.<BR>		 * i.e. 1 is normal y scale, 2 is double y scale, -1 is inverted y scale.		 */		public function get scaleY() : Number {			return _scaleY;		}
		public function set skewY(rads : Number) : void {			_skewY = rads;						var mtx : Matrix = instance.transform.matrix;						mtx.a = _scaleX * Math.cos(_skewY);			mtx.b = _scaleX * Math.sin(_skewY);						instance.transform.matrix = mtx;						updateRegistration();		}
		/**		 * Sets and returns the skew in the direction y for the DisplayObject in radians.		 */		public function get skewY() : Number {			return _skewY;		}
		public function set skewYDegree(value : Number) : void {			skewY = value * degreeRads;		}
		/**		 * Sets and returns the skew in the direction y for the DisplayObject in degrees.		 */		public function get skewYDegree() : Number {			return _skewY * radsDegree;		}
		public function set skewX(rads : Number) : void {			_skewX = rads;						var mtx : Matrix = instance.transform.matrix;						mtx.c = -_scaleY * Math.sin(_skewX);			mtx.d = _scaleY * Math.cos(_skewX);						instance.transform.matrix = mtx;						updateRegistration();		}
		/**		 * Sets and returns the skew in the direction x for the DisplayObject in radians.		 */		public function get skewX() : Number {			return _skewX;		}
		public function set skewXDegree(value : Number) : void {			skewX = value * degreeRads;		}
		/**		 * Sets and returns the skew in the direction x for the DisplayObject in degrees.		 */		public function get skewXDegree() : Number {			return _skewX * radsDegree;		}
		private function updateRegistration() : void {			var mtx : Matrix = instance.transform.matrix;						var pt : Point = mtx.deltaTransformPoint(_innerRegistrationPt);			mtx.tx = registrationPt.x - pt.x + _tXOffset;			mtx.ty = registrationPt.y - pt.y + _tYOffset;						instance.transform.matrix = mtx;		}
		public function toString() : String {			return "MatrixTransform {registrationX:" + registrationX + ", registrationY:" + registrationY + ", matrix:" + instance.transform.matrix + "}";		}	}}