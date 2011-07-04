package com.liu.map
{
	import com.liu.load.LoadInfo;
	import com.liu.load.LoadManager;
	
	import flash.display.Bitmap;
	import flash.events.Event;

	public class MapManager
	{
		private var _baseUrl:String = 'file:///D:/My%20Documents/map/';
		/*file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap*/
		/*file:///D:/My%20Documents/map/CJ301/CJ301.mapedit*/
		private var _mapName:String = 'CJ301';
		public function MapManager()
		{
			
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
			
			LoadManager.getInstance().addListLoad(loadList,onMapLoaded);
		}
		
		private function onLoadmapData(xml:XML):void{
			trace(xml)
		}
		private function onLoadMiniMap(bitmap:Bitmap):void{
			trace(1);
		}
		
		private function onMapLoaded(event:Event):void{
			trace("wancheng");
		}
		
		
	}
}