package  
{
	import flash.display.Bitmap;
    import org.flixel.*;
	import mx.core.BitmapAsset;
	import org.flixel.system.input.Keyboard;
    
    public class PlayState extends FlxState
    {
		[Embed(source = "data/ball.png")] private var ballGraphic:Class;
		[Embed(source = "data/P1.png")] private var p1Graphic:Class;
		[Embed(source = "data/P2.png")] private var p2Graphic:Class;
		
		private var ball:FlxSprite;
		private var p1:Player;
		private var p2:Player;
		private var scale:Number = 1.10;
		private var maxScale:Number = 4;
		private var ballInitVelocityX:Number = 100;
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
			
			// Set up players
			p1 = new Player(p1Graphic, "W", "S", 16, 104);
			add(p1.paddle);
			
			p2 = new Player(p2Graphic, "UP", "DOWN", 296, 104);
			add(p2.paddle);
			
			// Set up score
			score = new FlxText(0, 80, FlxG.width, p1.score + "   " + p2.score);
			score.setFormat(null, 60, 0xffffffff, "center");
			add(score);
			
			// Set up ball
			createBall();
        }
		
		public function createBall():void
		{
			ball = new FlxSprite(156, 116);
			ball.loadGraphic(ballGraphic, true, true);
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
			FlxG.collide(p1.paddle, ball, paddleCollide);
			FlxG.collide(p2.paddle, ball, paddleCollide);
			
			// Update player movement
			p1.paddle.update();
			p2.paddle.update();
			
			// Update ball movement
			updateBall();
			
			super.update();
		}
		
		public function paddleCollide(obj1:FlxObject, obj2:FlxObject):void
		{
			ballCollide();
		}
		
		public function ballCollide():void
		{
			p1.paddle.scaleSpeed(scale, maxScale);
			p2.paddle.scaleSpeed(scale, maxScale);
			if (!(p1.paddle.maxVelocity.y >= p1.paddle.paddleInitMaxVelocityY * maxScale) && !(p2.paddle.maxVelocity.y >= p2.paddle.paddleInitMaxVelocityY * maxScale))
			{
				ball.velocity.x *= scale;
				ball.velocity.y *= scale;
			}
			else
			{
				add(new FlxText(0, 100, FlxG.width, "FULL SPEED" + ball.velocity.x));
			}
			debug.text = "" + p1.paddle.maxVelocity.y;
		}
		
		public function updateBall():void
		{
			if (ball.x <= 0) // P2 Scores
			{
				p2.score++;
				ball.kill();
				p1.paddle.resetSpeed();
				p2.paddle.resetSpeed();
				score.text = p1.score + "   " + p2.score;
				createBall();
			}
			
			else if (ball.x >= 312) // P1 Scores
			{
				p1.score++;
				ball.kill();
				p1.paddle.resetSpeed();
				p2.paddle.resetSpeed();
				score.text = p1.score + "   " + p2.score;
				createBall();
			}
			else if (ball.y <= 0 || ball.y >= 232) // Rebound off top or bottom edge
			{
				ballCollide();
				ball.velocity.y *= -1;
			}
		}
    }
}