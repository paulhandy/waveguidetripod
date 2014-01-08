function out=can_ctrl(in,P)
  y_d    = in(1);
  y      = in(2);
  t      = in(3);

  persistent integrator
  persistent error_d1
  persistent xhat_       % estimated state (for observer)
  persistent u           % delayed input (for observer)

  N = 10;

  if t<P.Ts,
    xhat_  = zeros(3,1);
    u      = 0;
    integrator = 0;
    error_d1   = 0;
  end
  % solve observer differential equations
  for i=1:N,
    xhat_ = xhat_ + P.Ts/N*(P.A_dis*xhat_ + P.B_dis*u + P.L_dis*(y-P.C_dis*xhat_));
  end
  xhat = xhat_(1:2);
  xhat_
  disturbance_estimate = xhat_(3);
  % implement integrator
  error = y - y_d;
  integrator = integrator + (P.Ts/2)*(error+error_d1);
  error_d1 = error;
  % feedback controller
  u = - P.K_wi*xhat + P.ki*integrator - disturbance_estimate - P.kr_wi*y_d;
  u_sat = sat(u,P.F_max);
  out = [u;xhat];
end
function out = sat(in,limit)
  if     in > limit,      out = limit;
  elseif in < -limit,     out = -limit;
  else                    out = in;
  end
end

