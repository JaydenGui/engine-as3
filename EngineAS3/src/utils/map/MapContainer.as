package utils.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.ijelly.findPath.Cell;
	import org.ijelly.findPath.NavMesh;
	import org.ijelly.geom.Block;
	
	import utils.element.StaticSprite;
	import utils.role.Hero;
	
	public class MapContainer extends Sprite implements IResizeDisplayObject
	{
		private var _RoleContainer:Sprite;
		
		private var _mapBitmap:Bitmap;
		
		private var _mainBitmapdata:BitmapData;
		
		private var _recW:int;
		private var _recH:int;
		private var _mapW:int;
		private var _mapH:int;
		private var _wNum:int;
		private var _hNum:int;
		
		private var _beginPoint:Point;
		
		public var mapManager:MapManager;
		
		//public var nav:NavMesh;
		
		public var debug:Sprite;
		
		public var hero:Hero;
		
		public function MapContainer()
		{
			init();
		}
		private function init():void{
			_RoleContainer = new Sprite;
			this.addChild(_RoleContainer);
			
			this.addEventListener(Event.ADDED_TO_STAGE,refreshStaticSpriteAry);
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function refreshStaticSpriteAry(event:Event = null):void{
			this._recW = stage.stageWidth;
			this._recH = stage.stageHeight;
			_wNum = Math.ceil(_recW/300) + 1;
			_hNum = Math.ceil(_recH/300) + 1;
			//this.left = this._recW/2;
			//this.right = 
		}
		
		public function refrushMap(centerX:int,centerY:int):void{
			var tempx:int =  this._recW/2 - centerX;
			var tempy:int =  this._recH/2 - centerY;
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
			
			this._mapBitmap.x =  debug.x = tempx;
			this._mapBitmap.y = debug.y = tempy;
			/*this._mapBitmap.x = tempx;
			this._mapBitmap.y = tempy;*/
			mapManager.onLoadkey(-tempx,-tempy,this._wNum,this._hNum);
		}
		
		public function resize():void
		{
			refreshStaticSpriteAry();
		}

		private function onClick(event:MouseEvent):void{
			_beginPoint = new Point(hero.baseX,hero.baseY);
			
			var endPoint:Point = new Point(event.localX - this._mapBitmap.x, event.localY - this._mapBitmap.y);
			
			var outPath:Array =  mapManager.pathServer.findPath(_beginPoint, endPoint);
			debug.graphics.clear();
			debug.graphics.lineStyle(1,0x00ff00);
			for(var i:int;i<outPath.length;i++){
				debug.graphics.drawCircle(outPath[i].x,outPath[i].y,3);
			}
			hero.path = outPath;
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

		public function get recW():int
		{
			return _recW;
		}

		public function get recH():int
		{
			return _recH;
		}

		public function get mapW():int
		{
			return _mapW;
		}

		public function get mapH():int
		{
			return _mapH;
		}

		public function set beginPoint(value:Point):void
		{
			_beginPoint = value;
		}


	}
}