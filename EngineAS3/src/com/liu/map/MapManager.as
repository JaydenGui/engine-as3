package com.liu.map
{
	import com.liu.load.LoadInfo;
	import com.liu.load.LoadManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;

	public class MapManager
	{
		private var _baseUrl:String = 'file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/';
		/*file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap*/
		/*file:///D:/My%20Documents/map/CJ301/CJ301.mapedit*/
		private var _mapName:String = 'CJ301';
		private var stage:Stage;
		private var _mapContainer:MapContainer;
		private var _mapdataDIC:Object;
		
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _picw:int
		private var _pich:int; 
		
		public function MapManager(stage:Stage,mapContainer:MapContainer)
		{
			this.stage = stage;
			this._mapContainer = mapContainer;
		}
		public function initMap(mapName:String):void{
			this._mapName = mapName;
			var loadList:Vector.<LoadInfo> = new Vector.<LoadInfo>;
			var mapdataUrl:String = _baseUrl + _mapName + "/" + _mapName + ".navmap";
			var loadInfo:LoadInfo = new LoadInfo(mapdataUrl,LoadInfo.XML,onLoadmapData,true);
			loadList.push(loadInfo);
			var miniMapUrl:String = _baseUrl + _mapName + "/minimap/" + _mapName + ".jpg";
			loadInfo = new LoadInfo(miniMapUrl,LoadInfo.BITMAP,onLoadMiniMap,true);
			loadList.push(loadInfo);
			
			stage.addChild(MapLoaderInterface.getInstance());
			LoadManager.getInstance().addListLoad(loadList,onMapLoaded);
			
			_mapdataDIC = new Object;
		}
		
		private function onLoadmapData(xml:XML):void{
			this._mapWidth = xml.@mapwidth;
			this._mapHeight = xml.@mapheight;
			this._pich = xml.@pich;
			this._picw = xml.@picw;
		}
		private function onLoadMiniMap(bitmap:Bitmap):void{
			var time:int = getTimer();
			var bigbitmapdata:BitmapData = new BitmapData(_mapWidth,_mapHeight);
			var ma:Matrix = new Matrix()
			ma.scale(_mapWidth/bitmap.width,_mapHeight/bitmap.height);
			bigbitmapdata.draw(bitmap,ma);
			var w:int = Math.ceil(_mapWidth/_picw);
			var h:int = Math.ceil(_mapHeight/_pich);
			var key:String;
			var bitmapdata:BitmapData;
			var rec:Rectangle = new Rectangle(0,0,_picw,_pich);
			var point:Point = new Point();
			for(var i:int=0;i<h;i++){
				for(var j:int=0;j<w;j++){
					key = i + "_" + j;
					bitmapdata = new BitmapData(_picw,_pich,false,0);
					rec.x = j*_picw;
					rec.y = i*_pich;
					bitmapdata.copyPixels(bigbitmapdata,rec,point);
					_mapdataDIC[key] = bitmapdata;
					var bitmaps:Bitmap = new Bitmap(bitmapdata);
					_mapContainer.addBitmap(bitmaps);
					bitmaps.x = rec.x;
					bitmaps.y = rec.y;
				}
			}
			trace(getTimer() - time,System.totalMemory);
			_mapContainer.mapdataDIC = _mapdataDIC;
		}
		
		private function onMapLoaded(event:Event):void{
			stage.removeChild(MapLoaderInterface.getInstance());
			_mapContainer.mapW = this._mapWidth;
			_mapContainer.mapH = this._mapHeight;
			_mapContainer.refrushMap(new Point(2000,500));
			_mapContainer.addEventListener(Event.ENTER_FRAME,enFrame);
		}
		private var num:int;
		private function enFrame(event:Event):void{
			num += 5;
			if(num>=1090){
				num = 340;
			}
			_mapContainer.refrushMap(new Point(num*_mapWidth/stage.stageWidth,_mapContainer.stage.mouseY*_mapHeight/stage.stageHeight));
		}
		
		
	}
}