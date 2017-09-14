// Slide film - Automatic digitisation 
// HSLU - Design & Art
// Created 2017 by David Herren
// https://github.com/herdav/dia
// Licensed under the MIT License.
// -----------------------------------

const int button_start = 2;
const int button_stop = 3;
const int button_forw = 4;
const int button_back = 5;

const int relay_dia_forw = 12;
const int relay_dia_back = 11;
const int relay_cam = 13;

boolean button_start_pressed;
boolean button_stop_pressed;
boolean button_forw_pressed;
boolean button_back_pressed;

boolean run_start;
boolean run_stop;
boolean run_forw;
boolean run_back;

int delay_mechanic = 250;
int delay_count = 0;
int dia_count;
int dia_max = 5;

void setup() {
  Serial.begin(9600);
  pinMode(button_start, INPUT);
  pinMode(button_stop, INPUT);
  pinMode(button_forw, INPUT);
  pinMode(button_back, INPUT);
  pinMode(relay_dia_back, OUTPUT);
  pinMode(relay_dia_forw, OUTPUT);
  pinMode(relay_cam, OUTPUT);
}

void loop() {
  button_start_pressed = digitalRead(button_start);
  button_stop_pressed = digitalRead(button_stop);
  button_forw_pressed = digitalRead(button_forw);
  button_back_pressed = digitalRead(button_back);

  if (button_start_pressed == true) {
    run_start = true;
    run_stop = false;
  }
  if (button_stop_pressed == true) {
    run_start = false;
    run_stop = true;
    run_forw = false;
    run_back = false;
    delay_count = 0;
    dia_count = 0;
  }
  if (button_forw_pressed == true) {
    run_forw = true;
    run_stop = false;
  }
  if (button_back_pressed == true) {
    run_back = true;
    run_stop = false;
  }
  if (run_start == true && (run_forw == true || run_back == true) && run_stop != true) {
    if (delay_count < delay_mechanic && dia_count <= dia_max) {
      delay_count++;
      if (delay_count > 50 && delay_count < 100 && run_forw == true) {
        digitalWrite(relay_dia_forw, HIGH);
      } else {
        digitalWrite(relay_dia_forw, LOW);
      }
      if (delay_count > 50 && delay_count < 100 && run_back == true) {
        digitalWrite(relay_dia_back, HIGH);
      } else {
        digitalWrite(relay_dia_back, LOW);
      }
      if (delay_count == delay_mechanic) {
        digitalWrite(relay_cam, HIGH);
        delay(20);
        digitalWrite(relay_cam, LOW);
        delay_count = 0;
        dia_count++;
      }
    }
    if (dia_count == dia_max) {
      dia_count = 0;
      run_start = false;
      run_forw = false;
      run_back = false;
    }
  }
  Serial.print(run_start);
  Serial.print(run_stop);
  Serial.print(run_forw);
  Serial.println(run_back);
  Serial.print(dia_count);
  Serial.println(delay_count);
}
