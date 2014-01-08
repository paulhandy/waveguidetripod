
/*
  Well, if nothing else works to get the thing moving, the timing that is used here could be used on the motor to get it to go where I want. But here is working motor driver code.
*/
int motorPlusPin = 7, 
motorMinusPin = 8,
motorEncoderPin = 6;
int period = 500, lastTime = 0, selectDirection = 1;
void setup()
{
  initMotorDriver();
}
void loop()
{
  if(millis()-lastTime > period)
  {
    selectDirection = -selectDirection;
    setMotorDirection(selectDirection);
    setMotorVelocity(255);
    Serial.println("NewDir");
    lastTime = millis();
  }
}


void initMotorDriver()
{
  pinMode(motorPlusPin, OUTPUT);
  pinMode(motorMinusPin, OUTPUT);
  pinMode(motorEncoderPin, OUTPUT);
}
void setMotorDirection(int dir)
{
  if(dir > 0){
    digitalWrite(motorPlusPin, HIGH);
    digitalWrite(motorMinusPin, LOW);
  }else{
    digitalWrite(motorPlusPin, LOW);
    digitalWrite(motorMinusPin, HIGH);
  }
}
void setMotorVelocity(int v)
{
  analogWrite(motorEncoderPin, v);
}
