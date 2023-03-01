using Gtk;

namespace Diceroller.UI
{
	public class MainWindow : ApplicationWindow
	{
		private ResultBox result;
		
		public MainWindow(Gtk.Application app, string title)
		{
			Object(application: app);
			
			this.title = title;
		}
		
		construct
		{
			show_menubar = true;
			set_default_size(400, 300);
			
			var buttons = new DiceButtons();
			
			var roll = new Button.with_label("Roll");
			roll.clicked.connect(this.doTestUpdate);
			
			var takeHighest = new Button.with_label("Take Highest");
			takeHighest.clicked.connect(this.doAdvantageUpdate);
			
			var takeLowest = new Button.with_label("Take Lowest");
			takeLowest.clicked.connect(this.doDisadvantageUpdate);
			
			var buttonCol = new Box(Orientation.VERTICAL, App.DefaultSpacing);
			buttonCol.append(roll);
			buttonCol.append(takeHighest);
			buttonCol.append(takeLowest);
			
			var row = new Box(Orientation.HORIZONTAL, App.DefaultSpacing);
			row.set_halign(Align.CENTER);
			row.set_valign(Align.CENTER);
			row.append(buttons);
			row.append(buttonCol);
			
			result = new ResultBox();
			
			var column = new Box(Orientation.VERTICAL, App.DefaultSpacing);
			column.append(result);
			column.append(row);
			
			set_child(column);
		}
		
		private void doTestUpdate()
		{
			result.clear();
			
			result.increment(Die.d6);
			result.setDie(Die.d6, 2);
			result.increment(Die.d6);
			result.setDie(Die.d8, 1);
			result.setDie(Die.d12, 2);
			
			result.update(RollType.Normal, true);
		}
		
		private void doAdvantageUpdate()
		{
			result.clear();
			
			result.setDie(Die.d6, 2);
			result.setDie(Die.d20, 2);
			
			result.update(RollType.TakeHighest, true);
		}
		
		private void doDisadvantageUpdate()
		{
			result.clear();
			
			result.setDie(Die.d8, 2);
			result.setDie(Die.d12, 2);
			
			result.update(RollType.TakeLowest, true);
		}
	}
}
