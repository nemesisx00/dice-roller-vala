using Gtk;

namespace Diceroller.UI
{
	public class MainWindow : ApplicationWindow
	{
		public MainWindow(Gtk.Application app, string title)
		{
			Object(application: app);
			
			this.title = title;
		}
		
		construct
		{
			show_menubar = true;
			set_default_size(400, 300);
			
			var close = new Button.with_label("Close");
			close.clicked.connect(this.close);
			
			var buttons = new DiceButtons();
			
			var box = new Box(Orientation.HORIZONTAL, 5);
			box.set_halign(Align.CENTER);
			box.set_valign(Align.CENTER);
			
			box.append(buttons);
			box.append(close);
			
			set_child(box);
		}
	}
}
