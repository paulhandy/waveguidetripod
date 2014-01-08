/*
  This one is for PID control.  
  Here we will have a stationary center position about which we will sinusoidally move
*/
#include "./params.h"
void setup(){
  Serial.begin(9600);
  initPositionTracker();
  initMotorDriver();
  delay(0);
}
void loop(){
  int time = micros();
  float Ts = getSampleTime(time);
  int target = getTargetPosition(period, amplitude, center, time);
  target = 0;
  int force = pid(target, motorPosition, Kp, Ki, Kd, Fmax, Ts, Tau);
  Serial.print(target);
  Serial.print(" -> ");
  Serial.print(target-motorPosition);
  Serial.print(" # ");
  Serial.println(force);
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
