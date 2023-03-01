using Gtk;

namespace Diceroller.UI
{
	public class MainWindow : ApplicationWindow
	{
		public bool showRolls { get; set; }
		
		private ResultBox result;
		
		public MainWindow(Gtk.Application app, string title)
		{
			Object(application: app, title: title, showRolls: true);
		}
		
		construct
		{
			result = new ResultBox();
			
			show_menubar = true;
			set_default_size(400, 225);
			set_child(generateMainColumn());
		}
		
		private void clear()
		{
			result.clear();
			result.updateOutput();
		}
		
		private void doRoll()
		{
			result.updateOutput(RollType.Normal, showRolls);
			result.clear();
		}
		
		private void doHighest()
		{
			result.updateOutput(RollType.TakeHighest, showRolls);
			result.clear();
		}
		
		private void doLowest()
		{
			result.updateOutput(RollType.TakeLowest, showRolls);
			result.clear();
		}
		
		private Box generateButtonRow()
		{
			var buttons = new DiceButtons();
			buttons.decrementDie.connect((die) => result.decrement(die));
			buttons.incrementDie.connect((die) => result.increment(die));
			
			var row = new Box(Orientation.HORIZONTAL, App.DefaultSpacing);
			row.append(buttons);
			row.append(generateRollButtonColumn());
			row.append(generateControlButtonColumn());
			
			return row;
		}
		
		private Box generateControlButtonColumn()
		{
			var clear = new Button.with_label("Clear");
			clear.clicked.connect(this.clear);
			
			var toggleShowRolls = new Button.with_label("Hide Rolls");
			toggleShowRolls.clicked.connect(() => {
				showRolls = !showRolls;
				
				if(showRolls)
					toggleShowRolls.label = "Hide Rolls";
				else
					toggleShowRolls.label = "Show Rolls";
			});
			
			var column = new Box(Orientation.VERTICAL, App.DefaultSpacing);
			column.append(clear);
			column.append(toggleShowRolls);
			
			return column;
		}
		
		private Box generateMainColumn()
		{
			var column = new Box(Orientation.VERTICAL, App.DefaultSpacing);
			column.set_halign(Align.CENTER);
			column.set_valign(Align.CENTER);
			column.append(result);
			column.append(generateButtonRow());
			
			return column;
		}
		
		private Box generateRollButtonColumn()
		{
			var roll = new Button.with_label("Sum Total");
			roll.clicked.connect(this.doRoll);
			
			var takeHighest = new Button.with_label("Take Highest");
			takeHighest.clicked.connect(this.doHighest);
			
			var takeLowest = new Button.with_label("Take Lowest");
			takeLowest.clicked.connect(this.doLowest);
			
			var column = new Box(Orientation.VERTICAL, App.DefaultSpacing);
			column.append(roll);
			column.append(takeHighest);
			column.append(takeLowest);
			
			return column;
		}
	}
}
