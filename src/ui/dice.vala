using Gtk;

namespace Diceroller
{
	public class DiceButtons : Grid
	{
		public DiceButtons()
		{
			column_homogeneous = true;
			row_homogeneous = true;
			column_spacing = 5;
			row_spacing = 5;
			
			insert_column(0);
			insert_column(0);
			insert_column(0);
			insert_row(0);
			insert_row(0);
			insert_row(0);
			
			attach(new DieButton(4), 0, 0, 1, 1);
			attach(new DieButton(6), 1, 0, 1, 1);
			attach(new DieButton(8), 2, 0, 1, 1);
			
			attach(new DieButton(10), 0, 1, 1, 1);
			attach(new DieButton(12), 1, 1, 1, 1);
			attach(new DieButton(20), 2, 1, 1, 1);
			
			attach(new DieButton(100), 0, 2, 3, 1);
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
		
		public override void clicked()
		{
			var roll = die.roll(5);
			stdout.printf("%s\n", roll.toString());
		}
	}
}
