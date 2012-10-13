package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import GUI.Area;
	
	public class main extends MovieClip {
		var xmin, xmax		: Number;
		var ymin, ymax 		: Number;
		var startx, starty 	: Number;
		var linesEps		: Number;
		var lines			: int;
		var area			: Area;
		
		public function main() {
			drawBtn.addEventListener( MouseEvent.CLICK, drawArea);
			startx = start_point.x;
			starty = start_point.y;
			area = new Area( 512, 512, 0, 0, 0, 0, 0, 0, func );
			area.x = startx;
			area.y = starty;
			this.addChild(area);			
		}
		
		private function func(fx:Number, fy:Number):Number{
			return 3*( fx*fx )*fy + fy*fy*fy - 12*fx - 15*fy + 1;
		}
		
		private function func2(fx:Number, fy:Number):Number{
			return 3*( fx*fx ) + fy*fy - 12*fx - 15*fy + 1;
		}
		
		private function drawArea( me:MouseEvent ) { 			
			xmin = Number( xmin_lbl.text );
			xmax = Number( xmax_lbl.text );
			ymin = Number( ymin_lbl.text );
			ymax = Number( ymax_lbl.text );
			lines = int( linesCountLbl.text );
			linesEps = Number( linesEpsLbl.text );
			area.update( xmin, xmax, ymin, ymax, lines, linesEps, func );
		}
		
	}
}
