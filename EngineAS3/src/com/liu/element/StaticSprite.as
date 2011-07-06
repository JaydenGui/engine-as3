package com.liu.element
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class StaticSprite extends Bitmap
	{
		private var _x:int;
		private var _y:int;
		public var bmd:BitmapData;
		public var url:String;
		public var index:Point=new Point(-1,-1);

		public function StaticSprite(bmd:BitmapData=null)
		{
			super(bmd);
		}
        /*public function refrushPic(resVo:ResVO):void
		{
			if(url==resVo.params)
			{
            	var image:BitmapData = BitmapData(resVo.graphicObj);
		    	 super.bitmapData = image;
			 }

		}*/
		public function _refrush(image:BitmapData):void
		{
			super.bitmapData = image;
		}
		public function Despose():void
		{
			this.bitmapData.dispose();
		}

	}
}