function dydt = dynamics(t, y, p)
%dynamics calculates the state derivative vector for a 3 DOF point-mass
%flight
% Inputs:
%   t = current time (s), it is explicitly not used, so marked a ~
%   y = state vector [x ; z; vx; vz; mass]
%   p = configuration structure
% Outputs:
%   dydt = derivative vector [vx; vz; ax; az; mdot]

z  = y(2);
vx = y(3);
vz = y(4);
m  = y(5);

% Thrust and Mass Flow Rate Model
if m <= p.m_dry ||  t >= p.burn_time
    Thrust = 0.0;
    mdot = 0.0;
else
    Thrust = p.thrust;
    mdot = -p.thrust / (p.g0 * p.Isp);
end

% Kinematic Properties
speed = sqrt(vx^2 + vz^2);
alt = max(z, 0);

% Atmosphere & Dynamic Drag
if alt > 86000
    drag = 0.0;
else
[rho, ~, ~, ~] = std_atmosphere(alt);
drag = .5 * rho * (speed^2) * p.Cd * p.Area;
end

% Gravitational Model
g = gravity_model(alt, p);

% Equations of Motion
if speed > 0
    fx_drag = -drag * (vx / speed);
    fz_drag = -drag * (vz / speed);

    ax = (Thrust * (vx / speed) + fx_drag) / m;
    az = (Thrust * (vz / speed) + fz_drag) / m - g;
else
    %zero speed edge case / launch rail boudary 
    ax = (Thrust * cos(p.angle)) / m;
    az = (Thrust * sin(p.angle)) / m - g;
end

% Assemble derivative column vector
dydt = [vx; vz; ax; az; mdot];
end