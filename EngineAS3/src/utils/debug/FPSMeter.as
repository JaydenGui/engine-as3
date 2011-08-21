/**
 * FPSMeter.as
 * Keith Peters
 * version 0.9.9
 * 
 * An simple component showing the frames per second the current movie is running at.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
 package utils.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	public class FPSMeter extends Sprite
	{
		protected var _label:TextField;
		protected var _startTime:int;
		protected var _frames:int;
		protected var _prefix:String = "";
		protected var _fps:int = 0;
		private var _txt:TextField;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param prefix A string to put in front of the number value shown. Default is "FPS:".
		 */
		
		public function FPSMeter()
		{
			_prefix = prefix;
			_frames = 0;
			_startTime = getTimer();
			//if(stage != null)
			//{
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//}
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_label = new TextField
			_label.width = 80;
			_label.height = 20;
			_label.filters = [new GlowFilter(0,1,2,2,3)];
			_label.textColor = 0xff0000;
			
			_txt = new TextField
			_txt.width = 80;
			_txt.height = 20;
			_txt.filters = [new GlowFilter(0,1,2,2,3)];
			_txt.textColor = 0xffff00;
			_txt.x = 100;
			
			this.addChild(_label);
			this.addChild(_txt);
		}
		
		
		
		public function draw():void
		{
			_label.text = _prefix + _fps.toString() + "/" + int(System.totalMemory/1024/1024);
		}
		
		/**
		 * Internal enterFrame handler to measure fps and update label.
		 */
		protected function onEnterFrame(event:Event):void
		{
			// Increment frame count each frame. When more than a second has passed, 
			// display number of accumulated frames and reset.
			// Thus FPS will only be calculated and displayed once per second.
			// There are more responsive methods that calculate FPS on every frame. 
			// This method is uses less CPU and avoids the "jitter" of those other methods.
			_frames++;
			var time:int = getTimer();
			var elapsed:int = time - _startTime;
			if(elapsed >= 1000)
			{
				_fps = Math.round(_frames * 1000 / elapsed);
				_frames = 0;
				_startTime = time;
				draw();
			}
		}
		
		/**
		 * Stops the meter if it is removed from stage.
		 */
		protected function onRemovedFromStage(event:Event):void
		{
			stop();
		}
		
		/**
		 * Stops the meter by removing the enterFrame listener.
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Starts the meter again if it has been stopped.
		 */
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Sets or gets the prefix shown before the number. Defaults to "FPS:".
		 */
		public function set prefix(value:String):void
		{
			_prefix = value;
		}
		public function get prefix():String
		{
			return _prefix;
		}
		
		/**
		 * Returns the current calculated FPS.
		 */
		public function get fps():int
		{
			return _fps;
		}
		
		public function setConsole(str:String):void{
			_txt.text = str;
		}
	}
}