package com.liu.debug
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class Console extends Sprite
	{
		private var txt:TextField;
		private static var _instance:Console;
		public function Console()
		{
			if(_instance!=null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");  
			Console._instance = this;  
			init();
		}
		public static function getInstance():Console{
			if(!_instance)
				_instance = new Console();
			return _instance;
		}
		private function init():void{
			txt = new TextField;
			txt.width = 200;
			txt.height = 80;
			this.addChild(txt);
			txt.filters = [new GlowFilter(0xffffff,1,2,2,255,1)];
		}
		public function show(str:String):void{
			txt.text = str;
		}
	}
}