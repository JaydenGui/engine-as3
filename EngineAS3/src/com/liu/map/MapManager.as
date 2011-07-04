package com.liu.map
{
	public class MapManager
	{
		private var baseUrl:String = 'file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/';
		private var mapName:String = 'CJ301';
		public function MapManager()
		{
			
		}
		private function init():void{
			
		}
		public function load():void{
			var url:String = 'file:///C:/Documents%20and%20Settings/Administrator/My%20Documents/map/CJ301/CJ301.navmap';
			var urlloader:URLLoader = new URLLoader();
			var urlreq:URLRequest = new URLRequest(url);
			urlloader.addEventListener(Event.COMPLETE,onLoadmapData);
			urlloader.load(urlreq);
		}
		private function onLoadmapData(event:Event):void{
			var xml:XML = XML(event.target.data);
		}
	}
}