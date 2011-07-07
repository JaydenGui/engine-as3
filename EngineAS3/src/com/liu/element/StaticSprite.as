package com.liu.element
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class StaticSprite extends Bitmap
	{
		public var bmd:BitmapData;
		public var url:String;
		public var index:Point=new Point(-1,-1);
		public var state:int;

		public function StaticSprite(bmd:BitmapData=null)
		{
			super(bmd);
		}
		public function refrush(image:BitmapData):void
		{
			super.bitmapData = image;
		}
		public function Despose():void
		{
			this.bitmapData.dispose();
		}

	}
}