using Gee;
using GLib;

namespace Diceroller
{
	public class Die : Object
	{
		public int sides { get; construct; }
		
		public Die(int sides)
		{
			Object(sides: sides);
		}
		
		public Roll roll(int quantity = 1)
		{
			var highest = 0;
			var lowest = sides + 1;
			var total = 0;
			var values = new ArrayList<int>();
			
			for(int i = 0; i < quantity; i++)
			{
				var val = Random.int_range(1, sides + 1);
				values.add(val);
				if(val > highest)
					highest = val;
				if(val < lowest)
					lowest = val;
				total += val;
			}
			
			return Roll(highest, lowest, total, values);
		}
		
		public string toString() { return @"d$sides"; }
	}
	
	public struct Roll
	{
		public int highest { get; protected set; }
		public int lowest { get; protected set; }
		public int total { get; protected set; }
		public ArrayList<int> values { get; protected set; }
		
		public Roll(int highest, int lowest, int total, ArrayList<int> values)
		{
			this.highest = highest;
			this.lowest = lowest;
			this.total = total;
			this.values = values;
		}
		
		public string toString()
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
			return @"{values: $valueString, total: $total, highest: $highest, lowest: $lowest}";
		}
	}
}
