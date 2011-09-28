package utils.map
{
	import flash.geom.Point;
	
	import org.ijelly.TilePath;
	import org.ijelly.findPath.Cell;
	import org.ijelly.findPath.NavMesh;
	import org.ijelly.geom.Block;
	import org.ijelly.geom.Circle;
	import org.ijelly.geom.Vector2f;

	public class PathServer
	{
		private var nav:NavMesh;
		private var tile:TilePath;
		public function PathServer()
		{
			
		}
		public function initMapdata(xml:XML):void{
			var type:String = xml.@type;
			if(type == "nav"){
				//nav = new NavMesh();
			}else if(type == "tile"){
				
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
			var _crossBlockV:Vector.<Circle> = new Vector.<Circle>;
			
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
							cellary = String(pAry[j]).split(",");
							cell.blockAry = new Vector.<int>;
							for(var h:int=0;h<cellary.length;h++){
								cell.blockAry.push(cellary[h]);
							}
							
						}else if(blockStr.charAt(0) == "!"){
							blockStr = blockStr.substr(1,blockStr.length-1);
							cellary = String(pAry[j]).split(",");
							
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
				pAry = str.split(',');
				var circle:Circle = new Circle(pAry[0],pAry[1],pAry[2]);
				_crossBlockV.push(circle);
			}
			
			nav = new NavMesh(_cellV);
			nav.blockV = _blockV;
			nav.crossBlockV = _crossBlockV;
			//_mapContainer.setNav(_cellV,_blockV);
			nav.findPath(new Point,new Point);
			
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
		private function processTile():void{
			
		}
	}
}