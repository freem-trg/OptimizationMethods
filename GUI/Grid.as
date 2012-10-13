package  GUI {
	
	import flash.display.MovieClip;
	
	
	public class Grid extends MovieClip {
		
		
		public function Grid(minX:int, maxX:int, minY:int, maxY:int) {
			lx1.text = String(minX);
			ly1.text = String(minY);
			lx9.text = String(maxX);
			ly9.text = String(maxY);
			lx2.text = String( (maxX - minX)/8 * 1 + minX );
			ly2.text = String( (maxY - minY)/8 * 1 + minY );
			lx3.text = String( (maxX - minX)/8 * 2 + minX );
			ly3.text = String( (maxY - minY)/8 * 2 + minY );
			lx4.text = String( (maxX - minX)/8 * 3 + minX );
			ly4.text = String( (maxY - minY)/8 * 3 + minY );
			lx5.text = String( (maxX - minX)/8 * 4 + minX );
			ly5.text = String( (maxY - minY)/8 * 4 + minY );
			lx6.text = String( (maxX - minX)/8 * 5 + minX );
			ly6.text = String( (maxY - minY)/8 * 5 + minY );
			lx7.text = String( (maxX - minX)/8 * 6 + minX );
			ly7.text = String( (maxY - minY)/8 * 6 + minY );
			lx8.text = String( (maxX - minX)/8 * 7 + minX );
			ly8.text = String( (maxY - minY)/8 * 7 + minY );

			
		}
	}
	
}
