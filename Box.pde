// A rectangular box

class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  boolean delete = false;
  float lifespan =255;
  int dir;
  float speed;

  // Constructor
  Box(float x, float y, int _dir ) {
    w = 100;
    h = 60;
    dir = _dir;
    speed = random(1,5);

    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));
    //if (lock) bd.type = BodyType.STATIC;
    bd.type = BodyType.STATIC;
    //else bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);


    // Define the shape -- a  (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
     body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }


  void delete() {
    delete = true;
  }

  boolean done() {
    // Is it off the bottom of the screen?
    if ( lifespan <0|| delete) {
      killBody();
      return true;
    }
    return false;
  }

  Vec2 getPosition() {
    return box2d.getBodyPixelCoord(body);
  }

  //control how long the box can appear on the screen and its movement
  void decay() {
    lifespan-=1;
    float xBox = getPosition().x;
    float yBox = getPosition().y;
        if (dir == 1 ) {
      if ( xBox>50) {
        xBox-=speed;
      } else {
        dir = 0;
        xBox+=speed;
      }
    }
    if (dir == 0) {
      if ( xBox<width-50) {
        xBox+=speed;
      } else {
        dir = 1;
        xBox-=speed;
      }
    }
    if (moving) {
      yBox -= 1;
    }

    //println(xBox, yBox);
    body.setTransform(box2d.coordPixelsToWorld(xBox, yBox), 0);
    
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    tint(255, lifespan);
    image(cloud, 0,0, 100, 80);
    popMatrix();
  }
}
