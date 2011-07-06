package com.liu.map
{
	import com.liu.element.StaticSprite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MapContainer extends Sprite implements IResizeDisplayObject
	{
		private var _mapSprite:Sprite;
		private var _staticSpriteAry:Vector.<StaticSprite>;
		private var _mapdataDIC:Object
		
		private var _recW:int;
		private var _recH:int;
		
		public function MapContainer()
		{
			init();
		}
		private function init():void{
			_mapSprite = new Sprite;
			this.addChild(_mapSprite);
			
			_staticSpriteAry = new Vector.<StaticSprite>;
			
			/*var tile:StaticSprite;
			for(var i:int=0;i<30;i++)
			{
				tile = new StaticSprite();			
				//_mapSprite.addChild(tile);
				_staticSpriteAry[_staticSpriteAry.length]=tile;
			}*/
			this.addEventListener(Event.ADDED_TO_STAGE,refreshStaticSpriteAry);
		}
		
		private function refreshStaticSpriteAry(event:Event = null):void{
			this._recW = stage.stageWidth;
			this._recH = stage.stageHeight;
			
			var w:int = Math.ceil(_recW/300) + 1;
			var h:int = Math.ceil(_recH/300) + 1;
			var all:int = w*h - _staticSpriteAry.length;
			if(all <= 0){
				return;
			}
			
			var tile:StaticSprite;
			for(var i:int;i<all;i++){
				tile = new StaticSprite();	
				_staticSpriteAry[_staticSpriteAry.length]=tile;
			}
			
		}
		
		public function refrushMap(center:Point):void{
			var tempx:int =  this._recW/2 - center.x;
			var tempy:int =  this._recH/2 - center.y;
			if(tempx > 0){
				tempx = 0;
			}else if(tempx < this._recH ){
				
			}
		}
		
		public function resize():void
		{
			refreshStaticSpriteAry();
		}

		public function get mapdataDIC():Object
		{
			return _mapdataDIC;
		}

		public function set mapdataDIC(value:Object):void
		{
			_mapdataDIC = value;
		}

	}
}