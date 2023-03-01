using Gtk;
using Diceroller;

namespace Diceroller.UI
{
	public class DiceButtons : Box
	{
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
				row.append(new DieButton(s));
			
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
		
		public override void clicked()
		{
			var roll = die.roll(5);
			stdout.printf("%s\n", roll.toJson());
		}
	}
}
