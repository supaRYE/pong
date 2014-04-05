package  
{

	public class Player 
	{
		public var score:int = 0;
		public var paddle:Paddle;
		
		public function Player(graphic:Class, up:String, down:String, x:Number=0, y:Number=0, score:int=0)
		{
			this.score = score;
			this.paddle = new Paddle(graphic, up, down, x, y);
		}
		
	}

}