// Slide film - Automatic digitisation 
// HSLU - Design & Art
// Created 2017 by David Herren
//-------------------------------

import processing.serial.*;
import cc.arduino.*;

PImage img_hslu_logo, img_button_forward, img_button_backward, img_button_cancel;

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
int dia_number = 5;

boolean dia_forward_run = false;
boolean dia_backward_run = false;
boolean dia_cancel_run = false;

boolean mouseover_button_forward;
boolean mouseover_button_backward;
boolean mouseover_button_cancel;

int button_width = 120;
int menu_width = 680;
float button_gap;
PVector button_forward, button_backward, button_cancel;
PVector menu, status;

float status_width;

void setup()
{
  size(1280, 720, P2D);

  img_hslu_logo = loadImage("\\img_hslu_logo.png");
  img_hslu_logo.resize(0, 100);
  img_button_forward = loadImage("\\img_button_forward.png");
  img_button_backward = loadImage("\\img_button_backward.png");
  img_button_cancel = loadImage("\\img_button_cancel.png");

  button_forward = new PVector(1040, 120);
  button_backward = new PVector(1040, 480);
  button_cancel = new PVector(1040, 300);

  button_gap = ((button_backward.y - button_forward.y) - 3*button_width)/2;

  menu = new PVector(300, 120);
  status = new PVector(300, menu.y);

  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  arduino.pinMode(dia_forward, Arduino.OUTPUT);
  arduino.pinMode(dia_backward, Arduino.OUTPUT);
  arduino.pinMode(cam_capture, Arduino.OUTPUT);

  arduino.digitalWrite(dia_forward, Arduino.LOW);
  arduino.digitalWrite(dia_backward, Arduino.LOW);
  arduino.digitalWrite(cam_capture, Arduino.LOW);
}

void draw()
{
  background(250);

  fill(230, 230, 230);
  rect(menu.x, menu.y, menu_width, 480);
  if (dia_forward_run == true) {
    status_width = menu_width / dia_number * count_forward;
  }
  if (dia_backward_run == true) {
    status_width = menu_width / dia_number * count_backward;
  }

  fill(20);
  rect(status.x, status.y+480, status_width, 20);

  textSize(12);
  textAlign(LEFT);
  fill(160);
  text("Created 2017 by David Herren @ HSLU D&K. Licensed under the MIT License. https://github.com/herdav/dia", 20, height-20);

  image(img_hslu_logo, 20, 20);
  image(img_button_forward, button_forward.x, button_forward.y);
  image(img_button_backward, button_backward.x, button_backward.y);
  image(img_button_cancel, button_cancel.x, button_cancel.y);

  noStroke();
  fill(200);
  rect(button_forward.x, button_forward.y, button_width, button_width);
  image(img_button_forward, button_forward.x, button_forward.y);

  if (mouseX > button_forward.x && mouseX < button_forward.x + button_width && mouseY > button_forward.y && mouseY < button_forward.y + button_width == true) {
    mouseover_button_forward = true;
  } else {
    mouseover_button_forward = false;
  }
  if (mouseX > button_backward.x && mouseX < button_backward.x + button_width && mouseY > button_backward.y && mouseY < button_backward.y + button_width == true) {
    mouseover_button_backward = true;
  } else {
    mouseover_button_backward = false;
  }
  if (mouseX > button_cancel.x && mouseX < button_cancel.x + button_width && mouseY > button_cancel.y && mouseY < button_cancel.y + button_width == true) {
    mouseover_button_cancel = true;
  } else {
    mouseover_button_cancel = false;
  }

  if (dia_cancel_run != true) {
    if ((mouseover_button_forward && mousePressed == true || count_forward > 0) && (dia_backward_run || dia_forward_run || dia_cancel_run) != true) {
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
      rect(button_forward.x, button_forward.y, button_width, button_width);
      image(img_button_forward, button_forward.x, button_forward.y);
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
    rect(button_backward.x, button_backward.y, button_width, button_width);
    image(img_button_backward, button_backward.x, button_backward.y);

    if ((mouseover_button_backward && mousePressed == true || count_backward > 0) && (dia_backward_run || dia_forward_run || dia_cancel_run) != true) {
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
      rect(button_backward.x, button_backward.y, button_width, button_width);
      image(img_button_backward, button_backward.x, button_backward.y);
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
  rect(button_cancel.x, button_cancel.y, button_width, button_width);
  image(img_button_cancel, button_cancel.x, button_cancel.y);

  if (mouseover_button_cancel && mousePressed == true) {
    dia_cancel_run = true;
    time_cancel = millis();
  }
  if (dia_cancel_run == true && millis() - time_cancel < 1000) {
    fill(255, 0, 0);
    rect(button_forward.x, button_forward.y, button_width, button_width);
    image(img_button_forward, button_forward.x, button_forward.y);
    rect(button_backward.x, button_backward.y, button_width, button_width);
    image(img_button_backward, button_backward.x, button_backward.y);
    rect(button_cancel.x, button_cancel.y, button_width, button_width);
    image(img_button_cancel, button_cancel.x, button_cancel.y);
    arduino.digitalWrite(cam_capture, Arduino.LOW);
    arduino.digitalWrite(dia_forward, Arduino.LOW);
    arduino.digitalWrite(dia_backward, Arduino.LOW);
    count_backward = 0;
    count_forward = 0;
    dia_forward_run = false;
    dia_backward_run = false;
    status_width = 0;
  } else {
    dia_cancel_run = false;
  }
}
