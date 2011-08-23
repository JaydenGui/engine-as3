package utils.role
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import utils.load.LoadInfo;
	import utils.load.LoadManager;
	import utils.pool.BitmapdataPool;
	import utils.pool.BitmapdataSource;
	
	public class RoleBitmap extends Bitmap
	{
		private var _dircet:int;
		private var _frame:int;
		private var _interval:int;
		private var _source:String;
		private var _startFrame:int;
		private var _endFrame:int = 4;
		private var _bitmapdataSource:BitmapdataSource;
		
		public var title:TextField;
		
		public function RoleBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_interval = 5*Math.random();
			//_frame = 8*Math.random();
		}
		public function render():void{
			_interval++;
			if(_interval == 5){
				_frame++;
				if(_frame == _endFrame){
					_frame = _startFrame;
				}
				this.bitmapData = _bitmapdataSource.getBitmapdata(_frame + "-" + _dircet);
				_interval = 0;
			}
		}

		/*public function get dircet():int
		{
			return _dircet;
		}

		public function set dircet(value:int):void
		{
			_dircet = value;
		}*/
		public function startMove(direct:int):void{
			_frame = this._startFrame = 4;
			this._endFrame = 8;
			this._dircet = direct;
		}
		public function stopMove():void{
			_frame = this._startFrame = 0;
			this._endFrame = 4;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
			this._bitmapdataSource = BitmapdataPool.getInstance().addToPool(value);
		}
		
	}
}