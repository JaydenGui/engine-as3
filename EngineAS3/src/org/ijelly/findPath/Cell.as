/*
* @author 白连忱 
* date Jan 22, 2010
*/
package org.ijelly.findPath
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.ijelly.geom.PathPoint;
	import org.ijelly.geom.Triangle;
	import org.ijelly.geom.Vector2f;
	
	/**
	 * 寻路用的单元格（三角形）
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 */
	public class Cell extends Triangle
	{
		private var _index:int;				//在数组中的索引值
		private var _links:Vector.<int>;		// 与该三角型连接的三角型索引， -1表示改边没有连接
		
		public  var sessionId:int;
		public var f:int;
		public var h:int;
		public var isOpen:Boolean = false;
		public var parent:Cell;
		public var countPoint:Vector2f;
		public var pathPointOne:PathPoint;
		public var pathPointTwo:PathPoint;
		
		public var blockAry:Vector.<int>;
		public var crossBlockAry:Vector.<int>;
		
		public var m_ArrivalWall:int; // the side we arrived through.
		public var m_WallMidpoint:Vector.<Vector2f>; // 每个边的中点
		public var m_WallDistance:Vector.<Number>; // the distances between each wall midpoint of sides (0-1, 1-2, 2-0)
		
		public function Cell(p1:Vector2f=null, p2:Vector2f=null, p3:Vector2f=null) {
			super(p1, p2, p3);
			
			init();
		}

	
		/**
		 * 计算中心点（3个顶点的平均值） 
		 */

		public function get links():Vector.<int>
		{
			return _links;
		}

		public function set links(value:Vector.<int>):void
		{
			_links = value;
		}

		private function init():void {
			links = new Vector.<int>();
			links.push(-1);
			links.push(-1);
			links.push(-1);
			
			//
			calculateData();
			
			m_WallMidpoint = new Vector.<Vector2f>();
			m_WallDistance = new Vector.<Number>();
			// compute the midpoint of each cell wall
			m_WallMidpoint[0] = new Vector2f((pointA.x + pointB.x) / 2.0, (pointA.y + pointB.y) / 2.0);
			m_WallMidpoint[1] = new Vector2f((pointC.x + pointB.x) / 2.0, (pointC.y + pointB.y) / 2.0);
			m_WallMidpoint[2] = new Vector2f((pointC.x + pointA.x) / 2.0, (pointC.y + pointA.y) / 2.0);
			
			// compute the distances between the wall midpoints
			var wallVector:Vector2f;
			wallVector = m_WallMidpoint[0].subtract(m_WallMidpoint[1]);
			m_WallDistance[0] = wallVector.length();
			
			wallVector = m_WallMidpoint[1].subtract(m_WallMidpoint[2]);
			m_WallDistance[1] = wallVector.length();
			
			wallVector = m_WallMidpoint[2].subtract(m_WallMidpoint[0]);
			m_WallDistance[2] = wallVector.length();
			
		}

		/**
		 * 获得两个点的相邻三角型
		 * @param pA
		 * @param pB
		 * @param caller
		 * @return 如果提供的两个点是caller的一个边, 返回true
		 */		
		private function requestLink(pA:Vector2f, pB:Vector2f, caller:Cell):Boolean {
			if (pointA.equals(pA)) {
				if (pointB.equals(pB)) {
					links[SIDE_AB] = caller.index;
					return (true);
				} else if (pointC.equals(pB)) {
					links[SIDE_CA] = caller.index;
					return (true);
				}
			} else if (pointB.equals(pA)) {
				if (pointA.equals(pB)) {
					links[SIDE_AB] = caller.index;
					return (true);
				} else if (pointC.equals(pB)) {
					links[SIDE_BC] = caller.index;
					return (true);
				}
			} else if (pointC.equals(pA)) {
				if (pointA.equals(pB)) {
					links[SIDE_CA] = caller.index;
					return (true);
				} else if (pointB.equals(pB)) {
					links[SIDE_BC] = caller.index;
					return (true);
				}
			}
			
			// we are not adjacent to the calling cell
			return (false);
		}
		
		/**
		 * 取得指定边的相邻三角型的索引
		 * @param side
		 * @return 
		 */		
		private function getLink(side:int):int {
			return links[side];
		}
		
		/**
		 * 检查并设置当前三角型与cellB的连接关系（方法会同时设置cellB与该三角型的连接）
		 * @param cellB
		 */		
		public function checkAndLink(cellB:Cell):void {
			if (getLink(SIDE_AB) == -1 && cellB.requestLink(pointA, pointB, this)) {
				setLink(SIDE_AB, cellB);
			} else if (getLink(SIDE_BC) == -1 && cellB.requestLink(pointB, pointC, this)) {
				setLink(SIDE_BC, cellB);
			} else if (getLink(SIDE_CA) == -1 && cellB.requestLink(pointC, pointA, this)) {
				setLink(SIDE_CA, cellB);
			}
		}
		
		/**
		 * 设置side指定的边的连接到caller的索引
		 * @param side
		 * @param caller
		 */		
		private function setLink(side:int, caller:Cell):void {
			links[side] = caller.index;
		}
		
		/**
		 * 记录路径从上一个节点进入该节点的边（如果从终点开始寻路即为穿出边）
		 * @param index	路径上一个节点的索引
		 */		
		public function setAndGetArrivalWall(index:int):int {
			if (index == links[0]) {
				m_ArrivalWall = 0;
				return 0;
			} else if (index == links[1]) {
				m_ArrivalWall = 1;
				return 1;
			} else if (index == links[2]) {
				m_ArrivalWall = 2;
				return 2;
			}
			return -1;
		}
		
		/**
		 * 计算估价（h）  Compute the A* Heuristic for this cell given a Goal point
		 * @param goal
		 */		
		public function computeHeuristic(goal:Vector2f):void {
			// our heuristic is the estimated distance (using the longest axis delta) 
			// between our cell center and the goal location
			
			var XDelta:Number = Math.abs(goal.x - center.x);
			var YDelta:Number = Math.abs(goal.y - center.y);
			
//			h = Math.max(XDelta, YDelta);
			h = XDelta + YDelta;
		}
		
		/**
		 * 计算估价（h）  Compute the A* Heuristic for this cell given a Goal point
		 * @param goal
		 */		
		public function computeH(goal:Vector2f,curr:Vector2f):void {
			// our heuristic is the estimated distance (using the longest axis delta) 
			// between our cell center and the goal location
			
			if(curr==null) return;
			
			var XDelta:Number = Math.abs(goal.x - curr.x);
			var YDelta:Number = Math.abs(goal.y - curr.y);
			
//			h = Math.max(XDelta, YDelta);
			h = Math.sqrt(XDelta*XDelta + YDelta*YDelta);
		}
		

		/**
		 * 绘制网格索引
		 * @param sp
		 */		
		public function drawIndex(sp:Sprite):void {
			var tf:TextFormat = new TextFormat();
			tf.color = 0x00ff00;
			tf.bold = true;
			tf.size = 16;
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFormatAlign.LEFT;
			txt.text = this._index.toString();
			txt.x = this.center.x;
			txt.y = this.center.y;
			sp.addChild(txt);
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
	}
}