package  
{
	import flash.display.Bitmap;
    import org.flixel.*;
	import mx.core.BitmapAsset;
	import org.flixel.system.input.Keyboard;
	import WinState;
    
    public class PlayState extends FlxState
    {
		[Embed(source = "data/ball.png")] private var ballGraphic:Class;
		[Embed(source = "data/P1.png")] private var p1Graphic:Class;
		[Embed(source = "data/P2.png")] private var p2Graphic:Class;
		[Embed(source = "data/hit.mp3")] private var hitMp3:Class;
		[Embed(source = "data/point.mp3")] private var pointMp3:Class;
		[Embed(source = "data/startup.mp3")] private var startupMp3:Class;
		
		private var ball:FlxSprite;
		private var p1:Player;
		private var p2:Player;
		private var scale:Number = 1.07;
		private var maxScale:Number = 2.0;
		private var ballInitVelocityX:Number = 100;
		private var ptsToWin:int = 5;
		private var score:FlxText;
		
        override public function create():void
        {
			// Set up refresh rates
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			
			// Set up background color
			FlxG.bgColor = 0xff101010;
			
			FlxG.play(startupMp3);
			
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
			var maxY:Number = 50;
			
			// Generate random x and y velocities
			ball.velocity.y = Math.floor(Math.random() * (maxY * 2 + 1)) - maxY;
			ball.velocity.x = 120 - (.2 * Math.abs(ball.velocity.y));
			ball.velocity.x *= 1 - (2 * Math.floor(Math.random() * 2));
			
			ball.elasticity = 1;
			ball.maxVelocity.x = Math.abs(ball.velocity.x) * maxScale;
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
			var paddle:FlxSprite = obj1 as FlxSprite;
			var ball:FlxSprite = obj2 as FlxSprite;
			ball.velocity.y += ((ball.y + 4) - (paddle.y + 16)) * 3 + paddle.velocity.y * 36.0 / paddle.maxVelocity.y;
			paddle.play("contact");
			ballCollide();
		}
		
		public function ballCollide():void
		{
			FlxG.play(hitMp3);
			p1.paddle.scaleSpeed(scale, maxScale);
			p2.paddle.scaleSpeed(scale, maxScale);
			if (p1.paddle.maxVelocity.y != p1.paddle.paddleInitMaxVelocityY * maxScale)
			{
				ball.velocity.x *= scale;
				ball.velocity.y *= scale;
			}
		}
		
		public function updateBall():void
		{
			if (ball.x <= 0) // P2 Scores
			{
				p2.score++;
				score.text = p1.score + "   " + p2.score;
				if (p2.score >= ptsToWin)
				{
					FlxG.switchState(new WinState("PLAYER 2 WINS\n" + p1.score + " - " + p2.score));
				}
				FlxG.play(pointMp3);
				ball.kill();
				p1.paddle.resetSpeed();
				p2.paddle.resetSpeed();
				createBall();
			}
			
			else if (ball.x >= 312) // P1 Scores
			{
				p1.score++;
				score.text = p1.score + "   " + p2.score;
				if (p1.score >= ptsToWin)
				{
					FlxG.switchState(new WinState("PLAYER 1 WINS\n" + p1.score + " - " + p2.score));
				}
				FlxG.play(pointMp3);
				ball.kill();
				p1.paddle.resetSpeed();
				p2.paddle.resetSpeed();
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