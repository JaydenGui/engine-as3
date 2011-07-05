package com.liu.map
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class MapLoaderInterface extends Sprite implements IResizeDisplayObject
	{
		private static var _instance:MapLoaderInterface;
		private var loadInfoTxt:TextField;
		private var loadCount:int;
		private var count:int;
		private var currentCount:int;
		public function MapLoaderInterface()
		{
			if(_instance!=null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");  
			MapLoaderInterface._instance = this;  
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public static function getInstance():MapLoaderInterface{
			if(!_instance)
				_instance = new MapLoaderInterface();
			return _instance;
		}
		
		private function init(event:Event=null):void{
			loadInfoTxt = new TextField();
			loadInfoTxt.width = 200;
			loadInfoTxt.height = 50;
			loadInfoTxt.text = "正在加载.....";
			loadInfoTxt.autoSize = TextFieldAutoSize.CENTER;
			loadInfoTxt.x = (stage.stageWidth-loadInfoTxt.width)*0.5;
			loadInfoTxt.y = (stage.stageHeight-loadInfoTxt.height)*0.5;
			this.addChild(loadInfoTxt);
			loadInfoTxt.type = TextFieldType.INPUT;
		}
		
		public function setProgress(n:Number):void{
			loadInfoTxt.text = "加载" + int(n * 100) + "%";
		}
		
		private function onClick(event:Event):void{
			if(stage.displayState != "fullScreen"){
				stage.displayState = "fullScreen";
			}
		}
		public function resize():void{
			loadInfoTxt.x = (stage.stageWidth-loadInfoTxt.width)*0.5;
			loadInfoTxt.y = (stage.stageHeight-loadInfoTxt.height)*0.5;
		}
	}
}