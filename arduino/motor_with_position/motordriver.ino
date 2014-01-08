


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

