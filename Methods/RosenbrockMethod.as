package Methods{
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.Area;
	import GUI.Palette;

	public class RosenbrockMethod extends Sprite {
		private const ALFA = 3;
		private const BETTA = -0.5;

		private var _eps			: Number;// Точность с которой ищем экстремум
		private var _l1 			: Number;// Лямбда 1
		private var _l2 			: Number;// Лямбда 2
		private var _l1sum 			: Number;// Путь успешных лямбда 1
		private var _l2sum			: Number;// Путь успешных лямбда 2
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

		public function RosenbrockMethod( startX:Number, startY:Number, l1:Number, l2:Number, optimizationFunction:Function, 
		area:Area, eps:Number = 0.000001, showFailures:Boolean = false, optimizationType:String = "minimize") {
			// Блок инициализации :
			if ( optimizationType == "minimize" ) {
				_isMinimize = true;
			} else {
				_isMinimize = false;
			}
			_eps 	= eps;
			_l1 	= l1;
			_l2 	= l2;
			_area 	= area;
			_showFailures 		= showFailures;
			_optimizationFunc	= optimizationFunction;
			_currentPoint 	= new Point(startX,startY);
			_s1 			= new Point(1,0);
			_s2 			= new Point(0,1);
			_prevF 			= f(_currentPoint);
			_prevPoint 		= _currentPoint;
			_successWas = false;
			_l1sum 		= 0;
			_l2sum 		= 0;
		}



		public function find() {
			_iterations++;
			var suc:int = 0;
			if (findS(_s1,_l1)) {
				_currentPoint = fs(_s1,_l1);
				_l1sum +=  _l1;
				_l1 *=  ALFA;
				suc++;
			} else {
				_l1 *=  BETTA;
			}
			if (findS(_s2,_l2)) {
				_currentPoint = fs(_s2,_l2);
				_l2sum +=  _l2;
				_l2 *=  ALFA;
				suc++;
			} else {
				_l2 *=  BETTA;
			}
			if (suc == 2) {
				_successWas = true;
			}

			if ( suc == 0 && _successWas == true ) {
				//ищем новое направление:
				var A1,A2:Point;
				_successWas = false;
				A1 = pointSumm( pointMulNum( _s1, _l1sum ), pointMulNum( _s2 ,_l2sum ) );
				A2 = pointMulNum( _s2, _l2sum );
				_l1sum = 0;
				_l2sum = 0;
				_s1 = newS( A1 );
				_s2 = newS( B2( A2,_s1 ) );
				trace( _currentPoint );
				_area.drawLine( _prevPoint.x, _prevPoint.y, _currentPoint.x, _currentPoint.y, Palette.POLIGON_COLOR, 1);
				if ( Math.abs( _prevF - f(_currentPoint) ) < _eps) {
					_area.drawCircle( _currentPoint.x, _currentPoint.y, 2, Palette.POLIGON_END );
					return;
				}
				_prevF = f(_currentPoint);
				_prevPoint = _currentPoint;
			}

			if (Math.abs(_l1) < Math.abs(_eps) && _l2 < _eps) {
				trace( "Finish : " + _currentPoint);
				_area.drawCircle( _currentPoint.x, _currentPoint.y, 2, Palette.POLIGON_END );
				return;
			}
			find();
		}

		// Расчет значения функции в указанной точке:
		private function f( point:Point ) {
			return _optimizationFunc( point.x, point.y );
		}

		// Возвращает точку X + LAMBDA(i) * S(i);
		private function fs( s:Point, lamda:Number ):Point {
			return new Point( _currentPoint.x + lamda * s.x, _currentPoint.y + lamda * s.y);
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

		// Возвращает сумму двух точек:
		private function pointSumm( p1:Point, p2:Point):Point {
			return new Point( p1.x + p2.x, p1.y + p2.y );
		}
		
		// Возвращает произведение точки на число:
		private function pointMulNum( p:Point, num:Number ):Point {
			return new Point( p.x * num, p.y * num );
		}
		
		// S транспонированное / (Длинну вектора S )
		private function newS( A:Point ):Point {
			return new Point( A.x / A.length, A.y / A.length);
		}

		// Нахождение B2:
		private function B2( A2:Point, S1:Point ):Point {
			var mul1:Number = A2.x * S1.x + A2.y * S1.y;
			var mul2:Point = pointMulNum(S1,mul1);
			var res:Point = new Point(A2.x - mul2.x,A2.y - mul2.y);
			return res;
		}


	}
}