// DIA-Film Automatic Digitisation
// HSLU - Design & Art
// Created 2017 by David Herren
//-------------------------------

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int dia_forward = 7;
int dia_backward = 4;
int cam_capture = 2;

//-------------------------------

int delay = 2000;

int time_start_forward;
int time_start_backward;
int time_cancel;

int count_forward = 0;
int count_backward = 0;
int dia_number = 20;

boolean dia_forward_run = false;
boolean dia_backward_run = false;
boolean dia_cancel_run = false;

int l = 100;
int s, y;
PVector b0, b1, b2;

void setup()
{
  size(500, 250);
  s = (width-3*l)/4;
  y = height/2;
  b0 = new PVector(s+l/2, y);
  b1 = new PVector(2*s+l+l/2, y);
  b2 = new PVector(3*s+2*l+l/2, y);

  arduino = new Arduino(this, "COM6", 57600);

  arduino.pinMode(dia_forward, Arduino.OUTPUT);
  arduino.pinMode(dia_backward, Arduino.OUTPUT);
  arduino.pinMode(cam_capture, Arduino.OUTPUT);

  arduino.digitalWrite(cam_capture, Arduino.LOW);
  arduino.digitalWrite(dia_forward, Arduino.LOW);
  arduino.digitalWrite(dia_backward, Arduino.LOW);

  rectMode(CENTER);
}

void draw()
{
  background(255);
  noStroke();

  fill(200);
  rect(b0.x, b0.y, l, l);

  if (dia_cancel_run != true) {
    if ((mouseX > s && mouseX < s+l && mouseY > y-l/2 && mouseY < y+l && mousePressed == true || count_forward > 0) && (dia_backward_run || dia_forward_run || dia_cancel_run) != true) {
      count_forward++;
      dia_forward_run = true;
      arduino.digitalWrite(cam_capture, Arduino.LOW);
      arduino.digitalWrite(dia_forward, Arduino.HIGH);
      delay(50);
      arduino.digitalWrite(dia_forward, Arduino.LOW);
      time_start_forward = millis();
    }
    if (dia_forward_run == true && millis() - time_start_forward < delay && dia_cancel_run != true) {    
      fill(0, 255, 0);
      rect(b0.x, b0.y, l, l);
      if (millis() - time_start_forward > delay - 500) {
        arduino.digitalWrite(cam_capture, Arduino.HIGH);
      } else {
        arduino.digitalWrite(cam_capture, Arduino.LOW);
      }
    } else {
      dia_forward_run = false;
    }
    if (count_forward == dia_number) {
      count_forward = 0;
    }
    println("FORWARD: ", dia_forward_run, count_forward);

    fill(200);
    rect(b1.x, b1.y, l, l); 

    if ((mouseX > 2*s + l && mouseX < 2*s+2*l && mouseY > y-l/2 && mouseY < y+l && mousePressed == true || count_backward > 0) && (dia_backward_run || dia_forward_run || dia_cancel_run) != true) {
      count_backward++;
      dia_backward_run = true;
      arduino.digitalWrite(cam_capture, Arduino.LOW);
      arduino.digitalWrite(dia_backward, Arduino.HIGH);
      delay(50);
      arduino.digitalWrite(dia_backward, Arduino.LOW);
      time_start_backward = millis();
    }
    if (dia_backward_run == true && millis() - time_start_backward < delay && dia_cancel_run != true) {    
      fill(0, 255, 0);
      rect(b1.x, b1.y, l, l);
      if (millis() - time_start_backward > delay - 500) {
        arduino.digitalWrite(cam_capture, Arduino.HIGH);
      } else {
        arduino.digitalWrite(cam_capture, Arduino.LOW);
      }
    } else {
      dia_backward_run = false;
    }
    if (count_backward == dia_number) {
      count_backward = 0;
    }
    println("BACKWARD:", dia_backward_run, count_backward);
  }

  fill(200);
  rect(b2.x, b2.y, l, l);

  if (mouseX > 3*s + 2*l && mouseX < 3*s+3*l && mouseY > y-l/2 && mouseY < y+l && mousePressed == true) {
    dia_cancel_run = true;
    time_cancel = millis();
  }
  if (dia_cancel_run == true && millis() - time_cancel < 1000) {
    fill(255, 0, 0);
    rect(b0.x, b0.y, l, l);
    rect(b1.x, b1.y, l, l);
    rect(b2.x, b2.y, l, l);
    arduino.digitalWrite(cam_capture, Arduino.LOW);
    arduino.digitalWrite(dia_forward, Arduino.LOW);
    arduino.digitalWrite(dia_backward, Arduino.LOW);
    count_backward = 0;
    count_forward = 0;
    dia_forward_run = false;
    dia_backward_run = false;
  } else {
    dia_cancel_run = false;
  }
}