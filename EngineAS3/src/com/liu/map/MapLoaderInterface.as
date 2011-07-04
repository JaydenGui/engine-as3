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
		private var loadInfoTxt:TextField;
		private var loadCount:int;
		public function MapLoaderInterface()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init);
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