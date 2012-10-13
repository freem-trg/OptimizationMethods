package GUI
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import GUI.Palette;

	public class Gradient extends Sprite
	{
		private var _bitmap		: Bitmap;
		private var _bitmapdata	: BitmapData;
		private var _palette	: Palette;

		public function Gradient( gradWidth:int, gradHeight:int )
		{
			_palette = new Palette();
			_bitmapdata = new BitmapData( gradWidth, gradHeight, true, 0xffffff );
			_bitmap = new Bitmap( _bitmapdata );
			this.addChild( _bitmap );
			drawGradient( gradWidth, gradHeight );
		}

		private function drawGradient( gradWidth:int, gradHeight:int )
		{	
			var lineHeight:uint = gradHeight / _palette.COLORS;
			var lines:uint = gradHeight / lineHeight;
			for ( var i:int = 0; i < lines; i++ ) {
				for ( var j:int = 0; j < lineHeight; j++ ){
					for (var w:int = 0; w < gradWidth; w++) {
						if ( j == 0 && i % 16 == 0) {
							_bitmapdata.setPixel32( w, j + i*lineHeight, 0xff000000 );
						} else {
							_bitmapdata.setPixel32( w, j + i*lineHeight, 0xff000000 + _palette.getColor( _palette.COLORS - ( i+1 ) ) );
						}
						
					}
				}
			}

		}

	}

}