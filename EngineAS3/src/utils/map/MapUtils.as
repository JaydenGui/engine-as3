package utils.map
{
	public class MapUtils
	{
		public function MapUtils()
		{
		}
		private function initMapData(trgData:String,blockData:String):void{
			var cell:Cell;
			var ary:Array = trgData.split('|');
			var str:String;
			var pAry:Array
			for(var i:int=0;i<ary.length;i++){
				str = ary[i];
				pAry = str.split(',');
				cell = new Cell(new Vector2f(pAry[0],pAry[1]),new Vector2f(pAry[2],pAry[3]),new Vector2f(pAry[4],pAry[5]));
				cell.index = i;
				for(var j:int=6;j<pAry.length;j++){
					cell.bolckAry = new Vector.<int>;
					cell.bolckAry.push(pAry[j]);
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
			_mapContainer.setNav(_cellV,_blockV);
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
	}
}