using Gtk;

namespace Diceroller
{
	public class App : Gtk.Application
	{
		private const string AppId = "vala.diceroller";
		private const string AppTitle = "Dice Roller (Vala)";
		
		public App()
		{
			Object(
				application_id: AppId,
				flags: ApplicationFlags.FLAGS_NONE
			);
		}
		
		protected override void activate()
		{
			var window = new ApplicationWindow(this);
			window.show_menubar = true;
			window.title = AppTitle;
			//window.window_position = WindowPosition.CENTER;
			window.set_default_size(400, 300);
			
			var close = new Button.with_label("Close");
			close.clicked.connect(() => window.close());
			
			var buttons = new DiceButtons();
			
			var grid = new Grid();
			grid.row_spacing = 5;
			grid.column_spacing = 5;
			grid.insert_row(0);
			grid.insert_column(0);
			grid.insert_column(0);
			grid.attach(buttons, 0, 0, 1, 1);
			grid.attach(close, 1, 0, 1, 1);
			
			window.set_child(grid);
			window.present();
		}
	}
}
