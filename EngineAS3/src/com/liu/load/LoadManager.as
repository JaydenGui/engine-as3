package com.liu.load
{
	import flash.events.Event;

	public class LoadManager
	{
		private static var _instance:LoadManager;
		private var _listLoader:ListLoader;
		private var _stackLoader:StackLoader;
		
		public function LoadManager()
		{
			if(_instance!=null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");  
			LoadManager._instance = this;  
			init();
		}
		public static function getInstance():LoadManager{
			if(!_instance)
				_instance = new LoadManager();
			return _instance;
		}
		
		private function init():void{
			_listLoader = new ListLoader;
			_stackLoader = new StackLoader;
		}
		
		public function addSingleLoad(loaderInfo:LoadInfo):void{
			_stackLoader.addLoad(loaderInfo);
		}
		
		public function addListLoad(list:Vector.<LoadInfo>,fun:Function):void{
			_listLoader.load(list);
			_listLoader.addEventListener(Event.COMPLETE,fun);
		}
		
	}
}