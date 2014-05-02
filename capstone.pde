import ddf.minim.*;
Minim minim;
AudioPlayer teleport;
AudioPlayer arrive;
AudioPlayer bgm;
AudioPlayer run;
AudioPlayer left_turn;
AudioPlayer right_turn;
AudioPlayer bump;
PImage grid;
PImage user;
PImage target;
PImage wall;
PImage upFP;
PImage upRFP;
PImage upLFP;
PImage leftFP;
PImage leftRFP;
PImage leftLFP;
PImage downFP;
PImage downRFP;
PImage downLFP;
PImage rightFP;
PImage rightRFP;
PImage rightLFP;
PImage tele;
PImage arr;
PImage backscrn;
PFont f;
int move_speed = 10;
int uX;
int uXt;
int uY; 
int uYt;
int tX;
int tY;
int wX;
int wY;
int teleX;
int teleY;
int arrX;
int arrY;
int gridHeight = 500;
int gridWidth = 500;
int gridOffX = 438;
int gridOffY = 169;
int current_loc = 0;
boolean kW = false;
boolean kA = false;
boolean kS = false;
boolean kD = false;
boolean kR = false;
boolean kHeld = false;
ArrayList uFootprints;
ArrayList uRFootprints;
ArrayList uLFootprints;
ArrayList lFootprints;
ArrayList lRFootprints;
ArrayList lLFootprints;
ArrayList dFootprints;
ArrayList dRFootprints;
ArrayList dLFootprints;
ArrayList rFootprints;
ArrayList rRFootprints;
ArrayList rLFootprints;
ArrayList Walls;
int stage = 0;
boolean teleported = true;
boolean resetting = false;
String prev_dir = "";
String bump_dir = "none";
int bump_count = 0;
boolean bump_trigger = false;
boolean bump_trigger2 = false;
int teleTimer = 0;
boolean teleAnimate = false;
int arrTimer = 0;
boolean arrAnimate = false;
int walk_anim_count = 0;
String com_status = "";

import processing.serial.*;
Serial myPort;
int inByte;
String sByte = "0";

void setup() {
  minim = new Minim(this);
  teleport = minim.loadFile("sounds/teleport.wav");
  arrive = minim.loadFile("sounds/arrive.wav");
  bgm = minim.loadFile("sounds/bgm.wav");
  run = minim.loadFile("sounds/run.wav");
  left_turn = minim.loadFile("sounds/left_turn.wav");
  right_turn = minim.loadFile("sounds/right_turn.wav");
  bump = minim.loadFile("sounds/bump.wav");
  grid = loadImage("images/level1.png");
  backscrn = loadImage("images/game_outer_screen.png");
  user = loadImage("images/user.png");
  target = loadImage("images/target.png");
  wall = loadImage("images/wall.png");
  upFP = loadImage("images/upFP.png");
  upRFP = loadImage("images/upR.png");
  upLFP = loadImage("images/upL.png");
  leftFP = loadImage("images/leftFP.png");
  leftRFP = loadImage("images/leftR.png");
  leftLFP = loadImage("images/leftL.png");
  downFP = loadImage("images/downFP.png");
  downRFP = loadImage("images/downR.png");
  downLFP = loadImage("images/downL.png");
  rightFP = loadImage("images/rightFP.png");
  rightRFP = loadImage("images/rightR.png");
  rightLFP = loadImage("images/rightL.png");
  tele = loadImage("images/tele1.png");
  arr = loadImage("images/arrive1.png");
  uFootprints = new ArrayList<Integer>();
  uRFootprints = new ArrayList<Integer>();
  uLFootprints = new ArrayList<Integer>();
  lFootprints = new ArrayList<Integer>();
  lRFootprints = new ArrayList<Integer>();
  lLFootprints = new ArrayList<Integer>();
  dFootprints = new ArrayList<Integer>();
  dRFootprints = new ArrayList<Integer>();
  dLFootprints = new ArrayList<Integer>();
  rFootprints = new ArrayList<Integer>();
  rRFootprints = new ArrayList<Integer>();
  rLFootprints = new ArrayList<Integer>();
  Walls = new ArrayList<Integer>();
  size(1024, 768);
  frameRate(28);
  f = createFont("Verdana", 16, true);

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
    bgm.loop();
  run.loop();
}

void draw() {

  //arduino communication
  while (myPort.available () > 0) {
    inByte = myPort.read();
    sByte = String.valueOf(char(inByte));
    print(sByte);
    //status update
  }
  if ( sByte.equals("1") || sByte.equals("2") || sByte.equals("3") || sByte.equals("4") ) {
    com_status = "ACTIVE";
  }
  //move user
  if (uX != tX || uY != tY) {
    if (uXt > uX) {
      run.unmute();
      uX += move_speed;
      walk_anim_count ++;
      if (walk_anim_count < 2) {
        user = loadImage("images/userR1.png");
      }
      else if (walk_anim_count > 4) {
        user = loadImage("images/userR2.png");
      }
      if (walk_anim_count == 6) {
        walk_anim_count = 0;
      }
    }
    else if (uXt < uX) {
      run.unmute();
      uX -= move_speed;
      walk_anim_count ++;
      if (walk_anim_count < 2) {
        user = loadImage("images/userL1.png");
      }
      else if (walk_anim_count > 4) {
        user = loadImage("images/userL2.png");
      }
      if (walk_anim_count == 6) {
        walk_anim_count = 0;
      }
    }
    else if (uYt < uY) {
      run.unmute();
      uY -= move_speed;
      walk_anim_count ++;
      if (walk_anim_count < 2) {
        user = loadImage("images/userU1.png");
      }
      else if (walk_anim_count > 4) {
        user = loadImage("images/userU2.png");
      }
      if (walk_anim_count == 6) {
        walk_anim_count = 0;
      }
    }
    else if (uYt > uY) {
      run.unmute();
      uY += move_speed;
      walk_anim_count ++;
      if (walk_anim_count < 2) {
        user = loadImage("images/user1.png");
      }
      else if (walk_anim_count > 4) {
        user = loadImage("images/user2.png");
      }
      if (walk_anim_count == 6) {
        walk_anim_count = 0;
      }
    }
    else {
      run.mute();
      left_turn.rewind();
      left_turn.pause();
      right_turn.rewind();
      right_turn.pause();

      walk_anim_count = 0;
      if (prev_dir.equals("down") || prev_dir.equals("")) {
        user = loadImage("images/user.png");
      }
      else if (prev_dir.equals("left")) {
        user = loadImage("images/userL.png");
      }
      else if (prev_dir.equals("up")) {
        user = loadImage("images/userU.png");
      }
      else if (prev_dir.equals("right")) {
        user = loadImage("images/userR.png");
      }
    }
  }
  else {
    run.mute();
  }
  bump(6, 10);
  //activate teleporter
  if (stage > 0 && uX == tX && uY == tY) {
    teleAnimate = true;
    if ((sByte.equals("9") || kR) && teleTimer == 32) {
      teleported = true;
    }
  }

  if (teleported) {
    myPort.write(0);
  }
  if (teleported == false) {
    myPort.write(1);
  }

  //stage set up
  /*stage template
   Walls.addAll(Arrays.asList(
   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
   20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
   30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 
   40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 
   50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
   60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 
   70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
   80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
   90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
   */
  //stage 1
  if (stage == 0 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
    20, 21, 26, 27, 28, 29, 
    30, 31, 36, 37, 38, 39, 
    40, 41, 46, 47, 48, 49, 
    50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 250;
    uY = 150;
    uXt = 250;
    uYt = 150;
    tX = 100;
    tY = 150;
    stage += 1;
    grid = loadImage("images/level1.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 2
  if (stage == 1 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 11, 18, 19, 
    20, 21, 28, 29, 
    30, 31, 38, 39, 
    40, 41, 42, 43, 44, 48, 49, 
    50, 51, 52, 53, 54, 58, 59, 
    60, 61, 62, 63, 64, 68, 69, 
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 300;
    uY = 250;
    uXt = 300;
    uYt = 250;
    tX = 150;
    tY = 100;
    stage += 1;
    grid = loadImage("images/level2.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 3
  if (stage == 2 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 0;
    uY = 200;
    uXt = 0;
    uYt = 200;
    tX = 450;
    tY = 200;
    stage += 1;
    grid = loadImage("images/level3.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 4
  if (stage == 3 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 19, 
    20, 29, 
    30, 39, 
    40, 49, 
    50, 59, 
    60, 69, 
    70, 79, 
    80, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 350;
    uY = 350;
    uXt = 350;
    uYt = 350;
    tX = 100;
    tY = 100;
    stage += 1;
    grid = loadImage("images/level4.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 4
  if (stage == 4 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 19, 
    20, 29, 
    30, 33, 34, 35, 36, 37, 38, 39, 
    40, 43, 44, 45, 46, 47, 48, 49, 
    50, 53, 54, 55, 56, 57, 58, 59, 
    60, 63, 64, 65, 66, 67, 68, 69, 
    70, 73, 74, 75, 76, 77, 78, 79, 
    80, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 50;
    uY = 400;
    uXt = 50;
    uYt = 400;
    tX = 400;
    tY = 50;
    stage += 1;
    grid = loadImage("images/grid.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 5
  if (stage == 5 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
    30, 31, 37, 38, 39, 
    40, 41, 44, 47, 48, 49, 
    50, 51, 54, 57, 58, 59, 
    60, 61, 64, 67, 68, 69, 
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 300;
    uY = 300;
    uXt = 300;
    uYt = 300;
    tX = 100;
    tY = 300;
    stage += 1;
    grid = loadImage("images/grid.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 6
  if (stage == 6 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
   20, 21, 22, 27, 28, 29, 
   30, 31, 32, 34, 35, 37, 38, 39, 
   40, 41, 42, 44, 45, 46, 47, 48, 49, 
   50, 51, 52, 54, 55, 56, 57, 58, 59, 
   60, 61, 62, 66, 67, 68, 69, 
   70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
   80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
   90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 250;
    uY = 300;
    uXt = 250;
    uYt = 300;
    tX = 300;
    tY = 150;
    stage += 1;
    grid = loadImage("images/grid.png");
    arrAnimate = true;
    teleported = false;
  } 
  //stage 7
  if (stage == 7 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
   20, 29, 
   30, 36, 39, 
   40, 46, 49, 
   50, 56, 59, 
   60, 69, 
   70, 79, 
   80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
   90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 50;
    uY = 300;
    uXt = 50;
    uYt = 300;
    tX = 350;
    tY = 150;
    stage += 1;
    grid = loadImage("images/grid.png");
    arrAnimate = true;
    teleported = false;
  }
  //stage 8
  if (stage == 8 && teleported == true) {
    clearStage();
    Walls.addAll(Arrays.asList(
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
    20, 21, 23, 24, 25, 26, 28, 29, 
    30, 31, 33, 34, 35, 36, 38, 39, 
    40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 
    50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
    60, 62, 63, 64, 65, 66, 67, 69, 
    70, 79, 
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99));
    uX = 0;
    uY = 450;
    uXt = 0;
    uYt = 450;
    tX = 450;
    tY = 450;
    stage += 1;
    grid = loadImage("images/grid.png");
    arrAnimate = true;
    teleported = false;
  }
 

  current_loc = uXt/50 + (uYt/50)*10;
  background(210, 210, 210);
  setImageA(uFootprints, upFP);
  setImageA(uRFootprints, upRFP);
  setImageA(uLFootprints, upLFP);
  setImageA(lFootprints, leftFP);
  setImageA(lRFootprints, leftRFP);
  setImageA(lLFootprints, leftLFP);
  setImageA(dFootprints, downFP);
  setImageA(dRFootprints, downRFP);
  setImageA(dLFootprints, downLFP);
  setImageA(rFootprints, rightFP);
  setImageA(rRFootprints, rightRFP);
  setImageA(rLFootprints, rightLFP);
  image(target, tX+gridOffX, tY+gridOffY, 50, 50);
  if (uX != tX || uY != tY) {
    image(user, uX+gridOffX, uY+gridOffY, 50, 50);
  }
  setImageA(Walls, wall);
  image(grid, gridOffX, gridOffY, 500, 500);
  image(backscrn, 0, 0, 1024, 768);


  //teleport animation
  if (teleAnimate == false) {
    teleTimer = 0;
    teleport.rewind();
    teleport.pause();
  }
  teleX = tX+gridOffX - 50;
  teleY = tY+gridOffY - 450;
  if (teleAnimate && teleTimer < 32) {
    teleport.play();
    teleTimer += 1;
    image(tele, teleX, teleY, 150, 550);
    image(backscrn, 0, 0, 1024, 768);
    if (teleTimer > 28) {
      tele = loadImage("images/tele8.png");
    }
    else if (teleTimer > 24) {
      tele = loadImage("images/tele7.png");
    }
    else if (teleTimer > 20) {
      tele = loadImage("images/tele6.png");
    }
    else if (teleTimer > 16) {
      tele = loadImage("images/tele5.png");
    }
    else if (teleTimer > 12) {
      tele = loadImage("images/tele4.png");
    }
    else if (teleTimer > 8) {
      tele = loadImage("images/tele3.png");
    }
    else if (teleTimer > 4) {
      tele = loadImage("images/tele2.png");
    }
    else if (teleTimer < 4) {
      tele = loadImage("images/tele1.png");
    }
  }
  //arrival animation
  if (arrAnimate == false) {
    arrTimer = 0;
  }
  arrX = uX+gridOffX - 500;
  arrY = uY+gridOffY - 50;
  if (arrAnimate && arrTimer < 32) {
    arrive.play();
    arrTimer += 1;
    image(arr, arrX, arrY, 1050, 150);
    image(backscrn, 0, 0, 1024, 768);
    if (arrTimer > 28) {
      arr = loadImage("images/arrive8.png");
    }
    else if (arrTimer > 24) {
      arr = loadImage("images/arrive7.png");
    }
    else if (arrTimer > 20) {
      arr = loadImage("images/arrive6.png");
    }
    else if (arrTimer > 16) {
      arr = loadImage("images/arrive5.png");
    }
    else if (arrTimer > 12) {
      arr = loadImage("images/arrive4.png");
    }
    else if (arrTimer > 8) {
      arr = loadImage("images/arrive3.png");
    }
    else if (arrTimer > 4) {
      arr = loadImage("images/arrive2.png");
    }
    else if (arrTimer < 4) {
      arr = loadImage("images/arrive1.png");
    }
  }
  else if (arrTimer == 32) {
    arrive.rewind();
    arrive.pause();
  }

  textFont(f, 16);
  fill(255);
  text("Stage "+ stage, 2+gridOffX, 16+gridOffY);
  if (com_status.equals("INACTIVE")) {
    fill (255, 0, 0);
  }
  else {
    fill (0, 255, 0);
  }
  text(com_status, 410+gridOffX, 16+gridOffY);
  //control reset

  if (sByte.equals("9") && kHeld == true) {
    kHeld = false;
  }
  if (sByte.equals("8") && teleported == false) {
    stage -= 1;
    teleported = true;
  }
  //controls
  if ((sByte.equals("1")||kW) && kHeld == false) {
    if (boundary_test("up") && wall_test("up") ) {
      if (prev_dir.equals("left")) {
        right_turn.play();
        lRFootprints.add(current_loc);
      }
      else if (prev_dir.equals("right")) {
        left_turn.play();
        rLFootprints.add(current_loc);
      }
      else {
        uFootprints.add(current_loc);
      }
      prev_dir = "up";
      uYt -= 50;
      user = loadImage("images/userU.png");
      kHeld = true;
    } 
    else if (boundary_test("up") == false || wall_test("up") == false) {
      bump.play();
      bump_dir = "up";
      user = loadImage("images/userU.png");
      kHeld = true;
    }
  }
  if ((sByte.equals("3")||kS) && kHeld == false) {
    if (boundary_test("down") && wall_test("down")) {
      if (prev_dir.equals("left")) {
        left_turn.play();
        lLFootprints.add(current_loc);
      }
      else if (prev_dir.equals("right")) {
        right_turn.play();
        rRFootprints.add(current_loc);
      }
      else {
        dFootprints.add(current_loc);
      }
      prev_dir = "down";
      uYt += 50;
      user = loadImage("images/user.png");
      kHeld = true;
    }
    else if (boundary_test("down") == false || wall_test("down") == false) {
      bump.play();
      bump_dir = "down";
      user = loadImage("images/user.png");
      kHeld = true;
    }
  }
  if ((sByte.equals("2")||kA) && kHeld == false) {
    if (boundary_test("left") && wall_test("left")) {
      if (prev_dir.equals("up")) {
        left_turn.play();
        uLFootprints.add(current_loc);
      }
      else if (prev_dir.equals("down")) {
        right_turn.play();
        dRFootprints.add(current_loc);
      }
      else {
        lFootprints.add(current_loc);
      }
      prev_dir = "left";
      uXt -= 50;
      user = loadImage("images/userL.png");
      kHeld = true;
    }
    else if (boundary_test("left") == false || wall_test("left") == false) {
      bump.play();
      bump_dir = "left";
      user = loadImage("images/userL.png");
      kHeld = true;
    }
  }
  if ((sByte.equals("4")||kD) && kHeld == false) {
    if (boundary_test("right") && wall_test("right")) {
      if (prev_dir.equals("up")) {
        right_turn.play();
        uRFootprints.add(current_loc);
      }
      else if (prev_dir.equals("down")) {
        left_turn.play();
        dLFootprints.add(current_loc);
      }
      else {
        rFootprints.add(current_loc);
      }
      prev_dir = "right";
      uXt += 50;
      user = loadImage("images/userR.png");
      kHeld = true;
    }
    else if (boundary_test("right") == false || wall_test("right") == false) {
      bump.play();
      bump_dir = "right";
      user = loadImage("images/userR.png");
      kHeld = true;
    }
  }
}

//wall test
boolean wall_test(String dir) {
  if (dir.equals("up")) {
    int target_loc = current_loc-10;
    if (arrayTest(target_loc, Walls)) {
      return false;
    }
    else {
      return true;
    }
  }
  else if (dir.equals("left")) {
    int target_loc = current_loc-1;
    if (arrayTest(target_loc, Walls)) {
      return false;
    }
    else {
      return true;
    }
  }
  else if (dir.equals("down")) {
    int target_loc = current_loc+10;
    if (arrayTest(target_loc, Walls)) {
      return false;
    }
    else {
      return true;
    }
  }
  else if (dir.equals("right")) {
    int target_loc = current_loc+1;
    if (arrayTest(target_loc, Walls)) {
      return false;
    }
    else {
      return true;
    }
  }
  else {
    return true;
  }
}

//test if element is in array

boolean arrayTest(int value, ArrayList<Integer> arr) {
  for (int i = 0; i < arr.size(); i++) {
    if (arr.get(i) == value) {
      return true;
    }
  }
  return false;
}
//stops user from leaving stage
boolean boundary_test(String dir) {
  if (dir.equals("up") && uYt == 0) {
    return false;
  }
  else if (dir.equals("left") && uXt == 0) {
    return false;
  }
  else if (dir.equals("down") && uYt == gridHeight+gridOffY-50) {
    return false;
  }
  else if (dir.equals("right") && uXt == gridWidth+gridOffX-50) {
    return false;
  }
  else {
    return true;
  }
}

//remove element from list
void removeEle(ArrayList<Integer> arr, int ele) {
  for (int i = 0; i < arr.size(); i++) {
    if (arr.get(i) == ele) {
      arr.remove(i);
    }
  }
}
//apply image to location
void setImageA(ArrayList<Integer> arr, PImage img) {
  if (arr.size() > 0) {
    for (int i = 0; i < arr.size(); i++) {
      if (arr.get(i) < 10) {
        wX = arr.get(i)*50;
        wY = 0;
      }
      else if (arr.get(i) >= 10 && arr.get(i) < 20) {
        wX = (arr.get(i)-10)*50;
        wY = 50;
      }
      else if (arr.get(i) >= 20 && arr.get(i) < 30) {
        wX = (arr.get(i)-20)*50;
        wY = 100;
      }
      else if (arr.get(i) >= 30 && arr.get(i) < 40) {
        wX = (arr.get(i)-30)*50;
        wY = 150;
      }
      else if (arr.get(i) >= 40 && arr.get(i) < 50) {
        wX = (arr.get(i)-40)*50;
        wY = 200;
      }
      else if (arr.get(i) >= 50 && arr.get(i) < 60) {
        wX = (arr.get(i)-50)*50;
        wY = 250;
      }
      else if (arr.get(i) >= 60 && arr.get(i) < 70) {
        wX = (arr.get(i)-60)*50;
        wY = 300;
      }
      else if (arr.get(i) >= 70 && arr.get(i) < 80) {
        wX = (arr.get(i)-70)*50;
        wY = 350;
      }
      else if (arr.get(i) >= 80 && arr.get(i) < 90) {
        wX = (arr.get(i)-80)*50;
        wY = 400;
      }
      else if (arr.get(i) >= 90 && arr.get(i) < 100) {
        wX = (arr.get(i)-90)*50;
        wY = 450;
      }
      image(img, wX+gridOffX, wY+gridOffY, 50, 50);
    }
  }
}
//clear stage function
void clearStage() {
  Walls.clear();
  dFootprints.clear();
  dRFootprints.clear();
  dLFootprints.clear();
  uFootprints.clear();
  uRFootprints.clear();
  uLFootprints.clear();
  lFootprints.clear();
  lRFootprints.clear();
  lLFootprints.clear();
  rFootprints.clear();
  rRFootprints.clear();
  rLFootprints.clear();
  kHeld = false; 
  user = loadImage("images/user.png");
  teleAnimate = false;
  teleTimer = 0;
  arrAnimate = false;
  arrTimer = 0;
  prev_dir = "";
  myPort.write(2);
  com_status = "INACTIVE";
}
//removes previous footprint
void remove_prints() {
  removeEle(dFootprints, current_loc);
  removeEle(dRFootprints, current_loc);
  removeEle(dLFootprints, current_loc);
  removeEle(lFootprints, current_loc);
  removeEle(lRFootprints, current_loc);
  removeEle(lLFootprints, current_loc);
  removeEle(rFootprints, current_loc);
  removeEle(rRFootprints, current_loc);
  removeEle(rLFootprints, current_loc);
  removeEle(uFootprints, current_loc);
  removeEle(uRFootprints, current_loc);
  removeEle(uLFootprints, current_loc);
}
//bump function
void bump(int time, int bump_length) {
  if (bump_dir.equals("none") == false) {
    bump_count += 1;
  }
  if (bump_count < time/2 && bump_trigger == false) {
    if (bump_dir.equals("up")) {
      uYt -= bump_length;
      bump_trigger = true;
    }
    else if (bump_dir.equals("down")) {
      uYt += bump_length;
      bump_trigger = true;
    }
    else if (bump_dir.equals("left")) {
      uXt -= bump_length;
      bump_trigger = true;
    }
    else if (bump_dir.equals("right")) {
      uXt += bump_length;
      bump_trigger = true;
    }
  }
  else if (bump_count == time) {
    if (bump_trigger2 == false) {
      if (bump_dir.equals("up")) {
        uYt += bump_length;
        bump_trigger2 = true;
      }
      else if (bump_dir.equals("down")) {
        uYt -= bump_length;
        bump_trigger2 = true;
      }
      else if (bump_dir.equals("left")) {
        uXt += bump_length;
        bump_trigger2 = true;
      }
      else if (bump_dir.equals("right")) {
        uXt -= bump_length;
        bump_trigger2 = true;
      }
    }
    bump_dir = "none";
    bump_count = 0;
    bump_trigger = false;
    bump_trigger2 = false;
    bump.rewind();
    bump.pause();
  }
}
//keyboard for debugging
void keyReleased() {
  if (key == 'w' || key == 'W') {
    kW = false;
    kHeld = false;
  }
  if (key == 'a' || key == 'A') {
    kA = false;
    kHeld = false;
  }
  if (key == 'd' || key == 'D') {
    kD = false;
    kHeld = false;
  }
  if (key == 's' || key == 'S') {
    kS = false;
    kHeld = false;
  }
  if (key == 'r' || key == 'R') {
    kR = false;
    kHeld = false;
  }
}
void keyPressed() {
  if (key == 'w' || key == 'W') {
    kW = true;
  }
  if (key == 'a' || key == 'A') {
    kA = true;
  }
  if (key == 'd' || key == 'D') {
    kD = true;
  }
  if (key == 's' || key == 'S') {
    kS = true;
  }
  if (key == 'r' || key == 'R') {
    kR = true;
  }
}
void stop()
{
  teleport.close();
  arrive.close();
  bgm.close();
  run.close();
  left_turn.close();
  right_turn.close();
  bump.close();
  minim.stop();

  super.stop();
}

