package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.Sprite;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author Daphne
	 */
	public class Blackhole extends StaticEntity 
	{
		
		public function Blackhole(pX:Number, pY:Number, r:Number, gravityStrength:int)
		{
			super(pX, pY, r, gravityStrength);
		}
		
		
		override public function gravity(curDebris:b2Body) {
			var debrisPosition:b2Vec2 = curDebris.GetWorldCenter();
			
			var planetShape:b2CircleShape=body.GetFixtureList().GetShape() as b2CircleShape;
			var planetRadius:Number=planetShape.GetRadius() * 2;
			var planetPosition:b2Vec2=body.GetWorldCenter();
			var planetDistance:b2Vec2=new b2Vec2(0,0);
			planetDistance.Add(debrisPosition);
			planetDistance.Subtract(planetPosition);
			var finalDistance:Number=planetDistance.Length();
			if (finalDistance<=planetRadius*gravityStrength) {
				planetDistance.NegativeSelf();
				var vecSum:Number=Math.abs(planetDistance.x)+Math.abs(planetDistance.y);
				planetDistance.Multiply((1/vecSum)*planetRadius/finalDistance);
				curDebris.ApplyForce(planetDistance,curDebris.GetWorldCenter());
			}
		}
	}

}