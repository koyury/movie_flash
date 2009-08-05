package com.flashdynamix.motion.guides {
	import flash.geom.Point;	

	/**
	 * Allows for Objects to follow a 2D bezier path. This path is made from a list of
	 * points these points are either control points or through points for the bezier.
	 */
	public class Bezier2D {

		/**
		 * The Object you wish to be updated with x,y and rotation values.
		 */
		public var item : Object;
		/**
		 * A list of Points defining nodes of the bezier path.
		 */
		private var _pts : Array;
		/**
		 * Whether the Object will directionally rotate.
		 */
		public var autoRotate : Boolean;
		/**
		 * Whether the pts in the bezier path will be used as control points or through points.
		 */
		public var through : Boolean;
		/**
		 * Whether the pts in the BezierPath can be repositioned.
		 */
		public var movingPts : Boolean;

		private var curve : Array;
		private var _position : Number = 0;
		private var _distance : Number = 0;
		private var radsDegree : Number = 180 / Math.PI;

		/**
		 * @param item The Object you wish to be updated with x,y and rotation values.
		 * @param through Whether the pts in the bezier path will be used as control points or through points.
		 * @param autoRotate Whether the Object will directionally rotate.
		 * @param movingPts Whether the pts in the BezierPath can be repositioned.
		 */
		public function Bezier2D(item : Object, through : Boolean = false, autoRotate : Boolean = false, movingPts : Boolean = false, ...pts : Array) {
			this.item = item;
			this.through = through;
			this.autoRotate = autoRotate;
			this.movingPts = movingPts;
			_pts = pts;
			curve = [];
		}

		public function set path(curve : Array) : void {
			_pts = curve;
			update();
		}

		public function get path() : Array {
			return _pts;
		}

		/**
		 * @param index The position to return a Point from.
		 * @return Returns a Point at the specified index.
		 */
		public function index(index : int) : Point {
			return _pts[index];
		}

		/**
		 * Pushes a Point into the Bezier path.
		 * @param pt The Point which will be added to the end of the bezier path.
		 */
		public function push(pt : Point) : void {
			_pts.push(pt);
			update();
		}

		/**
		 * Adds a Point into the Bezier path at the specified index.
		 * @param index The index for which to insert the Point.
		 * @param pt The Point to insert at the index.
		 */
		public function addAt(index : int, pt : Point) : void {
			_pts.splice(index, 0, pt);
			update();
		}

		/**
		 * Removes a Point from the Bezier path.
		 * @param pt The Point you would like to remove from the bezier path.
		 */
		public function remove(pt : Point) : void {
			var index : int = _pts.indexOf(pt);
			if(index != -1) removeAt(index, 1);
		}

		/**
		 * Removes one or more Point(s) at the specified index and count from the Bezier path. 
		 * @param index The index to start removing nodes from the Bezier path.
		 * @param count the Number of nodes to remove from the Bezier path. If this is 0 no nodes are removed.
		 * 
		 */
		public function removeAt(index : int, count : int = 1) : void {
			_pts.splice(index, count);
			update();
		}

		/**
		 * @return The number of nodes in the Bezier path.
		 */
		public function get length() : int {
			return _pts.length;
		}

		/**
		 * Sets the position on the Object along the bezier path from 0-1.
		 * @param num The position from 0-1.
		 */
		public function set position(num : Number) : void {
			_position = num;
			
			if(curve.length == 0) return;
			
			if(movingPts) update();

			var posDist : Number = num * _distance;
			var distance : Number = 0;
			var arcDist : Number;
			var index : int;
			var segments : int = curve.length - 3;
			
			for(index = 0;index <= segments; index += 2) {
				arcDist = arcLength(curve[index], curve[index + 1], curve[index + 2]);
				
				if(distance + arcDist > posDist) break;
				
				distance += arcDist;
			}
			
			index = (index > segments) ? segments : index;
			var inc : Number = (posDist == _distance) ? 1 : (posDist - distance) / arcDist;
			
			var sPt : Point = curve[index];
			var cPt : Point = curve[index + 1];
			var ePt : Point = curve[index + 2];

			var pt : Point = new Point(quadratic(inc, sPt.x, cPt.x, ePt.x), quadratic(inc, sPt.y, cPt.y, ePt.y));
			item.x = pt.x;
			item.y = pt.y;

			if(autoRotate) item.rotation = angle(inc, sPt, cPt, ePt) * radsDegree;
		}

		/**
		 * @return The current position of the Object along the Bezier path from 0-1.
		 */
		public function get position() : Number {
			return _position;
		}

		private function update() : void {
			if(_pts.length <= 2) return;
			
			var i : int;
			var len : int;
			curve = [];
			
			if(through) {
				var pt : Point = _pts[int(0)];
				var cPt : Point;
				
				curve.push(pt);
				
				cPt = index(2).subtract(pt);
				cPt.x /= 4;
				cPt.y /= 4;
				cPt = index(1).subtract(cPt);
				
				pt = index(1);
				
				curve.push(cPt);
				curve.push(pt);
				
				
				len = _pts.length - 1;
				
				for(i = 1;i < len; i++) {
					cPt = index(i).add(index(i).subtract(cPt));
					pt = index(i + 1);
					
					curve.push(cPt);
					curve.push(pt);
				}
			} else {
				len = 3 + int((_pts.length - 3) / 2) * 2;
				
				for( i = 0;i < len;i++) {
					curve.push(index(i));
				}
			}
			
			updateDistance();
		}

		private function updateDistance() : void {
			_distance = 0;
			for(var i : int = 0;i <= curve.length - 3; i += 2) {
				_distance += arcLength(curve[i], curve[i + 1], curve[i + 2]);
			}
		}

		private function arcLength(pt1 : Point,pt2 : Point,pt3 : Point) : Number {
			
			var a1 : Number = angleBetween(pt1, pt2);
			var a2 : Number = angleBetween(pt2, pt3);
			if(a1 == a2 || (a2 == a1 + Math.PI)) return distanceBetween(pt1, pt3);
			
			var vmDivisor : Number = (pt2.y - .5 * pt3.y - .5 * pt1.y);
			var vm : Number = 0;
			if(vmDivisor != 0) {
				vm = -(pt2.x - .5 * pt3.x - .5 * pt1.x) / vmDivisor;
			}
			var vtDivisor : Number = (vm * (pt1.x - 2 * pt2.x + pt3.x) - (pt1.y - 2 * pt2.y + pt3.y));
			var vt : Number = 0;
			if(vtDivisor != 0) {
				vt = (-vm * (pt2.x - pt1.x) + (pt2.y - pt1.y)) / vtDivisor;
			}
			
			var va : Number = angle(vt, pt1, pt2, pt3);

			var ra : Number = projectDistance(pt1, pt2);
			var rb : Number = projectDistance(pt2, pt3);
			var alfa : Number = va - radAngle(pt1, pt2);
			
			var beta : Number = radAngle(pt2, pt3) - va;
			var rax : Number = ra * Math.cos(alfa);
			var ray : Number = ra * Math.sin(alfa);
		
			var rbx : Number = rb * Math.cos(beta);
			var rby : Number = rb * Math.sin(beta);

			var l1 : Number = .5 * parabolaArcLength(ray, 2 * Math.abs(rax));
			var l2 : Number = .5 * parabolaArcLength(rby, 2 * Math.abs(rbx));
			
			return (rax < 0 || rbx < 0) ? Math.abs(l2 - l1) : l1 + l2;
		}

		private function angleBetween(p1 : Point, p2 : Point) : Number {
			var x : Number = p2.x - p1.x;
			var y : Number = p2.y - p1.y;
			
			return Math.atan2(y, x);
		}

		private function distanceBetween(p1 : Point, p2 : Point) : Number {
			var x : Number = p2.x - p1.x;
			var y : Number = p2.y - p1.y;
			
			return Math.sqrt((x * x) + (y * y));
		}

		private function segment(pt1 : Point,pt2 : Point,pt3 : Point,t1 : Number,t2 : Number) : Object {
			var b1 : Point = new Point();
			var b2 : Point = new Point();
			var b3 : Point = new Point();
			
			b1.x = quadratic(t1, pt1.x, pt2.x, pt3.x);
			b1.y = quadratic(t1, pt1.y, pt2.y, pt3.y);
			b3.x = quadratic(t2, pt1.x, pt2.x, pt3.x);
			b3.y = quadratic(t2, pt1.y, pt2.y, pt3.y);
			b2.x = control(t1, t2, pt1.x, pt2.x, pt3.x);
			b2.y = control(t1, t2, pt1.y, pt2.y, pt3.y);

			return {b1:b1, b2:b2, b3:b3};
		};

		private  function control(t1 : Number,t2 : Number,a : Number,b : Number,c : Number) : Number {
			return a + (t1 + t2) * (b - a) + t1 * t2 * (c - 2 * b + a);
		}

		private function radAngle(p1 : Point,p2 : Point) : Number {
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}

		private function projectDistance(p1 : Point,p2 : Point) : Number {
			return Math.sqrt(p2.x * p2.x + p1.x * p1.x - 2 * p1.x * p2.x + p2.y * p2.y + p1.y * p1.y - 2 * p1.y * p2.y);
		}

		private function parabolaArcLength(a : Number,b : Number) : Number {
			if(a == 0) return 0;
			
			return .5 * Math.sqrt(b * b + 16 * a * a) + ((b * b) / (8 * a)) * Math.log((4 * a + Math.sqrt(b * b + 16 * a * a)) / b);
		}

		private function angle(t : Number, pt1 : Point, pt2 : Point, pt3 : Point) : Number {
			return (Math.atan2(derivative(t, pt1.y, pt2.y, pt3.y), derivative(t, pt1.x, pt2.x, pt3.x)));
		}

		private function quadratic(t : Number,a : Number,b : Number,c : Number) : Number {
			return a + t * (2 * (1 - t) * (b - a) + t * (c - a));
		}

		private function derivative(t : Number, a : Number, b : Number, c : Number) : Number {
			return 2 * a * (t - 1) + 2 * b * (1 - 2 * t) + 2 * c * t;
		}
	}
}
