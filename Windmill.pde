// Class to describe a spinning object
//Used windmill class originally but then decided to delete it

//class Windmill {

//  // Our object is two boxes and one joint
//  //RevoluteJoint joint;
//  //RevoluteJointDef rjd;
//  Box box1;
//  //Box box2;

//  int dir;
//  float xBox, yBox, speed;

//  Windmill(float x, float y, int _dir) {

//    // Initialize positions of two boxes
//    box1 = new Box(x, y, 100, 60, true, true); 
//    //box2 = new Box(x, y, 100, 60, true, true); 

//    // Define joint as between two bodies
//    //rjd = new RevoluteJointDef();

//    //rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());

//    //// Turning on a motor
//    //rjd.motorSpeed = PI;       // how fast?
//    //rjd.maxMotorTorque = 1000.0; // how powerful?
//    //rjd.enableMotor = true;      // is it on?

//    //rjd.lowerAngle = 0; // -90 degrees
//    //rjd.upperAngle = 0; // 45 degrees
//    //rjd.enableLimit = true;

//    // Create the joint
//    //joint = (RevoluteJoint) box2d.world.createJoint(rjd);

//    dir = _dir;
//    xBox = box1.getPosition().x;
//    yBox = box1.getPosition().y;
//    speed = random(1, 5);
//  }

//  //move the joint
//  void update() {
//    //dir = 0 means it should move to the left
//    //dir = 1 means it should move to the right
//    if (dir == 1 ) {
//      if ( xBox>50) {
//        xBox-=speed;
//      } else {
//        dir = 0;
//        xBox+=speed;
//      }
//    }
//    if (dir == 0) {
//      if ( xBox<width-50) {
//        xBox+=speed;
//      } else {
//        dir = 1;
//        xBox-=speed;
//      }
//    }
//    if (moving) {
//      yBox -= 1;
//    }

//    //println(xBox, yBox);
//    box1.body.setTransform(box2d.coordPixelsToWorld(xBox, yBox), 0);
//  }

//  void display() {
//    if (start) box1.decay();
//    //box1.decay();
//    //display rect for debugging
//    box1.display();

//    //display the image
//    Vec2 anchor = box2d.coordWorldToPixels(box1.body.getWorldCenter());
//    pushMatrix();
//    imageMode(CENTER);
//    tint(255, box1.lifespan);
//    image(cloud, anchor.x, anchor.y, 100, 80);
//    popMatrix();


//    //fill(col);
//    //noStroke();
//    //ellipse(anchor.x, anchor.y, 5, 5);
//  }
//}
