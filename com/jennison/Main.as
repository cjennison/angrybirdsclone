package com.jennison 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import flash.events.Event;
	import flash.display.Sprite;
	
	import com.jennison.Utils;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends MovieClip 
	{
		private var world:b2World;
		private var worldScale:Number = 30;
		
		//Physics Updates
		var timeStep:Number = 1 / 30;
		var velIterations:int = 10;
		var posIterations:int = 10;
			
		public function Main() 
		{
			trace("Starting Game");
			
			var gravity:b2Vec2 = new b2Vec2(0, 9.81);
			var sleep:Boolean = true;
			world = new b2World(gravity, sleep);
			createFloor();
			
			
			//Level Design
			 createBrick(275,435,30,30);
			  createBrick(365,435,30,30);
			  createBrick(320,405,120,30);
			  createBrick(320,375,60,30);
			  createBrick(305,345,90,30);
			  createBrick(320, 300, 120, 60);
			  createIdol(320, 242);
			
			debugDraw();
			addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		public function createIdol(x:Number, y:Number):void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(Utils.pixelsToMeters(x), Utils.pixelsToMeters(y));
			bodyDef.type = b2Body.b2_dynamicBody;
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(Utils.pixelsToMeters(5), Utils.pixelsToMeters(20));
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			
			var theIdol:b2Body = world.CreateBody(bodyDef);
			theIdol.CreateFixture(fixtureDef);
			
			//Create Additional Fixtures
			var bW:Number = Utils.pixelsToMeters(5);
			var bH:Number = Utils.pixelsToMeters(20);
			var boxPos:b2Vec2 = new b2Vec2(0, Utils.pixelsToMeters(10));
			var boxAngle:Number = -Math.PI / 4; //-45 Degrees (-180/4);
			
			polygonShape.SetAsOrientedBox(bW, bH, boxPos, boxAngle);
			fixtureDef.shape = polygonShape;
			theIdol.CreateFixture(fixtureDef);
			
			boxAngle = Math.PI / 4; //45 Degrees
			polygonShape.SetAsOrientedBox(bW, bH, boxPos, boxAngle);
			fixtureDef.shape = polygonShape;
			theIdol.CreateFixture(fixtureDef);
			
			//Add Head (Create any kind of shape by defining vertices)
			var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			vertices.push(new b2Vec2(Utils.pixelsToMeters( -15), Utils.pixelsToMeters( -25)));
			vertices.push(new b2Vec2(Utils.pixelsToMeters( 0), Utils.pixelsToMeters( -40)));
			vertices.push(new b2Vec2(Utils.pixelsToMeters( 15), Utils.pixelsToMeters( -25)));
			vertices.push(new b2Vec2(Utils.pixelsToMeters( 0), Utils.pixelsToMeters( -10)));
			
			polygonShape.SetAsVector(vertices, 4);
			
			fixtureDef.shape = polygonShape;
			theIdol.CreateFixture(fixtureDef);
		}
		
		public function createFloor():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(Utils.pixelsToMeters(320), Utils.pixelsToMeters(470));
			bodyDef.type = b2Body.b2_staticBody;
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(Utils.pixelsToMeters(320), Utils.pixelsToMeters(10));
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			
			var theFloor:b2Body = world.CreateBody(bodyDef);
			theFloor.CreateFixture(fixtureDef);
		}
		
		public function createCircle() {
			//Create Body Definition
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(Utils.pixelsToMeters(320), Utils.pixelsToMeters(30));
			bodyDef.type = b2Body.b2_dynamicBody;
			
			//Create Circle with Radius
			var circleShape:b2CircleShape;
			circleShape = new b2CircleShape(Utils.pixelsToMeters(25));
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.6;
			fixtureDef.friction = 0.1;
			
			var theBall:b2Body = world.CreateBody(bodyDef);
			theBall.CreateFixture(fixtureDef);
		}
		
		public function createBrick(x:int, y:int, w:Number, h:Number):void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(Utils.pixelsToMeters(x), Utils.pixelsToMeters(y));
			bodyDef.type = b2Body.b2_dynamicBody;
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(Utils.pixelsToMeters(w / 2), Utils.pixelsToMeters(h / 2));
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 2;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			
			var theBrick:b2Body = world.CreateBody(bodyDef);
			theBrick.CreateFixture(fixtureDef);
			
		}
		
		private function updateWorld(e:Event):void 
		{
			//Update
			world.Step(timeStep, velIterations, posIterations);
			world.ClearForces();
			world.DrawDebugData();
		}
		
		private function debugDraw() {
			 var debugDraw:b2DebugDraw = new b2DebugDraw();
			  var debugSprite:Sprite = new Sprite();
			  addChild(debugSprite);
			  debugDraw.SetSprite(debugSprite);
			  debugDraw.SetDrawScale(worldScale);
			  debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			  debugDraw.SetFillAlpha(0.5);
			  world.SetDebugDraw(debugDraw);
		}
		
		
	}

}