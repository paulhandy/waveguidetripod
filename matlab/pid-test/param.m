%close all;
%clear all;

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
AP.b = .15;
AP.A = pi*9;
AP.zeta = .707;
AP.r_gear = 8; % teeth
AP.r_top = 18; % teeth
AP.mgear = 9.7;
AP.Fm = 1.4; % max torque from motor (in mNm)
AP.V = 13.5; % max voltage to motor
AP.mVm = 12; % max voltage on motor sheet
AP.F_max = (AP.V/AP.mVm)*(AP.r_top/AP.r_gear)*AP.Fm * AP.mgear;
AP.kp = (AP.A / AP.F_max);
AP.wn = sqrt(AP.kp/AP.a);
AP.kd = (AP.a*(2*AP.zeta*AP.wn)-AP.b);

P  = tf([1/AP.a], [1, (AP.b )/AP.a, 1/AP.a, 0]);
%rltool(rootl);

AP.kp = 2.3183;
AP.kd = 0.0654;
AP.ki = 0.1272;

AP.Ts = 0.00005;
AP.tau = 0.01;
