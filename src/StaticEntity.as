package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.Sprite;
	import Box2D.Collision.Shapes.b2CircleShape;
	/**
	 * ...
	 * @author Daphne
	 */
	public class StaticEntity
	{
		protected var gravityStrength:int;
		protected var body:b2Body;
		
		public function StaticEntity(pX:Number,pY:Number,r:Number, gravityStrength:int)
		{
			this.gravityStrength = gravityStrength;
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution=0;
			fixtureDef.density = 3;
			var circleShape:b2CircleShape=new b2CircleShape(r/Main.worldScale);
			fixtureDef.shape = circleShape;
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.userData=new Sprite();
			bodyDef.position.Set(pX/Main.worldScale,pY/Main.worldScale);
			body = Main.world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			Main.orbitCanvas.graphics.drawCircle(pX, pY,  r * gravityStrength);
		}
		
		public function gravity(curDebris:b2Body) {
		}
	}

}