package  
{
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		
		override public function create():void
		{
			// Set up background color
			FlxG.bgColor = 0xff101010;
			
			var title:FlxText;
			title = new FlxText(0, 20, FlxG.width, "PONG");
			title.setFormat (null, 50, 0xffffffff, "center");
			add(title);
			
			var controlsTitle:FlxText;
			p1Controls = new FlxText(110, FlxG.height - 120, FlxG.width, "P1 Controls     P2 Controls");
			p1Controls.setFormat(null, 8, 0xffffffff);
			add(p1Controls);
			
			var p1Controls:FlxText;
			p1Controls = new FlxText(75, FlxG.height - 105, FlxG.width, "UP:              W                Up Arw");
			p1Controls.setFormat(null, 8, 0xffffffff);
			add(p1Controls);
			
			var p2Controls:FlxText;
			p2Controls = new FlxText(75, FlxG.height - 90, FlxG.width, "DOWN:         S               Down Arw");
			p2Controls.setFormat(null, 8, 0xffffffff);
			add(p2Controls);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 30, FlxG.width, "Press SPACE to start");
			instructions.setFormat(null, 8, 0xffffffff, "center");
			add(instructions);
		}
 
 
		override public function update():void
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.switchState(new PlayState());
			}
 
		}
	}

}