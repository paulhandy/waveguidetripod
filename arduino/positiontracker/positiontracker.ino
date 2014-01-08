
/*
  THIS CODE NOW WORKS, IT APPEARS.  DO NOT CHANGE THIS, ONLY COPY FOR USE IF NECESSARY.
*/

int motorAPin = 11,
motorBPin = 12;
int lastCaller = 0,
moveDirection = 1,
motorPosition = 0;
int swtch = 1;
void setup()
{
  initPositionTracker();
}

void loop()
{
  //Serial.println(motorPosition);
  static int lastDirection;
  if(lastDirection != moveDirection)
  {
    lastDirection = moveDirection;
    if(moveDirection > 0)
    {
      Serial.print("-");
    }
    else
    {
      Serial.print("+");
    }
    Serial.print("Change of Direction: ");
    Serial.println(motorPosition);
  }
  //Serial.println(motorPosition);
}
void initPositionTracker()
{
  pinMode(motorAPin, INPUT);
  pinMode(motorBPin, INPUT);
  attachInterrupt(motorAPin, motorAChange, CHANGE);
  attachInterrupt(motorBPin, motorBChange, CHANGE);
}
void motorAChange(){
  updatePosition(1);
}
void motorBChange(){
  updatePosition(-1);
}
void updatePosition(int caller)
{
  if(caller == lastCaller)
  {
    if(moveDirection > 0)
    {
      moveDirection = -1;
    }
    else
    {
      moveDirection = 1;
    }
  }
  if(moveDirection > 0)
  {
    motorPosition++;
  }
  else
  {
    motorPosition--;
  }
  lastCaller = caller;
}
