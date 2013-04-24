package Methods{
	import flash.display.Sprite;
	import GUI.Area;
	import GUI.Palette;
	import flash.geom.Point;

	public class GradientDescent extends Sprite {

		private var _optimizationFunc:Function;// Функция, которую мы оптимизируем
		private var _showFailures:Boolean;// Параметр, отвечающий за отображение неудачных шагов
		private var _area:Area;// Отрисовка процесса поиска
		private var _step:Number;
		private var _exploringFalures:uint;
		private var _isMinimize:Boolean;
		private var _eps:Number = 0.0001;

		public function FindGradient( xpos :Number, ypos :Number, r :Number ):Point {
			var gradient:Point = new Point(0,0);
			var valueInGradient:Number =  -  Number.MAX_VALUE;

			for (var i :int = 0; i < 360; i++) {
				var sin :Number = Math.sin( i * Math.PI / 180 );
				var cos :Number = Math.cos( i * Math.PI / 180 );
				if ( _optimizationFunc( xpos + r * sin, ypos + r * cos ) > valueInGradient ) {
					valueInGradient = _optimizationFunc( xpos + r * sin, ypos + r * cos );
					gradient.x = sin;
					gradient.y = cos;
				}
			}
			return gradient;
		}

		private function isBetter( oldPoint:Point, newPoint:Point ):Boolean {
			if ( _optimizationFunc( oldPoint.x, oldPoint.y ) > _optimizationFunc( newPoint.x, newPoint.y ) ) {
				if (_isMinimize) {
					return true;
				} else {
					return false;
				}
			} else {
				if (_isMinimize) {
					return false;
				} else {
					return true;
				}
			}
		}

		public function find( sx:Number, sy:Number, step:Number ) {
			var _sx,_sy,_step,_newX,_newY:Number;
			var df:Number = Number.MAX_VALUE;
			var grad:Point;
			_sx = sx;
			_sy = sy;
			_step = step;
			var iter:int = 0;
			while ( df > _eps || iter < 100 ) {
				iter ++;
				grad = FindGradient(_sx,_sy,_eps);
				if (_isMinimize) {
					_newX = _sx - _step * grad.x;
					_newY = _sy - _step * grad.y;
				} else {
					_newX = _sx + _step * grad.x;
					_newY = _sy + _step * grad.y;
				}
				if ( isBetter( new Point( _sx, _sy ) , new Point( _newX, _newY ) ) ) {
					_area.drawLine( _sx, _sy, _newX, _newY, Palette.EXPLORE_SUCCESS_COLOR );
					_sx = _newX;
					_sy = _newY;
					df = Math.abs( _optimizationFunc( _sx, _sy ) - _optimizationFunc( _newX, _newY ) );
				} else {
					_step /= 10;
				}
			}
			trace( _sx + " " + _sy );
		}

		public function GradientDescent( startX:Number, startY:Number, startStep:Number, optimizationFunction:Function, 
		 area:Area, showFailures:Boolean = false, optimizationType:String = "minimize") {
			// Блок инициализации :
			if ( optimizationType == "minimize" ) {
				_isMinimize = true;
			} else {
				_isMinimize = false;
			}
			_step = startStep;
			this._optimizationFunc = optimizationFunction;
			this._showFailures = showFailures;
			this._area = area;
			_exploringFalures = 0;
			//Начало поиска:
			find( startX, startY, startStep );
		}


	}

}