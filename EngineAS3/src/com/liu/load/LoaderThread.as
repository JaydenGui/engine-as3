package com.liu.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class LoaderThread extends EventDispatcher
	{
		
		private var _urlloader:URLLoader;
		private var _loader:Loader;
		private var _request:URLRequest;
		private var _loaderInfo:LoadInfo;
		private var _ioerrorTime:int;
		
		public var running:Boolean;
		
		/**
		 * 加载基本线程
		 * */
		public function LoaderThread()
		{
			init();
		}
		private function init():void{
			_urlloader = new URLLoader;
			_urlloader.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_urlloader.addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		/**
		 * 开始加载
		 * */
		public function load(loadInfo:LoadInfo):void{
			this._loaderInfo = loadInfo;
			_request = new URLRequest(loadInfo.url);
			if(loadInfo.type != LoadInfo.XML){
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			}else{
				_urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			_urlloader.load(_request);
		}
		private function onLoadComplete(event:Event):void{
			if(event.target.data is String){
				_loaderInfo.fun(XML(event.target.data));
				running = false;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else if(event.target.data is ByteArray){
				if(_loader == null){
					_loader = new Loader;
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDataComplete);
				}
				_loader.loadBytes(event.target.data);
			}
		}
		private function onLoadDataComplete(event:Event):void{
			_loaderInfo.fun(event.target.content);
			running = false;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onIOError(event:IOErrorEvent):void{
			if(_ioerrorTime == 2){
				load(_loaderInfo);
			}else{
				trace("加载错误" + _loaderInfo);
				running = false;
			}
			_ioerrorTime++;
		}
		private function onProgress(event:ProgressEvent):void{
			if(_loaderInfo.showProgress){
				
			}
		}
		
		
	}
}