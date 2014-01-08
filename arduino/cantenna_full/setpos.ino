
int getTargetPosition(int period, int amplitude, int center, int time)
{
  float sine = sin((float)time/period);
  return center + amplitude * sine;
}

int calculateCenterPosition(int period, int time)
{
  static int rssi[1000], location[1000], index, lastPeriod, center;
  int i, flag;
  if(Serial2.available() > 0)
  {
    rssiVal = pulseIn(rssiPin,LOW,200);
    //Serial.println(rssiVal);
    rssi[index] = rssiVal;
    location[index] = motorPosition;
    Serial2.read();
  }
  else
  {
    index--;
  }
  index++;
  if(time - lastPeriod > period*10/4)
  {
    int * x;
    lastPeriod = time;
    flag = 0;
    
    for(i = 0; i < 40; i++)
    {
      x = simplex(rssi, flag, index);
      flag = x[3];
    }
    //center = location[x[2]];
    int least = 1000, leastPos;
    int firstleastPos = -1, lastLeastPos;
    for(i = 0; i < index; i ++)
    {
      if(rssi[i]<least)
      {
        least = rssi[i];
        leastPos = i;
      }
      if(rssi[i] == least)
      {
        lastLeastPos = i;
      }
    }
    if(index > 0 && lastLeastVal < least)
    {
      center = location[(leastPos+lastLeastPos)/2];

    }
    if(location[x[2]] - center < 7000 && abs(lastLeastVal - least) < 2 )
    {
      stopMoving = 1;
    }else
    {
      stopMoving = 0;
      lastLeastVal = rssi[x[2]];
    }
    
    index = 0;
  }
  return center;
}
