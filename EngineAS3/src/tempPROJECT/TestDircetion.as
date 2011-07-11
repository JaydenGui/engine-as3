package tempPROJECT
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TestDircetion extends Sprite
	{
		[Embed(source='FF.png')]
		private var cls:Class;
		private var bitmapdata:BitmapData = new BitmapData(480,960,true,0);
		private var roleBitmpadata:BitmapData = new BitmapData(120,120,true,0);
		private var roleBitmpa:Bitmap = new Bitmap(roleBitmpadata);
		private var rec:Rectangle = new Rectangle(0,0,120,120);
		private var p:Point = new Point();
		private var beginP:Point = new Point();
		private var endP:Point = new Point();
		private var gSprite:Sprite = new Sprite;
		
		private var stepX:Number;
		private var stepY:Number;
		private var v:Number = 2;
		private var vx:Number;
		private var vy:Number;
		
		public function TestDircetion()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(event:Event=null):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var bitmap:Bitmap = new cls();
			//this.addChild(bitmap);
			var matrix:Matrix = new Matrix();
			matrix.tx = -480;
			bitmapdata.draw(bitmap,matrix);
			bitmap.bitmapData = bitmapdata;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.addChild(roleBitmpa);
			this.addChild(gSprite);
			stage.addEventListener(MouseEvent.CLICK,onMouseClick);
			gSprite.addEventListener(Event.ENTER_FRAME,run);
		}
		private var dic:int;
		private function onMouseClick(event:MouseEvent):void{
			this.beginP.x = this.endP.x;
			this.beginP.y = this.endP.y;
			/*this.beginP.x = 500;
			this.beginP.y = 300;*/
			
			this.endP.x = this.mouseX;
			this.endP.y = this.mouseY;
			
			var lx:int = this.endP.x - this.beginP.x;
			var ly:int = this.endP.y - this.beginP.y;
			
			var l:int = Math.sqrt(lx*lx+ly*ly);
			
			var angle:Number = Math.atan(ly/lx)*180/Math.PI;
			
			trace(angle);
			
			if(lx > 0 && ly < 0){//第一象限
				if(angle > -10 ){
					dic = 6;
				}else if(angle < -80){
					dic = 4;
				}else{
					dic = 5;
				}
			}else if(lx < 0 && ly <0){//第二象限
				if(angle > 80 ){
					dic = 8;
				}else if(angle < 10){
					dic = 2;
				}else{
					dic = 3;
				}
			}else if(lx < 0 && ly >0){//第三象限
				if(angle > -10 ){
					dic = 2;
				}else if(angle < -80){
					dic = 0;
				}else{
					dic = 1;
				}
			}else if(lx > 0 && ly >0){//第四象限
				if(angle > 80 ){
					dic = 0;
				}else if(angle < 10){
					dic = 6;
				}else{
					dic = 7;
				}
			}
			
			this.vx = v*lx/l;
			this.vy = v*ly/l;
			
			roleBitmpa.x = this.beginP.x-60;
			roleBitmpa.y = this.beginP.y-60;
			
			draw();
		}
		private function run(event:Event):void{
			roleBitmpa.x += this.vx;
			roleBitmpa.y += this.vy;
		}
		private function draw():void{
			gSprite.graphics.clear();
			gSprite.graphics.lineStyle(2,0xff0000);
			gSprite.graphics.moveTo(this.beginP.x,this.beginP.y);
			gSprite.graphics.lineTo(this.endP.x,this.endP.y);
			
		}
		
		private var i:int;
		private function onEnterFrame(event:Event):void{
			i++;
			if(i!=5){
				return;
			}else{
				i=0;
			}
			roleBitmpadata.copyPixels(bitmapdata,rec,p);
			rec.y = 120*dic;
			if(rec.x == 360){
				rec.x = 0;
			}else{
				rec.x += 120;
			}
		}
	}
}