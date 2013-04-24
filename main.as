package  {	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import GUI.Area;
	import Methods.HookDjivsMethod;
	import Methods.NelderMidMethod;
	import Methods.RosenbrockMethod;
	import Methods.PauelsMethod;
	import Methods.GradientDescent;
	import Other.CustomEvents;
	import flash.ui.MouseCursor;

	
	public class main extends MovieClip {
		var xmin, xmax		: Number;
		var ymin, ymax 		: Number;
		var startx, starty 	: Number;
		var linesEps		: Number;
		var lines			: int;
		var area			: Area;
		var curFunc			: Function;
		
		private function func6( fx:Number, fy:Number ) : Number {
			var res:Number = 100*(fy - fx*fx)*(fy - fx*fx) + ( 1 - fx )*( 1 - fx );
			return res;
		}
		
		private function func4( fx:Number, fy:Number ):Number{
			var res:Number = 4*( fx - 5)*( fx - 5 ) + ( fy - 6 )*( fy - 6 );
			return res;
		}
		
		public function addTrace( msg:String ){
			this.tracer.text += msg + "\n";
		}
		
		private function func(fx:Number, fy:Number):Number{
			var res:Number = 3*( fx*fx )*fy + fy*fy*fy - 12*fx - 15*fy + 1;
			return res;
		}
		
		private function func5(fx:Number, fy:Number):Number{
			return fx*fx - fx*fy + fy*fy - 2 * fx + fy;
		}
		
		private function func2(fx:Number, fy:Number):Number{
			return 3*( fx*fx ) + fy*fy - 12*fx - 15*fy + 1;
		}
		
		private function func3( fx:Number, fy:Number) {
			return (1-fx)*(1-fx) + 10*(fy-fx*fx)*(fy-fx*fx);
		}
		
		public function main() {
			curFunc = func2;
			drawBtn.addEventListener( MouseEvent.CLICK, drawArea);
			startx = start_point.x;
			starty = start_point.y;
			area = new Area( 512, 512, 0, 0, 0, 0, 0, 0, func );
			area.x = startx;
			area.y = starty;
			this.addChild(area);						
			clearMethodsLinesBtn.addEventListener ( MouseEvent.CLICK, clearMethodsLines );

			

		}
		

		
		private function drawArea( me:MouseEvent ) { 			
			xmin = Number( xmin_lbl.text );
			xmax = Number( xmax_lbl.text );
			ymin = Number( ymin_lbl.text );
			ymax = Number( ymax_lbl.text );
			lines = int( linesCountLbl.text );
			linesEps = Number( linesEpsLbl.text );
			area.update( xmin, xmax, ymin, ymax, lines, linesEps, curFunc );
			//area.drawLine( 0.5, 6, 3, 10, 0xff0000 );
			
			//area.removeMethodLines();
			//var hj2:HookDjivsMethod = new HookDjivsMethod( 0, 0, 0.3, 0.3, func2, area, false, "maximize" );
			hj_properties.addEventListener ( CustomEvents.CALCULATE, create_HJmethod );
			rosenbrock_properties.addEventListener ( CustomEvents.CALCULATE, create_rosenbrock_method );
			pauels_properties.addEventListener ( CustomEvents.CALCULATE, create_pauels_method );
			nelder_properties.addEventListener ( CustomEvents.CALCULATE, create_nelder_method );
			//var nm:NelderMidMethod = new NelderMidMethod( [-1, 0, 1], [2.2, 3.5, 2.5], func, area );
			//nm.find();
			//var rose:RosenbrockMethod = new RosenbrockMethod ( 0.1, 2, 0.2, 0.2, func, area );
			//rose.find();
			//var pm:PauelsMethod = new PauelsMethod( 0, 0, 0.1, 0.1, func, area );
			//pm.find();
			
			
		}
		
		private function create_nelder_method ( CustomEvents = null) {
			var sx, sy, eps : Number;
			var isMax 			 : String;
			sx 		= nelder_properties.startX;
			sy 		= nelder_properties.startY;
			eps		= nelder_properties.startEps;
			isMax 	= nelder_properties.isMax;
			var nel:NelderMidMethod = new NelderMidMethod( sx, sy, curFunc, area, this, eps, false, isMax);
			nel.find();
		}
		
		private function create_pauels_method ( CustomEvents = null) {
			var sx, sy, sl1, sl2, eps : Number;
			var isMax 			 : String;
			sx 		= pauels_properties.startX;
			sy 		= pauels_properties.startY;
			sl1 	= pauels_properties.startL1;
			sl2 	= pauels_properties.startL2;
			eps		= pauels_properties.startEps;
			isMax 	= pauels_properties.isMax;
			//trace ( sx + " " + sy + " " + sdx + " " + sdy + " " + isMax );
			var pau:PauelsMethod = new PauelsMethod( sx, sy, sl1, sl2, curFunc, area, eps, false, isMax);
			pau.find();
		}
		
		private function create_rosenbrock_method ( CustomEvents = null) {
			var sx, sy, sl1, sl2, eps : Number;
			var isMax 			 : String;
			sx 		= rosenbrock_properties.startX;
			sy 		= rosenbrock_properties.startY;
			sl1 	= rosenbrock_properties.startL1;
			sl2 	= rosenbrock_properties.startL2;
			eps		= rosenbrock_properties.startEps;
			isMax 	= rosenbrock_properties.isMax;
			//trace ( sx + " " + sy + " " + sdx + " " + sdy + " " + isMax );
			var ros:RosenbrockMethod = new RosenbrockMethod( sx, sy, sl1, sl2, curFunc, area, eps, false, isMax);
			ros.find();
		}
		
		private function create_HJmethod ( CustomEvents = null) {
			var sx, sy, sdx, sdy : Number;
			var isMax 			 : String;
			sx 		= hj_properties.startX;
			sy 		= hj_properties.startY;
			sdx 	= hj_properties.startDx;
			sdy 	= hj_properties.startDy;
			isMax 	= hj_properties.isMax;
			//trace ( sx + " " + sy + " " + sdx + " " + sdy + " " + isMax );
			var hj:HookDjivsMethod = new HookDjivsMethod( sx, sy, sdx, sdy, curFunc, area, this, false, isMax);
			this.addChild( hj );
		}
		
		private function clearMethodsLines ( me:MouseEvent = null) {
			area.removeMethodLines();
			//var gd:GradientDescent = new GradientDescent( 0, 0, 1, func, area, false, "minimize" );
			
		}
		
	}
}
