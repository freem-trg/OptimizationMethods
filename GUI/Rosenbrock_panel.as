package GUI
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import Other.CustomEvents;

	public class Rosenbrock_panel extends MovieClip
	{

		private var _isMinimized:Boolean;
		private var _isMax		:Boolean;

		public function Rosenbrock_panel()
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
		
		public function get startX():Number{
			return Number ( params_panel.startx_lbl.text );
		}
		
		public function get startY():Number{
			return Number ( params_panel.starty_lbl.text );
		}
		
		public function get startL1():Number{
			return Number ( params_panel.l1_lbl.text );
		}
		
		public function get startL2():Number{
			return Number ( params_panel.l2_lbl.text );
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
				main(this.parent).pauels_properties.y += params_panel.height;
				main(this.parent).nelder_properties.y += params_panel.height;
			}
			
			else {				
				main(this.parent).pauels_properties.y -= params_panel.height;
				main(this.parent).nelder_properties.y -= params_panel.height;
				params_panel.max_toggle.removeEventListener( MouseEvent.CLICK, maxToggleClk );
				params_panel.min_toggle.removeEventListener( MouseEvent.CLICK, minToggleClk );
				params_panel.calculate_btn.removeEventListener( MouseEvent.CLICK, calculateBtnClk );
				params_panel.gotoAndStop( 1 );
			}
			_isMinimized = ! _isMinimized;
			

		}

	}
}