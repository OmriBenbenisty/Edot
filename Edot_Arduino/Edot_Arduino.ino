#define PANEL A0 // panel editing switch
//#define CONTROL A1 
#define potentiometer A4
//#define fsrPin A3     // the FSR and 10K pulldown are connected to a0
//#define trigger 2

//// rotary dial
//#define CLK 2
//#define DT 3
//#define SW 4

#define PLAY_PAUSE 5
#define INSERT 6
#define CUT 7
#define MARK_IN 8
#define MARK_OUT 9
#define vibePin A5

//float panel, clk, dt, sw, play, insert, cut, mark_in, mark_out;
float panel, pote, play, insert, cut, mark_in, mark_out;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(PLAY_PAUSE, INPUT);
  pinMode(INSERT, INPUT);
  pinMode(CUT, INPUT);
  pinMode(MARK_IN, INPUT);
  pinMode(MARK_OUT, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  panel = analogRead(PANEL);
//  clk = digitalRead(CLK);
//  dt = digitalRead(DT);
//  sw = digitalRead(SW);
  pote = analogRead(potentiometer);
  play = digitalRead(PLAY_PAUSE);
  insert = digitalRead(INSERT);
  cut = digitalRead(CUT);
  mark_in = digitalRead(MARK_IN);
  mark_out = digitalRead(MARK_OUT);


//  Serial.print(clk);
//  Serial.print(",");
//
//  Serial.print(dt);
//  Serial.print(",");
//
//  Serial.print(sw);
//  Serial.print("\n");
//  delay(2000);

//   Print to Serial
// panel,pote,play,insert,cut,mark_in,mark_out\n
  Serial.print(panel, DEC);
  Serial.print(",");
  Serial.print(pote);
  Serial.print(",");
  Serial.print(play);
  Serial.print(",");
  Serial.print(insert, DEC);
  Serial.print(",");
  Serial.print( cut, DEC);
  Serial.print(",");
  Serial.print(mark_in, DEC);
  Serial.print(",");
  Serial.print(mark_out);
  Serial.print("\n");
  delay(10);

  

}
