using Gee;
using Diceroller.UI;

namespace Diceroller
{
	public enum RollType
	{
		Normal,
		TakeHighest,
		TakeLowest,
	}
	
	/**
	 * A rollable die with an arbitrary number of sides.
	 */
	public class Die : Object
	{
		public static Die d4 = new Die(4);
		public static Die d6 = new Die(6);
		public static Die d8 = new Die(8);
		public static Die d10 = new Die(10);
		public static Die d12 = new Die(12);
		public static Die d20 = new Die(20);
		public static Die d100 = new Die(100);
		
		/** The immutable number of sides on this {@link Die}. */
		public int sides { get; construct; }
		
		/**
		 * Constructor
		 * 
		 * @param sides The number of sides on this {@link Die}. Must be a positive
		 * value, otherwise behavior is undefined.
		 */
		public Die(int sides)
			requires(sides > 0)
		{
			Object(sides: sides);
		}
		
		/**
		 * Roll this {@link Die} an arbitrary number of times.
		 * 
		 * Generates an arbitrary number of random values between 1 and the number
		 * of sides, inclusive.
		 * 
		 * @param quantity The number of values to be generated. Must be a positive
		 * value, otherwise no values will be generated. Defaults to 1.
		 * @return Returns an instance of the {@link Roll} struct containing the
		 * generated values.
		 */
		public Roll roll(int quantity = 1)
			requires(sides > 0 && quantity > 0)
			ensures(result.highest > 0
				&& result.lowest <= sides
				&& result.total > 0
				&& result.values.size > 0)
		{
			var highest = 0;
			var lowest = sides + 1;
			var total = 0;
			var values = new ArrayList<int>();
			
			for(int i = 0; i < quantity; i++)
			{
				var val = Random.int_range(1, sides + 1);
				
				if(val > highest)
					highest = val;
				
				if(val < lowest)
					lowest = val;
				
				total += val;
				values.add(val);
			}
			
			return Roll(highest, lowest, total, values);
		}
		
		public string toString() { return @"d$sides"; }
	}
	
	/**
	 * The result of a {@link Die}.roll().
	 * 
	 * A struct containing all of the results generated by a single call to {@link Die}.roll().
	 * This includes the array of all generated values, the total sum of all values,
	 * the highest value generated, and the lowest value generated.
	 */
	public struct Roll
	{
		/** The highest value generated in this roll. */
		public int highest { get; protected set; }
		/** The lowest value generated in this roll. */
		public int lowest { get; protected set; }
		/** The total sum of all values generated in this roll. */
		public int total { get; protected set; }
		/** The list of all values generated in this roll. */
		public ArrayList<int> values { get; protected set; }
		
		/**
		 * Constructor
		 * 
		 * @param highest The integer value representing the highest generated value.
		 * @param lowest The integer value representing the lowest generated value.
		 * @param total The integer value representing the total sum of all generated values.
		 * @param values The list of generated integer values.
		 */
		public Roll(int highest, int lowest, int total, ArrayList<int> values)
		{
			this.highest = highest;
			this.lowest = lowest;
			this.total = total;
			this.values = values;
		}
		
		/**
		 * Generate a JSON string representing this {@link Roll}.
		 * 
		 * @return Returns a string containing the JSON representation of this
		 * Roll as a JSON object.
		 */
		public string toJson()
		{
			var builder = new StringBuilder();
			builder.append("[");
			foreach(int i in values)
			{
				if(builder.len > 1)
					builder.append(",");
				builder.append(@"$i");
			}
			builder.append("]");
			
			var valueString = builder.str;
			return @"{ \"values\": $valueString, \"total\": $total, \"highest\": $highest, \"lowest\": $lowest }";
		}
	}
}
