import SimpleOpenNI.*;
import java.util.Vector;
import processing.video.*;
import peasy.*;
import toxi.geom.*;

SimpleOpenNI kinect;
PVector center;
Movie movie;
//Viewers viewers;
IntVector userList;
float curPos;
int[][] values;

PeasyCam cam;
Vec3D globalOffset, avg, cameraCenter;
float camD0;
float camDMax;
float camDMin;

PVector rot = new PVector();
PVector tran0 = new PVector();//width/2, height/2, 530);
PVector tran = new PVector(width/-2, height/-2, 0);

void setup(){
  size(1024,760, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  center = new PVector();
  movie = new Movie(this, "scientists1.mov");
  values = new int[movie.width][movie.height];
  userList = new IntVector();
  curPos = 0;
  
  movie.play();
  camD0 = 1000;
  camDMax = 2000;
  camDMin = 100;
  cam = new PeasyCam(this, camD0);
  cam.setDistance(camD0);
  cam.setMinimumDistance(camDMin);
  cam.setMaximumDistance(camDMax);
  cameraCenter = new Vec3D();//tran.x,tran.y,tran.z);
  avg = new Vec3D();
  frameRate(24);
  globalOffset = new Vec3D();//tran.x,tran.y,tran.z);
  tran = new PVector(width/-2 + 200, height/-2, 0);
}

void draw(){
  background(0);
  kinect.update();
  translate(tran.x,tran.y,0);
  userList.clear();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    center = new PVector();
    for (int i = 0; i < userList.size(); i++) {
      int userId = userList.get(i);
      PVector position = new PVector();
      kinect.getCoM(userId, position);
      center.x += position.x;
      center.y += position.y;
      center.z += position.z;
    }
    center.x /= userList.size();
    center.y /= userList.size();
    center.z /= userList.size();
  }
  if(abs(center.x) > 100)
//    cam.rotateY(map(center.x, -1000, 300, PI/-6, PI/6));
  curPos = map(center.z, 300, 2300, 0, movie.duration());
  movie.jump(curPos);
  if (movie.available()) {
    movie.read();
  }
//  PImage img = movie;
  for (int y = 0; y < movie.height; y++) {
    for (int x = 0; x < movie.width; x++) {
      color pixel = movie.get(x, y);
      int bright = (int)brightness(pixel);
      stroke(pixel);
      point(x, y, bright);
    }
  }
}

void mouseMoved(){
  curPos = map(mouseX, 0, width, 0, movie.duration());
  movie.jump(curPos);
}
public void mouseDragged() {
  if (keyPressed) {
    if (keyCode == ALT) {
      tran.x += (mouseX - pmouseX) * 2;
      tran.y += (mouseY - pmouseY) * 2;
      println(tran);
      return;
    }
  }
}
