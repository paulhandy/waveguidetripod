
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
