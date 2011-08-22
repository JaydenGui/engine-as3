package utils.role
{
	import utils.map.MapContainer;

	public class Hero extends Role
	{
		private var _map:MapContainer;
		private var _path:Array;
		public function Hero(map:MapContainer)
		{
			this._map = map;	
		}
		
		override public function set baseX(value:int):void{
			super.baseX = value;
			if(value < _map.recW/2){
				this.x = value;
			}else if(value > _map.mapW - _map.recW/2){
				this.x = value - _map.mapW + _map.recW;
			}else{
				this.x = _map.recW/2;
			}
		}
		override public function set baseY(value:int):void{
			super.baseY = value;
			if(value < _map.recH/2){
				this.y = value;
			}else if(value > _map.mapH - _map.recH/2){
				this.y = value - _map.mapH + _map.recH;
			}else{
				this.y = _map.recH/2;
			}
		}
		override public function go():void{
			this.baseX += this.vx;
			this.baseY += this.vy;
			_map.refrushMap(this.baseX,this.baseY);
		}

		public function set path(value:Array):void
		{
			_path = value;
			
			
		}

	}
}