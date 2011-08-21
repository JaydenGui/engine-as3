package utils.pool
{
	import flash.display.BitmapData;

	public class BitmapdataPool
	{
		private var _bitmapdataDic:Object;
		private static var _instance:BitmapdataPool;
		public static var bitmapdata:BitmapData = new BitmapData(120,120,true,0);
		
		public function BitmapdataPool()
		{
			_bitmapdataDic = new Object;
		}
		public static function getInstance():BitmapdataPool{
			if(_instance == null){
				_instance = new BitmapdataPool;
			}
			return _instance;
		}
		public function addToPool(key:String):BitmapdataSource{
			if(!_bitmapdataDic.hasOwnProperty(key)){
				var bitmapsource:BitmapdataSource = new BitmapdataSource
				_bitmapdataDic[key] = bitmapsource;
				bitmapsource.key = key;
			}
			return _bitmapdataDic[key];
			
		}
		public function getFromPool(key:String):BitmapData{
			return _bitmapdataDic[key];
		}
	}
}