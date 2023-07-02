package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.infrastructure.managers.impl.ContainerManagerBase;
	import scaleform.clik.events.ButtonEvent;

	public class hangarCalculatorButton extends AbstractView implements IhangarCalculatorButton {

		public function hangarCalculatorButton() {
			super();
			this.init();
		}

		public var py_log:Function;
		public var py_getWoTPath:Function;

		private var lobby:LobbyPage = null;
		private var current_alias:String = "";

		private var zCalculatorButton:hCalculatorButton = null;

		private function init(param1:Event = null):void {
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE,this.init);
				return;
			}
			removeEventListener(Event.ADDED_TO_STAGE,this.init);
			(App.containerMgr as ContainerManagerBase).loader.addEventListener(LoaderEvent.VIEW_LOADED,this.onViewLoaded,false,0,true);
		}

		private function onViewLoaded(param1:LoaderEvent):void {
			this.processView(param1.view,false);
		}

		private function processView(param1:IView, param2:Boolean):void {
			var view:IView = param1;
			var populated:Boolean = param2;
			var _WoT_:String = py_getWoTPath();
			try {
				this.zCalculatorButton = new hCalculatorButton(_WoT_);
				this.current_alias = view.as_config.alias;
				this.zCalculatorButton.addEventListener(ButtonEvent.CLICK,this.onCalcBtnClick);
				if(this.current_alias == "lobby") {
					this.lobby = view as LobbyPage;
					this.lobby.header.addChild(this.zCalculatorButton);
					//py_log("is loaded");
				}
			}
			catch(error:Error) {
				py_log("processView" + error.getStackTrace());
			}
		}

		override protected function nextFrameAfterPopulateHandler():void {
			if(this.parent != App.instance) {
				(App.instance as MovieClip).addChild(this);
			}
			visible = false;
		}

		override protected function onDispose():void {
			this.zCalculatorButton.removeEventListener(MouseEvent.CLICK,this.onCalcBtnClick);
		}

		private function onCalcBtnClick(param1:ButtonEvent):void {
			var external:Array = new Array();
			external.push(this.current_alias);
			external.unshift("hangarCalculatorButton.showCalculator","hangarCalculatorButton");
			ExternalInterface.call.apply(null,external);
		}

	}

}
