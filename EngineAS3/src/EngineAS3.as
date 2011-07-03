package
{
	import com.liu.map.IResizeDisplayObject;
	import com.liu.map.MapLoaderInterface;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class EngineAS3 extends Sprite
	{
		public function EngineAS3()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(event:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onStageResize);
			addTxt();
		}
		private function addTxt():void{
			this.addChild(new MapLoaderInterface);
		}
		private function onStageResize(event:Event):void{
			for(var i:int;i<this.numChildren;i++){
				var obj:Object = this.getChildAt(i);
				if(obj is IResizeDisplayObject){
					obj.resize(); 
				}
			}
		}
	}
}