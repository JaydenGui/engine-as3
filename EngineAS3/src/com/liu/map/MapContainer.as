package com.liu.map
{
	import com.liu.element.StaticSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class MapContainer extends Sprite implements IResizeDisplayObject
	{
		private var _mapSprite:Sprite;
		
		private var _mapBitmap:Bitmap;
		
		private var _mainBitmapdata:BitmapData;
		
		private var _recW:int;
		private var _recH:int;
		private var _mapW:int;
		private var _mapH:int;
		private var _wNum:int;
		private var _hNum:int;
		
		public var mapManager:MapManager;
		
		public function MapContainer()
		{
			init();
		}
		private function init():void{
			_mapSprite = new Sprite;
			this.addChild(_mapSprite);
			
			this.addEventListener(Event.ADDED_TO_STAGE,refreshStaticSpriteAry);
		}
		private function refreshStaticSpriteAry(event:Event = null):void{
			this._recW = stage.stageWidth;
			this._recH = stage.stageHeight;
			_wNum = Math.ceil(_recW/300) + 1;
			_hNum = Math.ceil(_recH/300) + 1;
		}
		
		public function refrushMap(center:Point):void{
			var tempx:int =  this._recW/2 - center.x;
			var tempy:int =  this._recH/2 - center.y;
			if(tempx > 0){
				tempx = 0;
			}else if(tempx < this._recW - _mapW){
				tempx = this._recW - _mapW;
			}
			
			if(tempy > 0){
				tempy = 0;
			}else if(tempy < this._recH - _mapH){
				tempy = this._recH - _mapH;
			}
			
			this._mapBitmap.x = tempx;
			this._mapBitmap.y = tempy;
			mapManager.onLoadkey(-tempx,-tempy,this._wNum,this._hNum);
		}
		
		public function resize():void
		{
			refreshStaticSpriteAry();
		}

		public function setMapWH(w:int,h:int):void{
			_mapW = w;
			_mapH = h
		}

		public function set mapBitmap(value:Bitmap):void
		{
			_mapBitmap = value;
			this._mainBitmapdata = _mapBitmap.bitmapData;
			this.addChildAt(_mapBitmap,0);
		}

		public function get mapBitmap():Bitmap
		{
			return _mapBitmap;
		}


	}
}