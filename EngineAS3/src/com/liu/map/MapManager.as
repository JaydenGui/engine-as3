package com.liu.map
{
	import com.liu.load.LoadInfo;
	import com.liu.load.LoadManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class MapManager
	{
		private var _baseUrl:String = 'file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/';
		/*file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap*/
		/*file:///D:/My%20Documents/map/CJ301/CJ301.mapedit*/
		private var _mapName:String = 'CJ301';
		private var stage:Stage;
		private var _mapContainer:MapContainer;
		
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
			var miniMapUrl:String = _baseUrl + _mapName + "/" + _mapName + ".jpg";
			loadInfo = new LoadInfo(miniMapUrl,LoadInfo.BITMAP,onLoadMiniMap,true);
			loadList.push(loadInfo);
			
			stage.addChild(MapLoaderInterface.getInstance());
			LoadManager.getInstance().addListLoad(loadList,onMapLoaded);
		}
		
		private function onLoadmapData(xml:XML):void{
			this._mapWidth = xml.@mapwidth;
			this._mapHeight = xml.@mapheight;
			this._pich = xml.@pich;
			this._picw = xml.@_mapHeight;
		}
		private function onLoadMiniMap(bitmap:Bitmap):void{
			_mapContainer.addChild(bitmap);
			bitmap.width = _mapWidth;
			bitmap.height = 1800;
		}
		
		private function onMapLoaded(event:Event):void{
			stage.removeChild(MapLoaderInterface.getInstance());
		}
		
		
	}
}