package  
{
	import flash.display.Bitmap;
    import org.flixel.*;
	import mx.core.BitmapAsset;
	import org.flixel.system.input.Keyboard;
    
    public class PlayState extends FlxState
    {
		[Embed(source = "data/ball.png")] private var Ball:Class;
		[Embed(source = "data/P1.png")] private var P1:Class;
		[Embed(source = "data/P2.png")] private var P2:Class;
		
		private var ball:FlxSprite;
		private var p1:FlxSprite;
		private var p2:FlxSprite;
		private var speedScale:Number = 1.10;
		private var maxScale:Number = 4;
		private var paddleInitMaxVelocityY:Number = 200;
		private var paddleInitDragY:Number = 640;
		private var ballInitVelocityX:Number = 100;
		private var p1Score:int = 0;
		private var p2Score:int = 0;
		private var score:FlxText;
		private var debug:FlxText;
		
        override public function create():void
        {
			debug = new FlxText(0, 0, FlxG.width, "GO");
			add(debug);
			
			// Set up refresh rates
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			
			// Set up background color
			FlxG.bgColor = 0xff101010;
			
			// Set up score
			score = new FlxText(0, 80, FlxG.width, p1Score + "   " + p2Score);
			score.setFormat(null, 60, 0xffffffff, "center");
			add(score);
			
			// Set up players
			p1 = new FlxSprite(16, 104);
			p1.loadGraphic(P1, true, true, 8, 32);
			p1.immovable = true;
			p1.drag.y = 640;
			p1.maxVelocity.y = paddleInitMaxVelocityY;
			p1.maxVelocity.x = 0;
			add(p1);
			
			p2 = new FlxSprite(296, 104);
			p2.loadGraphic(P2, true, true, 8, 32);
			p2.immovable = true;
			p2.drag.y = paddleInitDragY;
			p2.maxVelocity.y = paddleInitMaxVelocityY;
			p2.maxVelocity.x = 0;
			add(p2);
			
			// Set up ball
			createBall();
        }
		
		public function createBall():void
		{
			ball = new FlxSprite(156, 116);
			ball.loadGraphic(Ball, true, true);
			ball.velocity.x = ballInitVelocityX - (ballInitVelocityX * 2 * Math.floor(Math.random() * 2));
			var maxY:Number = 150;
			ball.velocity.y = 0;// Math.floor(Math.random() * (maxY * 2 + 1)) - maxY;
			ball.elasticity = 1;
			ball.maxVelocity.x = Math.abs(ball.velocity.x) * maxScale;
			ball.maxVelocity.y = Math.abs(ball.velocity.y) * maxScale;
			add(ball);
		}
		
		override public function update():void
		{
			p1.acceleration.y = 0;
			p2.acceleration.y = 0;
			
			FlxG.collide(p1, ball, ballCollide);
			FlxG.collide(p2, ball, ballCollide);
			
			// Update player movement
			updatePlayer(p1, FlxG.keys.W, FlxG.keys.S);
			updatePlayer(p2, FlxG.keys.UP, FlxG.keys.DOWN);
			
			// Update ball movement
			updateBall();
			
			super.update();
		}
		
		public function ballCollide(obj1:FlxObject, obj2:FlxObject):void
		{
			if (!(p1.maxVelocity.y >= paddleInitMaxVelocityY * maxScale) && !(p2.maxVelocity.y >= paddleInitMaxVelocityY * maxScale))
			{
				p1.drag.y *= speedScale;
				p1.velocity.y *= speedScale;
				p1.maxVelocity.y *= speedScale;
				p2.drag.y *= speedScale;
				p2.velocity.y *= speedScale;
				p2.maxVelocity.y *= speedScale;
				ball.velocity.x *= speedScale;
				ball.velocity.y *= speedScale;
			}
			else
			{
				add(new FlxText(0, 100, FlxG.width, "FULL SPEED" + ball.velocity.x));
			}
			debug.text = "" + p1.maxVelocity.y;
		}
		
		public function updatePlayer(player:FlxSprite, up:Boolean, down:Boolean):void
		{
			if (up)
			{
				player.acceleration.y -= player.drag.y;
				if (player.y <= 0) {
					player.acceleration.y = 0;
					player.velocity.y = 0;
				}
			}
			if (down) // Not else if because pressing up and down should negate
			{
				player.acceleration.y += player.drag.y;
				if (player.y > 208) {
					player.acceleration.y = 0;
					player.velocity.y = 0;
				}
			}
			
			if (player.y <= 0) {
				player.y = 0;
			}
			
			if (player.y > 208) {
				player.y = 208;
			}
		}
		
		public function updateBall():void
		{
			if (ball.x <= 0) // P2 Scores
			{
				p2Score++;
				ball.kill();
				p1.drag.y = paddleInitDragY;
				p1.maxVelocity.y = paddleInitMaxVelocityY;
				p2.drag.y = paddleInitDragY;
				p2.maxVelocity.y = paddleInitMaxVelocityY;
				score.text = p1Score + "   " + p2Score;
				createBall();
			}
			
			else if (ball.x >= 312) // P1 Scores
			{
				p1Score++;
				ball.kill();
				p1.drag.y = paddleInitDragY;
				p1.maxVelocity.y = paddleInitMaxVelocityY;
				p2.drag.y = paddleInitDragY;
				p2.maxVelocity.y = paddleInitMaxVelocityY;
				score.text = p1Score + "   " + p2Score;
				createBall();
			}
			else if (ball.y <= 0 || ball.y >= 232) // Rebound off top or bottom edge
			{
				ballCollide(null, null);
				ball.velocity.y *= -1;
			}
		}
    }
}