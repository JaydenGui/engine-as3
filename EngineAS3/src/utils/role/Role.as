package utils.role
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import utils.TextToBitmapdata;

	public class Role
	{
		private var _txt:TextField;
		private var _info:Object;
		private var _x:int;
		private var _y:int;
		private var _baseX:Number;
		private var _baseY:Number;
		private var _alpha:Number;
		private var _rect:Rectangle;
		private var _rolebitmap:RoleBitmap;
		private var _txtbitmap:Bitmap;
		private var _parent:DisplayObjectContainer;
		
		public var vx:Number;
		public var vy:Number;
		public function Role()
		{
			_txt = new TextField;
			_txt.multiline = true;
			_txt.filters = [new GlowFilter(0,1,2,2,3)];
			_txt.mouseEnabled = false;
			_txt.width = 60;
			_txt.height = 15;
			
			_rolebitmap = new RoleBitmap();
			_txtbitmap = new Bitmap();
			_rect = new Rectangle(0,0,120,120);
		}
		
		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			_txtbitmap.x = _x - 30;
			_rolebitmap.x = _x - 60;	
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			_txtbitmap.y = _rolebitmap.y = _y-60;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function addTostage(container:DisplayObjectContainer):void{
			//container.addChild(_txt);
			container.addChild(_rolebitmap);
			container.addChild(_txtbitmap);
			this._parent = container;
		}
		
		public function removeFromStage():void{
			if(_parent){
				//_parent.removeChild(_txt);
				_parent.removeChild(_txtbitmap);
				_parent.removeChild(_rolebitmap);
				_parent = null;
			}
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}

		public function set rect(value:Rectangle):void
		{
			_rect = value;
		}
		
		public function hitTest(rect:Rectangle):Boolean
		{
			return this.rect.intersects(rect);
		}
		
		public function get childIndex():int
		{
			return _parent.getChildIndex(_rolebitmap);
		}
		
		public function SetChildIndex(index:int):int
		{
			_parent.setChildIndex(_txtbitmap,index--);
			index = index<0?0:index;
			_parent.setChildIndex(_rolebitmap,index);
			return --index;
		}

		public function get info():Object
		{
			return _info;
		}

		public function set info(value:Object):void
		{
			_info = value;
			//_txt.htmlText = "<font color='#ffffff'>" + value.title + "</font>"
			//_txt.cacheAsBitmap = true;
			_txtbitmap.bitmapData = TextToBitmapdata.getBitmapdata(value.title);
			_rolebitmap.source = value.image;
			
		}
		public function render():void{
			_rolebitmap.render();
		}
		public function set dircet(value:int):void
		{
			_rolebitmap.dircet = value;
		}
		public function move():void{
			
		}
		public function go():void{
			this.baseX += vx;
			this.baseX += vy;
		}

		public function get baseX():Number
		{
			return _baseX;
		}

		public function set baseX(value:Number):void
		{
			_baseX = value;
		}

		public function get baseY():Number
		{
			return _baseY;
		}

		public function set baseY(value:Number):void
		{
			_baseY = value;
		}
		

	}
}