package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import net.wg.gui.lobby.LobbyPage;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.events.LoaderEvent;
	import net.wg.infrastructure.interfaces.IView;
	import net.wg.infrastructure.managers.impl.ContainerManagerBase;

	public class hangarClock extends AbstractView {

		public function hangarClock() {
			super();
			this.init();
		}

		public var py_log:Function;
		public var py_getWoTPath:Function;

		private var lobby:LobbyPage = null;
		private var current_alias:String = "";

		private var zClock:hClock = null;

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
				this.zClock = new hClock(_WoT_);
				this.current_alias = view.as_config.alias;
				if(this.current_alias == "lobby") {
					this.lobby = view as LobbyPage;
					this.lobby.header.addChild(this.zClock);
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

	}

}
