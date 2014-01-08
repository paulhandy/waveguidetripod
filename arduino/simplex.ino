// nalder-mead simplex method
double simplex(int f, int rssi){
  static int N = 3, fp, fa, fc, fr, fe, ft, flag, index, deltaTau, lastVal, f1,f2,f3;
  static double  xp, x1,x2,x3, xa, xb, xe, xc, xr,
    alpha, gamma, beta, target;
  static double p[3];
  if(f == 0){
    p[0] = - 50* Tau / 360;
    p[1] = 50* Tau / 360;
    p[2] = 0;
    deltaTau = 3;
    alpha = 1;
    gamma = 2.5;
    beta = 0.25;
    index = 0;
    flag = -2;
    f1 = 100; f2 = 100; f3 = 100; fp = 100;
  }
  if(flag == -2){
    if(index == N){
      index = 0;
      flag = 1;
    }else{

      if(abs(angularPosition - p[index]) < Tau * 0.01){
        fp = rssi;
        xp = p[index];
        index++;
      }
      if(fp < f3){
        x1 = x2;f1 = f2;
        x2 = x3;f2 = f3;
        x3 = xp;f3 = fp;
      }else if(fp < f2){
        x1 = x2;f1 = f2;
        x2 = xp;f2 = fp;       
      }else{
        x1 = xp; f1 = fp;
      }
      target = p[index];
    }
  }
  if(flag == -1){
    if(fr < f3){
      x1 = x2;f1 = f2;
      x2 = x3;f2 = f3;
      x3 = xr;f3 = fr;
    }else if(fp < f2){
      x1 = x2;f1 = f2;
      x2 = xr;f2 = fr;        
    }else if(fr<f1){
      x1 = xr; f1 = fr;
    }
    if(abs(f1) - abs(f3) < deltaTau){
      flag = 6;
      lastVal = f3;
    } else{
      flag = -2;
      p[0] = x1;
      p[1] = x2;
      p[2] = x3;
    }
  }
  if(flag == 1){
          Serial.println("flag 1");
    xb = (x2+x3) / N;
    flag = 2;
  }
  if(flag == 2){
    xr = (xb + alpha * (xb - x1));
    if(abs(angularPosition - xr) < Tau * 0.01){
            Serial.print("flag 2-");
            fr = rssi;
            Serial.println (f3);
      if(fr < f2 && fr >= f3){
        flag = -1; // done, continue on;
      }else if(fr < f3){
        flag = 3; // expand
      }else if(fr >= f2 && fr < f1){
        flag = 4; //outside contraction
      }else if(fr >= f1){
        flag = 5; // inside contraction
      }
    }else{
      target = xr;
    }
  }
  if(flag == 3){
    xe = xb + gamma *(xr - xb);
    if(abs(angularPosition - xe) < Tau * 0.01){
      Serial.println("flag 3");
      fe = rssi;
      if(fe < fr){
        xr = xe;
        fr = fe;
      }
      flag = -1;
    }else{
      target = xe;
    }
  }
  if(flag == 4){
    xc = xb + beta*(xr-xb);
    if(abs(angularPosition - xc) < Tau * 0.01){
            Serial.println("flag 4");
      fc = rssi;
      if(fc <= fr){
        fr = fc;
        xr = xc;
      }
      flag = -1;
    }else{
      target = xc;
    }
  }
  if(flag == 5){
    xc = xb + beta*(x1-xb);
    if(abs(angularPosition - xc) < Tau * 0.01){
            Serial.println("flag 5");
      fc = rssi;
      if(fc <= f1){
        fr = fc;
        xr = xc;
      }
      flag = -1;
    }else{
      target = xc;
    }
  }
  if(flag == 6){
    target = x3;
    ft = rssi;
    Serial.print(lastVal);
    Serial.print("---");
    Serial.print(ft);
    
    Serial.print(ft-lastVal);

    if(abs(lastVal - ft) > deltaTau){
      Serial.println("flag 6");
      flag = -2;
      p[0] = x3 - 50* Tau / 360;
      p[1] = x3 + 50* Tau / 360;
      p[2] = x3;
    }
  }
  return target;
}
