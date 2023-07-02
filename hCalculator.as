package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class hCalculator extends MovieClip {

		public function hCalculator() {
			super();
			addFrameScript(0,this.frame1);
		}

		/////

		// Init calculator
		private function initCalculator():void {

			removeCalculator();
			addCalculator();

		}

		///// Calculator window

		// Add calculator to stage
		private function addCalculator():void {

			Calculator.x = 0;
			Calculator.y = 0;
			Calculator.visible = true;
			App.stage.focus = Calculator;
			resetCalculator();

			// Add listeners for buttons
			var numi:uint;
			for (numi = 0; numi <= 9; numi++) {
				Calculator["num" + numi.toString()].addEventListener(MouseEvent.CLICK, numClick);
			}

			var oppi:uint;
			for (oppi = 1; oppi <= 4; oppi++) {
				Calculator["opp" + oppi.toString()].addEventListener(MouseEvent.CLICK, oppClick);
			}

			Calculator.numDec.addEventListener(MouseEvent.CLICK, numClick);
			Calculator.oppNeg.addEventListener(MouseEvent.CLICK, negClick);
			Calculator.oppPct.addEventListener(MouseEvent.CLICK, pctClick);
			Calculator.oppEquals.addEventListener(MouseEvent.CLICK, equalsClick);
			Calculator.ctrClearEntry.addEventListener(MouseEvent.CLICK, ctrClick);
			Calculator.ctrClear.addEventListener(MouseEvent.CLICK, ctrClick);

			// Add listeners for keyboard
			Calculator.addEventListener(KeyboardEvent.KEY_DOWN, keyPressCalculator);

		}

		// Remove calculator from stage
		private function removeCalculator():void {

			Calculator.visible = false;

			// Remove listeners from buttons
			var numi:uint;
			for (numi = 0; numi <= 9; numi++) {
				if(Calculator["num" + numi.toString()].hasEventListener(MouseEvent.CLICK)) {
					Calculator["num" + numi.toString()].removeEventListener(MouseEvent.CLICK, numClick);
				}
			}

			var oppi:uint;
			for (oppi = 1; oppi <= 4; oppi++) {
				if(Calculator["opp" + oppi.toString()].hasEventListener(MouseEvent.CLICK)) {
					Calculator["opp" + oppi.toString()].removeEventListener(MouseEvent.CLICK, oppClick);
				}
			}

			if(Calculator.numDec.hasEventListener(MouseEvent.CLICK)) {
				Calculator.numDec.removeEventListener(MouseEvent.CLICK, numClick);
			}
			if(Calculator.oppNeg.hasEventListener(MouseEvent.CLICK)) {
				Calculator.oppNeg.removeEventListener(MouseEvent.CLICK, negClick);
			}
			if(Calculator.oppPct.hasEventListener(MouseEvent.CLICK)) {
				Calculator.oppPct.removeEventListener(MouseEvent.CLICK, pctClick);
			}
			if(Calculator.oppEquals.hasEventListener(MouseEvent.CLICK)) {
				Calculator.oppEquals.removeEventListener(MouseEvent.CLICK, equalsClick);
			}
			if(Calculator.ctrClearEntry.hasEventListener(MouseEvent.CLICK)) {
				Calculator.ctrClearEntry.removeEventListener(MouseEvent.CLICK, ctrClick);
			}
			if(Calculator.ctrClear.hasEventListener(MouseEvent.CLICK)) {
				Calculator.ctrClear.removeEventListener(MouseEvent.CLICK, ctrClick);
			}

			// Remove listeners from keyboard
			if(Calculator.hasEventListener(KeyboardEvent.KEY_DOWN)) {
				Calculator.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressCalculator);
			}

		}

		///// Calculator

		//
		private var input1:Number = 0;
		private var input2:Number = 0;
		private var lastNum:Number = 0;
		private var memoryENum:Number = 0;
		private var memoryPNum:Number = 0;
		private var neg:Number = 0;
		private var pct:Number = 0;
		private var total:Number = 0;

		private var lastOpp:String = "";
		private var opp:String = "";
		private var toHistory:String = "";

		private var decPressed:Boolean = false;
		private var equalPressed:Boolean = false;
		private var negPressed:Boolean = false;
		private var numPressed:Boolean = false;
		private var oppPressed:Boolean = false;
		private var pctPressed:Boolean = false;

		private var repEquals:Boolean = false;
		private var repOpp:Boolean = false;
		private var repPct:Boolean = false;

		private var clearScreen:Boolean = false;
		private var startScreen:Boolean = true;

		private var scrn:String = "";
		private var scrnhist:String = "";

		private var space:String = String.fromCharCode(32);

		private var Add:String = String.fromCharCode(43);
		private var Div:String = String.fromCharCode(47);
		private var Mult:String = String.fromCharCode(42);
		private var Subt:String = String.fromCharCode(45);

		private function resetCalculator():void {

			input1 = 0;
			input2 = 0;
			lastNum = 0;
			memoryENum = 0;
			memoryPNum = 0;
			neg = 0;
			pct = 0;
			total = 0;

			lastOpp = "";
			opp = "";
			toHistory = "";

			decPressed = false;
			equalPressed = false;
			negPressed = false;
			numPressed = false;
			oppPressed = false;
			pctPressed = false;

			repEquals = false;
			repOpp = false;
			repPct = false;

			clearScreen = false;
			startScreen= true;

			Calculator.scrn.text = "0";
			Calculator.scrnhist.text = "";

		}

		private function scrollScrnhist():void {
			if(Calculator.scrnhist.numLines > Calculator.scrnhist.bottomScrollV) {
				Calculator.scrnhist.scrollV = Calculator.scrnhist.maxScrollV;
			}
		}

		private function calculate():void {

			switch(opp) {
				case Add:
					total = (input1 + input2);
				break;
				case Subt:
					total = (input1 - input2);
				break;
				case Mult:
					total = (input1 * input2);
				break;
				case Div:
					total = (input1 / input2);
				break;
			}

			function checkForDecimal(number:Number):Boolean {
					return number%1 ? true : false;
				}

			if(!checkForDecimal(total)) {
				total = Number(total.toPrecision(15));
			} else {
				total = Number(total.toPrecision(13));
			}

		}

		private function totalExp():void {
			if(Calculator.scrn.length > 15) {
				Calculator.scrn.text = total.toExponential(15);
				total = Number(Calculator.scrn.text);
			}
		}

		// event handler for Number Buttons Click;
		private function numClick(e:MouseEvent):void {

			var numButton:String = e.target.name;
			var buttonVal:String = "";
			var nullPressed:Boolean = false;

			function checkNullPoint():void {
				if (startScreen || pctPressed || Calculator.scrn.text == "") {
					buttonVal = ("0" + ".");
				}
			}

			if (clearScreen) {
				clearScreen = false;
				Calculator.scrn.text = "";
			}

			if (equalPressed) {
				equalPressed = false;
				Calculator.scrn.text = "";
			}

			if (numButton == "numDec") {
				if (!decPressed){
					decPressed = true;
					buttonVal = ".";
					checkNullPoint();
				}
			} else {
				buttonVal = numButton.substr(numButton.length-1, numButton.length);
				numPressed = true;
			}

			if (buttonVal == "0") {
				nullPressed = true;
			}

			if (Calculator.scrn.text == "0") {
				if (startScreen) {
					startScreen = false;
					nullPressed = false;
					Calculator.scrn.text = "";
					Calculator.scrnhist.text = "";
				}
				if (nullPressed) {
					nullPressed = false;
					buttonVal = "";
				}
			}

			startScreen = false;
			nullPressed = false;

			if(Calculator.scrn.length >= 15) {
				buttonVal = "";
			}

			if (pctPressed) {
				pctPressed = false;
				Calculator.scrn.text = buttonVal;
			} else {
				Calculator.scrn.appendText(buttonVal);
			}

			var nullFirst:Boolean = false;
			var nullFirstPtrn:RegExp = /^0[1-9]$/g;
			nullFirst = nullFirstPtrn.test(Calculator.scrn.text);
			if(nullFirst){
				nullFirst = false;
				Calculator.scrn.replaceText(0, 1, "");
			}

			lastNum = Number(Calculator.scrn.text);
			toHistory = String(lastNum);

		}

		// event handler for +/- Button Click
		private function negClick(e:MouseEvent):void {

				neg = Number(Calculator.scrn.text) * -1;
				Calculator.scrn.text = neg.toString();
				toHistory = String(neg);
				negPressed = true;

		}

		// event handler for Opperation Buttons Click
		private function oppClick(e:MouseEvent):void {

			var oppButton:String = e.target.name;
			var checkDoubleOpp:Boolean = true;

			clearScreen = true;

			function oppButtons():void {

				switch(oppButton) {
					case "opp1":
						opp = Add;
					break;
					case "opp2":
						opp = Subt;
					break;
					case "opp3":
						opp = Mult;
					break;
					case "opp4":
						opp = Div;
					break;

				}

			}

			function checkLastOpp():void {
				if(opp != lastOpp) {
					oppReplaceHistory();
					lastOpp = opp;
				}
			}

			function oppToHistory():void {
				Calculator.scrnhist.appendText(toHistory);
				Calculator.scrnhist.appendText(space + opp + space);
				scrollScrnhist();
			}

			function oppReplaceHistory():void {

				var oldScrnhist:String = "";
				var newScrnhist:String = "";

				oldScrnhist = Calculator.scrnhist.text;
				newScrnhist = oldScrnhist.substring(0, (oldScrnhist.length - 3));
				Calculator.scrnhist.text = newScrnhist;
				Calculator.scrnhist.appendText(space + opp + space);
				scrollScrnhist();

			}

			function doOppCalculate():void {

				calculate();
				Calculator.scrn.text = total.toString();
				totalExp();
				negPressed = false;
				numPressed = false;
				oppPressed = false;
				pctPressed = false;
				repOpp = true;

				lastNum = total;

			}

			if(!oppPressed) {
				if(pctPressed) {
					if(negPressed) {
						pct = neg;
					}
					input2 = pct;
					doOppCalculate();
				} else {
					input1 = Number(Calculator.scrn.text);
					oppButtons();
					if(!numPressed) {
						if (Calculator.scrn.text == "0") {
							toHistory = String(Number(Calculator.scrn.text));
						}
					}
					oppToHistory();
					lastOpp = opp;
					if(checkDoubleOpp) {
						decPressed = false;
						equalPressed = false;
						negPressed = false;
						numPressed = false;
						oppPressed = true;
						repEquals = false;
						repPct = false;
						Calculator.scrn.text = "";
					}
					Calculator.scrn.text = input1.toString();
					lastNum = input1;
					memoryPNum = 0;
				}
			} else {
				if(!numPressed) {
					oppButtons();
					checkLastOpp();
				} else {
					input2 = Number(Calculator.scrn.text);
					doOppCalculate();
				}
			}

			if(repOpp) {
				input1 = Number(Calculator.scrn.text);
				oppButtons();
				oppToHistory();
				checkLastOpp();
				decPressed = false;
				oppPressed = true;
				repOpp = false;
			}

		}

		// event handler for Percent Button Click
		private function pctClick(e:MouseEvent):void {

			function doPctCalculate():void {

				if( input1 < 0 && input2 < 0 ) {
					pct = (input1 * input2) * -0.01;
				} else {
					pct = (input1 * input2) * 0.01;
				}
				pct = Number(pct.toPrecision(13));
				Calculator.scrn.text = pct.toString();
				toHistory = Calculator.scrn.text;
				decPressed = false;
				equalPressed = false;
				negPressed = false;
				numPressed = false;
				oppPressed = false;
				pctPressed = true;

				if(!repPct) {
					memoryPNum = pct;
					lastNum = pct;
				}

			}

			// only calculate if an operation button has been pressed
			if(oppPressed || pctPressed || equalPressed) {
				if(equalPressed) {
					input1 = Number(Calculator.scrn.text);
				}
				input2 = Number(Calculator.scrn.text);
				doPctCalculate();
			} else {
				resetCalculator();
			}

		}

		// event handler for Equals Button Click
		private function equalsClick(e:MouseEvent):void {

			function doEqualsCalculate():void {

				calculate();
				Calculator.scrn.text = total.toString();
				totalExp();
				Calculator.scrnhist.text = "";
				toHistory = Calculator.scrn.text;
				decPressed = false;
				equalPressed = true;
				negPressed = false;
				numPressed = false;
				oppPressed = false;
				pctPressed = false;

			}

			// only calculate if an operation button has been pressed
			if(oppPressed || equalPressed || pctPressed) {

				if(oppPressed) {
					if(negPressed) {
						lastNum = neg;
					}
					input2 = lastNum;
					memoryENum = lastNum;
					repEquals = true;
					repPct = true;
				}

				if(pctPressed) {
					if(repPct) {
						input1 = Number(Calculator.scrn.text);
					}
					if(negPressed) {
						lastNum = neg;
					}
					input2 = lastNum;
					memoryENum = lastNum;
					repPct = true;
				}

				if(equalPressed ) {
					if(repEquals || repPct) {
						input1 = Number(Calculator.scrn.text);
					}
					input2 = lastNum;
					memoryENum = lastNum;
					repEquals = true;
				}

				doEqualsCalculate();

			} else {
				if(numPressed) {
					input1 = Number(Calculator.scrn.text);
					input2 = memoryENum;
					lastNum = memoryENum;
					doEqualsCalculate();
				}
			}

		}

		// event handler for Clear Button Click
		private function ctrClick(e:MouseEvent):void {

			var ctrButton:String = e.target.name;

			if (ctrButton == "ctrClearEntry") {
				input2 = 0;
				Calculator.scrn.text = "0";
				toHistory = "";
			}

			if (ctrButton == "ctrClear") {
				resetCalculator();
			}

		}

		private function keyPressCalculator(e:KeyboardEvent):void {

			var key:uint = e.keyCode;

			if(!e.shiftKey) {
				switch(key) {
					// ESC
					/*
					case 27:
						Calculator.ctrClear.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					*/
					// Delete
					case 46:
						Calculator.ctrClearEntry.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// F9
					case 120:
						Calculator.oppNeg.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Enter
					case 13:
						Calculator.oppEquals.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Decimail
					case 188:
						Calculator.numDec.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;

					// "-"
					case 189:
						Calculator.opp2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// "/"
					case 191:
						Calculator.opp4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// "="
					case 187:
						Calculator.oppEquals.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;

					// 0
					case 48:
						Calculator.num0.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 1
					case 49:
						Calculator.num1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 2
					case 50:
						Calculator.num2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 3
					case 51:
						Calculator.num3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 4
					case 52:
						Calculator.num4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 5
					case 53:
						Calculator.num5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 6
					case 54:
						Calculator.num6.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 7
					case 55:
						Calculator.num7.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 8
					case 56:
						Calculator.num8.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// 9
					case 57:
						Calculator.num9.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;

					// Numpad 0
					case 96:
						Calculator.num0.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 1
					case 97:
						Calculator.num1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 2
					case 98:
						Calculator.num2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 3
					case 99:
						Calculator.num3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 4
					case 100:
						Calculator.num4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 5
					case 101:
						Calculator.num5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 6
					case 102:
						Calculator.num6.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 7
					case 103:
						Calculator.num7.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 8
					case 104:
						Calculator.num8.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad 9
					case 105:
						Calculator.num9.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;

					// Numpad "*"
					case 106:
						Calculator.opp3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad "+"
					case 107:
						Calculator.opp1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad "-"
					case 109:
						Calculator.opp2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad Decimail
					case 110:
						Calculator.numDec.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// Numpad "/"
					case 111:
						Calculator.opp4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}

			if(e.shiftKey) {
				switch(key) {
					// "%"
					case 53:
						Calculator.oppPct.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// "*"
					case 56:
						Calculator.opp3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
					// "+"
					case 187:
						Calculator.opp1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}

		}

		/////

		function frame1() : * {

			//
			initCalculator();
			stop();

		}

	}

}
