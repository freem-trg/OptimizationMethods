package Methods {
	import flash.display.Sprite;
	import GUI.Area;
	import GUI.Palette;
	import flash.geom.Point;
	
	public class HookDjivsMethod extends Sprite {
		
		private var _optimizationFunc	: Function ; // Функция, которую мы оптимизируем
		private var _showFailures		: Boolean ;	// Параметр, отвечающий за отображение неудачных шагов
		private var _dx					: Number ;	// Приращение по переменной х
		private var _dy					: Number ;	// Приращение по переменной у
		private var _area 				: Area ;	// Отрисовка процесса поиска
		private var _prevBasis			: Point;
		private var _basis				: Point;
		private var _exploringFalures	: uint;
		private var _startDx			: Number;
		private var _startDy			: Number;
		private var _isMinimize			: Boolean;
		
		public function HookDjivsMethod( startX:Number, startY:Number, dx:Number, dy:Number, optimizationFunction:Function, 
										area:Area, showFailures:Boolean = false, optimizationType:String = "minimize"){
			// Блок инициализации :
			if ( optimizationType == "minimize" ) {
				_isMinimize = true;
			} else {
				_isMinimize = false;
			}
			_prevBasis 	= new Point( startX, startY );
			_basis		= new Point( startX, startY );
			this._optimizationFunc 	= optimizationFunction;
			this._showFailures 		= showFailures;
			this._dx 				= dx;
			this._dy				= dy;
			this._startDx			= dx;
			this._startDy			= dy;
			this._area				= area;
			_exploringFalures 		= 0;
			//Начало поиска:
			exploringSearch( startX, startY );
		}
		
		private function compare ( x1:Number, y1:Number, x2:Number, y2:Number ) : Boolean {
			if ( _isMinimize ){
				if ( _optimizationFunc( x1, y1 ) > _optimizationFunc( x2, y2 ) ) return true;
				else return false;
			} else {
				if ( _optimizationFunc( x1, y1 ) < _optimizationFunc( x2, y2 ) ) return true;
				else return false;
			}
		}
		
		private function exploringSearch ( searchX:Number, searchY:Number ){
			var failuresCount:uint = 0;
			//+dx
			//trace( "explore" );
			if ( compare( searchX, searchY, searchX + _dx, searchY ) ) {
				_area.drawLine( searchX, searchY, searchX + _dx, searchY, Palette.EXPLORE_SUCCESS_COLOR );
				_basis.x = searchX + _dx;
				searchX += _dx;				
				//рисование удачи
			} else {
				failuresCount += 1;
				//рисование неудачи
				_area.drawLine( searchX, searchY, searchX + _dx, searchY, Palette.EXPLORE_FAILURE_COLOR );
			}
			//-dx
			if ( compare( searchX, searchY, searchX - _dx, searchY ) ) {
				_area.drawLine( searchX, searchY, searchX - _dx, searchY, Palette.EXPLORE_SUCCESS_COLOR );
				_basis.x = searchX - _dx;
				searchX -= _dx;
				//рисование удачи
			} else {
				failuresCount += 1;
				//рисование неудачи
				_area.drawLine( searchX, searchY, searchX - _dx, searchY, Palette.EXPLORE_FAILURE_COLOR );
			}
			//+dy
			if ( compare( searchX, searchY, searchX , searchY + _dy ) ) {
				_area.drawLine( searchX, searchY, searchX , searchY + _dy, Palette.EXPLORE_SUCCESS_COLOR );
				_basis.y = searchY + _dy;
				searchY += _dy;
				//рисование удачи
			} else {
				failuresCount += 1;
				//рисование неудачи
				_area.drawLine( searchX, searchY, searchX , searchY + _dy, Palette.EXPLORE_FAILURE_COLOR );
			}
			//-dy
			if ( compare( searchX, searchY, searchX , searchY - _dy ) ) {
				_area.drawLine( searchX, searchY, searchX , searchY - _dy, Palette.EXPLORE_SUCCESS_COLOR );
				_basis.y = searchY - _dy;
				searchY -= _dy;
				//рисование удачи
			} else {
				failuresCount += 1;
				//рисование неудачи
				_area.drawLine( searchX, searchY, searchX , searchY - _dy, Palette.EXPLORE_FAILURE_COLOR );
			}
			if ( failuresCount < 4 ) {
				acceleratingSearch();
			} else {
				_exploringFalures += 1;
				_dx = _dx*( _startDx / Math.exp( _exploringFalures ) );
				_dy = _dy*( _startDy / Math.exp( _exploringFalures ) );
				//trace( _exploringFalures );
				if ( _exploringFalures < 3 ) {
					exploringSearch( searchX, searchY ); // Начинаем поиск в той же точке с новыми dx и dy
				} else {
					trace( "Экстремум: " + searchX + " ; " + searchY );
				}
				
			}
			
		}
		
		private function acceleratingSearch ( ) {
			//trace( "accelerate" );
			var acceleratingPoint:Point = new Point();
			var tmp:Point = new Point( _basis.x, _basis.y );
			acceleratingPoint.x = 2 * _basis.x - _prevBasis.x;
			acceleratingPoint.y = 2 * _basis.y - _prevBasis.y;
			
			var failuresCount:uint = 0;
			//+dx
			if ( compare( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x + _dx, acceleratingPoint.y ) ) {
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x + _dx, acceleratingPoint.y, Palette.ACCELERATE_SUCCESS_COLOR );
				acceleratingPoint.x += _dx;
				//рисование удачи
			} else {
				failuresCount += 1;
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x + _dx, acceleratingPoint.y, Palette.ACCELERATE_FAILURE_COLOR );
				//рисование неудачи
			}
			//-dx
			if ( compare( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x - _dx, acceleratingPoint.y ) ) {
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x - _dx, acceleratingPoint.y, Palette.ACCELERATE_SUCCESS_COLOR );
				acceleratingPoint.x -= _dx;
				//рисование удачи
			} else {
				failuresCount += 1;
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x - _dx, acceleratingPoint.y, Palette.ACCELERATE_FAILURE_COLOR );
				//рисование неудачи
			}
			//+dy
			if ( compare( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y + _dy ) ) {
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y + _dy, Palette.ACCELERATE_SUCCESS_COLOR );
				acceleratingPoint.y += _dy;
				//рисование удачи
			} else {
				failuresCount += 1;
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y + _dy, Palette.ACCELERATE_FAILURE_COLOR );
				//рисование неудачи
			}
			//-dy
			if ( compare( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y - _dy ) ) {
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y - _dy, Palette.ACCELERATE_SUCCESS_COLOR );
				acceleratingPoint.x -= _dy;
				//рисование удачи
			} else {
				failuresCount += 1;
				_area.drawLine( acceleratingPoint.x, acceleratingPoint.y, acceleratingPoint.x, acceleratingPoint.y - _dy, Palette.ACCELERATE_FAILURE_COLOR );
				//рисование неудачи
			}
			if ( failuresCount < 4) {
				if (  compare( _basis.x, _basis.y, acceleratingPoint.x, acceleratingPoint.y ) ) {
					_prevBasis = _basis;
					_basis = acceleratingPoint;
					acceleratingSearch();
				} else {
					exploringSearch( _basis.x, _basis.y );
				}
			} else {
				exploringSearch( _basis.x, _basis.y );
			}
		}
		
		
	}
	
}