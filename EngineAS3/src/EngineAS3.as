package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	
	import utils.debug.Console;
	import utils.map.IResizeDisplayObject;
	import utils.map.MapContainer;
	import utils.map.MapLoaderInterface;
	import utils.map.MapManager;
	import utils.pool.ConstPool;
	import utils.role.Hero;
	
	public class EngineAS3 extends Sprite
	{
		private var mapManager:MapManager;
		private var mapContainer:MapContainer;
		private var hero:Hero;
		public function EngineAS3()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(event:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onStageResize);
			initMap();
		}
		private function initMap():void{
			mapContainer = new MapContainer;
			this.addChild(mapContainer);
			mapManager = new MapManager(stage,mapContainer);
			mapManager.initMap("CJ301");
			this.addChild(Console.getInstance());
			mapManager.addEventListener(Event.INIT,onMapInit);
			//mapContainer.refrushMap(new Point(100,100));
		}
		private function onMapInit(event:Event):void{
			mapContainer.refrushMap(new Point(500,500));
			hero = new Hero;
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			
			hero.dircet = 8*Math.random();
			var obj:Object = new Object;
			obj.title = "牛的一逼";
			obj.image = ConstPool.roleAry[int(16*Math.random())];
			hero.info = obj;
			
			hero.addTostage(this);
			this.addEventListener(Event.ENTER_FRAME,render);
		}
		private function onStageResize(event:Event):void{
			for(var i:int;i<this.numChildren;i++){
				var obj:Object = this.getChildAt(i);
				if(obj is IResizeDisplayObject){
					obj.resize(); 
				}
			}
		}
		private function render(event:Event):void{
			hero.render();
		}
	}
}