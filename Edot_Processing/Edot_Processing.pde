import processing.sound.*;
SoundFile file;
SoundFile file_down;
import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial myPort;      // Initializing a vairable named 'myPort' for serial communication
PImage img;
PImage LOGO;
PImage LOGO2;
String val;
int play;
int old_play = 0;
int screen = 0;
float add;
float rate=1;
float control = 1;
float jump =-1;
float old_jump =-1;
float mark_in = -1;
float old_mark_in = -1;
float mark_out =-1;
float old_mark_out = -1;

color first_c  = 0;
color second_c  = 0;
color third_c  = #CAFF29;
FloatList down_window_list;

boolean add_m = false;
int drop_down;
int cut;


void setup() {
  //size(640, 360);
  fullScreen(1);
  background(0);
  down_window_list = new FloatList();

  //////////ARDUINO
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n'); 
  /////////

  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "Recording.aiff");
  file_down = new SoundFile(this, "Recording.aiff");

  img = loadImage("_GAL_0001_Brightness_Contrast-1.png");
  img.resize(width, height/2);
  LOGO = loadImage("LOGO.png");
  LOGO2 = loadImage("LOGO2.png");
  //LOGO.resize(width, height/50);
  //create outlines
  draw_wave_up();
}      

void draw() {
  //check_key();

  draw_wave_up();
  draw_wave_down();

  //println("play: ", play, "rtae: ", rate, "mark_in: ", mark_in, "mark_out", mark_out, "jump: ", jump);
  if (screen == 0) {
    check_play();
    draw_line_up();
  }
  if (screen == 1) {
    check_play_down();
    draw_line_down();
  }
  draw_rects();
  file.rate(control);
  check_end();
  mark();
  jump_to();
}

void draw_wave_up() {
  //upper

  image(img, -2, 0);
  image(LOGO, 30, 30, width/20, height/20);
  image(LOGO2, width- width/15, 30, width/20, height/20);
}


void draw_wave_down() {
  for (int i = 0; i < down_window_list.size(); i+=2) {

    float a =  (down_window_list.get(i));
    a = map(a, 0, file.duration(), 0, width);
    float b =  (down_window_list.get(i+1));
    b = map(b, 0, file.duration(), 0, width);
    int w = (int)(b-a);

    copy(img,(int)a, 0, w, height/2, 0, height/2+1, w, height/2+5);
  }
}
void draw_rects() {
  strokeWeight(1);
  stroke(255, 100);
  line(0, height/2, width, height/2);
}


void draw_line_up() {
  float p =file.position(); 
  float x_pos = map(p, 0, file.duration(), 0, width);
  if (mark_in >= 0 && mark_out <0) {
    noStroke();
    fill(150, 100);
    float mark_in_x_pos = map(mark_in, 0, file.duration(), 0, width);
    rect(mark_in_x_pos, 0, x_pos-mark_in_x_pos, height/2);
  } else if (mark_in >= 0 && mark_out  > 0) {
    noStroke();
    fill(150, 100);
    float mark_in_x_pos = map(mark_in, 0, file.duration(), 0, width);
    float mark_out_x_pos = map(mark_out, 0, file.duration(), 0, width);
    rect(mark_in_x_pos, 0, mark_out_x_pos - mark_in_x_pos, height/2);
  }
  stroke(255);
  strokeWeight(10);
  line(x_pos, 0, x_pos, height/2-5);
  draw_rects();
}

void draw_line_down() {
  float p =file_down.position(); 
  float a =  (down_window_list.get(0));
  //a = map(a, 0, file_down.duration(), 0, width);
  float b =  (down_window_list.get(1));
  //b = map(b, 0, file_down.duration(), 0, width);
  int w = (int)(b-a);
  w= (int)map(w, 0, file_down.duration(), 0, width);
  w = (int)map(p, a, b, 0, w);
  //float x_pos = map(p, 0, file_down.duration(), 0, w);
  //if (mark_in >= 0 && mark_out <0) {
  //  noStroke();
  //  fill(150, 100);
  //  float mark_in_x_pos = map(mark_in, 0, file_down.duration(), 0, width);
  //  rect(mark_in_x_pos, height/2, x_pos-mark_in_x_pos, height);
  //} else if (mark_in >= 0 && mark_out  > 0) {
  //  noStroke();
  //  fill(150, 100);
  //  float mark_in_x_pos = map(mark_in, 0, file_down.duration(), 0, width);
  //  float mark_out_x_pos = map(mark_out, 0, file_down.duration(), 0, width);
  //  rect(mark_in_x_pos, height/2, mark_out_x_pos - mark_in_x_pos, height);
  //}
  stroke(255);
  strokeWeight(10);

  line(w, height/2+5, w, height);
    draw_rects();
}


void check_play_down() {
  mark_in = -1;
  old_mark_in = -1;
  mark_out =-1;
  old_mark_out = -1;
  if (file.isPlaying()) {
    file.pause();
  }

  if (screen == 1  && !file_down.isPlaying() ) {
    file_down.play();
    if (file_down.position() <= down_window_list.get(0)) {
      file_down.jump(down_window_list.get(0));
    }
  }
  if (play == 1 && !file_down.isPlaying()) {
    file_down.play();
  } else if (play == 0 && file_down.isPlaying()) {
    file_down.pause();
  }
  //println(screen, down_window_list.get(1));
  if (file_down.position() >= down_window_list.get(1) && file_down.isPlaying()) {
    file_down.jump(down_window_list.get(0));
  }
  old_jump = jump;
}





void check_play() {
  if (file_down.isPlaying()) {
    file_down.pause();
  }
  if (screen == 0) {
    if (play == 1 && !file.isPlaying()) {
      file.play();
    } else if (play == 0 && file.isPlaying()) {
      file.pause();
    }
  }
}

void mark() {
  if (drop_down == 1 && mark_in != old_mark_in && mark_out!= old_mark_out) {
    down_window_list.append(mark_in);
    down_window_list.append(mark_out);
    old_mark_in = mark_in;
    old_mark_out = mark_out;
    drop_down = 0;
  }
  if (mark_in >= 0 && mark_out >=0 && file.position() >= mark_in && file.position() <= mark_out) {
    file.jump(mark_out);
  }
}

void jump_to() {
  if (jump != old_jump) {
    file.jump(jump);
    old_jump = jump;
  }
}

void check_end() {
  if (file.position() >= file.duration() - 0.5 ) {
    file.jump(0);
  }
}


void serialEvent( Serial myPort) 
{
  val = myPort.readStringUntil('\n');
  //print(val);
  if (val != null)
  {
    val = trim(val);
    println("screen: ", screen, "control: ", control, "play: ", play, "drop_down: ", drop_down, "cut: ", cut, "mark_in: ", mark_in, "mark_out: ", mark_out);
    //panel,control,play,insert,cut,mark_in, mark_out;
    float[] vals = float(splitTokens(val, ","));
    //println("X: ", vals[0], "Y: ", vals[1], "B: ", vals[2], "FSR: ", vals[3], "SONAR: ", vals[4], "COLOR: ", vals[5], "L1: ", vals[6], "L2: ", vals[7]);
    if ((int)vals[0] > 20) {
      screen = 1;
    } else {
      screen = 0;
    }


    if (vals[1] <= 100) {
      control = 0.5;
    } else if (vals[1] <= 500) {
      control = 1;
    } else {
      control =  map(vals[1], 500, 1023, 1, 4);
    }
    //control =  map(control, 0 ,1023, 0,4);
    //control = min(0.5,control);

    if ((int)vals[2] != old_play) {
      old_play = play;
      play = (int)vals[2];
    }
    drop_down = (int)vals[3];
    cut = (int)vals[4];
    if (vals[5] > 0) {
      mark_in = file.position();
    }
    if (vals[6] > 0) {
      mark_out = file.position();
    }
  }
}

void check_key() {
  ///////////////////////////////////////DELETE
  rate = 1;
  if (keyPressed) {
    if (keyCode == RIGHT) {
      play = 1 - play;
    } else if (keyCode == UP) {
      rate += 0.1;
    } else if (keyCode == DOWN) {
      rate -= 0.1;
    } else if (keyCode == 'I') {
      mark_in = file.position();
    } else if (keyCode == 'O') {
      mark_out = file.position();
    } else if (keyCode == 'J') {
      jump  = 0;
    } else if (keyCode == 'D') {
      drop_down = 1;
    } else if (keyCode == 'S') {
      screen = 1 - screen;
    }
  }
}
