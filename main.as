package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.text.GridFitType;
	import GUI.Grid;
	import GUI.Gradient;
	
	
	public class main extends MovieClip {
		var xmin, xmax, ymin, ymax, startx, starty, dx, dy, minVal, maxVal, interval, xinterval, yinteval : Number;
		var xdots, ydots : uint;
		var res, lines:Array;
		var point:Shape;
		var added:Boolean;
		var linesCount:int; //Количество линий одинакового уровня
		
		const startColor:int 	= 0xffffff;	//черный
		const endColor:int   	= 0x000000; //белый
		const colors:int 		= /*startColor - endColor*/ 256;
		const gridWidth:Number 	= 540; //800 Длина сетки
		const gridHeight:Number = 540; //540 Высота сетки 
		const dotSize:Number 	= 1; //Размер точки на поверхности

		const eps:Number 		= 0.2; // Параметр определяющий точность рисования линий уровня
		
		
		public function main() {
			drawBtn.addEventListener( MouseEvent.CLICK, drawArea);
			startx = start_point.x;
			starty = start_point.y;
			point = new Shape();
			minVal = 16777215;
			maxVal = -16777215;
			
			
		}
		
		private function func(fx:Number, fy:Number):Number{
			return 3 * fx * fx  * fy + fy * fy * fy - 12 * fx - 15 * fx + 1;
		}
		
		private function addPoint(x:Number, y:Number, val:Number){			
			//if ( y == starty ) trace( (startColor-uint(colors*(val-minVal)/interval)*0x010101) + "->" + val);
			point.graphics.beginFill( startColor-uint(colors*(val-minVal)/interval)*0x010100, 1 );
			point.graphics.drawRect( x, y, dotSize, dotSize );
			this.addChild(point);
		}		
		
		
		private function drawPoints(){
			for ( var px:uint = 0; px < xdots; px++){
				for ( var py:uint = 0; py < ydots; py++){
					addPoint(px*dotSize+startx, py*dotSize + starty, res[px + py * xdots]);
				}
			}	
		}
		
		private function calculateGrid(){
			var tval:Number = 0;
			for ( var px:uint = 0; px < xdots; px++){
				for ( var py:uint = 0; py < ydots; py++){
					tval =  Number(func ( Number(px*xinterval + xmin), Number(py*yinteval + ymin) ));
					res[ px + py * xdots ] = tval;
					if (minVal > tval ) minVal = tval;
					if (maxVal < tval ) maxVal = tval;
				}
			}				
			//trace(minVal);
			//trace(maxVal);
			//trace (res[0] + " " + res[1] + " " + res[2] + " " + res[3] + " " + res[4] + " " + res[5] + " " + res[6]+ " " + res[7] + " " + res[8] + " " + res[9]);
			//trace ( minVal-colors*(res[0]-minVal)/interval) + " " + (minVal-colors*(res[1]-minVal)/interval) + " " + (minVal-colors*(res[2]-minVal)/interval) + " " + (minVal-colors*(res[3]-minVal)/interval) + " " + (minVal-colors*(res[4]-minVal)/interval) + " " + (minVal-colors*(res[5]-minVal)/interval) + " " + (minVal-colors*(res[6]-minVal)/interval) + " " + (minVal-colors*(res[7]-minVal)/interval) + " " + (minVal-colors*(res[8]-minVal)/interval) + " " + (minVal-colors*(res[9]-minVal)/interval) );
		}
		
		private function calculateLines(){
			for ( var i:int = 0; i < linesCount + 1; i++) {
				lines[i] = (maxVal - minVal) / linesCount * i + minVal;
			}
			/*trace ( lines.length ) ;
			trace( maxVal + " " + minVal );
			trace( lines );*/
		}
		
		private function drawLines(){
			for ( var px:uint = 0; px < xdots; px++){
				for ( var py:uint = 0; py < ydots; py++){
					added = false;
					for ( var i:int = 0; i < linesCount + 1; i++ ) {
						if ( res[px + py * xdots] - eps < lines[i] && res[px + py * xdots] + eps > lines[i] ){
							addLinePoint(px*dotSize+startx, py*dotSize + starty);
							added = true;
							break;
						}						
					}	
					if ( !added ) addPoint(px*dotSize+startx, py*dotSize + starty, res[px + py * xdots]);
				}
			}	
		}
		
		private function addLinePoint(x:Number, y:Number){			
			//if ( y == starty ) trace( (startColor-uint(colors*(val-minVal)/interval)*0x010101) + "->" + val);
			point.graphics.beginFill( 0x000000, 1 );
			point.graphics.drawRect( x, y, dotSize, dotSize );
			this.addChild(point);
		}		
		
		public function drawArea(me:MouseEvent){			
			xmin = Number(xmin_lbl.text);
			xmax = Number(xmax_lbl.text);
			ymin = Number(ymin_lbl.text);
			ymax = Number(ymax_lbl.text);
			linesCount = int(linesCountLbl.text) + 1;
			xdots = uint( gridWidth/dotSize );
			ydots = uint( gridHeight/dotSize );
			xinterval = (xmax - xmin) / xdots ;
			yinteval = (ymax - ymin) / ydots;
//			dx = (xmax - xmin)/xdots;
//			dy = (ymax - ymin)/ydots;
			res = new Array(xdots*ydots + 1);
			lines = new Array(linesCount + 1);
			//trace(xmin + " " + xmax + " " + ymin + " " + ymax + " " + xdots + " " + ydots); 
			calculateGrid();
			interval = maxVal - minVal;
			minValLbl.text = minVal;
			maxValLbl.text = maxVal;
			calculateLines();
			//trace ( (minVal+colors*(res[0]-minVal)/interval) + " " + (minVal-colors*(res[1]-minVal)/interval) + " " + (minVal-colors*(res[2]-minVal)/interval) + " " + (minVal-colors*(res[3]-minVal)/interval) + " " + (minVal-colors*(res[4]-minVal)/interval) + " " + (minVal-colors*(res[5]-minVal)/interval) + " " + (minVal-colors*(res[6]-minVal)/interval) + " " + (minVal-colors*(res[7]-minVal)/interval) + " " + (minVal-colors*(res[8]-minVal)/interval) + " " + (minVal-colors*(res[9]-minVal)/interval) );
			//drawPoints();				
			drawLines();
			var gradient:Gradient = new Gradient();
			gradient.x = startx + gridWidth + 20;
			minValLbl.x = startx + gridWidth + 22 + 7;
			maxValLbl.x = startx + gridWidth + 22 + 7;
			gradient.y = starty;
			gradient.width = 22;
			gradient.height = gridHeight;
			addChild(gradient);
			var grid:Grid = new Grid(xmin, xmax, ymin, ymax);
			grid.x = startx;
			grid.y = starty;
			grid.scaleX = gridWidth / 800;
			grid.scaleY = gridHeight / 540;
			
			addChild(grid);
			//trace( func( -4, -4 ));
			//trace(maxVal + " " + minVal);
		}
	}
	
}
