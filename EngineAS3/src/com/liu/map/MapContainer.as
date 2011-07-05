package com.liu.map
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class MapContainer extends Sprite implements IResizeDisplayObject
	{
		private var _miniMapBitmap:Bitmap;
		private var _mapSprite:Sprite;
		public function MapContainer()
		{
			init();
		}
		private function init():void{
			_mapSprite = new Sprite;
			this.addChild(_mapSprite);
		}
		
		public function addMiniMap(bitmap:Bitmap):void{
			_miniMapBitmap = bitmap;
			showMiniMap();
		}
		public function hideMiniMap():void{
			_mapSprite.removeChild(_miniMapBitmap);
		}
		public function showMiniMap():void{
			_mapSprite.addChildAt(_miniMapBitmap,0);
		}
		public function resize():void
		{
			
		}
	}
}