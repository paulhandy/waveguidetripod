
AP.mb = 0.3753; %kg
AP.l1 = 88e-3;
AP.l2 = (131.5-AP.l1)*1e-3;

AP.mc = 51.6e-3 + 24.9e-3;
AP.rc = (74.23e-3)/2;
AP.ri = (73.64e-3)/2;

AP.mm = .3; %kg
AP.rm = 10.5e-3; %m

AP.a = AP.mb*((AP.l2^3+AP.l1^3)/(AP.l1+AP.l2))...
    +AP.mc*(AP.rc^2+AP.ri^2) + AP.mm*AP.rm^2;
AP.theta0 = 0;
AP.thetadot_0 = 0;
AP.b = .01;
AP.A = pi/3;
AP.zeta = .707;
AP.r_gear = 20; % mm
AP.r_top = 40; % mm
AP.Fm = 1.4; % max torque from motor (in mNm)
AP.V = 9; % max voltage to motor
AP.mVm = 12; % max voltage on motor sheet
AP.F_max = (AP.V/AP.mVm)*(AP.r_top/AP.r_gear)*AP.Fm;
AP.kp = AP.A / AP.F_max;
AP.wn = sqrt(AP.kp/AP.a);
AP.kd = (AP.a*(2*AP.zeta*AP.wn)-AP.b);

%rootl = tf([AP.kp/AP.a], [AP.a, (AP.b + AP.kd)/AP.a, AP.kp/AP.a, 0]);
%rltool(rootl);

%AP.ki = 9.69e-7;
AP.ki = .0002;
AP.Ts = 0.05;
AP.tau = AP.Ts*0.05;


G = tf([AP.kp/AP.a], [AP.a, (AP.b + AP.kd)/AP.a, AP.kp/AP.a, 0]);
C_pid = tf([(AP.kd+AP.kp*AP.tau),(AP.kp+AP.ki*AP.tau),AP.ki],[AP.tau,1,0]);
GCpid = series(G,C_pid);
