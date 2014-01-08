AP.A = [0, 1; 0, 0];
AP.B = [0; 1];
AP.C = [1, 0];
AP.D = 0;

P.A = AP.A;
P.A = 1.5*[0, 1; 0.1 0.1];
P.B = AP.B;
%P.B = 0.9*[0; 1];
P.C = [1, 0];
P.D = 0;

P.Ts = 0.01;  % sample rate of controller

%P.control_mode = 1;  % no integrator, no disturbance estimate
P.control_mode = 2;  % integrator, no disturbance estimate
%P.control_mode = 3;  % no integrator, disturbance estimate
%P.control_mode = 4;  % integrator, disturbance estimate

% pick desired char equation for system response
wn = 1;
zeta = 0.707;
control_poles = roots([1,2*zeta*wn,wn^2]);

% place control poles using feedback gain K
P.K = place(P.A,P.B,control_poles);

% feedforward gain
P.kr = -1/(P.C*inv(P.A-P.B*P.K)*P.B);

% pick desired char equation for observation error
wn = 10; 
zeta = 0.707;
observer_poles = roots([1,2*zeta*wn,wn^2]);

% place observer poles using observer gain L
P.L = place(P.A',P.C',observer_poles)';

% gains if there is an integrator
integrator_pole = -.5;
P.A_int = [P.A, [0;0]; P.C, 0];
P.B_int = [P.B; 0];
P.C_int = [P.C, 0; ];
P.K_int = place(P.A_int,P.B_int,[control_poles; integrator_pole]);
P.K_wi = P.K_int(1:2);
P.ki = P.K_int(3);
P.kr_wi = -1/(P.C*inv(P.A-P.B*P.K_wi)*P.B);

% observer gain if estimating the input disturbance
input_disturbance_pole = -1;
P.A_dis = [P.A, P.B; zeros(1,3)];
P.B_dis = [P.B; 0];
P.C_dis = [P.C, 0];
P.L_dis = place(P.A_dis',P.C_dis',[observer_poles;input_disturbance_pole])';

