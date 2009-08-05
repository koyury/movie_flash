package com.flashdynamix.motion.guides {

	/**
	 * Allows for Objects to follow a 2D directional path. This path is made from a list of
	 * points these points are through points for the direction path.
	 */
	public class Direction2D {

		/**
		 * The Object you wish to be updated with x,y values
		 */
		public var item : Object;

		/**
		 * Whether the Object will directionally rotate.
		 */
		public var autoRotate : Boolean = false;

		private var sx : Number;
		private var sy : Number;
		private var _angle : Number;
		private var _distance : Number;
		private var _position : Number = 0;
		private var cosA : Number;
		private var sinA : Number;
		private var degreeRad : Number = Math.PI / 180;
		private var radDegree : Number = 180 / Math.PI;

		/**
		 * @param item The Object you wish to be updated with x,y and rotation values
		 * @param angle The angle in degrees you would like your Object to travel.<BR>
		 * This value can be either a Number or a String i.e. "45, 90" will use a random angle between 45 and 90 degrees.
		 * @param distance The distance in pixels you would like your Object to travel.<BR>
		 * This value can be either a Number or a String i.e. "50, 100" will use a random distance between 50 and 100 pixels.
		 * @param startDistance The start distance pixels will offset the Objects current position using the current angle.<BR>
		 * This value can be either a Number or a String i.e. "50, 100" will use a random distance between 50 and 100 pixels.
		 * @param autoRotate Whether the Object will directionally rotate.
		 */
		public function Direction2D(item : Object, angle : *, distance : *, startDistance : * = 0, autoRotate : Boolean = false) : void {
			this.item = item;
			
			_angle = translate(angle) * degreeRad;
			_distance = translate(distance);
			
			cosA = Math.cos(_angle);
			sinA = Math.sin(_angle);
			
			var sd : Number = translate(startDistance);
			item.x += cosA * sd;
			item.y += sinA * sd;
			
			sx = item.x;
			sy = item.y;
			
			if(autoRotate) item.rotation = _angle * radDegree;
		}

		/**
		 * Sets the position on the Object along the Directional path from 0-1
		 * @param num The position from 0-1
		 */
		public function set position(num : Number) : void {
			_position = num;
			
			update();
		}

		/**
		 * @return The current position of the Object along the Directional path from 0-1
		 */
		public function get position() : Number {
			return _position;
		}

		/**
		 * The angle in degrees you would like your Object to travel.
		 */
		public function set angle(degrees : Number) : void {
			_angle = degrees * degreeRad;
			
			cosA = Math.cos(_angle);
			sinA = Math.sin(_angle);
			
			if(autoRotate) item.rotation = _angle * radDegree;
			
			update();
		}

		/**
		 * @return The angle in degrees you would like your Object to travel.
		 */
		public function get angle() : Number {
			return _angle * radDegree;
		}

		/**
		 * The distance you would like your Object to travel in pixels.
		 */
		public function set distance(pixels : Number) : void {
			_distance = pixels;
			update();
		}

		public function get endX() : Number {
			return sx + (cosA * distance);
		}

		public function get endY() : Number {
			return sy + (sinA * distance);
		}

		/**
		 * @return The distance you would like your Object to travel in pixels.
		 */
		public function get distance() : Number {
			return _distance;
		}

		private function translate(num : *) : Number {
			
			if(num is String) {
				var values : Array = String(num).split(",");
				if(values.length == 1) {
					return parseFloat(num);
				} else {
					var start : Number = parseFloat(values[0]), end : Number = parseFloat(values[1]);
					return start + (Math.random() * (end - start));
				}
			} else {
				return num;
			}
		}

		private function update() : void {
			var dist : Number = (distance * _position);
			item.x = sx + (cosA * dist);
			item.y = sy + (sinA * dist);
		}
	}
}
