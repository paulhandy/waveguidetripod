int pid(
int y_d, 
int y, 
double kp, 
double ki, 
double kd, 
int limit, 
int Ts,
int tau)
{
  //static int integrator, ydot, error_d1, y_d1;
  int u_unsat, u, error;
  
  error = y_d - y;
  ydot = ((2*tau-Ts)/(2*tau+Ts))*ydot + (2/(2*tau+Ts))*(y-y_d1);
  if(abs(ydot) < 716)
  {
    integrator += (error + error_d1) * Ts / 2;
  }
  
  error_d1 = error;
  y_d1 = y;
  
  u_unsat = kp*error - kd*ydot + ki*integrator;
  u = u_unsat > limit ? limit : (u_unsat < -limit ? -limit : u_unsat);
  if( ki != 0){
    integrator += (u - u_unsat) * Ts / ki;
  }
  return u;
}
