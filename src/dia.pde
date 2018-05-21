// Slide film - Automatic digitisation 
// HSLU - Design & Art
// Created 2017 by David Herren
// https://github.com/herdav/dia
// Licensed under the MIT License.
// -----------------------------------

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int dia_forward = 7;
int dia_backward = 4;
int cam_capture = 2;

int mechanics_delay = 2000;

// -----------------------------------

PImage img_hslu_logo, img_button_forward, img_button_backward, img_button_cancel;

int time_start_forward, time_start_backward, time_cancel;
int count_forward, count_backward, dia_number;

boolean dia_forward_run, dia_backward_run, dia_cancel_run, dia_forward_run_finished, dia_backward_run_finished;
boolean mouseover_button_forward, mouseover_button_backward, mouseover_button_cancel;

int button_width = 120;
int menu_width = 680;
int input_delay = 200;

float button_gap, status_width;

PVector button_forward, button_backward, button_cancel, menu, status;

int input_01, input_10, input_11, input_val, input_position, input_start, input_end, finished;

void setup()
{
  size(1280, 720);
  noStroke();

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
  menu();
  arduino();
}
void arduino() {
  if (dia_cancel_run != true && dia_number > 0) {
    if ((mouseover_button_forward && mousePressed == true || count_forward > 0) && (dia_forward_run || dia_backward_run || dia_cancel_run) != true) {
      count_forward++;
      dia_forward_run = true;
      arduino.digitalWrite(cam_capture, Arduino.LOW);
      arduino.digitalWrite(dia_forward, Arduino.HIGH);
      delay(50);
      arduino.digitalWrite(dia_forward, Arduino.LOW);
      time_start_forward = millis();
    }
    if (dia_forward_run == true && millis() - time_start_forward < mechanics_delay && dia_cancel_run != true) {    
      fill(0, 255, 0);
      rect(button_forward.x, button_forward.y, button_width, button_width);
      image(img_button_forward, button_forward.x, button_forward.y);
      if (millis() - time_start_forward > mechanics_delay - 500) {
        arduino.digitalWrite(cam_capture, Arduino.HIGH);
      } else {
        arduino.digitalWrite(cam_capture, Arduino.LOW);
      }
    } else {
      dia_forward_run = false;
    }
    if (count_forward == dia_number) {
      count_forward = 0;
      dia_forward_run_finished = true;
    } 
    if ((mouseover_button_backward && mousePressed == true || count_backward > 0) && (dia_forward_run || dia_backward_run || dia_cancel_run) != true) {
      count_backward++;
      dia_backward_run = true;
      arduino.digitalWrite(cam_capture, Arduino.LOW);
      arduino.digitalWrite(dia_backward, Arduino.HIGH);
      delay(50);
      arduino.digitalWrite(dia_backward, Arduino.LOW);
      time_start_backward = millis();
    }
    if (dia_backward_run == true && millis() - time_start_backward < mechanics_delay && dia_cancel_run != true) {    
      fill(0, 255, 0);
      rect(button_backward.x, button_backward.y, button_width, button_width);
      image(img_button_backward, button_backward.x, button_backward.y);
      if (millis() - time_start_backward > mechanics_delay - 500) {
        arduino.digitalWrite(cam_capture, Arduino.HIGH);
      } else {
        arduino.digitalWrite(cam_capture, Arduino.LOW);
      }
    } else {
      dia_backward_run = false;
    }
    if (count_backward == dia_number) {
      count_backward = 0;
      dia_backward_run_finished = true;
    }
  }
  if (mouseover_button_cancel && mousePressed == true || (dia_forward_run || dia_backward_run) == true && keyPressed == true) {
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
    
    input_01 = 0;
    input_10 = 0;
    input_11 = 0;
    input_val = 0;    
    status_width = 0;
  } else {
    dia_cancel_run = false;
  }
}
void menu() {
  background(250);

  fill(230, 230, 230);
  rect(menu.x, menu.y, menu_width, 480);

  image(img_hslu_logo, 20, 20);
  image(img_button_forward, button_forward.x, button_forward.y);
  image(img_button_backward, button_backward.x, button_backward.y);
  image(img_button_cancel, button_cancel.x, button_cancel.y);

  textSize(12);
  textAlign(LEFT);
  fill(160);
  text("Created 2017 by David Herren @ HSLU D&K. Licensed under the MIT License. https://github.com/herdav/dia", 20, height-20);
  textSize(30);
  fill(20);
  text("Slide film - Automatic digitisation", menu.x + 20, menu.y + 40);

  fill(200);
  rect(button_forward.x, button_forward.y, button_width, button_width);
  image(img_button_forward, button_forward.x, button_forward.y);
  rect(button_backward.x, button_backward.y, button_width, button_width);
  image(img_button_backward, button_backward.x, button_backward.y);
  rect(button_cancel.x, button_cancel.y, button_width, button_width);
  image(img_button_cancel, button_cancel.x, button_cancel.y);

  fill(255, 0, 0);
  textSize(80);
  text(input_val, menu.x + menu_width/2 - 20, menu.y + height/2 - 20);

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

  if (dia_number > 0) {
    if (dia_forward_run == true) {
      status_width = menu_width / dia_number * count_forward;
    } 
    if (dia_backward_run == true) {
      status_width = menu_width / dia_number * count_backward;
    }
    if (dia_forward_run_finished == true || dia_backward_run_finished == true) {
      status_width = menu_width;
    }
  }

  if (mousePressed == true) {
    dia_forward_run_finished = false;
    dia_backward_run_finished = false;
  }
  
  fill(50);
  rect(status.x, status.y+460, status_width, 20);
  
  fill(255, 0, 0);
  textSize(16);
  text("Please enter the number of images, then click the up or down button.", menu.x + 20, menu.y + 160);

  if (keyPressed && key >= 48 && key <= 58) {
    if (input_position == 0 && millis() - input_end > input_delay || millis() - input_start > 1000) {
      input_01 = key - 48;
      input_10 = 0;
      input_position = 1;
      input_start = millis();
    }
    if (input_position == 1 && millis() - input_start > input_delay) {
      input_01 = input_01 * 10;
      input_10 = (key - 48);    
      input_position = 0;
      input_end = millis();
    }
  }
  input_11 = input_01 + input_10;
  dia_number = input_11;

  if (dia_forward_run == true) {
    input_val = input_11 - count_forward;
  } else {
    input_val = input_11 - count_backward;
  }
}
