package GUI
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import Other.CustomEvents;

	public class Nelder_panel extends MovieClip
	{

		private var _isMinimized:Boolean;
		private var _isMax		:Boolean;

		public function Nelder_panel()
		{
			_isMinimized = true;			
			show_btn.addEventListener( MouseEvent.CLICK, showPanel );
			
		}
		
		private function setToggles ( isMax:Boolean ) {
			_isMax = isMax;
			if ( _isMax )
			{
				params_panel.max_toggle.gotoAndStop( 2 );
				params_panel.min_toggle.gotoAndStop( 1 );
			} else {
				params_panel.max_toggle.gotoAndStop( 1 );
				params_panel.min_toggle.gotoAndStop( 2 );
			}
		}
		
		public function get isMax():String {
			if ( _isMax ) return "maximize";
			else 		  return "minimize";
		}
		
		private function calculateBtnClk ( me:MouseEvent ) {
			this.dispatchEvent( new Event(CustomEvents.CALCULATE) );
		}
		
		public function get startX():Array{
			var xarr:Array = new Array(3);
			xarr[0] = Number ( params_panel.startx1_lbl.text );
			xarr[1] = Number ( params_panel.startx2_lbl.text );
			xarr[2] = Number ( params_panel.startx3_lbl.text );			
			return xarr;
		}
		
		public function get startY():Array{
			var yarr:Array = new Array(3);
			yarr[0] = Number ( params_panel.starty1_lbl.text );
			yarr[1] = Number ( params_panel.starty2_lbl.text );
			yarr[2] = Number ( params_panel.starty3_lbl.text );			
			return yarr;
		}
				
		public function get startEps():Number{
			return Number ( params_panel.eps_lbl.text );
		}
		
		private function maxToggleClk ( me:MouseEvent = null ){
			setToggles( true );
		}
		
		private function minToggleClk ( me:MouseEvent = null ){
			setToggles( false );
		}

		public function showPanel( me:MouseEvent = null )
		{
			if (_isMinimized) { 
				params_panel.gotoAndPlay( 2 ); 
				setToggles( false );
				params_panel.max_toggle.addEventListener( MouseEvent.CLICK, maxToggleClk );
				params_panel.min_toggle.addEventListener( MouseEvent.CLICK, minToggleClk );
				params_panel.calculate_btn.addEventListener( MouseEvent.CLICK, calculateBtnClk );
			}
			
			else {				
				params_panel.max_toggle.removeEventListener( MouseEvent.CLICK, maxToggleClk );
				params_panel.min_toggle.removeEventListener( MouseEvent.CLICK, minToggleClk );
				params_panel.calculate_btn.removeEventListener( MouseEvent.CLICK, calculateBtnClk );
				params_panel.gotoAndStop( 1 );
			}
			_isMinimized = ! _isMinimized;
			

		}

	}
}