// A circular ball

class Ball {

  // We need to keep track of a Body and a radius
  Body body;
  float r; 
  Vec2 pos;
  BodyDef bd;

  // Constructor
  Ball(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    r = 30;
    pos = box2d.getBodyPixelCoord(body);
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  Vec2 getPosition() {
    return box2d.getBodyPixelCoord(body);
  }
  
  // draw the ball
  void display() {

    // Get its screen position
    pos = box2d.getBodyPixelCoord(body);

    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 243, 225);
    noStroke();
    ellipse(0, 0, r,r);
    popMatrix();
  }

  // Here's our function that adds the ball to the Box2D world
  void makeBody(Vec2 center) { 
    
    CircleShape cs = new CircleShape();
    //float r = box2d.scalarPixelsToWorld(w_/2);
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 3;
    fd.friction = 0.3;
    fd.restitution = 0.2;

    // Define the body and make it from the shape
    bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.angle = random(TWO_PI);

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }
}
