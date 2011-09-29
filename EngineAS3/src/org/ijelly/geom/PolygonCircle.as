package org.ijelly.geom
{
	public class PolygonCircle
	{
		public var vertexNmu:int;				//顶点数
		public var vertexV:Vector.<Vector2f>;	//顶点列表
		public var circle:Circle;
		public function PolygonCircle(vertexv:Vector.<Vector2f>,circle:Circle)
		{
			this.vertexV = vertexv;
			this.circle = circle;
			this.vertexNmu = vertexv.length;
		}
		private var allLine:Array;
		public function getRatelition(testline:Line2D):Boolean{
			if(allLine == null){
				allLine = getAllLine();
			}
			var thisline:Line2D;
			var num:int;
			for(var i:int;i<allLine.length;i++){
				thisline = allLine[i];
				var p:Vector2f = new Vector2f;
				if(thisline.intersection(testline,p) == LineClassification.SEGMENTS_INTERSECT){
					if(!(p.equal(testline.pointA) || p.equal(testline.pointB))){
						return true;
					}else{
						num++
					}
				}
			}
			if(num >= 4){
				//return true; 
			}
			return false;
		}
		public function getAllLine():Array{
			var ary:Array = new Array;
			for(var i:int=0;i<vertexV.length-1;i++){
				ary.push(new Line2D(vertexV[i],vertexV[i+1]));
			}
			ary.push(new Line2D(vertexV[vertexV.length-1],vertexV[0]));
			return ary;
		}
	}
}