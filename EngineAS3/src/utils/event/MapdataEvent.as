package utils.event
{
	import flash.events.Event;
	
	public class MapdataEvent extends Event
	{
		public static const MAPDATAEVENT:String = "mapdataevent";
		public var xml:XML;
		public function MapdataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}