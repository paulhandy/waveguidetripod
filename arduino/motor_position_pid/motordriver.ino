void initMotorDriver()
{
  pinMode(motorPlusPin, OUTPUT);
  pinMode(motorMinusPin, OUTPUT);
  pinMode(motorEncoderPin, OUTPUT);
  
  setMotorDirection(1);
  setMotorDuty(100);
  delay(5);
  moveDirection = 1;
  setMotorDuty(0);
  delay(5);
  motorPosition = 0;
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
void setMotorDuty(int v)
{
  analogWrite(motorEncoderPin, v);
}

