package utils.event
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class RefreshBitmapEvent extends Event
	{
		public static const REFRESHBITMAPEVENT:String = "refreshbitmapevent";
		public var bitmaptype:String;
		public var bitmap:Bitmap;
		public var p:Point;
		public function RefreshBitmapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}