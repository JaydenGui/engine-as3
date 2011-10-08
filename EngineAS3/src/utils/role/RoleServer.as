package utils.role
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import utils.debug.Console;
	import utils.event.MapCenterEvent;
	import utils.pool.ConstPool;

/**
* 派发地图中心点事件
* */
[Event(name="mapcenterevent", type="utils.event.MapCenterEvent")]
	
	
	public class RoleServer extends EventDispatcher
	{
		public var hero:Hero;
		public var roleContainer:Sprite;
		private var allRoleList:Vector.<Role>;
		private var displayList:Vector.<Role>;
		
		private var baseW:int;
		private var baseH:int;
		
		private var mapW:int;
		private var mapH:int;
		
		private var flag:Boolean;
		
		private var keyAry:Array = ["FAngel.png","FAngel_2.png","FAngel_3.png",
			"FAngel_4.png","FHuman.png","FHuman_2.png","FHuman_3.png",
			"FHuman_4.png","FMerfolk.png","FMerfolk_2.png","FMerfolk_3.png",
			"FMerfolk_4.png","FTiaer.png","FTiaer_2.png","FTiaer_3.png","FTiaer_4.png"];
		
		public function RoleServer()
		{
			allRoleList = new Vector.<Role>;
			displayList = new Vector.<Role>;
		}
		public function setWH(w:int,h:int):void{
			this.baseW = w;
			this.baseH = h;
			if(hero){
				hero.recW = w;
				hero.recH = h;
			}
		}
		public function setMapWH(w:int,h:int):void{
			this.mapW = w;
			this.mapH = h;
			if(hero){
				hero.mapW = w;
				hero.mapH = h;
			}
		}
		public function addHero():void{
			
			hero = new Hero();
			hero.vx = 0;
			hero.vy = 0;
			
			hero.dircet = 8*Math.random();
			var obj:Object = new Object;
			obj.title = "血池地狱";
			obj.color = "#00ff00"; 
			obj.image = ConstPool.roleAry[int(16*Math.random())];
			hero.info = obj;
			
			hero.baseX = 400;
			hero.baseY = 400;
			
			hero.recW = baseW;
			hero.recH = baseH;
			hero.mapW = mapW;
			hero.mapH = mapH;
			
			hero.addTostage(roleContainer);
			hero.server = this;
			this.dispatchCenter(new Point(hero.baseX,hero.baseY));
			allRoleList.push(hero);
			addRoles();
			roleContainer.addEventListener(Event.ENTER_FRAME,render);
		}
		private function addRoles():void{
			
			var l:int = 3;
			var angle:Number = 2 * Math.PI
			for(var j:int=0;j<1500;j++){
				var role:OtherRole = new OtherRole;
				role.hero = hero;
				role.baseX = mapW*Math.random();
				role.baseY = mapH*Math.random();
				var s:Number = angle*Math.random(); 
				if(j%2){
					role.vx = l * Math.sin(s);
					role.vy = l * Math.cos(s);
				}else{
					role.vx = 0;
					role.vy = 0;
				}
				
				role.dircet = 8*Math.random();
				var obj:Object = new Object;
				obj.title = "神舟" + j + "号";
				obj.image = keyAry[int(16*Math.random())];
				role.info = obj;
				allRoleList.push(role);
				
			}
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,onTimerLogic);
			timer.start();
		}
		public function addRole(role:Role):void{
			
		}
		public function removeRole(role:Role):void{
			
		}
		private function changeDisplay():void{
			var tempV:Vector.<Role> = new Vector.<Role>;
			var role:Role;
			for(var i:int=0;i<allRoleList.length;i++){
				role = allRoleList[i];
				if(role.x > 0 && role.x < baseW && role.y > 0 && role.y < baseH){
					tempV.push(role);
				}
				
			}
			var tArr:Vector.<Role> = toSetArray(displayList,tempV),
				t2Arr:Vector.<Role> = toSetArray(tempV,displayList);
			for each(role in tArr)
			{
				role.removeFromStage();
			} 
			for each(role in t2Arr)
			{
				role.addTostage(roleContainer);
			}	
			displayList = tempV;
			//trace(roleContainer.numChildren);
			Console.getInstance().show(String(roleContainer.numChildren));
		}
		private function onTimerLogic(event:TimerEvent):void{
			if(flag){
				changeDisplay();
				flag = false;
			}else{
				sortLayer();
				flag = true;
			}
		}
		private function toSetArray (arr:Vector.<Role> ,arr1:Vector.<Role> ):Vector.<Role> 
		{
			var l:int = arr.length;
			var temp:Vector.<Role> =new Vector.<Role>;
			for(var i:int=0;i<l;i++)
			{
				if(arr1.indexOf(arr[i])==-1)
					temp[temp.length] = arr[i];  
			}
			return temp; 
		}
		private function sortLayer():void
		{
			displayList.sort(compare);
			var index:int = roleContainer.numChildren-1;
			for each(var r2:Role in displayList)
			{
				index = r2.SetChildIndex(index);	
			} 
		}
		private function compare(one:Role,two:Role):Number{
			return two.y - one.y;
		}
		private function render(event:Event):void{
			var role:Role;
			for each(role in displayList){ 
				role.render();
			}
			for each(role in allRoleList){
				role.go();
				if(role.baseX > mapW || role.baseX < 0 || role.baseY > mapH|| role.baseY < 0){
					role.baseX = mapW*Math.random();
					role.baseY = mapH*Math.random();
				}
			}
		}
		
		public function dispatchCenter(p:Point):void{
			var event:MapCenterEvent = new MapCenterEvent(MapCenterEvent.MAPCENTEREVENT);
			event.p = p;
			this.dispatchEvent(event);
		}
		
		public function setPath(path:Array):void{
			hero.path = path;
		}
	}
}