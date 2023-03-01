using Gtk;

namespace Diceroller.UI
{
	public class App : Gtk.Application
	{
		public const int DefaultSpacing = 5;
		
		private const string AppId = "com.github.nemesisx00.diceroller.vala";
		private const string AppTitle = "Dice Roller (Vala)";
		
		private MainWindow window { get; set; }
		
		public App()
		{
			Object(
				application_id: AppId,
				flags: ApplicationFlags.FLAGS_NONE
			);
		}
		
		protected override void activate()
		{
			window = new MainWindow(this, AppTitle);
			window.present();
		}
	}
}
