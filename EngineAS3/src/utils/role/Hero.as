package utils.role
{
	import flash.utils.getTimer;
	
	import org.ijelly.geom.Vector2f;
	
	import utils.map.MapContainer;

	public class Hero extends Role
	{
		private var _map:MapContainer;
		private var _path:Array;
		private var _currentPoint:Vector2f;
		private var _targetPoint:Vector2f;
		private var _flag:int;
		private var _startTime:int;
		private var _startX:int;
		private var _startY:int;
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
			var time:int = getTimer();
			this.baseX = this._startX + (time-this._startTime)*this.vx;
			this.baseY = this._startY + (time-this._startTime)*this.vy;
			_map.refrushMap(this.baseX,this.baseY);
			if(Math.abs(this.baseX-this._targetPoint.x) < 3 && Math.abs(this.baseY-this._targetPoint.y) < 3){
				if(this._flag == _path.length-1){
					stopMove();
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
			this.vx = spX/sp/10;
			this.vy = spY/sp/10;
			
			this._startTime = getTimer();
			this._startX = this.baseX;
			this._startY = this.baseY;
			
			
			var cos:Number=spX/sp;
			var angle:int=int(Math.acos(cos)*180/Math.PI);
			
			if(spY<0)
				angle=360-angle;
			
			var baseA:int = 15;
			
			if(angle>349 || angle<11) //往右
				startMove(6);
			else if(angle>310) //右上
				startMove(5);
			else if(angle>275)
				startMove(10);
			else if(angle>265)
				startMove(4);
			else if(angle>231)//正上
				startMove(11);
			else if(angle>191) //左上
				startMove(3);
			else if(angle>168)//正左
				startMove(2);
			else if(angle>129)//左下
				startMove(1);
			else if(angle>95)//左下
				startMove(8);
			else if(angle>85) //正下
				startMove(0);
			else if(angle>50) //正下
				startMove(9);
			else              //右下
				startMove(7);
		}
		

	}
}