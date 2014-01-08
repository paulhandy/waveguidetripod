function out=ctrl(in,P)
    y_d    = in(1);
    y      = in(2);
    t      = in(3);
    x      = in(4:5);
    
    % define and initialize persistent variables
    persistent integrator
    persistent error_d1
    persistent xhat_       % estimated state (for observer)
    persistent u           % delayed input (for observer)
    
    N = 10; % number of integration steps for each sample
    
    % compute state feedback control 
    switch P.control_mode,
        case 1, % no integrator, no disturbance estimate
            % initialize persistent variables
            if t<P.Ts,
                xhat_  = zeros(2,1);
                u      = 0;
            end
            % solve observer differential equations
            for i=1:N,
                xhat_ = xhat_ + P.Ts/N*(P.A*xhat_ + P.B*u + P.L*(y-P.C*xhat_));
            end
            xhat = xhat_(1:2);
            % feedback controller
            u = P.kr*y_d - P.K*xhat;
            
            
        case 2, % integrator, no disturbance estimate
            % initialize persistent variables
            if t==0,
                xhat_  = zeros(2,1);
                u      = 0;
                integrator = 0;
                error_d1   = 0;
            end
            % solve observer differential equations
            for i=1:N,
                xhat_ = xhat_ + P.Ts/N*(P.A*xhat_ + P.B*u + P.L*(y-P.C*xhat_));
            end
            xhat = xhat_(1:2);
            % implement integrator
            error = y - y_d;
            integrator = integrator + (P.Ts/2)*(error+error_d1);
            error_d1 = error;
            % feedback controller
            u = - P.K_wi*xhat - P.ki*integrator + P.kr*y_d;
            
        case 3, % no integrator, disturbance estimate
            % initialize persistent variables
            if t==0,
                xhat_  = zeros(3,1);
                u      = 0;
            end
            % solve observer differential equations
            for i=1:N,
                xhat_ = xhat_ + P.Ts/N*(P.A_dis*xhat_ + P.B_dis*u + P.L_dis*(y-P.C_dis*xhat_));
            end
            xhat = xhat_(1:2);
            disturbance_estimate = xhat_(3)
            % feedback controller
            u = P.kr*y_d - P.K*xhat - disturbance_estimate;
            
        case 4, % integrator and disturbance estimate
            % initialize persistent variables
            if t==0,
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
            disturbance_estimate = xhat_(3);
            % implement integrator
            error = y - y_d;
            integrator = integrator + (P.Ts/2)*(error+error_d1);
            error_d1 = error;
            % feedback controller
            u = - P.K_wi*xhat - P.ki*integrator - disturbance_estimate + P.kr*y_d;

     end
   
    out = [u; xhat];
end

%-----------------------------------------------------------------
% saturation function
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end
