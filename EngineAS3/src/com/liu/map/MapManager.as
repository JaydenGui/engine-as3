package com.liu.map
{
	public class MapManager
	{
		private var _baseUrl:String = 'file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap';
		private var _mapName:String = 'CJ301';
		public function MapManager()
		{
			
		}
		public function initMap(mapName:String):void{
			this._mapName = mapName;
			
		}
		
		private function onLoadmapData(event:Event):void{
			var xml:XML = XML(event.target.data);
		}
	}
}