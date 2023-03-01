using Gee;
using Gtk;
using Diceroller;

namespace Diceroller.UI
{
	public class ResultBox : Box
	{
		public TreeMap<Die, int> rollCounts { get; protected set; }
		
		private Label equation { get; set; }
		private Label output { get; set; }
		
		public ResultBox()
		{
			Object(orientation: Orientation.VERTICAL, spacing: App.DefaultSpacing);
		}
		
		construct
		{
			rollCounts = new TreeMap<Die, int>((a, b) => a.sides - b.sides);
			
			//Equation line
			equation = new Label(null);
			equation.set_selectable(true);
			append(equation);
			
			//Output line
			output = new Label(null);
			output.set_selectable(true);
			append(output);
		}
		
		public void clear()
		{
			rollCounts.clear();
			
			update();
		}
		
		public void increment(Die die)
		{
			rollCounts[die] = rollCounts[die] + 1;
		}
		
		public void decrement(Die die)
		{
			rollCounts[die] = rollCounts[die] - 1;
			if(rollCounts[die] < 0)
				rollCounts.unset(die);
		}
		
		public void setDie(Die die, int quantity)
		{
			if(quantity > 0)
				rollCounts[die] = quantity;
			else
				rollCounts.unset(die);
		}
		
		public void update(RollType type = RollType.Normal, bool showRolls = false)
		{
			equation.label = buildEquation();
			output.label = buildOutput(type, showRolls);
		}
		
		private string buildEquation()
		{
			var builder = new StringBuilder();
			foreach(Die die in rollCounts.keys)
			{
				if(builder.len > 0)
					builder.append(" + ");
				
				var quantity = rollCounts[die];
				builder.append(@"$quantity");
				builder.append(die.toString());
			}
			
			return builder.str;
		}
		
		private string buildOutput(RollType type = RollType.Normal, bool showRolls = false)
		{
			var rollsBuilder = new StringBuilder();
			var intermediateBuilder = new StringBuilder();
			int finalValue = 0;
			
			foreach(Die die in rollCounts.keys)
			{
				var roll = die.roll(rollCounts[die]);
				
				//Rolls
				if(rollsBuilder.len > 0)
					rollsBuilder.append(" + ");
				
				for(int i = 0; i < roll.values.size; i++)
				{
					var value = roll.values[i];
					if(i > 0)
						rollsBuilder.append(", ");
					else
						rollsBuilder.append("[");
					rollsBuilder.append(@"$value");
					
					if(i == roll.values.size - 1)
						rollsBuilder.append("]");
				}
				
				//Individual die totals/values
				int intermediateValue = roll.total;
				if(type == RollType.TakeHighest)
					intermediateValue = roll.highest;
				else if(type == RollType.TakeLowest)
					intermediateValue = roll.lowest;
				
				if(intermediateBuilder.len > 0)
					intermediateBuilder.append(" + ");
				intermediateBuilder.append(@"$intermediateValue");
				
				//Final total
				finalValue = finalValue + intermediateValue;
			}
			
			//Compose the resultant output
			var finalBuilder = new StringBuilder();
			
			if(type == RollType.TakeHighest)
				finalBuilder.append("Take Highest ");
			else if(type == RollType.TakeLowest)
				finalBuilder.append("Take Lowest ");
			
			if(showRolls)
			{
				finalBuilder.append(rollsBuilder.str);
				finalBuilder.append(" => ");
			}
			finalBuilder.append(intermediateBuilder.str);
			finalBuilder.append(" = ");
			finalBuilder.append(@"$finalValue");
			
			return finalBuilder.str;
		}
	}
}
