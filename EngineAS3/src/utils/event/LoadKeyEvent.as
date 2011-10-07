package utils.event
{
	import flash.events.Event;
	
	public class LoadKeyEvent extends Event
	{
		public static const LOADKEYEVENT:String = "loadkeyevent";
		
		public var xpos:int;
		public var ypos:int;
		public var wNum:int;
		public var hNum:int;
		public function LoadKeyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}