package com.liu.debug
{
	import flash.display.Sprite;
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
		}
		public function show(str:String):void{
			txt.text = str;
		}
	}
}