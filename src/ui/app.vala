using GLib;
using Gtk;

namespace Diceroller
{
	public class App : Object
	{
		private Gtk.Application application;
		
		public App(string id)
		{
			application = new Gtk.Application(id, ApplicationFlags.FLAGS_NONE);
			
			application.activate
				.connect(() => {
					var window = new ApplicationWindow(application);
					
					var close = new Button.with_label("Close");
					close.clicked.connect(() => window.close());
					
					var buttons = new DiceButtons();
					
					var grid = new Grid();
					grid.row_spacing = 5;
					grid.column_spacing = 5;
					grid.insert_row(0);
					grid.insert_column(0);
					grid.insert_column(0);
					grid.attach(buttons.grid, 0, 0, 1, 1);
					grid.attach(close, 1, 0, 1, 1);
					
					window.set_child(grid);
					window.present();
				});
		}
		
		public int run(string[] args)
		{
			return application.run(args);
		}
	}
}
