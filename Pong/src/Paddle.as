package  
{
	import org.flixel.*;
	
	public class Paddle extends FlxSprite
	{
		public var paddleInitMaxVelocityY:Number = 200;
		public var paddleInitDragY:Number = 640;
		private var up:String;
		private var down:String;
		
		public function Paddle(graphic:Class, up:String, down:String, x:Number=0, y:Number=0)
		{
			super(x, y);
			super.loadGraphic(graphic, true, true, 8, 32);
			super.addAnimation("contact", [1, 0], 8, false);
			this.up = up;
			this.down = down;
			super.immovable = true;
			super.drag.y = paddleInitDragY;
			super.maxVelocity.y = paddleInitMaxVelocityY;
			super.maxVelocity.x = 0;
		}
		
		override public function update():void
		{
			this.acceleration.y = 0;
			if (FlxG.keys.pressed(up))
			{
				this.acceleration.y -= this.drag.y;
				if (this.y <= 0) {
					this.acceleration.y = 0;
					this.velocity.y = 0;
				}
			}
			if (FlxG.keys.pressed(down)) // Not else if because pressing up and down should negate
			{
				this.acceleration.y += this.drag.y;
				if (this.y > 208) {
					this.acceleration.y = 0;
					this.velocity.y = 0;
				}
			}
			if (this.y <= 0) {
				this.y = 0;
			}
			else if (this.y > 208) {
				this.y = 208;
			}
	
			super.update();
		}
		
		public function scaleSpeed(scale:Number, maxScale:Number):void
		{
			this.drag.y *= scale;
			this.velocity.y *= scale;
			this.maxVelocity.y *= scale;
			if (this.drag.y >= paddleInitDragY * maxScale)
			{
				this.drag.y = paddleInitDragY * maxScale;
				this.maxVelocity.y = paddleInitMaxVelocityY * maxScale;
			}
		}
		
		public function resetSpeed():void
		{
			this.drag.y = paddleInitDragY;
			this.maxVelocity.y = paddleInitMaxVelocityY;
		}
	}

}