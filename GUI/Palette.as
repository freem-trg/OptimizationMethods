package  GUI {	

	/*
	Класс, который отвечает за заполнение палитры цветов, на основании которой будет построена поверхность
	и градиентная шкала.
	*/

	public class Palette{		
		public const COLORS							 	 : uint = 256; // Тоже статик?
		static public const ACCELERATE_FAILURE_COLOR	 : uint = 0xff0000;
		static public const ACCELERATE_SUCCESS_COLOR	 : uint = 0x00ff00;
		static public const EXPLORE_FAILURE_COLOR 		 : uint = 0xffff33;
		static public const EXPLORE_SUCCESS_COLOR 		 : uint = 0xffff00;
		static public const ACCELERATE_LINE_COLOR		 : uint = 0xff9999;
		static public const POLIGON_COLOR				 : uint = 0x00ff00;
		static public const POLIGON_END					 : uint = 0xff0000;
		
		private var _colors:Array;
		
		
		public function Palette() {
			_colors = new Array( COLORS );
			for ( var i:int = 0; i < COLORS; i++ ) {
				_colors[ COLORS - 1 - i ] = 0xffffff - 0x010100*i; 	//Заполняем градациями синего
			}
		}
		
		public function getColor( pos:uint ):uint {
			return uint(_colors[ pos ]);
		}
		
		
		
	}
	
}