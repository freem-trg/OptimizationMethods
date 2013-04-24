package Methods{
	import flash.display.Sprite;
	import GUI.Area;
	import flash.geom.Point;
	import GUI.Palette;
	import main;
	
	public class NelderMidMethod extends Sprite {
		private const _alfa 	= 1;
		private const _beta 	= 0.5;
		private const _gamma 	= 2;
		private const _reduct 	= 0.5;
		private var _eps		= 0.000001;
		private var _optimizationFunc	: Function ; // Функция, которую мы оптимизируем
		private var _showFailures		: Boolean ;	// Параметр, отвечающий за отображение неудачных шагов
		private var _area 				: Area ;	// Отрисовка процесса поиска
		private var _isMinimize			: Boolean; 
		private var _coordinates		: Object;
		private var _prnt				: main;
		
		public function NelderMidMethod(startX:Array, startY:Array, optimizationFunction:Function, 
										area:Area, prnt:main, eps:Number = 0.000001, showFailures:Boolean = false, optimizationType:String = "minimize"){
			// Блок инициализации :
			if ( optimizationType == "minimize" ) {
				_isMinimize = true;
			} else {
				_isMinimize = false;
			}
			_coordinates 	= new Object();
			_coordinates.x 	= startX;
			_eps			= eps;
			_coordinates.y 	= startY;
			_area 			= area;
			_showFailures 	= showFailures;
			_optimizationFunc = optimizationFunction;
			_prnt = prnt;
			//вывод сообщения
			//_prnt.addTrace( );
		}
		
		public function find(){
			var eps		:Number = Number.MAX_VALUE;			
			var xh		:Point;
			var xl		:Point;
			var _centr	:Point;
			var x_otr	:Point;
			var x_rast	:Point;
			var x_sgat	:Point;
			var xh_index:int;
			var xl_index:int;
			var iter	:int = 0;
			var gindex	:int;			
			while ( eps > _eps ) {
				if (iter > 200) break;
				if (_isMinimize){
					//поиск минимума:
					//худшая точка
					xh = Point( max( _coordinates ).point );
					xh_index = int( max( _coordinates ).index ) ;
					//лучшая точка
					xl = Point( min( _coordinates ).point );
					xl_index = int( min( _coordinates ).index ) ;
					//находим центр тяжести
					_centr = center( _coordinates, xh);
					//находим отраженную точку: xn+3 = xn+2 + alfa * ( xn+2  - xh )
					x_otr = reflection( xh, _centr);
					//выполняется ли f( xn+3 ) < f( xh ):
					if ( _optimizationFunc( x_otr.x, x_otr.y ) < _optimizationFunc( xl.x, xl.y ) ){
						//растяжение:
						x_rast = tension( x_otr, _centr );
						//выполняется ли f( xn+4 ) < f( xl ):
						if ( _optimizationFunc( x_rast.x, x_rast.y ) < _optimizationFunc( xl.x, xl.y ) ){
							//Заменяем xh на xn+4 (x_rast):
							_coordinates.x[xh_index] = x_rast.x;
							_coordinates.y[xh_index] = x_rast.y;
						} else {
							//Заменить xh на xn+3 ( x_otr )
							_coordinates.x[xh_index] = x_otr.x;
							_coordinates.y[xh_index] = x_otr.y;
						}
					} else {
						gindex = 3 - xh_index - xl_index;
						if ( _optimizationFunc( x_otr.x, x_otr.y ) > _optimizationFunc( _coordinates.x[gindex], _coordinates.y[gindex] ) ){
							if ( _optimizationFunc( x_otr.x, x_otr.y ) > _optimizationFunc( xh.x, xh.y ) ) {
								//Заменить xh на xn+3 ( x_otr )
								_coordinates.x[xh_index] = x_otr.x;
								_coordinates.y[xh_index] = x_otr.y;
							}
							//сжатие:
							x_sgat = compression( xh, _centr );
							if ( _optimizationFunc( x_sgat.x, x_sgat.y ) > _optimizationFunc( xh.x, xh.y ) ){
								//Редукция:
								reduction( _coordinates, xl );
							} else {
								//Заменить xh на xn+5 (x_sgat):
								_coordinates.x[xh_index] = x_sgat.x;
								_coordinates.y[xh_index] = x_sgat.y;
							}
						} else {
							//Заменить xh на xn+3 ( x_otr )
							_coordinates.x[xh_index] = x_otr.x;
							_coordinates.y[xh_index] = x_otr.y;
						}
					}
				} else {
					//поиск максимума:
					//худшая точка
					xh = Point( min( _coordinates ).point );
					xh_index = int( min( _coordinates ).index ) ;
					//лучшая точка
					xl= Point( max( _coordinates ).point );
					xl_index = int( max( _coordinates ).index ) ;
					//находим центр тяжести
					_centr = center( _coordinates, xh);
					//находим отраженную точку: xn+3 = xn+2 + alfa * ( xn+2  - xh )
					x_otr = reflection( xh, _centr);
					//выполняется ли f( xn+3 ) < f( xh ):
					if ( _optimizationFunc( x_otr.x, x_otr.y ) > _optimizationFunc( xl.x, xl.y ) ){
						//растяжение:
						x_rast = tension( x_otr, _centr );
						//выполняется ли f( xn+4 ) < f( xl ):
						if ( _optimizationFunc( x_rast.x, x_rast.y ) > _optimizationFunc( xl.x, xl.y ) ){
							//Заменяем xh на xn+4 (x_rast):
							_coordinates.x[xh_index] = x_rast.x;
							_coordinates.y[xh_index] = x_rast.y;
						} else {
							//Заменить xh на xn+3 ( x_otr )
							_coordinates.x[xh_index] = x_otr.x;
							_coordinates.y[xh_index] = x_otr.y;
						}
					} else {
						gindex = 3 - xh_index - xl_index;
						if ( _optimizationFunc( x_otr.x, x_otr.y ) < _optimizationFunc( _coordinates.x[gindex], _coordinates.y[gindex] ) ){
							if ( _optimizationFunc( x_otr.x, x_otr.y ) > _optimizationFunc( xh.x, xh.y ) ) {
								//Заменить xh на xn+3 ( x_otr )
								_coordinates.x[xh_index] = x_otr.x;
								_coordinates.y[xh_index] = x_otr.y;
							}
							//сжатие:
							x_sgat = compression( xh, _centr );
							if ( _optimizationFunc( x_sgat.x, x_sgat.y ) < _optimizationFunc( xh.x, xh.y ) ){
								//Редукция:
								reduction( _coordinates, xl );
							} else {
								//Заменить xh на xn+5 (x_sgat):
								_coordinates.x[xh_index] = x_sgat.x;
								_coordinates.y[xh_index] = x_sgat.y;
							}
						} else {
							//Заменить xh на xn+3 ( x_otr )
							_coordinates.x[xh_index] = x_otr.x;
							_coordinates.y[xh_index] = x_otr.y;
						}
					}
				}
				eps = 0;
				for( var i:int = 0; i < _coordinates.x.length; i++ ){
					var f1:Number = _optimizationFunc(_coordinates.x[i], _coordinates.y[i]);
					var f2:Number = _optimizationFunc(_centr.x, _centr.y);
					eps += Math.pow( f1 - f2, 2 );
				}
				for ( i = 0; i < _coordinates.x.length-1; i++ ){
					_area.drawLine( _coordinates.x[i], _coordinates.y[i], _coordinates.x[i+1], _coordinates.y[i+1], Palette.POLIGON_COLOR, 1 );
				}
				_area.drawLine( _coordinates.x[0], _coordinates.y[0], _coordinates.x[_coordinates.x.length - 1], _coordinates.y[_coordinates.x.length - 1], Palette.POLIGON_COLOR, 1 );
				eps = Math.pow( eps / 3, 0.5 );
				iter += 1;				
			}
			//Рисуем точку экстремума:
			_area.drawCircle( _coordinates.x[0] , _coordinates.y[0], 2, Palette.POLIGON_END );
			trace ( "iteration: " + iter + " " + _coordinates.x + " " + _coordinates.y + " err: " + eps );
		}
		
		//Нахождение центра тяжести многогранника:s
		private function center( coordinates:Object, badRes:Point ):Point{
			var res:Point = new Point();
			for ( var i:int; i < coordinates.x.length; i++ ){
				res.x += coordinates.x[i];
				res.y += coordinates.y[i];
			}
			res.x -= badRes.x;
			res.y -= badRes.y;
			res.x /= (coordinates.x.length-1);
			res.y /= (coordinates.y.length-1);
			return res;						
		}
		
		//Поиск точки многогранника, в котором функция принимает минимальное значение:
		private function min(coordinates:Object):Object{
			var res:Number = Number.MAX_VALUE;
			var point:Object = new Object();
			for ( var i:int = 0; i < coordinates.x.length; i++){
				if ( _optimizationFunc(coordinates.x[i], coordinates.y[i]) < res ){
					res = _optimizationFunc(coordinates.x[i], coordinates.y[i]);
					point.point = new Point(coordinates.x[i], coordinates.y[i]);
					point.index = i;
				}
			}
			return point;
		}
		
		//Поиск точки многогранника, в котором функция принимает максимальное значение:
		private function max(coordinates:Object):Object{
			var res:Number = -Number.MAX_VALUE;
			var point:Object = new Object();
			for ( var i:int = 0; i < coordinates.x.length; i++){
				if ( _optimizationFunc(coordinates.x[i], coordinates.y[i]) > res ){
					res = _optimizationFunc(coordinates.x[i], coordinates.y[i]);
					point.point = new Point(coordinates.x[i], coordinates.y[i]);
					point.index = i;
				}
			}
			return point;
		}
		
		//Отражение:
		private function reflection( xh:Point, _centr:Point ){
			var res:Point = new Point();
			res.x = _centr.x + _alfa * ( _centr.x - xh.x );
			res.y = _centr.y + _alfa * ( _centr.y - xh.y );
			return res;	
		}
		
		//Сжатие:
		private function compression( xh:Point, _centr:Point ){
			var res:Point = new Point();
			res.x = _centr.x + _beta * ( _centr.x - xh.x );
			res.y = _centr.y + _beta * ( _centr.y - xh.y );
			return res;	
		}
		
		//Растяжение:
		private function tension ( xh:Point, _centr:Point ):Point {
			var res:Point = new Point();
			res.x = _centr.x + _gamma * ( xh.x - _centr.x );
			res.y = _centr.y + _gamma * ( xh.y - _centr.y );
			return res;	
		}
		
		//Редукция:
		private function reduction ( coordinates:Object, xl:Point ){
			for ( var i:int = 0; i < coordinates.x.length; i++ ) {
				coordinates.x[i] = xl.x + 0.5 * ( coordinates.x[i] - xl.x );
				coordinates.y[i] = xl.y + 0.5 * ( coordinates.y[i] - xl.y );
			}
		}
		
		
	}
}