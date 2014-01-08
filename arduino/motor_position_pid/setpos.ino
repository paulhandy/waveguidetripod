int getTargetPosition(int period, int amplitude, int center, int time)
{
  static int lastperiod, target, sign;
  if(time - lastperiod > period)
  {
    if(sign == 0)
    {
      sign = 1;
    }
    target = center + sign*amplitude;
    sign = -sign;
    lastperiod = time;
  }
  float sine = sin((float)time/period);
  return center + amplitude * sine;
}


