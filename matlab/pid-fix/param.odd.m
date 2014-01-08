close all;
clear all;

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
AP.A = 4*10000/3;
AP.zeta = .707;
AP.r_gear = 8; % mm
AP.r_top = 18; % mm
AP.Fm = (1.4e-3) * 9.7;
AP.V = 13.5; % max voltage to motor
AP.mVm = 12; % max voltage on motor sheet
AP.ltran = 10000;
AP.F_max = (AP.V/AP.mVm)*(AP.r_top/AP.r_gear)*AP.Fm*AP.ltran;
AP.kp =  AP.A / AP.F_max; 
AP.wn = sqrt(AP.kp/AP.a);
AP.kd = (AP.a*(2*AP.zeta*AP.wn)-AP.b);


G = tf([AP.kp/AP.a], [1, (AP.b + AP.kd)/AP.a, AP.kp/AP.a, 0]);
%rltool(G);

%AP.ki = 19.9; 
AP.ki = 11.3;
AP.Ts = 0.05;
AP.tau = AP.Ts;
