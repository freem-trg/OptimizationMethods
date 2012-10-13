package  GUI {	

	/*
	Класс, который отвечает за заполнение палитры цветов, на основании которой будет построена поверхность
	и градиентная шкала.
	*/

	public class Palette{		
		public const COLORS:uint = 256;
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