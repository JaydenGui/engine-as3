package utils.load
{
	public class LoadInfo
	{
		public static const XML:String = 'xml';
		public static const BITMAP:String = 'bitmap';
		public static const MOVIE:String = 'movie';
		
		public var url:String;
		public var type:String;
		public var fun:Function;
		public var showProgress:Boolean;
		public var info:Object;
		public function LoadInfo(url:String,type:String,fun:Function,showProgress:Boolean=false,info:Object=null)
		{
			this.url  = url;
			this.type = type;
			this.fun  = fun;
			this.showProgress = showProgress;
			this.info = info;
		}
		public function toString():String{
			return url + "," + type;
		}
	}
}