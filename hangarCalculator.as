package  {

	import flash.display.MovieClip;
	import net.wg.infrastructure.base.AbstractWindowView;

	public class hangarCalculator extends AbstractWindowView {

		public function hangarCalculator() {
			super();
			isCentered = true;
		}

		public var py_log: Function;

		private var zCalculator:hCalculator = null;

		override protected function onPopulate():void {
			super.onPopulate();
		}

		override protected function onDispose():void {
			super.onDispose();
		}

		override protected function configUI():void {
			try {
				super.configUI();
			}
			catch(error:Error) {
				py_log("configUI " + error.getStackTrace());
			}
		}

	}

}
