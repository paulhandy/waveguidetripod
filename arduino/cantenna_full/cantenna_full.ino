/*
  Finding the center from an array using the nalder-mead simplex algorithm.
*/
/*
  This one is for PID control.  
  Here we will have a stationary center position about which we will sinusoidally move
*/
#include "./params.h"

void setup()
{
  randomSeed(analogRead(23));
  Serial.begin(9600);
  Serial2.begin(9600);
  pinMode(rssiPin, INPUT);
  initPositionTracker();
  initMotorDriver();
  delay(2000);
}
void loop()
{
  int time = micros();
  float Ts = getSampleTime(time);
  rssiVal = pulseIn(rssiPin,LOW,200);
  initialSearch(time);
  center = calculateCenterPosition(period, time);
  int target, force;
  if(stopMoving > 0)
  {
    target = center;
  }
  else
  {
    target = getTargetPosition(period, amplitude, center, time);
  }
  force = pid(target, motorPosition, Kp, Ki, Kd, Fmax, Ts, Tau);
  /*Serial.print(target);
  Serial.print(", ");
  Serial.print(motorPosition);
  Serial.println(";");*/
  setMotorDirection(force);
  setMotorDuty(abs(force));
}


float getSampleTime(int time)
{
  static int previousTime;
  float ts = (time-previousTime)*0.000001;
  previousTime = time;
  return ts;
}

void initialSearch(int time)
{
  static int startTime;
  if(startTime == 0)
  {
    startTime = time;
  }
  if(time - startTime > period*20){
    amplitude = 45000/6;
    period = 150000*2;
    return;
  }
  amplitude = 45000/2;
  period = 150000*4;
}


