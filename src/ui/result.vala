using Gee;
using Gtk;
using Diceroller;

namespace Diceroller.UI
{
	/**
	 * A {@link Widget} to display the currently defined equation and the
	 * subsequent results of a single roll.
	 */
	public class ResultBox : Box
	{
		private TreeMap<Die, int> rollCounts { get; set; }
		
		private Label equation { get; set; }
		private Label output { get; set; }
		
		public ResultBox()
		{
			Object(orientation: Orientation.VERTICAL, spacing: App.DefaultSpacing);
		}
		
		construct
		{
			rollCounts = new TreeMap<Die, int>((a, b) => a.sides - b.sides);
			
			equation = new Label(null);
			equation.set_selectable(true);
			append(equation);
			
			output = new Label(null);
			output.set_selectable(true);
			append(output);
		}
		
		/**
		 * Clear the {@link TreeMap} of all stored {@link Die}-quantity pairs.
		 * 
		 * Also triggers an update.
		 * 
		 * @see ResultBox.update()
		 */
		public void clear()
		{
			rollCounts.clear();
			
			update();
		}
		
		/**
		 * Increment the desired quantity of a single {@link Die} type.
		 * 
		 * @param die The {@link Die} type whose quantity is to be incremented.
		 */
		public void increment(Die die)
		{
			rollCounts[die] = rollCounts[die] + 1;
		}
		
		/**
		 * Decrement the desired quantity of a single {@link Die} type.
		 * 
		 * If the desired quantity is reduced below zero (0), the key is unset
		 * from the stored {@link Die}-quantity pairs.
		 * 
		 * @param die The {@link Die} type whose quantity is to be decremented.
		 */
		public void decrement(Die die)
		{
			rollCounts[die] = rollCounts[die] - 1;
			
			if(rollCounts[die] < 0)
				rollCounts.unset(die);
		}
		
		/**
		 * Directly set the desired quantity of a single {@link Die} type.
		 * 
		 * @param die The {@link Die} type whose quantity is to be set.
		 * @param quantity The quantity to be set. If the quantity is less than
		 * or equal to zero (0), the {@link Die} is unset from the stored
		 * {@link Die}-quantity pairs.
		 */
		public void setDie(Die die, int quantity)
		{
			if(quantity > 0)
				rollCounts[die] = quantity;
			else
				rollCounts.unset(die);
		}
		
		/**
		 * Update the equation and output {@link Widget}s based on the current
		 * state of the stored {@link Die}-quantity pairs.
		 */
		public void update(RollType type = RollType.Normal, bool showRolls = false)
		{
			equation.label = buildEquation();
			output.label = buildOutput(type, showRolls);
		}
		
		/**
		 * Process the currently stored rolls to generate the equation string.
		 * 
		 * Iterate over rollCounts to generate a string representing the desired
		 * roll as an equation. Each Die and quantity pair are formatted as "XdY",
		 * where X is the quantity and Y is Die's number of sides.
		 */
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
		
		/**
		 * Process the currently stored rolls and generate the output string.
		 * 
		 * @param type The {@link RollType} of this roll.
		 * @param showRolls A boolean flag determining whether or not the rolls
		 * string is appended to the output string.
		 * 
		 * @return Returns the fully formed output string ready to be displayed
		 * to the user.
		 */
		private string buildOutput(RollType type, bool showRolls)
		{
			var rollsBuilder = new StringBuilder();
			var intermediateBuilder = new StringBuilder();
			int finalValue = 0;
			
			foreach(Die die in rollCounts.keys)
			{
				var roll = die.roll(rollCounts[die]);
				
				processRolls(rollsBuilder, roll);
				var intermediateValue = processIntermediateValues(intermediateBuilder, roll, type);
				finalValue = finalValue + intermediateValue;
			}
			
			return composeOutput(rollsBuilder.str, intermediateBuilder.str, finalValue, type, showRolls);
		}
		
		/**
		 * Compose the final output string to be displayed.
		 * 
		 * @param rolls The string representing each individually rolled value,
		 * organized by {@link Die} type.
		 * @param intermediate The string representing the intermediate result
		 * for each {@link Die} type.
		 * @param value The final accumulated result of all the rolls.
		 * @param type The {@link RollType} of this roll.
		 * @param showRolls A boolean flag determining whether or not the rolls
		 * string is appended to the {@link StringBuilder}.
		 * 
		 * @return Returns the fully formed output string ready to be displayed
		 * to the user.
		 */
		private string composeOutput(string rolls, string intermediate, int value, RollType type, bool showRolls)
		{
			var builder = new StringBuilder();
			
			if(type == RollType.TakeHighest)
				builder.append("Take Highest ");
			else if(type == RollType.TakeLowest)
				builder.append("Take Lowest ");
			
			if(showRolls)
			{
				builder.append(rolls);
				builder.append(" => ");
			}
			builder.append(intermediate);
			builder.append(" = ");
			builder.append(@"$value");
			
			return builder.str;
		}
		
		/**
		 * Format an intermediate value for a single {@link Die} type.
		 * 
		 * An intermediate value is defined as the total, highest, or lowest
		 * value generated for a single {@link Die} type.
		 * 
		 * @param builder The {@link StringBuilder} to which to append the
		 * generated string(s).
		 * @param roll The {@link Roll} which provides the desired value.
		 * @param type The {@link RollType} determining which specific value is
		 * appended.
		 * A Normal roll appends the total. A TakeHighest roll appends the
		 * highest value. A TakeLowest roll appends the lowest value.
		 * 
		 * @return Returns the numeric value which was appended to the
		 * {@link StringBuilder}.
		 */
		private int processIntermediateValues(StringBuilder builder, Roll roll, RollType type)
		{
			int value = roll.total;
			
			if(type == RollType.TakeHighest)
				value = roll.highest;
			else if(type == RollType.TakeLowest)
				value = roll.lowest;
			
			if(builder.len > 0)
				builder.append(" + ");
			
			builder.append(@"$value");
			
			return value;
		}
		
		/**
		 * Format the individual rolled values for a single {@link Roll} into a
		 * list.
		 * 
		 * @param builder The {@link StringBuilder} to which to append the
		 * generated string(s).
		 * @param roll The {@link Roll} which provides the desired values.
		 */
		private void processRolls(StringBuilder builder, Roll roll)
		{
			if(builder.len > 0)
				builder.append(" + ");
			
			for(int i = 0; i < roll.values.size; i++)
			{
				var value = roll.values[i];
				
				if(i > 0)
					builder.append(", ");
				else
					builder.append("[");
				
				builder.append(@"$value");
				
				if(i == roll.values.size - 1)
					builder.append("]");
			}
		}
	}
}
