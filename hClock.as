package  {

	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import Delegate;

	public class hClock extends MovieClip {

		public function hClock(param1:String = "") {

			super();
			var _WoT_:String = param1;
			addFrameScript(0,Delegate.create(frame1,_WoT_));

		}

		/////

		//
		private var hAlign:String = "";
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;

		private var hOffsetBg:Number = 0;
		private var hOffsetClock:Number = 0;
		private var hOffsetDate:Number = 0;
		private var hOffsetDay:Number = 0;

		//
		private var AMPM:Boolean = false;
		private var blink:Boolean = false;
		private var dd:Boolean = true;

		//
		private var bgDateClock:MovieClip;

		//
		private var Colors:String  = "0x000000, 0x000000";
		private var Alphas:String = "1, 0";
		private var Ratios:String = "0, 255";
		private var Gradient:String = "RADIAL";
		private var gType:String = GradientType.RADIAL;
		private var gColors:Array = [Colors];
		private var gAlphas:Array = [Alphas];
		private var gRatios:Array = [Ratios];
		private var gSpreadMethod:String = SpreadMethod.PAD;
		private var gInterp:String = InterpolationMethod.LINEAR_RGB;
		private var gFocalPtRatio:Number = 0;

		private var gBoxWidth:Number = 0;
		private var gBoxHeight:Number = 0;
		private var gBoxRotation:Number = 0;
		private var gTx:Number = 0;
		private var gTy:Number = 0;

		private var gRectX:Number = 0;
		private var gRectY:Number = 0;
		private var gRectWidth:Number = 0;
		private var gRectHeight:Number = 0;

		//
		private var filterClock:String = "";
		private var filterDay:String = "";
		private var filterDate:String = "";

		//
		private var now:Date;

		//
		private var theClockHrs:String = "";
		private var theClockMin:String = "";
		private var theClockSec:String = "";
		private var theClockSep1:String = "";
		private var theClockSep2:String = "";
		private var theClockAMPM:String = "";
		private var theDay:String = "";
		private var theDate:String = "";
		private var hours:uint = 23;
		private var minutes:uint = 59;
		private var seconds:uint = 59;
		private var milliseconds:uint = 999;
		private var days:Array = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
		private var months:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		private var dom:String = "";
		private var hrs:String = "";
		private var mins:String = "";
		private var secs:String = "";

		//
		public var clockHrs:TextField;
		public var clockMin:TextField;
		public var clockSec:TextField;
		public var clockSep1:TextField;
		public var clockSep2:TextField;
		public var clockAMPM:TextField;
		public var day:TextField;
		public var date:TextField;

		/////

		// Init clock
		private function initClock(param1:String = ""):void {

			var _WoT_:String = param1;

			this.visible = false;

			initConfig(_WoT_);
			startClock(_WoT_);

		}

		// Load configuration file
		private function initConfig(param1:String = ""):void {

			var _WoT_:String = param1;
			_WoT_ = _WoT_.replace(/\\/g, "/");

			var configLoader:URLLoader = new URLLoader();

			configLoader.load(new URLRequest("file:///"+escape(_WoT_+"mods/configs/AntonVK/configHangarClock.xml")));
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, configDefault);
			configLoader.addEventListener(Event.COMPLETE, configLoad);

		}

		// Update clock
		private function startClock(param1:String = ""):void {

			var _WoT_:String = param1;

			var clockTimer:Timer = new Timer(500, 0);
			clockTimer.addEventListener(TimerEvent.TIMER, Delegate.create(updateClock,_WoT_));
			clockTimer.start();

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

			//
			var gMatrix:Matrix = new Matrix();
			
			var clockTextFormat:TextFormat = new TextFormat();
			var clockTextFilterGlow:GlowFilter = new GlowFilter();
			var clockTextFilterShadow:DropShadowFilter = new DropShadowFilter();
			
			var dayTextFormat:TextFormat = new TextFormat();
			var dayTextFilterGlow:GlowFilter = new GlowFilter();
			var dayTextFilterShadow:DropShadowFilter = new DropShadowFilter();
			
			var dateTextFormat:TextFormat = new TextFormat();
			var dateTextFilterGlow:GlowFilter = new GlowFilter();
			var dateTextFilterShadow:DropShadowFilter = new DropShadowFilter();

			// Background for date, clock, day: visibility, position, transparency by default
			bgDateClock.visible = true;
			bgDateClock.alpha = 0.7;
			bgDateClock.x = (stage.stageWidth - bgDateClock.width) * 0.5;
			bgDateClock.y = 34;

			// Background: Gradient rectangle
			gType = GradientType.RADIAL;
			Colors = "0xFF0000, 0x000000";
			Alphas = "1, 0";
			Ratios = "0, 255";
			gColors = Colors.split(",");
			gAlphas = Alphas.split(",");
			gRatios = Ratios.split(",");
			gFocalPtRatio= 0;

			gBoxWidth = 768;
			gBoxHeight = 72;
			gBoxRotation = 0;
			gTx = 10;
			gTy = -20;

			gMatrix.createGradientBox(gBoxWidth, gBoxHeight, gBoxRotation, gTx, gTy);

			bgDateClock.graphics.clear();

			bgDateClock.graphics.beginGradientFill(gType,
										gColors,
										gAlphas,
										gRatios,
										gMatrix,
										gSpreadMethod,
										gInterp,
										gFocalPtRatio);

			gRectX = 10;
			gRectY = 10;
			gRectWidth = 768;
			gRectHeight = 16;

			bgDateClock.graphics.drawRect(gRectX, gRectY, gRectWidth, gRectHeight);

			bgDateClock.graphics.endFill();

			/////

			// 12/24-hour clock and blink
			AMPM = false;
			blink = false;

			// Clock: text format by default
			clockTextFormat.align = "center";
			clockTextFormat.bold = false;
			clockTextFormat.color = 0xFFFFCC;
			clockTextFormat.font = "Micra";
			clockTextFormat.kerning = false;
			clockTextFormat.size = 12;

			// Clock: visibility and position by default
			clockHrs.visible = true;
			clockHrs.width = clockHrs.textWidth + 4;
			if(clockHrs.width < 36) {
				clockHrs.width = 36;
			}
			clockHrs.height = clockHrs.textHeight;
			clockHrs.x = (stage.stageWidth - (clockHrs.width + clockSep1.width + clockMin.width + clockSep2.width + clockSec.width + clockAMPM.width)) * 0.5;
			clockHrs.y = 44;
			clockHrs.defaultTextFormat = clockTextFormat;
			clockHrs.embedFonts = true;

			clockSep1.visible = true;
			clockSep1.width = clockSep1.textWidth + 2;
			if(clockSep1.width < 10) {
				clockSep1.width = 10;
			}
			clockSep1.height = clockSep1.textHeight;
			clockSep1.x = clockHrs.x + clockHrs.width;
			clockSep1.y = clockHrs.y;
			clockSep1.defaultTextFormat = clockTextFormat;
			clockSep1.embedFonts = true;

			clockMin.visible = true;
			clockMin.width = clockMin.textWidth + 4;
			if(clockMin.width < 36) {
				clockMin.width = 36;
			}
			clockMin.height = clockMin.textHeight;
			clockMin.x = clockSep1.x + clockSep1.width;
			clockMin.y = clockHrs.y;
			clockMin.defaultTextFormat = clockTextFormat;
			clockMin.embedFonts = true;

			clockSep2.visible = true;
			clockSep2.width = clockSep2.textWidth + 2;
			if(clockSep2.width < 10) {
				clockSep2.width = 10;
			}
			clockSep2.height = clockSep2.textHeight;
			clockSep2.x = clockMin.x + clockMin.width;
			clockSep2.y = clockHrs.y;
			clockSep2.defaultTextFormat = clockTextFormat;
			clockSep2.embedFonts = true;

			clockSec.visible = true;
			clockSec.width = clockSec.textWidth + 4;
			if(clockSec.width < 36) {
				clockSec.width = 36;
			}
			clockSec.height = clockSec.textHeight;
			clockSec.x = clockSep2.x + clockSep2.width;
			clockSec.y = clockHrs.y;
			clockSec.defaultTextFormat = clockTextFormat;
			clockSec.embedFonts = true;

			clockAMPM.visible = false;
			clockAMPM.width = 0;

			// Clock: text filter effects by default
			clockTextFilterShadow.angle = 45;
			clockTextFilterShadow.blurX = 2;
			clockTextFilterShadow.blurY = 2;
			clockTextFilterShadow.color = 0x000000;
			clockTextFilterShadow.distance = 2;
			clockTextFilterShadow.strength = 1;

			clockHrs.filters = [clockTextFilterShadow];
			clockMin.filters = [clockTextFilterShadow];
			clockSec.filters = [clockTextFilterShadow];
			clockSep1.filters = [clockTextFilterShadow];
			clockSep2.filters = [clockTextFilterShadow];

			theClockHrs = "{HH}";
			theClockMin = "{mm}";
			theClockSec = "{ss}";
			theClockSep1 = ":";
			theClockSep2 = ":";
			theClockAMPM = ""

			//
			date.visible = false;
			day.visible = false;

			/////

		}

		private function configLoad(event:Event):void {

			/////
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE,this.configLoad);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE,this.configLoad);

			//
			var configData:XML = new XML(event.target.data);

			hAlign = configData.@align;
			offsetX = configData.@offsetX;
			offsetY = configData.@offsetY;
			switch(hAlign) {
				case "center":
					hOffsetBg = offsetX + ((stage.stageWidth - bgDateClock.width) * 0.5);
					hOffsetClock = offsetX + ((stage.stageWidth - (clockHrs.width + clockSep1.width + clockMin.width + clockSep2.width + clockSec.width + clockAMPM.width)) * 0.5);
					hOffsetDate = offsetX + ((stage.stageWidth - date.width) * 0.5);
					hOffsetDay = offsetX + ((stage.stageWidth - day.width) * 0.5);
				break;
				case "left":
					hOffsetBg = offsetX + 0;
					hOffsetClock = offsetX + 0;
					hOffsetDate = offsetX + 0;
					hOffsetDay = offsetX + 0;
				break;
				case "right":
					hOffsetBg = offsetX + (stage.stageWidth - bgDateClock.width);
					hOffsetClock = offsetX + (stage.stageWidth - (clockHrs.width + clockSep1.width + clockMin.width + clockSep2.width + clockSec.width + clockAMPM.width));
					hOffsetDate = offsetX + (stage.stageWidth - date.width);
					hOffsetDay = offsetX + (stage.stageWidth - day.width);
				break;
				default:
					hOffsetBg = offsetX + ((stage.stageWidth - bgDateClock.width) * 0.5);
					hOffsetClock = offsetX + ((stage.stageWidth - (clockHrs.width + clockSep1.width + clockMin.width + clockSep2.width + clockSec.width + clockAMPM.width)) * 0.5);
					hOffsetDate = offsetX + ((stage.stageWidth - date.width) * 0.5);
					hOffsetDay = offsetX + ((stage.stageWidth - day.width) * 0.5);
				break;
			}

			//
			this.visible = true;

			//
			var gMatrix:Matrix = new Matrix();
			
			var clockTextFormat:TextFormat = new TextFormat();
			var clockTextFilterGlow:GlowFilter = new GlowFilter();
			var clockTextFilterShadow:DropShadowFilter = new DropShadowFilter();
			
			var dayTextFormat:TextFormat = new TextFormat();
			var dayTextFilterGlow:GlowFilter = new GlowFilter();
			var dayTextFilterShadow:DropShadowFilter = new DropShadowFilter();
			
			var dateTextFormat:TextFormat = new TextFormat();
			var dateTextFilterGlow:GlowFilter = new GlowFilter();
			var dateTextFilterShadow:DropShadowFilter = new DropShadowFilter();

			// Background for date, clock, day: visibility, position, transparency by default
			bgDateClock.visible = configData.ConfigBackground.@visible == "true";
			bgDateClock.alpha = configData.ConfigBackground.@alpha;
			bgDateClock.x = hOffsetBg + Number(configData.ConfigBackground.position.@x);
			bgDateClock.y = offsetY + Number(configData.ConfigBackground.position.@y);

			// Background: Gradient rectangle
			Colors = String(configData.ConfigBackground.gColors);
			Alphas = String(configData.ConfigBackground.gAlphas);
			Ratios = String(configData.ConfigBackground.gRatios);
			Gradient = String(configData.ConfigBackground.gType);
			switch(Gradient) {
				case "RADIAL":
					gType = GradientType.RADIAL;
				break;
				case "LINEAR":
					gType = GradientType.LINEAR;
				break;
				default:
					gType = GradientType.RADIAL;
				break;
			}
			gColors = Colors.split(",");
			gAlphas = Alphas.split(",");
			gRatios = Ratios.split(",");
			gFocalPtRatio= configData.ConfigBackground.gFocalPtRatio.@focalPtRatio;

			gBoxWidth = configData.ConfigBackground.gBox.@width;
			gBoxHeight = configData.ConfigBackground.gBox.@height;
			gBoxRotation = configData.ConfigBackground.gBox.@rotation;
			gTx = configData.ConfigBackground.gTxy.@tx;
			gTy = configData.ConfigBackground.gTxy.@ty;

			gMatrix.createGradientBox(gBoxWidth, gBoxHeight, gBoxRotation, gTx, gTy);

			bgDateClock.graphics.clear();

			bgDateClock.graphics.beginGradientFill(gType,
										gColors,
										gAlphas,
										gRatios,
										gMatrix,
										gSpreadMethod,
										gInterp,
										gFocalPtRatio);

			gRectX = configData.ConfigBackground.gRectangle.@x;
			gRectY = configData.ConfigBackground.gRectangle.@y;
			gRectWidth = configData.ConfigBackground.gRectangle.@width;
			gRectHeight = configData.ConfigBackground.gRectangle.@height;

			bgDateClock.graphics.drawRect(gRectX, gRectY, gRectWidth, gRectHeight);

			bgDateClock.graphics.endFill();

			/////

			// 12/24-hour clock and blink
			AMPM = configData.ConfigClock.@AMPM == "true";
			blink = configData.ConfigClock.@blink == "true";

			// Clock: text format
			clockTextFormat.align = "center";
			clockTextFormat.bold = configData.ConfigClock.text.@bold == "true";
			clockTextFormat.color = configData.ConfigClock.text.@color;
			clockTextFormat.font = configData.ConfigClock.text.@font;
			clockTextFormat.kerning = false;
			clockTextFormat.size = configData.ConfigClock.text.@size;

			// Clock: visibility and position
			clockHrs.visible = configData.ConfigClock.@visible == "true";
			clockHrs.width = clockHrs.textWidth + Number(configData.ConfigClock.formatHrs.@offsetHrs);
			//clockHrs.width = clockHrs.textWidth + 4;
			//if(clockHrs.width < 36) {
			//	clockHrs.width = 36;
			//}
			clockHrs.height = clockHrs.textHeight;
			clockHrs.x = hOffsetClock + Number(configData.ConfigClock.position.@x);
			clockHrs.y = offsetY + Number(configData.ConfigClock.position.@y);
			clockHrs.defaultTextFormat = clockTextFormat;
			clockHrs.embedFonts = true;

			clockSep1.visible = configData.ConfigClock.@visible == "true";
			clockSep1.width = clockSep1.textWidth + Number(configData.ConfigClock.@sepWidth);
			//clockSep1.width = clockSep1.textWidth + 2;
			//if(clockSep1.width < 10) {
			//	clockSep1.width = 10;
			//}
			clockSep1.height = clockSep1.textHeight;
			clockSep1.x = clockHrs.x + clockHrs.width;
			clockSep1.y = clockHrs.y;
			clockSep1.defaultTextFormat = clockTextFormat;
			clockSep1.embedFonts = true;

			clockMin.visible = configData.ConfigClock.@visible == "true";
			clockMin.width = clockMin.textWidth + Number(configData.ConfigClock.formatMin.@offsetMin);
			//clockMin.width = clockMin.textWidth + 4;
			//if(clockMin.width < 36) {
			//	clockMin.width = 36;
			//}
			clockMin.height = clockMin.textHeight;
			clockMin.x = clockSep1.x + clockSep1.width;
			clockMin.y = clockHrs.y;
			clockMin.defaultTextFormat = clockTextFormat;
			clockMin.embedFonts = true;

			clockSep2.visible = configData.ConfigClock.@visible == "true";
			if(configData.ConfigClock.formatSec.@visible == "true") {
				clockSep2.width = clockSep2.textWidth + Number(configData.ConfigClock.@sepWidth);
				//clockSep2.width = clockSep2.textWidth + 2;
				//if(clockSep2.width < 10) {
				//	clockSep2.width = 10;
				//}
			} else {
				clockSep2.visible = false;
				clockSep2.width = 0;
			}
			clockSep2.height = clockSep2.textHeight;
			clockSep2.x = clockMin.x + clockMin.width;
			clockSep2.y = clockHrs.y;
			clockSep2.defaultTextFormat = clockTextFormat;
			clockSep2.embedFonts = true;

			clockSec.visible = configData.ConfigClock.@visible == "true";
			if(configData.ConfigClock.formatSec.@visible == "true") {
				clockSec.width = clockSec.textWidth + Number(configData.ConfigClock.formatSec.@offsetSec);
				//clockSec.width = clockSec.textWidth + 4;
				//if(clockSec.width < 36) {
				//	clockSec.width = 36;
				//}
			} else {
				clockSec.visible = false;
				clockSec.width = 0;
			}
			clockSec.height = clockSec.textHeight;
			clockSec.x = clockSep2.x + clockSep2.width;
			clockSec.y = clockHrs.y;
			clockSec.defaultTextFormat = clockTextFormat;
			clockSec.embedFonts = true;

			if(AMPM) {
				clockAMPM.visible = configData.ConfigClock.@visible == "true";
				clockAMPM.width = clockAMPM.textWidth + Number(configData.ConfigClock.formatAMPM.@offsetAMPM);
				//clockAMPM.width = clockAMPM.textWidth + 4;
				//if(clockAMPM.width < 64) {
				//	clockAMPM.width = 64;
				//}
				clockAMPM.height = clockAMPM.textHeight;
				clockAMPM.x = clockSec.x + clockSec.width;
				clockAMPM.y = clockHrs.y;
				clockAMPM.defaultTextFormat = clockTextFormat;
				clockAMPM.embedFonts = true;
			} else {
				clockAMPM.visible = false;
				clockAMPM.width = 0;
			}

			// Clock: text filter effects
			if(configData.ConfigClock.filters.@enable == "true") {

				filterClock = configData.ConfigClock.filters.@filter;
				switch(filterClock) {
					case "glow":
						clockTextFilterGlow.blurX = configData.ConfigClock.filters.glow.@blurX;
						clockTextFilterGlow.blurY = configData.ConfigClock.filters.glow.@blurY;
						clockTextFilterGlow.color = configData.ConfigClock.filters.glow.@color;
						clockTextFilterGlow.strength = configData.ConfigClock.filters.glow.@strength;

						clockHrs.filters = [clockTextFilterGlow];
						clockMin.filters = [clockTextFilterGlow];
						clockSec.filters = [clockTextFilterGlow];
						clockSep1.filters = [clockTextFilterGlow];
						clockSep2.filters = [clockTextFilterGlow];
						if(AMPM) {
							clockAMPM.filters = [clockTextFilterGlow];
						}
					break;
					case "shadow":
						clockTextFilterShadow.angle = configData.ConfigClock.filters.shadow.@angle;
						clockTextFilterShadow.blurX = configData.ConfigClock.filters.shadow.@blurX;
						clockTextFilterShadow.blurY = configData.ConfigClock.filters.shadow.@blurY;
						clockTextFilterShadow.color = configData.ConfigClock.filters.shadow.@color;
						clockTextFilterShadow.distance = configData.ConfigClock.filters.shadow.@distance;
						clockTextFilterShadow.strength = configData.ConfigClock.filters.shadow.@strength;

						clockHrs.filters = [clockTextFilterShadow];
						clockMin.filters = [clockTextFilterShadow];
						clockSec.filters = [clockTextFilterShadow];
						clockSep1.filters = [clockTextFilterShadow];
						clockSep2.filters = [clockTextFilterShadow];
						if(AMPM) {
							clockAMPM.filters = [clockTextFilterShadow];
						}
					break;
					default:
						clockHrs.filters = [];
						clockMin.filters = [];
						clockSec.filters = [];
						clockSep1.filters = [];
						clockSep2.filters = [];
						if(AMPM) {
							clockAMPM.filters = [];
						}
					break;
				}

			} else {

				clockHrs.filters = [];
				clockMin.filters = [];
				clockSec.filters = [];
				clockSep1.filters = [];
				clockSep2.filters = [];
				if(AMPM) {
					clockAMPM.filters = [];
				}

			}

			theClockHrs = String(configData.ConfigClock.formatHrs);
			theClockMin = String(configData.ConfigClock.formatMin);
			theClockSec = String(configData.ConfigClock.formatSec);
			theClockSep1 = ":";
			theClockSep2 = ":";
			theClockAMPM = "";

			/////

			// Day of the week: text format
			dayTextFormat.align = configData.ConfigDay.text.@align;
			dayTextFormat.bold = configData.ConfigDay.text.@bold == "true";
			dayTextFormat.color = configData.ConfigDay.text.@color;
			dayTextFormat.font = configData.ConfigDay.text.@font;
			dayTextFormat.kerning = false;
			dayTextFormat.size = configData.ConfigDay.text.@size;

			// Day of the week: visibility and position
			day.visible = configData.ConfigDay.@visible == "true";
			day.width = day.textWidth +16;
			if(day.width < 288) {
				day.width = 288;
			}
			day.height = day.textHeight;
			day.x = hOffsetDay + Number(configData.ConfigDay.position.@x);
			day.y = offsetY + Number(configData.ConfigDay.position.@y);
			day.defaultTextFormat = dayTextFormat;
			day.embedFonts = true;

			// Day of the week: text filter effects
			if(configData.ConfigDay.filters.@enable == "true") {

				filterDay = configData.ConfigDay.filters.@filter;
				switch(filterDay) {
					case "glow":
						dayTextFilterGlow.blurX = configData.ConfigDay.filters.glow.@blurX;
						dayTextFilterGlow.blurY = configData.ConfigDay.filters.glow.@blurY;
						dayTextFilterGlow.color = configData.ConfigDay.filters.glow.@color;
						dayTextFilterGlow.strength = configData.ConfigDay.filters.glow.@strength;

						day.filters = [dayTextFilterGlow];
					break;
					case "shadow":
						dayTextFilterShadow.angle = configData.ConfigDay.filters.shadow.@angle;
						dayTextFilterShadow.blurX = configData.ConfigDay.filters.shadow.@blurX;
						dayTextFilterShadow.blurY = configData.ConfigDay.filters.shadow.@blurY;
						dayTextFilterShadow.color = configData.ConfigDay.filters.shadow.@color;
						dayTextFilterShadow.distance = configData.ConfigDay.filters.shadow.@distance;
						dayTextFilterShadow.strength = configData.ConfigDay.filters.shadow.@strength;

						day.filters = [dayTextFilterShadow];
					break;
					default:
						day.filters = [];
					break;
				}

			} else {

				day.filters = [];

			}

			days[0] = configData.Day.Su;
			days[1] = configData.Day.Mo;
			days[2] = configData.Day.Tu;
			days[3] = configData.Day.We;
			days[4] = configData.Day.Th;
			days[5] = configData.Day.Fr;
			days[6] = configData.Day.Sa;

			theDay = String(configData.ConfigDay.format);

			/////

			// Day of the month: double digit
			dd = configData.ConfigDate.format.@dd == "true";

			// Date: text format
			dateTextFormat.align = configData.ConfigDate.text.@align;
			dateTextFormat.bold = configData.ConfigDate.text.@bold == "true";
			dateTextFormat.color = configData.ConfigDate.text.@color;
			dateTextFormat.font = configData.ConfigDate.text.@font;
			dateTextFormat.kerning = false;
			dateTextFormat.size = configData.ConfigDate.text.@size;

			// Date: visibility and position
			date.visible = configData.ConfigDate.@visible == "true";
			date.width = date.textWidth + 16;
			if(date.width < 288){
				date.width = 288;
			}
			date.height = date.textHeight;
			date.x = hOffsetDate + Number(configData.ConfigDate.position.@x);
			date.y = offsetY + Number(configData.ConfigDate.position.@y);
			date.defaultTextFormat = dateTextFormat;
			date.embedFonts = true;

			// Date: text filter effects
			if(configData.ConfigDate.filters.@enable == "true") {

				filterDate = configData.ConfigDate.filters.@filter;
				switch(filterDate) {
					case "glow":
						dateTextFilterGlow.blurX = configData.ConfigDate.filters.glow.@blurX;
						dateTextFilterGlow.blurY = configData.ConfigDate.filters.glow.@blurY;
						dateTextFilterGlow.color = configData.ConfigDate.filters.glow.@color;
						dateTextFilterGlow.strength = configData.ConfigDate.filters.glow.@strength;

						date.filters = [dateTextFilterGlow];
					break;
					case "shadow":
						dateTextFilterShadow.angle = configData.ConfigDate.filters.shadow.@angle;
						dateTextFilterShadow.blurX = configData.ConfigDate.filters.shadow.@blurX;
						dateTextFilterShadow.blurY = configData.ConfigDate.filters.shadow.@blurY;
						dateTextFilterShadow.color = configData.ConfigDate.filters.shadow.@color;
						dateTextFilterShadow.distance = configData.ConfigDate.filters.shadow.@distance;
						dateTextFilterShadow.strength = configData.ConfigDate.filters.shadow.@strength;

						date.filters = [dateTextFilterShadow];
					break;
					default:
						date.filters = [];
					break;
				}

			} else {

				date.filters = [];

			}

			months[0] = configData.Month.Jan;
			months[1] = configData.Month.Feb;
			months[2] = configData.Month.Mar;
			months[3] = configData.Month.Apr;
			months[4] = configData.Month.May;
			months[5] = configData.Month.Jun;
			months[6] = configData.Month.Jul;
			months[7] = configData.Month.Aug;
			months[8] = configData.Month.Sep;
			months[9] = configData.Month.Oct;
			months[10] = configData.Month.Nov;
			months[11] = configData.Month.Dec;

			theDate = String(configData.ConfigDate.format);

			/////

		}

		///// Clock

		private function doubleDigitFormat(n:uint):String {

			if( n < 10 ){
				return ("0"+n);
			}
			return n.toString();

		}

		protected function updateClock(event:Event,param1:String = ""):void {

			var _WoT_:String = param1;

			initConfig(_WoT_);

			now = new Date();
			hours = now.hours;
			minutes = now.minutes;
			seconds = now.seconds;
			milliseconds = now.milliseconds;

			if(AMPM) {
				if ( hours > 11 ) {
					theClockAMPM = "PM";
				} else {
					theClockAMPM = "AM";
				}
				if ( hours > 12 )
				{
					hours-=12;
				}
				hrs = hours.toString();
			} else {
				theClockAMPM = "";
				hrs = doubleDigitFormat(hours);
			}

			if(dd) {
				dom = doubleDigitFormat(now.date);
			} else {
				dom = now.date.toString();
			}

			mins = doubleDigitFormat(minutes);
			secs = doubleDigitFormat(seconds);

			theClockHrs = theClockHrs.replace(/\{HH\}/gx, hrs);
			theClockMin = theClockMin.replace(/\{mm\}/gx, mins);
			theClockSec = theClockSec.replace(/\{ss\}/gx, secs);

			clockHrs.text = theClockHrs;
			clockMin.text = theClockMin;
			clockSec.text = theClockSec;
			clockSep1.text = theClockSep1;
			clockSep2.text = theClockSep2;
			if(blink) {
				if ( milliseconds < 500 ){
					clockSep1.alpha = 1;
					clockSep2.alpha = 1;
				} else {
					clockSep1.alpha = 0;
					clockSep2.alpha = 0;
				}
			} else {
					clockSep1.alpha = 1;
					clockSep2.alpha = 1;
			}
			clockAMPM.text = theClockAMPM;

			theDay = theDay.replace(/\{day\}/gx, days[now.day]);
			day.text = theDay;

			theDate = theDate.replace(/\{fullYear\}/gx, now.fullYear);
			theDate = theDate.replace(/\{month\}/gx, months[now.month]);
			theDate = theDate.replace(/\{date\}/gx, dom);
			date.text = theDate;

			if (getChildByName("bgDateClock") == null) {

				var bgDelayTimer:Timer = new Timer(500, 1);
				bgDelayTimer.addEventListener(TimerEvent.TIMER, addBg);
				bgDelayTimer.start();

				function addBg():void {
					addChild(bgDateClock);
					setChildIndex(bgDateClock, 0);
				}

			}

		}

		/////

		function frame1(param1:String = "") : * {

			//
			var _WoT_:String = param1;
			bgDateClock = new MovieClip();
			initClock(_WoT_);
			stop();

		}

	}

}
