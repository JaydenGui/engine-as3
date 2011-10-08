package utils
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import utils.event.LoadKeyEvent;
	import utils.event.MapCenterEvent;
	import utils.event.MapdataEvent;
	import utils.event.PathEvent;
	import utils.event.RefreshBitmapEvent;
	import utils.event.ShowLoadingEvent;
	import utils.map.GameContainer;
	import utils.map.MapContainer;
	import utils.map.MapLoaderInterface;
	import utils.map.MapManager;
	import utils.map.MapServer;
	import utils.map.PathServer;
	import utils.role.RoleServer;

	public class GameServer
	{
		private var stage:Stage;
		
		private var mapServer:MapServer;
		private var pathServer:PathServer;
		private var gameContainer:GameContainer;
		private var roleServer:RoleServer;
		private var loaderInterface:MapLoaderInterface;
		
		public function GameServer(stage:Stage)
		{
			this.stage = stage;
		}
		
		public function start():void{
			gameContainer = new GameContainer();
			stage.addChild(gameContainer);
			
			mapServer = new MapServer;
			pathServer = new PathServer;
			loaderInterface = new MapLoaderInterface;
			roleServer = new RoleServer;
			roleServer.roleContainer = gameContainer.RoleContainer;
			
			gameContainer.addEventListener(LoadKeyEvent.LOADKEYEVENT,mapServer.onLoadkey);
			gameContainer.addEventListener(PathEvent.PATHEVENT,onFindPath);
			mapServer.addEventListener(RefreshBitmapEvent.REFRESHBITMAPEVENT,gameContainer.refreshBitmap);
			mapServer.addEventListener(ShowLoadingEvent.SHOWLOADINGEVENT,showLoading);
			mapServer.addEventListener(MapdataEvent.MAPDATAEVENT,maploadComplete);
			roleServer.addEventListener(MapCenterEvent.MAPCENTEREVENT,gameContainer.refrushMap);
			
		}
		
		public function gotoScence(str:String):void{
			mapServer.initMap(str);
		}
		
		public function showLoading(event:ShowLoadingEvent):void{
			if(event.showable){
				stage.addChild(loaderInterface);
			}else{
				if(loaderInterface.parent){
					loaderInterface.parent.removeChild(loaderInterface);
				}
			}
		}
		
		public function maploadComplete(event:MapdataEvent):void{
			gameContainer.setMapWH(int(event.xml.@mapwidth),int(event.xml.@mapheight));
			roleServer.setMapWH(int(event.xml.@mapwidth),int(event.xml.@mapheight));
			
			pathServer.initMapdata(event.xml);
			
			roleServer.addHero();
		}
		
		public function resize():void{
			roleServer.setWH(stage.stageWidth,stage.stageHeight);
		}
		public function onFindPath(event:PathEvent):void{
			var path:Array = pathServer.findPath(event.beginP,event.endP);
			gameContainer.drawPath(path);
			roleServer.setPath(path);
		}
	}
}