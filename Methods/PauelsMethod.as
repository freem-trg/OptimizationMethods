package Methods {
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.Area;
	import GUI.Palette;
	
	public class PauelsMethod extends Sprite {
		private const ALFA = 3;
		private const BETTA = -0.1;

		private var _eps			: Number;// Точность с которой ищем экстремум
		private var _l1 			: Number;// Лямбда 1
		private var _l2 			: Number;// Лямбда 2
		private var _sl				: Number;
//		private var _l1sum 			: Number;// Путь успешных лямбда 1
//		private var _l2sum			: Number;// Путь успешных лямбда 2
		private var _prevF			: Number;// Значение функции на предыдущем этапе

		private var _prevPoint		: Point;// Предыдущая точка
		private var _currentPoint	: Point;// Текущая точка
		private var _s1				: Point;// Матрица S1
		private var _s2				: Point;// Матрица S2


		private var _area 				: Area;// Для отрисовки процесса поиска
		private var _optimizationFunc	: Function;// Функция, которую мы оптимизируем
		private var _showFailures		: Boolean;// Параметр отвечающий за отображение неудачных шагов
		private var _isMinimize			: Boolean;// Параметр отвечающий за поиск максимума/минимума
		private var _successWas			: Boolean;// Параметр, показывающий были ли 2 удачных шага подряд
		private var _iterations 		: uint = 0;// Счетчик количества итераций
		
		
		public function PauelsMethod(startX:Number, startY:Number, l1:Number, l2:Number, optimizationFunction:Function, 
				area:Area, eps:Number = 0.000000001, showFailures:Boolean = false, optimizationType:String = "minimize") {
			// Блок инициализации :
			if ( optimizationType == "minimize" ) {
				_isMinimize = true;
			} else {
				_isMinimize = false;
			}
			_eps 	= eps;
			_l1 	= l1;
			_l2 	= l2;
			_sl = l1;
			_area 	= area;
			_showFailures 		= showFailures;
			_optimizationFunc	= optimizationFunction;
			_currentPoint 	= new Point(startX,startY);
			_s1 			= new Point(1,0);
			_s2 			= new Point(0,1);			
		}
		
		
		
		// Расчет значения функции в указанной точке:
		private function f( point:Point ) {
			return _optimizationFunc( point.x, point.y );
		}
		
		// Функция, которая показывает, является ли удачной точка X + LAMBDA(i) * S(i):
		private function findS( s:Point, lamda:Number ):Boolean {
			var newPoint:Point = new Point();
			newPoint = fs(s,lamda);
			if (_isMinimize) {
				//Ищем минимум:
				if ( f(_currentPoint) > f ( newPoint ) ) {
					return true;
				} else {
					return false;
				}
			} else {
				//максимум:
				if ( f(_currentPoint) < f ( newPoint ) ) {
					return true;
				} else {
					return false;
				}
			}
		}
				
		// Возвращает точку X + LAMBDA(i) * S(i);
		private function fs( s:Point, lamda:Number ):Point {
			return new Point( _currentPoint.x + lamda * s.x, _currentPoint.y + lamda * s.y);
		}
		
		public function find(){
			_prevF = f(_currentPoint);
			_prevPoint = _currentPoint;
			_l2 = singleDimensionalOptimization( _s2, _l2 );
			_l1 = singleDimensionalOptimization( _s1, _l1 );
/*			_s1 = _s2;
			_s2 = new Point( 2*_currentPoint.x + _prevPoint.x, 2*_currentPoint.y - _prevPoint.y );*/
			if ( Math.abs( _prevF - f(_currentPoint) ) < _eps && Math.abs(_l1) < _eps && Math.abs(_l2) < _eps ) {
				trace( "Finished : " + _currentPoint );
				_area.drawCircle( _currentPoint.x, _currentPoint.y, 2, Palette.POLIGON_END);
				return;
			}
			_area.drawLine( _prevPoint.x, _prevPoint.y, _currentPoint.x, _currentPoint.y, Palette.POLIGON_COLOR, 1 );
			if (_iterations > 100000 ) {
				trace ("Aborted : " + _currentPoint );
				return;
			}
			//trace( _currentPoint );
			find();
		}
		
		private function singleDimensionalOptimization( s:Point, l:Number ):Number {
			_iterations ++;
			var prevF:Number = f(_currentPoint);
			if (_iterations > 100000 ) {
				trace ("Aborted : " + _currentPoint );
				return l;
			}
			if (findS(s, l)) {
				_currentPoint = fs( s, l );
				l *=  ALFA;
			} else {
				l *=  BETTA;
			}
			if ( Math.abs( prevF - f(_currentPoint) ) < _eps ) {
				//trace( _currentPoint );
				return l;
			}
			return singleDimensionalOptimization( s, l );
		}
		
	}
	
	
}