int pVal;
int dir = 0;
boolean activated = false;
boolean toggleSwitch = false;
int tileNum = 0;
long previousMillis = 0;
long interval = 1000; 
int prevDir;
int prev_1 = -1;
int prev_2 = -1;
int prev_3 = -1;
int prev_4 = -1;
int prev_5 = -1;
int prev_6 = -1;
int prev_7 = -1;
int prev_8 = -1;
boolean terminated = false;

void setup()
{
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  Serial.begin(9600);
}

void loop()
{
  if (Serial.available())
  {
    pVal = Serial.read();
  }
  unsigned long currentMillis = millis();
  //push button toggle switch
  int pushValue = analogRead(A4);
  if (pushValue < 250 && toggleSwitch == true){
    toggleSwitch = false; 
  }
  if (pushValue > 500 && activated == false && toggleSwitch == false){
    toggleSwitch = true;
    activated = true;
    terminated = false;
  }
  if (pushValue > 500 && activated == true && toggleSwitch == false){
    toggleSwitch = true;
    activated = false; 
  }
  if (pVal == 0){
    activated = false;
  }
  if (pVal == 2){
    dir = 10;
  }
  //restart tiles
  if (activated == false){
    tileNum = 1;
    prev_1 = -1;
    prev_2 = -1;
    prev_3 = -1;
    prev_4 = -1;
    prev_5 = -1;
    prev_6 = -1;
    prev_7 = -1;
    prev_8 = -1;
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    digitalWrite(9, LOW);
    if (dir < 10){
    dir = 8;
    Serial.println(dir);
    }
  }

  //start
  if (pVal == 1){
    if (activated){
      if (dir==8|| dir==10){
        previousMillis = currentMillis;
        tileNum = 1;
        dir = 0;
      }
      if (tileNum == 9){
        tileNum = 1; 
      }
      if(currentMillis - previousMillis > interval/2) {
        dir = 9;
      }
      if(currentMillis - previousMillis > interval) {
        previousMillis = currentMillis; 
        tileNum += 1;
        dir = 0;
      }
      if (tileNum == 9){
        tileNum = 1;
      }
      if (tileNum == 1){
        digitalWrite(9, LOW);
        digitalWrite(2, HIGH);
      }
      else if (tileNum == 2){
        digitalWrite(2, LOW);
        digitalWrite(3, HIGH);
      }
      else if (tileNum == 3){
        digitalWrite(3, LOW);
        digitalWrite(4, HIGH);
      }
      else if (tileNum == 4){
        digitalWrite(4, LOW);
        digitalWrite(5, HIGH);
      }
      else if (tileNum == 5){
        digitalWrite(5, LOW);
        digitalWrite(6, HIGH);
      }
      else if (tileNum == 6){
        digitalWrite(6, LOW);
        digitalWrite(7, HIGH);
      }
      else if (tileNum == 7){
        digitalWrite(7, LOW);
        digitalWrite(8, HIGH);
      }
      else if (tileNum == 8){
        digitalWrite(8, LOW);
        digitalWrite(9, HIGH);
      }


      int topValue = analogRead(A0);
      int leftValue = analogRead(A1);
      int downValue = analogRead(A2);
      int rightValue = analogRead(A3);
      if (topValue > 200){
        if(dir == 0){
          dir = 1;
          if (tileNum == 1){
            if (prev_1 == 1 || prev_1 == -1){
              prev_1 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 2){
            if (prev_2 == 1 || prev_2 == -1){
              prev_2 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 3){
            if (prev_3 == 1 || prev_3 == -1){
              prev_3 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 4){
            if (prev_4 == 1 || prev_4 == -1){
              prev_4 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 5){
            if (prev_5 == 1 || prev_5 == -1){
              prev_5 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 6){
            if (prev_6 == 1 || prev_6 == -1){
              prev_6 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 7){
            if (prev_7 == 1 || prev_7 == -1){
              prev_7 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 8){
            if (prev_8 == 1 || prev_8 == -1){
              prev_8 = 1;
            }else{
              activated = false;
              terminated = true;
            }
          }
        }
      }
      else if (leftValue > 200){
        if(dir == 0){
          dir = 2; 
          if (tileNum == 1){
            if (prev_1 == 2 || prev_1 == -1){
              prev_1 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 2){
            if (prev_2 == 2 || prev_2 == -1){
              prev_2 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 3){
            if (prev_3 == 2 || prev_3 == -1){
              prev_3 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 4){
            if (prev_4 == 2 || prev_4 == -1){
              prev_4 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 5){
            if (prev_5 == 2 || prev_5 == -1){
              prev_5 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 6){
            if (prev_6 == 2 || prev_6 == -1){
              prev_6 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 7){
            if (prev_7 == 2 || prev_7 == -1){
              prev_7 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 8){
            if (prev_8 == 2 || prev_8 == -1){
              prev_8 = 2;
            }else{
              activated = false;
              terminated = true;
            }
          }
        }
      }
      else if (downValue > 200){
        if(dir == 0){
          dir = 3; 
          if (tileNum == 1){
            if (prev_1 == 3 || prev_1 == -1){
              prev_1 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 2){
            if (prev_2 == 3 || prev_2 == -1){
              prev_2 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 3){
            if (prev_3 == 3 || prev_3 == -1){
              prev_3 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 4){
            if (prev_4 == 3 || prev_4 == -1){
              prev_4 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 5){
            if (prev_5 == 3 || prev_5 == -1){
              prev_5 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 6){
            if (prev_6 == 3 || prev_6 == -1){
              prev_6 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 7){
            if (prev_7 == 3 || prev_7 == -1){
              prev_7 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 8){
            if (prev_8 == 3 || prev_8 == -1){
              prev_8 = 3;
            }else{
              activated = false;
              terminated = true;
            }
          }
        }
      }
      else if (rightValue > 200){
        if(dir == 0){
          dir = 4; 
          if (tileNum == 1){
            if (prev_1 == 4 || prev_1 == -1){
              prev_1 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 2){
            if (prev_2 == 4 || prev_2 == -1){
              prev_2 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 3){
            if (prev_3 == 4 || prev_3 == -1){
              prev_3 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 4){
            if (prev_4 == 4 || prev_4 == -1){
              prev_4 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 5){
            if (prev_5 == 4 || prev_5 == -1){
              prev_5 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 6){
            if (prev_6 == 4 || prev_6 == -1){
              prev_6 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 7){
            if (prev_7 == 4 || prev_7 == -1){
              prev_7 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 8){
            if (prev_8 == 4 || prev_8 == -1){
              prev_8 = 4;
            }else{
              activated = false;
              terminated = true;
            }
          }
        }
      }
      else{
        dir = 0;
        if (tileNum == 1){
            if (prev_1 == 0 || prev_1 == -1){
              prev_1 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 2){
            if (prev_2 == 0 || prev_2 == -1){
              prev_2 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 3){
            if (prev_3 == 0 || prev_3 == -1){
              prev_3 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 4){
            if (prev_4 == 0 || prev_4 == -1){
              prev_4 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 5){
            if (prev_5 == 0 || prev_5 == -1){
              prev_5 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 6){
            if (prev_6 == 0 || prev_6 == -1){
              prev_6 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 7){
            if (prev_7 == 0 || prev_7 == -1){
              prev_7 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }else if (tileNum == 8){
            if (prev_8 == 0 || prev_8 == -1){
              prev_8 = 0;
            }else{
              activated = false;
              terminated = true;
            }
          }
        tileNum +=1;
      }
      Serial.println(dir);
    }
  }
  else{
    activated = false;
  }
}





