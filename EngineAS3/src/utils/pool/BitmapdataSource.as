package utils.pool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import utils.load.LoadInfo;
	import utils.load.LoadManager;

	public class BitmapdataSource
	{
		private var _dic:Object;
		private var _count:int;
		private var _key:String;
		public function BitmapdataSource()
		{
			//_dic = new Object;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key(value:String):void
		{
			_key = value;
			var loadinfo:LoadInfo = new LoadInfo("file:///D:/role/" + value,LoadInfo.BITMAP,onBitmap);
			LoadManager.getInstance().addSingleLoad(loadinfo);
		}
		
		private function onBitmap(bitmap:Bitmap):void{
			_dic = new Object;
			var rec:Rectangle = new Rectangle(0,0,120,120);
			var p:Point = new Point;
			for(var i:int=0;i<8;i++){
				for(var j:int=0;j<12;j++){
					var smaBitmapdata:BitmapData = new BitmapData(120,120,true,0);
					rec.x = 120 * i;
					rec.y = 120 * j;
					smaBitmapdata.copyPixels(bitmap.bitmapData,rec,p);
					var key:String = i+"-"+j;
					_dic[key] = smaBitmapdata;
				}
			}
		}
		
		public function getBitmapdata(key:String):BitmapData{
			if(_dic){
				return _dic[key];
			}else{
				return BitmapdataPool.bitmapdata;
			}
		}

	}
}