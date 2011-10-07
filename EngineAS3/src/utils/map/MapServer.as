package utils.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.ijelly.findPath.Cell;
	import org.ijelly.findPath.NavMesh;
	import org.ijelly.geom.Block;
	import org.ijelly.geom.Triangle;
	import org.ijelly.geom.Vector2f;
	import org.osmf.events.TimeEvent;
	
	import utils.debug.Console;
	import utils.event.LoadKeyEvent;
	import utils.event.MapdataEvent;
	import utils.event.RefreshBitmapEvent;
	import utils.event.ShowLoadingEvent;
	import utils.load.LoadInfo;
	import utils.load.LoadManager;
	
	
 /**
 * 派发图片加载好的事件，分为两种类型，部分加载图块，和小的马赛克图片
 * */
[Event(name="refreshbitmapevent", type="utils.event.RefreshBitmapEvent")]

 /**
 * 派发显示和隐藏loading事件
 * */
[Event(name="showloadingevent", type="utils.event.ShowLoadingEvent")]

 /**
 * 派发地图信息加载完成事件
 * */
[Event(name="mapdataevent", type="utils.event.MapdataEvent")]



	public class MapServer extends EventDispatcher
	{
		private var _baseUrl:String = 'file:///D:/My%20Documents/map/';
		/*file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap*/
		/*file:///D:/My%20Documents/map/CJ301/CJ301.mapedit*/
		private var _mapName:String = 'CJ301';

		private var _mapdataDIC:Object;
		
		private var _loadListDIC:Object;
		
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _picw:int
		private var _pich:int; 
		
		private var _loadNum:int;
		private var _allNum:int;
		private var _currentPoint:String;
		
		private var _mapdata:XML;
		
		
		public function MapServer()
		{
			
		}
		public function initMap(mapName:String):void{
			this._mapName = mapName;
			
			var loadList:Vector.<LoadInfo> = new Vector.<LoadInfo>;
			var mapdataUrl:String = _baseUrl + _mapName + "/" + _mapName + ".navtile";
			var loadInfo:LoadInfo = new LoadInfo(mapdataUrl,LoadInfo.XML,onLoadmapData,true);
			loadList.push(loadInfo);
			
			var miniMapUrl:String = _baseUrl + _mapName + "/minimap/" + _mapName + ".jpg";
			loadInfo = new LoadInfo(miniMapUrl,LoadInfo.BITMAP,onLoadMiniMap,true);
			loadList.push(loadInfo);
			
			var event:ShowLoadingEvent = new ShowLoadingEvent(ShowLoadingEvent.SHOWLOADINGEVENT);
			event.showable = true;
			this.dispatchEvent(event);
			
			LoadManager.getInstance().addListLoad(loadList,onMapLoaded);
			
			_mapdataDIC = new Object;
		}
		
		private function onLoadmapData(xml:XML):void{
			this._mapWidth = xml.@mapwidth;
			this._mapHeight = xml.@mapheight;
			this._pich = xml.@pich;
			this._picw = xml.@picw;
			_mapdata = xml;
		}
		
		private function onLoadMiniMap(bitmap:Bitmap):void{
			var event:RefreshBitmapEvent = new RefreshBitmapEvent(RefreshBitmapEvent.REFRESHBITMAPEVENT);
			event.bitmap = bitmap;
			event.bitmaptype = "all";
			this.dispatchEvent(event);
		}
		
		private function onMapLoaded(event:Event):void{
			var events:ShowLoadingEvent = new ShowLoadingEvent(ShowLoadingEvent.SHOWLOADINGEVENT);
			events.showable = false;
			this.dispatchEvent(events);
			initListDIC();
			
			var mapdataEvent:MapdataEvent = new MapdataEvent(MapdataEvent.MAPDATAEVENT);
			mapdataEvent.xml = _mapdata
			this.dispatchEvent(mapdataEvent);
		}
		private function initListDIC():void{
			if(_loadListDIC == null)
				_loadListDIC = new Object;
			var w:int = Math.ceil(_mapWidth/300);
			var h:int = Math.ceil(_mapHeight/300);
			_allNum = w*h;
			for(var i:int=0;i<w;i++){
				for(var j:int=0;j<h;j++){
					var key:String = i + "_" + j;
					_loadListDIC[key] = false;
				}
			}
			
		}
		
		private function onLoadAll():void{
			for(var i:int=0;i<10;i++){
				for(var j:int=0;j<6;j++){
					var key:String = i + "_" + j + ".jpg";
					var url:String = _baseUrl + _mapName + "/newimg/" + key;
					var loadInfo:LoadInfo = new LoadInfo(url,LoadInfo.BITMAP,refreshBitmap,false,new Point(i,j));
					LoadManager.getInstance().addSingleLoad(loadInfo);
				}
			}
		}
		public function onLoadkey(event:LoadKeyEvent):void{
			if(_loadNum >= _allNum){
				//Console.getInstance().show("加载全部完成");
				return;
			}
			
			/*var xpos:int = event.xpos;
			,ypos:Number
			,wNum:int
			,hNum:int*/
			
			var key:String;
			var beginX:int = event.xpos/300;
			var beginY:int = event.ypos/300;
			
			key = beginX + "_" + beginY;
			
			/*if(_currentPoint != key){
				Console.getInstance().show("加载");
				_currentPoint = key;
			}else{
				Console.getInstance().show("空闲");
				return;
			}*/
			
			for(var i:int=0;i<event.wNum;i++){
				for(var j:int=0;j<event.hNum;j++){
					key = (i+beginX) + "_" + (j+beginY);
					if(!_loadListDIC.hasOwnProperty(key) || _loadListDIC[key]){
						continue;
					}
					var url:String = _baseUrl + _mapName + "/newimg/" + key + ".jpg";
					_loadListDIC[key] = true;
					_loadNum++;
					if(_loadNum == 49){
						Console.getInstance().show("complete");
					}
					var loadInfo:LoadInfo = new LoadInfo(url,LoadInfo.BITMAP,refreshBitmap,false,new Point(i+beginX,j+beginY));
					LoadManager.getInstance().addSingleLoad(loadInfo);
				}
			}
			
		}
		
		private function refreshBitmap(bitmap:Bitmap,p:Point):void{
			var event:RefreshBitmapEvent = new RefreshBitmapEvent(RefreshBitmapEvent.REFRESHBITMAPEVENT);
			event.bitmap = bitmap;
			event.p = p;
			event.bitmaptype = "part";
			this.dispatchEvent(event);
			/*var bitmapdata:BitmapData = _mapContainer.mapBitmap.bitmapData;
			var newbitmapdata:BitmapData = bitmap.bitmapData;
			var rec:Rectangle = new Rectangle(0,0,300,300);
			var newp:Point = new Point(p.x * 300,p.y * 300);
			bitmapdata.copyPixels(newbitmapdata,rec,newp);*/
		}
		
	}
}