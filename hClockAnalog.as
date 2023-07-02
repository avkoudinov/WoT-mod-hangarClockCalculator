package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import Delegate;

	public class hClockAnalog extends MovieClip {

		public function hClockAnalog(param1:String = "") {

			super();
			var _WoT_:String = param1;
			addFrameScript(0,Delegate.create(frame1,_WoT_));

		}

		/////

		//
		private var hAlign:String = "";
		private var hOffset:Number = 0;

		//
		private var now:Date;

		//
		private var h:uint;
		private var m:uint;
		private var s:uint;
		private var ms:uint;

		/////

		// Init clock
		private function initClockAnalog(param1:String = ""):void {

			var _WoT_:String = param1;

			this.visible = false;

			initConfig(_WoT_);
			startClockAnalog(_WoT_);

		}

		// Load configuration file
		private function initConfig(param1:String = ""):void {

			var _WoT_:String = param1;
			_WoT_ = _WoT_.replace(/\\/g, "/");

			var configLoader:URLLoader = new URLLoader();

			configLoader.load(new URLRequest("file:///"+escape(_WoT_+"mods/configs/AntonVK/configHangarClockAnalog.xml")));
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, configDefault);
			configLoader.addEventListener(Event.COMPLETE, configLoad);

		}

		// Update clock (check if the configuration has changed)
		private function startClockAnalog(param1:String = ""):void {

			var _WoT_:String = param1;

			var clockAnalogTimer:Timer = new Timer(125, 0);
			clockAnalogTimer.addEventListener(TimerEvent.TIMER, Delegate.create(updateClockAnalog,_WoT_));
			clockAnalogTimer.start();

		}

		///// Configuration

		private function configDefault(event:IOErrorEvent):void {

			/////
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE,this.configDefault);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE,this.configDefault);

			//
			this.visible = true;

			// Clock: position by default
			this.x = (stage.stageWidth - this.width * 0.5) - 384;
			this.y = 2;

		}

		private function configLoad(event:Event):void {

			/////
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE,this.configDefault);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE,this.configDefault);

			//
			var configData:XML = new XML(event.target.data);

			hAlign = configData.@align;
			switch(hAlign) {
				case "center":
					hOffset = (stage.stageWidth-this.width) * 0.5 + this.width * 0.5;
				break;
				case "left":
					hOffset = this.width * 0.5;
				break;
				case "right":
					hOffset = stage.stageWidth - this.width * 0.5;
				break;
				default:
					hOffset = (stage.stageWidth-this.width) * 0.5 + this.width * 0.5;
				break;
			}

			//
			this.visible = true;

			// Clock visibility and position
			this.x = hOffset + Number(configData.ConfigClockAnalog.position.@x);
			this.y = configData.ConfigClockAnalog.position.@y;

		}

		/////

		protected function updateClockAnalog(event:Event,param1:String = ""):void {

			var _WoT_:String = param1;

			initConfig(_WoT_);

			now = new Date();
			s = now.getSeconds();
			ms = now.getMilliseconds();
			m = now.getMinutes();
			h = now.getHours();

			hand_s.rotation = (s*6)+(ms*0.005);
			hand_m.rotation = (m*6)+(s*0.1);
			hand_h.rotation = (h*30)+(m*0.5);

		}

		/////

		function frame1(param1:String = "") : * {

			//
			var _WoT_:String = param1;
			initClockAnalog(_WoT_);
			stop();

		}

	}

}
