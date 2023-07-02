package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import net.wg.gui.components.controls.SoundButtonEx;
	import Delegate;

	public class hCalculatorButton extends SoundButtonEx {

		public function hCalculatorButton(param1:String = "") {

			super();
			var _WoT_:String = param1;
			addFrameScript(0,Delegate.create(frame1,_WoT_));

		}

		/////

		private var hAlign:String = "";
		private var hOffset:Number = 0;

		/////

		// Init calculator button
		private function initCalculatorButton(param1:String = ""):void {

			var _WoT_:String = param1;

			this.visible = false;

			initConfig(_WoT_);
			startCalculatorButton(_WoT_);

		}

		// Load configuration file
		private function initConfig(param1:String = ""):void {

			var _WoT_:String = param1;
			_WoT_ = _WoT_.replace(/\\/g, "/");

			var configLoader:URLLoader = new URLLoader();

			configLoader.load(new URLRequest("file:///"+escape(_WoT_+"mods/configs/AntonVK/configHangarCalculator.xml")));
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, configDefault);
			configLoader.addEventListener(Event.COMPLETE, configLoad);

		}

		// Update calculator button (check if the configuration has changed)
		private function startCalculatorButton(param1:String = ""):void {

			var _WoT_:String = param1;

			var calculatorButtonTimer:Timer = new Timer(1000, 0);
			calculatorButtonTimer.addEventListener(TimerEvent.TIMER, Delegate.create(updateCalculatorButton,_WoT_));
			calculatorButtonTimer.start();

			this.alpha = 0.5;

			this.addEventListener(MouseEvent.MOUSE_OVER, mOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mUp);

			function mOver(event:MouseEvent):void {
				event.target.alpha = 1.0;
			}

			function mOut(event:MouseEvent):void {
				event.target.alpha = 0.5;
			}

			function mDown(event:MouseEvent):void {
				event.target.alpha = 0.5;
			}

			function mUp(event:MouseEvent):void {
				event.target.alpha = 1.0;
			}

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

			// Calculator button: position by default
			this.x = (stage.stageWidth - this.width * 0.5) - 7;
			this.y = 55;

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

			// Calculator button visibility and position
			this.x = hOffset + Number(configData.ConfigCalculator.position.@x);
			this.y = configData.ConfigCalculator.position.@y;

		}

		/////

		protected function updateCalculatorButton(event:Event,param1:String = ""):void {

			var _WoT_:String = param1;

			initConfig(_WoT_);

		}

		/////

		function frame1(param1:String = "") : * {

			//
			var _WoT_:String = param1;
			initCalculatorButton(_WoT_);
			stop();

		}

	}

}
