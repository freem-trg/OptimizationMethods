package  GUI {	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import GUI.Palette;
	import GUI.Grid;
	
	/*
	Класс, который отвечает за построение поверхности, нанесение на нее линий одинакового уровня,
	добавление координатной сетки, добавление градиентной шкалы, для определения значений.
	*/
	
	public class Area extends Sprite {		
		private var _bitmap				:Bitmap;
		private var _bitmapdata			:BitmapData;
		private var _optimizationFunc 	:Function;
		private var _points, _lines		:Array;
		private var _minVal, _maxVal	:Number;
		private var _areaW, _areaH		:Number;
		private var _xmin, _xmax		:Number;
		private var _ymin, _ymax		:Number;
		private var _dx, _dy			:Number;
		private var _funcInterval		:Number;
		private var _linesCount			:int;
		private var _eps				:Number;
		private var _palette			:Palette;
		private var _grid				:Grid;
		
		public function Area( areaWidth:uint, areaHeight:uint, xmin:Number, xmax:Number, 
							 ymin:Number, ymax:Number, linesCount:int, linesEps:Number, optimizationFunction:Function) {
								 
			_palette 	= new Palette();
			_grid		= new Grid( areaWidth, areaHeight );
			_areaW 		= areaWidth;
			_areaH 		= areaHeight;
			_bitmapdata = new BitmapData(areaWidth, areaHeight, true, 0xff0000);			
			_bitmap 	= new Bitmap(_bitmapdata);
			update( xmin, xmax, ymin, ymax, linesCount, linesEps, optimizationFunction );
			this.addChild( _bitmap );
			this.addChild( _grid );
		}
		
		public function update ( xmin:Number, xmax:Number, ymin:Number, 
								ymax:Number, linesCount:int, linesEps:Number, optimizationFunction:Function ){
									
			_optimizationFunc 	= optimizationFunction; 		
			_linesCount = linesCount;
			_eps 		= linesEps;
			_points		= new Array( _areaW * _areaH );
			_lines		= new Array ( linesCount + 1 );
			_xmin 		= xmin;
			_xmax		= xmax;
			_ymin		= ymin;
			_ymax		= ymax;
			calculateGrid();
		}
		
		private function calculateGrid(){
			_maxVal 	= Number.MIN_VALUE;
			_minVal 	= Number.MAX_VALUE;
			_dx	= ( _xmax - _xmin ) / _areaW;
			_dy	= ( _ymax - _ymin ) / _areaH;
			var _px:Number = _xmin;
			var _py:Number = _ymin;			
			var funcVal:Number;
			for ( var i:int = 0; i < _areaW; i++ ){
				for ( var j:int = 0; j < _areaH; j++ ) {
					funcVal = _optimizationFunc( _px, _py );
					_points[ i + j*_areaW ] = funcVal;
					if ( _maxVal < funcVal ) _maxVal = funcVal;
					if ( _minVal > funcVal ) _minVal = funcVal;
					_py += _dy;
				}
				_px += _dx;
				_py = _ymin;
			}			
			_funcInterval = _maxVal - _minVal;
			calculateLines();
			drawArea();			
		}
		
		private function drawArea(){
			var colorIndex	:uint;
			var isAdded		:Boolean;
			for ( var i:int = 0; i < _areaW; i++ ) {
				for ( var j:int = 0; j < _areaH; j++ ) {
					isAdded = false;
					for (var k:int = 0; k < _linesCount + 1; k++){
						if ( _points [ i + j*_areaW ] - _eps < _lines[k] && _points [ i + j*_areaW ] + _eps > _lines[k] ){
							_bitmapdata.setPixel32( i, _areaH - ( j + 1),  0xff000000 );
							isAdded = true;
							break;
						}
					}
					if (isAdded == false) {
						colorIndex = uint( ( ( _points [ i + j*_areaW ] - _minVal ) / _funcInterval ) * (_palette.COLORS-1) );					
						_bitmapdata.setPixel32( i, _areaH - ( j + 1),  0xff000000 + _palette.getColor(colorIndex) );
						//colorIndex = 0xffffff  - uint (256 * (_maxVal - _points [ i + j*_areaW ])/_funcInterval)*0x010100; альтернативный способ расчета
						//_bitmapdata.setPixel( i, _areaH - ( j + 1),  colorIndex );
					}
				}
			}
		}
		
		private function calculateLines(){
			for ( var i:int = 0; i < _linesCount + 1; i++) {
				_lines[i] = (_maxVal - _minVal) / _linesCount * i + _minVal;
			}
		}
		
		
		
	}
	
}