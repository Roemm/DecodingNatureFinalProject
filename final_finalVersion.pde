//This sketch is based on a vertical screen
//It may seem off if it's displayed horizontally.

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

import processing.serial.*;

Serial myPort;
int valueFromArduino;
float cnt = 0;

Minim minim;
AudioPlayer song;
BeatDetect beat;

PImage bg, cloud, arrow;
float yBg;
boolean moving = false;
boolean fall = true;
boolean start = false;

//startPositions ={width-250f, width-230f, width+230f,width+250f};


// A reference to our box2d world
Box2DProcessing box2d;

Ball ball;

ArrayList<Box> boxes;

ArrayList<Boundary> boundaries;
Box box;
boolean songNotPlayed = true;

void settings() {
  fullScreen(2);
}


void setup() {
  //size(480, 640);
  background(0);
  println(width, height);
  printArray(Serial.list());
  // this prints out the list of all available serial ports on your computer.

  myPort = new Serial(this, Serial.list()[1], 9600);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();

  // We are setting a custom gravity
  box2d.setGravity(0, -20);


  ball = new Ball(width/2, -15);

  boxes = new ArrayList<Box>();
  
  //initialize certain box classes on the screen
  boxes.add(new Box(width/2-200, height/4, 1));
  boxes.add(new Box(width/2+200, height/3, 0));
  boxes.add(new Box(width/2-150, height/2, 1));
  boxes.add(new Box(width/2+200, height/2-50, 0));
  boxes.add(new Box(width/2-100, height/2+100, 1));
  boxes.add(new Box(width/2+50, height*2/3, 0));


  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(10, height/2, 10, height));
  boundaries.add(new Boundary(width-10, height/2, 10, height));
  //boundaries.add(new Boundary(width/2, height-10, width, 10));

  minim = new Minim(this);
  song = minim.loadFile("data/cutted.wav", 2048);
  song.loop();

  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  bg = loadImage("data/bg3.png");
  cloud = loadImage("data/clouds.png");
  arrow = loadImage("data/arrow.png");
  yBg = bg.height/2;
}

void draw() {
  //reading data from sensor to start the sketch
  while ( myPort.available() > 0) {
    valueFromArduino = int(myPort.readStringUntil('\n'));  
  }
  println(valueFromArduino);
  if (valueFromArduino<270 && valueFromArduino>50) {
    start = true;
  }


  if (start) {
    box2d.step();
  }

  //display the image and move it
  background(0);
  pushMatrix();
  imageMode(CENTER);
  tint(255);
  image(bg, width/2, yBg);
  popMatrix();


  if (start == false) {
    pushMatrix();
    imageMode(CENTER);
    tint(255, 243, 225);
    image(arrow, width/2, 80);
    textAlign(CENTER);
    textSize(20);
    fill(255, 243, 225);
    text("Drop the ball from the tube:)", width/2+170, 50);
    popMatrix();
  }
  if (ball.pos.y>200) {
    moving = true;
  }
  
  //moving the background picture upwards before the ball reaches the end 
  if (moving && yBg > height-bg.height/2) {
    yBg-=3;
  } else moving = false;

  //detect the song and generate new windmills based on the beat
  beat.detect(song.mix);
  if ( beat.isOnset() && ball.getPosition().y<height*3/4) {
    generate();
  }


  //turn off the music
  if (ball.getPosition().y>height-30) {
    fall = false;
  }

  if (fall == false && cnt == 0) {
    song.shiftGain(0, -80, 10000);
    cnt =1;
  }

  //display and remove the windmills
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    b.display();
    if (start)b.decay();
    if (b.done()) {
      boxes.remove(i);
    }
  }

  ball.display();

  //Display all the boundaries
  //for (Boundary wall : boundaries) {
  //  wall.display();
  //}
}

void generate() {
  float y = ball.getPosition().y;
  int dir = int(random(2));
  //for (int i = 0; i<2; i++) {
  if (start == true) {
    if (dir ==0) {
      boxes.add(new Box(random(50, 300), random(y+100, height-50), dir));
    } else if (dir == 1) {
      boxes.add(new Box(random(width/2+100, width-50), random(y+50, height-50), dir));
    }
  }
}
//}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  //println(o2.getClass());

  if (o1==null || o2==null)
    return;

  if (o1.getClass() == Box.class && o2.getClass() == Box.class) {
    //println("delete");
    Box box1 = (Box) o1;
    box1.delete();
  }
  
  if (o1.getClass() == Boundary.class && o2.getClass() == Box.class) {
    //println("delete");
    Box box2 = (Box) o2;
    box2.delete();
  }
  if (o1.getClass() == Box.class && o2.getClass() == Boundary.class) {
    //println("delete");
    Box box1 = (Box) o1;
    box1.delete();
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
}

void serialEvent(Serial porty)
{
  String message = porty.readStringUntil('\n');
  if (message!=null)
  {
    message=trim(message);
    valueFromArduino = parseInt(message);
  }
}
