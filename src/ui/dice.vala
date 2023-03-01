using Gtk;
using Diceroller;

namespace Diceroller.UI
{
	public class DiceButtons : Box
	{
		public signal void incrementDie(Die die);
		
		public DiceButtons()
		{
			Object(orientation: Orientation.VERTICAL, spacing: App.DefaultSpacing);
		}
		
		construct
		{
			append(generateRow({ 4, 6, 8 }));
			append(generateRow({ 10, 12, 20 }));
			append(generateRow({ 100 }));
		}
		
		private Box generateRow(int[] sides)
		{
			var row = new Box(Orientation.HORIZONTAL, App.DefaultSpacing);
			row.homogeneous = true;
			
			foreach(int s in sides)
			{
				var button = new DieButton(s);
				button.clicked.connect(() => incrementDie(button.die));
				row.append(button);
			}
			
			return row;
		}
	}
	
	public class DieButton : Button
	{
		public Die die { get; construct; }
		
		public DieButton(int sides)
		{
			Object(die: new Die(sides));
			label = die.toString();
		}
	}
}
