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
	import utils.event.LoadKeyEvent;
	import utils.event.MapCenterEvent;
	import utils.event.RefreshBitmapEvent;
	import utils.role.Hero;

/**
* 派发加载地图事件
* */
[Event(name="loadkeyevent", type="utils.event.LoadKeyEvent")]

	
	public class GameContainer extends Sprite implements IResizeDisplayObject
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
		
		public var debug:Sprite;
		
		public function GameContainer()
		{
			init();
		}
		private function init():void{
			_RoleContainer = new Sprite;
			this.addChild(_RoleContainer);
			
			//this.addEventListener(Event.ADDED_TO_STAGE,refreshStaticSpriteAry);
		}
		private function refreshStaticSpriteAry(event:Event = null):void{
			this._recW = stage.stageWidth;
			this._recH = stage.stageHeight;
			_wNum = Math.ceil(_recW/300) + 1;
			_hNum = Math.ceil(_recH/300) + 1;
		}
		
		public function refrushMap(mapevent:MapCenterEvent):void{
			var tempx:int =  this._recW/2 - mapevent.p.x;
			var tempy:int =  this._recH/2 - mapevent.p.y;
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
			
			var event:LoadKeyEvent = new LoadKeyEvent(LoadKeyEvent.LOADKEYEVENT);
			event.xpos = -tempx;
			event.ypos = -tempy;
			event.wNum = _wNum;
			event.hNum = _hNum;
			this.dispatchEvent(event);
			//mapManager.onLoadkey(-tempx,-tempy,this._wNum,this._hNum);
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
		
		public function refreshBitmap(event:RefreshBitmapEvent):void{
			if(event.bitmaptype == "part"){
				var newbitmapdata:BitmapData = event.bitmap.bitmapData;
				var rec:Rectangle = new Rectangle(0,0,300,300);
				var newp:Point = new Point(event.p.x * 300,event.p.y * 300);
				_mainBitmapdata.copyPixels(newbitmapdata,rec,newp);
			}else if(event.bitmaptype == "all"){
				this.mapBitmap = event.bitmap;
			}
			
		}

		public function get RoleContainer():Sprite
		{
			return _RoleContainer;
		}


	}
}