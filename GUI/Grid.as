package GUI
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Grid extends Sprite
	{
		private var _bitmap		: Bitmap;
		private var _bitmapdata	: BitmapData;
		private const LINES		: int = 9;

		public function Grid( gridWidth:int, gridHeight:int )
		{
			_bitmapdata = new BitmapData(gridWidth,gridHeight,true,0xffffff);
			_bitmap = new Bitmap(_bitmapdata);
			this.addChild( _bitmap );
			drawGrid( gridWidth, gridHeight );
		}

		private function drawGrid( gridWidth:int, gridHeight:int )
		{
			for (var tx:int = 0; tx < gridWidth; tx ++)
			{
				for (var line:int = 0; line < LINES; line ++)
				{
					_bitmapdata.setPixel32( tx, uint(gridHeight/(LINES-1)*line), 0xff000000 );
				}
			}
			for (var ty:int = 0; ty < gridHeight; ty ++)
			{
				for ( line = 0; line < LINES; line ++)
				{
					_bitmapdata.setPixel32( uint( gridWidth/(LINES-1)*line ), ty , 0xff000000 );
				}
			}
		}

	}

}