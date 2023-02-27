using GLib;
using Gtk;

namespace Diceroller
{
	public class DiceButtons : Object
	{
		public Grid grid { get; private set; }
		
		public DiceButtons()
		{
			grid = new Grid();
			grid.column_homogeneous = true;
			grid.row_homogeneous = true;
			grid.column_spacing = 5;
			grid.row_spacing = 5;
			
			grid.insert_column(0);
			grid.insert_column(0);
			grid.insert_column(0);
			grid.insert_row(0);
			grid.insert_row(0);
			grid.insert_row(0);
			
			grid.attach(generateButton(4), 0, 0, 1, 1);
			grid.attach(generateButton(6), 1, 0, 1, 1);
			grid.attach(generateButton(8), 2, 0, 1, 1);
			
			grid.attach(generateButton(10), 0, 1, 1, 1);
			grid.attach(generateButton(12), 1, 1, 1, 1);
			grid.attach(generateButton(20), 2, 1, 1, 1);
			
			grid.attach(generateButton(100), 0, 2, 3, 1);
		}
		
		private DieButton generateButton(int dieSides)
		{
			var button = new DieButton(dieSides);
			button.clicked
				.connect(() => {
					var roll = button.die.roll(5);
					stdout.printf("%s\n", roll.toString());
				});
			
			return button;
		}
	}
	
	public class DieButton : Button
	{
		public Die die { get; protected set; }
		
		public DieButton(int sides)
		{
			die = new Die(sides);
			label = die.toString();
		}
	}
}
