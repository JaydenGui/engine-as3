package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import view.RoleBitmap;
	
	
	public class TestRole extends Sprite
	{
		private var loader:Loader;
		//private var roleList:Vector.<RoleBitmap>;
		private var allList:Vector.<Vector.<RoleBitmap>>;
		private var allRoleList:Vector.<RoleBitmap>;
		private var defaultBimtap:Array = new Array;
		
		private var mainRec:Rectangle;
		public function TestRole()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addTostage);
		}
		private function addTostage(event:Event):void{
			mainRec = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			loadRole();
		}
		private function loadRole():void{
			loader = new Loader;
			var urlreq:URLRequest = new URLRequest("assets/FAngel_2.png");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.load(urlreq);
		}
		private function loadAll():void{
			for(var i:int;i<200;i++){
				loadDefault();
			}
		}
		private function loadDefault():void{
			var dLoader:Loader = new Loader();
			var urlreq:URLRequest = new URLRequest("assets/default.png");
			dLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onDcom);
			dLoader.load(urlreq);
		}
		private var loadNum:int;
		private function onDcom(event:Event):void{
			var bitmap:Bitmap = event.target.content;
			defaultBimtap.push(bitmap.bitmapData);
			loadNum++;
			if(loadNum==200){
				loadRole();
			}
		}
		private function onComplete(event:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			allList = new Vector.<Vector.<RoleBitmap>>;
			allRoleList = new Vector.<RoleBitmap>;
			
			var bitmap:Bitmap = event.target.content;
			addRole(bitmap);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private function addRole(bitmap:Bitmap):void{
			for(var i:int=0;i<5;i++){
				var roleList:Vector.<RoleBitmap> = new Vector.<RoleBitmap>;
				allList.push(roleList);
				for(var j:int=0;j<100;j++){
					//var role:RoleBitmap = new RoleBitmap(defaultBimtap.pop());
					var role:RoleBitmap = new RoleBitmap(new BitmapData(120,120));
					role.mainBitmapdata = bitmap.bitmapData;
					this.addChild(role);
					role.x = 2600*Math.random();
					role.y = 1400*Math.random();
					role.dircet = 8*Math.random()
					roleList.push(role);
					allRoleList.push(role);
				}
				
			}
		}
		private var flag:int;
		private var _roleList:Vector.<RoleBitmap> 
		private function onEnterFrame(event:Event):void{
			_roleList = allList[flag];
			for each(var role:RoleBitmap in _roleList){
				role.render();
			}
			flag++;
			if(flag == 5){
				flag = 0;
			}
			
			for each(role in allRoleList){
				role.x ++;
				role.y ++;
				if(role.x > 2500){
					role.x = 0;
				}
				if(role.y > 1300){
					role.y = 0;
				}
			}
		}
	}
}