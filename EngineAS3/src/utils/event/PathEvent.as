package utils.event
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PathEvent extends Event
	{
		public static const PATHEVENT:String = "pathevent";
		public var beginP:Point;
		public var endP:Point;
		public function PathEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}