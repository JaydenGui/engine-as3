package com.liu.role
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class RoleBitmap extends Bitmap implements IRender
	{
		private var _mainBitmap:BitmapData; 
		public function RoleBitmap()
		{
			
		}
		
		public function render():void{
			
		}

		public function set mainBitmap(value:BitmapData):void
		{
			_mainBitmap = value;
		}

	}
}