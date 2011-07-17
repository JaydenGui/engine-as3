package com.liu.role
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RoleBitmap extends Bitmap
	{
		private var _mainBitmapdata:BitmapData;
		private var _rec:Rectangle;
		private var _p:Point;
		
		private var _dircet:int;
		private var _frame:int;
		private var _interval:int;
		public function RoleBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_rec = new Rectangle(0,0,120,120);
			_p = new Point();
			_interval = 5*Math.random();
			_frame = 8*Math.random();
		}

		public function set mainBitmapdata(value:BitmapData):void
		{
			_mainBitmapdata = value;
		}
		
		public function render():void{
			_interval++;
			if(_interval == 5){
				_frame++;
				if(_frame == 8){
					_frame = 0;
				}
				_rec.x = 120*_frame;
				this.bitmapData.copyPixels(_mainBitmapdata,_rec,_p);
				_interval = 0;
			}
		}

		public function get dircet():int
		{
			return _dircet;
		}

		public function set dircet(value:int):void
		{
			_dircet = value;
			_rec.y = _dircet*120;
		}


	}
}