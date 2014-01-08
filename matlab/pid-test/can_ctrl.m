function F = can_ctrl(in, P,C)
    theta_c = in(1);
    theta = in(2);
    t = in(3);
    
    persistent flag
    if t < P.Ts,
        flag = 1;
    else
        flag = 0;
    end
    % F_e = 0;
    F_tilde = PID_theta(theta_c, theta, flag, P.kp, P.kd, P.ki, P.F_max, P.Ts, P.tau);
    F = F_tilde;
end
function u = PID_theta(theta_c, theta, flag, kp, kd, ki, limit, Ts, tau)
    persistent integrator
    persistent thetadot
    persistent error_d1
    persistent theta_d1

    error = theta_c-theta;

    if flag == 1,
        integrator = 0;
        thetadot = 0;
        error_d1 = 0;
        theta_d1 = 0;
    end
    
    thetadot = (2*tau-Ts)/(2*tau+Ts)*thetadot + 2/(2*tau+Ts)*(theta-theta_d1);
    if abs(thetadot) < 0.1,
        integrator = integrator + (Ts/2)*(error+error_d1);
    end
    error_d1 = error;
    theta_d1 = theta;
    
    u_unsat = kp*error - kd*thetadot;
    u_unsat = u_unsat + ki*integrator;
    u = sat(u_unsat, limit);
    if ki ~=0
        integrator = integrator + Ts/ki*(u-u_unsat);
    end
end

function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end
