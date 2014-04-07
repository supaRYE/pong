package   
{
	import org.flixel.*;
	
	public class WinState extends FlxState
	{
		[Embed(source = "data/win.mp3")] private var winMp3:Class;
		
		private var winner:String;
		
		public function WinState(winner:String)
		{
			this.winner = winner;
			super();
		}
		
		override public function create():void
		{
			// Set up background color
			FlxG.bgColor = 0xff101010;
			
			FlxG.play(winMp3);
			
			var title:FlxText;
			title = new FlxText(0, 80, FlxG.width, winner);
			title.setFormat (null, 30, 0xffffffff, "center");
			add(title);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 30, FlxG.width, "Press SPACE to return to menu");
			instructions.setFormat(null, 8, 0xffffffff, "center");
			add(instructions);
		}
 
 
		override public function update():void
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.switchState(new MenuState());
			}
 
		}
	}

}