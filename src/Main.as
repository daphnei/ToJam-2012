package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	import flash.geom.Point;
	
	public class Main extends Sprite {
		public static const world:b2World=new b2World(new b2Vec2(0,0),true);
		public static const worldScale:Number = 30;
		
		private var entityVector:Vector.<StaticEntity> = new Vector.<StaticEntity>();

		private var debrisVector:Vector.<b2Body> = new Vector.<b2Body>();
		
		private var bhGravityStrength:int = 4;
		private var planetGravityStrength:int = 3;
		
		public static var orbitCanvas:Sprite;
		private var lineCanvas:Sprite;
		
		private var startPoint:b2Vec2;
		private var mouseDown:Boolean = false;
		
		//scale of speed that objects are released 
		private const DEBRIS_SPEED_FACTOR:Number = 1/3;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			orbitCanvas = new Sprite();
			addChild(orbitCanvas);
			orbitCanvas.graphics.lineStyle(1,0xff0000);
			debugDraw();
			
			lineCanvas = new Sprite();
			addChild(lineCanvas);
			
			entityVector.push(new Blackhole(180, 240, 90, 4));
			entityVector.push(new Blackhole(480, 120, 45, 3));
			addEventListener(Event.ENTER_FRAME,update);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, dragOut);
			stage.addEventListener(MouseEvent.MOUSE_UP, release);
		}
			
		private function release(e:MouseEvent):void {
			var endPoint:b2Vec2 =  new b2Vec2(stage.mouseX, stage.mouseY);
			addOrb(endPoint, 10);
			lineCanvas.graphics.clear();
			mouseDown = false;
		}
		
		private function dragOut(e:MouseEvent):void {
			startPoint = new b2Vec2(stage.mouseX, stage.mouseY);
			mouseDown = true;
		}

		private function createDebris(e:MouseEvent):void {
			//addBox(mouseX,mouseY,20,20);
		}

		//I am not calling this. The boxes go kind of crazy.
	/*	private function addBox(dragPoint:b2Vec2,w:Number,h:Number):void {
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(w/worldScale/2,h/worldScale/2);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density=.5;
			fixtureDef.friction=.5;
			fixtureDef.restitution=0;
			fixtureDef.shape=polygonShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.position.Set(startPoint.x/worldScale,startPoint.y/worldScale);
			var box:b2Body=world.CreateBody(bodyDef);
			debrisVector.push(box);
			box.CreateFixture(fixtureDef);
			var xSpeed:Number = (startPoint.x - dragPoint.x) * DEBRIS_SPEED_FACTOR; 
			var ySpeed:Number = (startPoint.y - dragPoint.y) * DEBRIS_SPEED_FACTOR;
			box.ApplyForce(new b2Vec2(xSpeed, ySpeed), dragPoint);
		}
	*/
		
		//Similar to add box, but with circles, which seem to behave more normally.
		private function addOrb(dragPoint:b2Vec2, r:Number):void {
			var polygonShape:b2CircleShape = new b2CircleShape((r * 2) / worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density=.5;
			fixtureDef.friction=0;
			fixtureDef.restitution=0;
			fixtureDef.shape=polygonShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type=b2Body.b2_dynamicBody;
			bodyDef.position.Set(startPoint.x/worldScale,startPoint.y/worldScale);
			var box:b2Body=world.CreateBody(bodyDef);
			debrisVector.push(box);
			box.CreateFixture(fixtureDef);
			var xSpeed:Number = (startPoint.x - dragPoint.x) * DEBRIS_SPEED_FACTOR ;
			var ySpeed:Number = (startPoint.y - dragPoint.y) * DEBRIS_SPEED_FACTOR ;
			box.ApplyForce(new b2Vec2(xSpeed, ySpeed), dragPoint);
		}
		
		private function debugDraw():void {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		private function update(e:Event):void {
			world.Step(1/30, 10, 10);
			world.ClearForces();
			for (var i:int=0; i<debrisVector.length; i++) {
				for each (var entity:StaticEntity in entityVector) {
					entity.gravity(debrisVector[i]);
				}
			}
			
			world.DrawDebugData();
			if (mouseDown) {
				drawPowerLine();
			}
		}
		
		private function drawPowerLine():void {
			lineCanvas.graphics.clear();
			lineCanvas.graphics.lineStyle(2,0x000000);
			lineCanvas.graphics.moveTo(startPoint.x,startPoint.y);
			lineCanvas.graphics.lineTo(stage.mouseX,stage.mouseY);
		}
	}
}