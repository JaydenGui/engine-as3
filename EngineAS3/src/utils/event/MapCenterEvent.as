package utils.event
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MapCenterEvent extends Event
	{
		public static const MAPCENTEREVENT:String = "mapcenterevent";
		public var p:Point;
		public function MapCenterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}