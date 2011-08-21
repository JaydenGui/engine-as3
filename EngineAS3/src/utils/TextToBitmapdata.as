package utils
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;

	public class TextToBitmapdata
	{
		public function TextToBitmapdata()
		{
		}
		private static var _txt:TextField = new TextField;
		public static function getBitmapdata(str:String):BitmapData{
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.filters = [new GlowFilter(0,1,2,2,3)];
			_txt.width = 120;
			_txt.htmlText = "<font color='#ffffff'>" + str + "</font>"
				
			var bitmapdata:BitmapData = new BitmapData(60,17,true,0);
			bitmapdata.draw(_txt);
			return bitmapdata;
			
		}
	}
}