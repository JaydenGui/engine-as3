package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import utils.GameServer;
	import utils.debug.Console;
	import utils.map.MapContainer;
	import utils.map.IResizeDisplayObject;
	import utils.map.MapLoaderInterface;
	import utils.map.MapManager;
	import utils.map.PathServer;
	import utils.pool.ConstPool;
	import utils.role.Hero;
	
	public class EngineAS3 extends Sprite
	{
		private var mapServer:MapManager;
		private var mapContainer:MapContainer;
		private var debugContainer:Sprite;
		private var hero:Hero;
		
		private var gameServer:GameServer 
		
		public function EngineAS3()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(event:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onStageResize);
			gameServer = new GameServer(stage);
			gameServer.start();
			gameServer.gotoScence("CJ201");
			
			stage.addChild(Console.getInstance());
			//initMap();
		}
		private function initMap():void{
			mapContainer = new MapContainer;
			this.addChild(mapContainer);
			debugContainer = new Sprite;
			this.addChild(debugContainer);
			debugContainer.mouseEnabled = false;
			debugContainer.mouseChildren = false;
			mapContainer.debug = debugContainer;
			
			mapServer = new MapManager(stage,mapContainer);
			mapServer.initMap("CJ301");
			this.addChild(Console.getInstance());
			mapServer.addEventListener(Event.INIT,onMapInit);
			
		}
		private function onMapInit(event:Event):void{
			
			hero = new Hero();
			hero.vx = 3;
			hero.vy = 3;
			
			hero.dircet = 8*Math.random();
			var obj:Object = new Object;
			obj.title = "血池地狱";
			obj.image = ConstPool.roleAry[int(16*Math.random())];
			hero.info = obj;
			
			hero.baseX = 439;
			hero.baseY = 440;
			mapContainer.hero = hero;
			mapContainer.refrushMap(hero.baseX,hero.baseY);
			
			
			hero.addTostage(this);
			this.addEventListener(Event.ENTER_FRAME,render);
		}
		private function onStageResize(event:Event):void{
			for(var i:int;i<stage.numChildren;i++){
				var obj:Object = stage.getChildAt(i);
				if(obj is IResizeDisplayObject){
					obj.resize(); 
				}
			}
			gameServer.resize();
		}
		private function render(event:Event):void{
			hero.render();
			hero.go();
		}
	}
}