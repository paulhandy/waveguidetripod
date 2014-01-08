#include "./init_params.h"
// This one checks out.  No more edits!

void setup()
{
  initPositionTracker();
  initMotorDriver();
}


void loop()
{
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
  if(millis()-lastTime > period)
  {
    selectDirection = -selectDirection;
    setMotorDirection(selectDirection);
    setMotorVelocity(10);
    Serial.println("NewDir");
    lastTime = millis();
  }
}








