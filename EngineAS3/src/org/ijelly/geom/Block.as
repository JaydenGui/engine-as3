package org.ijelly.geom
{
	public class Block
	{
		private var _lineV:Vector.<Line2D>
		public function Block(pointv:Vector.<Vector2f>)
		{
			init(pointv);
		}
		private function init(pointv:Vector.<Vector2f>):void{
			_lineV = new Vector.<Line2D>;
			var l:Line2D;
			for(var i:int;i<pointv.length-1;i++){
				l = new Line2D(pointv[i],pointv[i+1]);
				_lineV.push(l);
			}
			l = new Line2D(pointv[i],pointv[0]);
			_lineV.push(l);
		}

		public function get lineV():Vector.<Line2D>
		{
			return _lineV;
		}

		
	}
}