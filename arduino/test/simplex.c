int * simplex(int val[], int flag, int len)
{
  // posh is the holder position
  static int x[4], posh, n = 3, xb, xr, xc, alpha = 1, beta = 0.25, gamma = 2.5;
  if(flag == 0)
  {
    x[0] = 0;
    x[1] = len/2;
    x[2] = len-1;
    if(val[x[0]] < val[x[1]])
    {
      if(val[x[0]] < val[x[2]])
      {
        posh = x[0];
        x[0] = x[2];
        x[2] = posh;
      }
      else
      {  
        posh = x[0];
        x[0] = x[1];
        x[1] = posh;
      }
    }
    else if(val[x[1]] < val[x[2]])
    {
      if(val[x[0]] < val[x[2]])
      {
        posh = x[0];
        x[0] = x[2];
        x[2] = x[1];
        x[1] = posh;
      }
      else
      {
        posh = x[1];
        x[1] = x[2];
        x[2] = posh;
      }
    }
    flag = 1;
  }
  if(flag == -1)
  {
    flag = 1;
    if(val[xr] < val[x[2]])
    {
      x[0] = x[1];
      x[1] = x[2];
      x[2] = xr;
    }
    else if(val[xr] < val[x[1]])
    {
      x[0] = x[1];
      x[1] = xr;
    }
    else
    {
      x[0] = xr;
    }
  }
  if(flag == 1)
  {
    xb = (x[1]+x[2])/n;
    flag = 2;
  }
  if(flag == 2)
  {
    xr = (xb + alpha * (xb - x[0]));
    xr = xr > len? len: xr < 0? 0: xr;
    flag = val[xr] < val[x[1]] && val[xr] >= val[x[2]] ? -1 : // we're done. we will swap out x[0] for xr, and put xr in place of x[1]
      (val[xr] < val[x[2]] ? 3 : //expand
       (val[xr] >= val[x[1]] && val[xr] < val[x[0]] ? 4 : 5 )); //outside contraction : inside contraction
  }
  if(flag == 3)
  {
    xc = xb + (xr - xb) * gamma;
    xc = xc > len? len: xc < 0 ? 0 : xc;
    if(val[xc] < val[xr])
    {
      xr = xc;
    }
    flag = -1;
  }
  if(flag == 4)
  {
    xc = xb + beta * (xr - xb);
    xc = xc > len? len: xc < 0 ? 0 : xc;
    if(val[xc] <= val[xr])
    {
      xr = xc;
    }
    flag = -1;
  }
  if(flag == 5)
  {
    xc = xb + beta * (x[0] - xb);
    xc = xc > len? len: xc < 0 ? 0 : xc;
    if(val[xc] <= val[x[0]])
    {
      xr = xc;
    }else{
      xr = x[0];
    }
    flag = -1;
  }
  x[3] = flag;
  return x;
}
