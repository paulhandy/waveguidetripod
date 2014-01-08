
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
AP.b = .01;

AP.r_gear = 20; % mm
AP.r_top = 40; % mm
AP.Fm = 1.4; % max torque from motor (in mNm)
AP.V = 9; % max voltage to motor
AP.mVm = 12; % max voltage on motor sheet
P.F_max = (AP.V/AP.mVm)*(AP.r_top/AP.r_gear)*AP.Fm;
AP.kp = (pi/3) / P.F_max;
AP.wn = sqrt(AP.kp/AP.a);

P.A = [ 0, 1; 0, -AP.b/AP.a];
P.B = [ 0; 1];
P.C = [1, 0];
P.D = 0;

AP.wn = AP.wn*1.0;
AP.zeta = 0.707;
control_poles = roots([1,2*AP.zeta*AP.wn,AP.wn^2]);
wn = AP.wn*.1;
zeta = 0.707;
observer_poles = roots([1,2*zeta*wn,wn^2]);

P.Ts = 0.05;
P.L = place(P.A',P.C',observer_poles)';

integrator_pole = -1;

P.A_int = [P.A, [0;0]; P.C, 0];
P.B_int = [P.B; 0];
P.C_int = [P.C, 0; ];
P.K_int = place(P.A_int,P.B_int,[control_poles; integrator_pole]);
P.K_wi = P.K_int(1:2);
P.ki = P.K_int(3);
P.kr_wi = -1/(P.C*inv(P.A-P.B*P.K_wi)*P.B);

% observer gain if estimating the input disturbance
input_disturbance_pole = 0;
P.A_dis = [P.A, P.B; zeros(1,3)];
P.B_dis = [P.B; 0];
P.C_dis = [P.C, 0];
P.L_dis = place(P.A_dis',P.C_dis',[observer_poles;input_disturbance_pole])';

P.control_mode = 1;
