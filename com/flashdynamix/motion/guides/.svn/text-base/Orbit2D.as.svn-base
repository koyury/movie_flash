package com.flashdynamix.motion.guides {

	/**
	 * Allows for Objects to follow a 2D orbit path.<BR>
	 * This path is defined by a radiusX/radiusX and centerX/centerY.
	 */
	public class Orbit2D {

		/**
		 * The Object you wish to be updated with x,y values of the orbit path.
		 */
		public var item : Object;
		/**
		 * Whether the Object will directionally rotate.
		 */
		public var autoRotate : Boolean = false;

		private var _radiusX : Number;
		private var _radiusY : Number;
		private var _angle : Number = 0;
		private var _centerX : Number = 0;
		private var _centerY : Number = 0;
		private var cosAX : Number = 0;
		private var sinAY : Number = 0;

		private var degreeRad : Number = Math.PI / 180;
		private var radDegree : Number = 180 / Math.PI;

		/**
		 * @param item The Object you wish to be updated with x,y values.
		 * @param radiusX The x radius of the orbit path in pixels.
		 * @param radiusY The y radius of the orbit path in pixels.
		 * @param centerX The center x of the orbit path in pixels.
		 * @param centerY The center y of the orbit path in pixels.
		 * @param autoRotate Whether the Object will directionally rotate.
		 */
		public function Orbit2D(item : Object, radiusX : Number, radiusY : Number, centerX : Number, centerY : Number, autoRotate:Boolean = false) {
			this.item = item;
			
			this.radiusX = radiusX;
			this.radiusY = radiusY;
			this.centerX = centerX;
			this.centerY = centerY;
			this.autoRotate = autoRotate;
			
			update();
		}

		/**
		 * The center x of the orbit path in pixels.
		 */
		public function set centerX(pixels : Number) : void {
			_centerX = pixels;
			
			update();
		}

		/**
		 * @return The center x of the orbit path in pixels.
		 */
		public function get centerX() : Number {
			return _centerX;
		}

		/**
		 * @param radius The x radius of the orbit path in pixels.
		 */
		public function set radiusX(radius : Number) : void {
			_radiusX = radius;
			
			update();
		}

		/**
		 * @return The x radius of the orbit path in pixels.
		 */
		public function get radiusX() : Number {
			return _radiusX;
		}

		/**
		 * @param pixels The center y of the orbit path in pixels.
		 */
		public function set centerY(pixels : Number) : void {
			_centerY = pixels;
			
			update();
		}

		/**
		 * @return The center y of the orbit path in pixels.
		 */
		public function get centerY() : Number {
			return _centerY;
		}

		/**
		 * @param radius The y radius of the orbit path in pixels.
		 */
		public function set radiusY(radius : Number) : void {
			_radiusY = radius;
			
			update();
		}

		/**
		 * @return The y radius of the orbit path in pixels.
		 */
		public function get radiusY() : Number {
			return _radiusY;
		}
		
		public function set degree(degree : Number) : void {
			rotation = degree * degreeRad;
		}

		/**
		 * Sets and returns the angle in degrees on the orbit path for your object.
		 */
		public function get degree() : Number {
			return _angle * radDegree;
		}

		public function set rotation(rads : Number) : void {
			_angle = rads;
			cosAX = Math.cos(_angle);
			sinAY = Math.sin(_angle);
			
			if(autoRotate) item.rotation = _angle * radDegree;
			
			update();
		}
		
		/**
		 * Sets and returns the rotation in radians on the orbit path for your object.
		 */
		public function get rotation() : Number {
			return _angle;
		}

		private function update() : void {
			item.x = _centerX + cosAX * _radiusX;
			item.y = _centerY + sinAY * _radiusY;
		}
	}
}
