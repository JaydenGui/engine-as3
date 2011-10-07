package utils.event
{
	import flash.events.Event;
	
	public class ShowLoadingEvent extends Event
	{
		public static const SHOWLOADINGEVENT:String = "showloadingevent";
		public var showable:Boolean;
		public function ShowLoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}