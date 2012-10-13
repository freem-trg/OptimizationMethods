package Methods {
	import flash.display.Sprite;
	
	public class HookDjivsMethod extends Sprite {
		
		private var _optimizationFunc	:Function ; // Функция, которую мы оптимизируем
		private var _showFailures		:Boolean ;	// Параметр, отвечающий за отображение неудачных шагов
		private var _dx					:Number ;	// Приращение по переменной х
		private var _dy					:Number ;	// Приращение по переменной у
		
		public function HookDjivsMethod( startX:Number, startY:Number, dx:Number, dy:Number, optimizationFunction:Function, showFailures:Boolean ){
			// Блок инициализации :
			this._optimizationFunc 	= optimizationFunction;
			this._showFailures 		= showFailures;
			this._dx 				= dx;
			this._dy				= dy;
			//Начало поиска:
			exploringSearch( startX, startY );
		}
		
		private function exploringSearch ( searchX:Number, searchY:Number ){
			
		}
		
		private function acceleratingSearch ( searchX:Number, searchY:Number ) {
			
		}
		
		
	}
	
}