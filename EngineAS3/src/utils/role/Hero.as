package utils.role
{
	import org.ijelly.geom.Vector2f;
	
	import utils.map.MapContainer;

	public class Hero extends Role
	{
		private var _map:MapContainer;
		private var _path:Array;
		private var _currentPoint:Vector2f;
		private var _targetPoint:Vector2f;
		private var _flag:int;
		public var walk:Boolean;
		public function Hero(map:MapContainer)
		{
			this._map = map;	
		}
		
		override public function set baseX(value:Number):void{
			super.baseX = value;
			if(value < _map.recW/2){
				this.x = value;
			}else if(value > _map.mapW - _map.recW/2){
				this.x = value - _map.mapW + _map.recW;
			}else{
				this.x = _map.recW/2;
			}
		}
		override public function set baseY(value:Number):void{
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
			if(!walk){
				return;
			}
			this.baseX += this.vx;
			this.baseY += this.vy;
			_map.refrushMap(this.baseX,this.baseY);
			//trace(this.baseX,this.baseY);
			//return;
			if(Math.abs(this.baseX-this._targetPoint.x) < 3 && Math.abs(this.baseY-this._targetPoint.y) < 3){
				if(this._flag == _path.length-1){
					walk = false;
				}else{
					_flag++;
					this._currentPoint = this._targetPoint;
					this._targetPoint = _path[_flag];
					setXY();
				}
			}
		}

		public function set path(value:Array):void
		{
			if(value == null){
				return;
			}
			_path = value;
			walk = true;
			this._currentPoint = value[0];
			this._targetPoint = value[1];
			_flag = 1;
			setXY();
		}
		private function setXY():void{
			var spY:int = _targetPoint.y-_currentPoint.y;
			var spX:int = _targetPoint.x-_currentPoint.x;
			var sp:int = Math.sqrt(spX*spX + spY*spY);
			this.vx = 3*spX/sp;
			this.vy = 3*spY/sp;
			//trace(this.vx,this.vy,this._targetPoint.x,this._targetPoint.y)
		}

	}
}