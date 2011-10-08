package utils.role
{
	public class OtherRole extends Role
	{
		public var hero:Hero;
		public function OtherRole()
		{
			super();
		}
		override public function set baseX(value:Number):void{
			super.baseX = value;
			this.x = value - hero.baseX + hero.x;
		}
		override public function set baseY(value:Number):void{
			super.baseY = value;
			this.y = value - hero.baseY + hero.y;
		}
	}
}