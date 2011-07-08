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
		private var _staticSpriteDIC:Object
		private var _mapdataDIC:Object
		
		private var _mapBitmap:Bitmap;
		
		private var _mainBitmapdata:BitmapData;
		private var _renderBitmap:Bitmap;
		private var _rec:Rectangle;
		private var _p:Point;
		
		private var _recW:int;
		private var _recH:int;
		private var _mapW:int;
		private var _mapH:int;
		private var _wNum:int;
		private var _hNum:int;
		
		public function MapContainer()
		{
			init();
		}
		private function init():void{
			_mapSprite = new Sprite;
			this.addChild(_mapSprite);
			
			_staticSpriteDIC = new Object;
			
			this.addEventListener(Event.ADDED_TO_STAGE,refreshStaticSpriteAry);
		}
		
		private function refreshStaticSpriteAry(event:Event = null):void{
			this._recW = stage.stageWidth;
			this._recH = stage.stageHeight;
			
			_wNum = Math.ceil(_recW/300) + 1;
			_hNum = Math.ceil(_recH/300) + 1;
			
			if(event == null)
				return;
			
			/*var bitmapdata:BitmapData = new BitmapData(_recW,_recH,false);
			_renderBitmap = new Bitmap(bitmapdata);
			this.addChild(_renderBitmap);*/
			
			_rec = new Rectangle(0,0,_recW,_recH);
			_p = new Point();
			
			var all:int = _wNum*_hNum;
			
			var tile:StaticSprite;
			for(var i:int;i<all;i++){
				tile = new StaticSprite();	
				_staticSpriteDIC[String(i)] = tile;
				_mapSprite.addChild(tile);
			}
			
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
			
			/*this._mapSprite.x = tempx;
			this._mapSprite.y = tempy;*/
			
			this._mapBitmap.x = tempx;
			this._mapBitmap.y = tempy;
			
			//getRenderList(-tempx,-tempy);
			//renderBitmap(-tempx,-tempy);
		}
		private function loadRound():void{
			
		}
		public function addBitmap(bitmap:Bitmap):void{
			this._mapSprite.addChild(bitmap);
		}
		public function renderBitmap(disX:int,disY:int):void{
			_rec.x = disX;
			_rec.y = disY;
			var bitmapdata:BitmapData = _renderBitmap.bitmapData;
			//bitmapdata.copyPixels(mainBitmapdata,_rec,_p);
		}
		public function getRenderList(disX:int,disY:int):void{
			var beginX:int = disX/300;
			var beginY:int = disY/300;
			
			var keyAry:Vector.<String> = new Vector.<String>;
			var time:int = getTimer();
			var key:String;
			for(var i:int=0;i<this._wNum;i++){
				for(var j:int=0;j<this._hNum;j++){
					key = (j+beginY) + "_" + (i+beginX);
					if(!_staticSpriteDIC.hasOwnProperty(key)){
						keyAry.push(key);
					}else{
						_staticSpriteDIC[key].state = time;
					}
				}
			}
			if(keyAry.length == 0){
				return;
			}
			
			for (key in _staticSpriteDIC){
				var obj:StaticSprite = _staticSpriteDIC[key];
				if(obj.state != time){
					var newkey:String = keyAry.pop();
					if(newkey == null)
						break;
					_staticSpriteDIC[newkey] = obj;
					delete _staticSpriteDIC[key];
					obj.refrush(_mapdataDIC[newkey]);
					var xy:Array = newkey.split('_');
					obj.x = xy[1]*300;
					obj.y = xy[0]*300;
				}
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

		public function get mapW():int
		{
			return _mapW;
		}

		public function set mapW(value:int):void
		{
			_mapW = value;
		}

		public function get mapH():int
		{
			return _mapH;
		}

		public function set mapH(value:int):void
		{
			_mapH = value;
		}

		public function set mapBitmap(value:Bitmap):void
		{
			_mapBitmap = value;
			this._mainBitmapdata = _mapBitmap.bitmapData;
			this.addBitmap(_mapBitmap);
		}

		public function get mapBitmap():Bitmap
		{
			return _mapBitmap;
		}


	}
}