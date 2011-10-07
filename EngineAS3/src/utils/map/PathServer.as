package utils.map
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.ijelly.TilePath;
	import org.ijelly.findPath.Cell;
	import org.ijelly.findPath.NavMesh;
	import org.ijelly.geom.Block;
	import org.ijelly.geom.Circle;
	import org.ijelly.geom.Polygon;
	import org.ijelly.geom.PolygonCircle;
	import org.ijelly.geom.Vector2f;
	import org.ijelly.util.Util;

	public class PathServer
	{
		private var nav:NavMesh;
		private var tile:TilePath;
		private var type:String;
		public var debug:Sprite;
		public function PathServer()
		{
			
		}
		public function initMapdata(xml:XML):void{
			type = xml.@type;
			if(type == "nav"){
				//nav = new NavMesh();
				processNav(xml);
			}else if(type == "tile"){
				processTile(xml);
			}
		}
		private function processNav(xml:XML):void{
			var trgData:String = xml.@mapdata;
			var blockData:String = xml.@blockdata;
			var crossBlockData:String = xml.@crossBlockdata;
			
			var cell:Cell;
			var ary:Array = trgData.split('|');
			var str:String;
			var pAry:Array;
			var _cellV:Vector.<Cell> = new Vector.<Cell>();
			var _blockV:Vector.<Block> = new Vector.<Block>;
			var _crossBlockV:Vector.<PolygonCircle> = new Vector.<PolygonCircle>;
			
			for(var i:int=0;i<ary.length;i++){
				str = ary[i];
				pAry = str.split('/');
				for(var j:int=0;j<pAry.length;j++){
					if(j==0){
						var cellary:Array = String(pAry[0]).split(",");
						cell = new Cell(new Vector2f(cellary[0],cellary[1]),new Vector2f(cellary[2],cellary[3]),new Vector2f(cellary[4],cellary[5]));
						cell.index = i;
					}else{
						var blockStr:String = pAry[j];
						if(blockStr.charAt(0) == "~"){
							blockStr = blockStr.substr(1,blockStr.length-1);
							cellary = blockStr.split(",");
							cell.blockAry = new Vector.<int>;
							for(var h:int=0;h<cellary.length;h++){
								cell.blockAry.push(cellary[h]);
							}
							
						}else if(blockStr.charAt(0) == "!"){
							blockStr = blockStr.substr(1,blockStr.length-1);
							cellary = blockStr.split(",");
							
							cell.crossBlockAry = new Vector.<int>;
							for(h=0;h<cellary.length;h++){
								cell.crossBlockAry.push(cellary[h]);
							}
						}
					}
				}
				_cellV.push(cell);
			}
			linkCells(_cellV);
			
			ary = blockData.split('//');
			
			for(i=0;i<ary.length;i++){
				str = ary[i];
				pAry = str.split('|');
				var vAry:Vector.<Vector2f> = new Vector.<Vector2f>;
				for(j=0;j<pAry.length;j++){
					str = pAry[j];
					var bAry:Array = str.split(",");
					var v2f:Vector2f = new Vector2f(bAry[0],bAry[1]);
					vAry.push(v2f);
				}
				_blockV.push(new Block(vAry));
			}
			
			ary = crossBlockData.split('//');
			
			for(i=0;i<ary.length;i++){
				str = ary[i];
				var pcary:Array = str.split(">");
				str = pcary[0];
				
				pAry = str.split('|');
				vAry = new Vector.<Vector2f>;
				for(j=0;j<pAry.length;j++){
					str = pAry[j];
					bAry = str.split(",");
					v2f = new Vector2f(bAry[0],bAry[1]);
					vAry.push(v2f);
				}
				str = pcary[1];
				pAry = str.split(',');
				var circle:Circle = new Circle(pAry[0],pAry[1],pAry[2]);
				
				var polyCircle:PolygonCircle = new PolygonCircle(vAry,circle);
				_crossBlockV.push(polyCircle);
				
			}
			
			nav = new NavMesh(_cellV);
			nav.blockV = _blockV;
			nav.crossBlockV = _crossBlockV;
			
			
			//_mapContainer.setNav(_cellV,_blockV);
			//nav.findPath(new Point,new Point);
			
		}
		public function linkCells(pv:Vector.<Cell>):void {
			for each (var pCellA:Cell in pv) {
				for each (var pCellB:Cell in pv) {
					if (pCellA != pCellB) {
						pCellA.checkAndLink(pCellB);
					}
				}
			}
		}
		private function processTile(xml:XML):void{
			
			var mapWidth:int = int(xml.@mapwidth)/64 + 1;//65
			var mapHeight:int = int(xml.@mapheight)/16 + 1;//162
			
			var _mapdata:String = xml.@mapdata;
			//trace(_mapdata.length);
			var index:int = 0;
			var mapData:Array = [];
			for(var i:int=0;i<mapHeight;i++)
			{
				var tempArr:Array = [];
				for(var j:int=0;j<mapWidth;j++)
				{
					tempArr[j] = int(_mapdata.charAt(index));					
					index++;
				}
				mapData[i] = tempArr;
			}
			
			/*for(i=0;i<mapData.length;i++){
				for(j=0;j<mapData[0].length;j++){
					var txt:TextField = new TextField;
					txt.height = 18;
					txt.width = 50;
					txt.selectable = false;
					txt.text = mapData[i][j];
					var p:Point = Util.getPixelPoint(j,i);
					txt.x = p.x;
					txt.y = p.y;
					debug.addChild(txt);
				}
			}*/
			
			tile = new TilePath();
			tile.initData(mapData);
		}
		
		public function findPath(beginP:Point,endP:Point):Array{
			if(type == "nav"){
				return nav.findPath(beginP,endP);
			}else if(type == "tile"){
				beginP = Util.getTilePoint(beginP.x,beginP.y);
				endP = Util.getTilePoint(endP.x,endP.y);
				tile.DoSearch(beginP.x,beginP.y,endP.x,endP.y);
				return processTilePath(tile.aPath);
			}
			return null;
		}
		
		private function processTilePath(ary:Array):Array{
			var newAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				var p:Point = Util.getPixelPoint(ary[i][0],ary[i][1]);
				var f:Vector2f = new Vector2f(p.x,p.y);
				newAry.push(f);
			}
			newAry.reverse();
			return newAry;
		}
		
	}
}