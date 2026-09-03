function [t, Y] = solver(p)
% solver Numerical integration wrapper for 3 DOF  trajectory simulation
% Input:
%   p = configuration structure from config()
% Outputs:
%   t = time vector array (s)
%   Y = output state matrix [x, z, vx, vz, mass] over time

% Convert initial launch conditions into Cartesian state components
vx0 = p.v_init * cos(p.angle);
vz0 = p.v_init * sin(p.angle);
m0 = p.m_dry + p.m_prop;

% Initial state vector: [x0; z0; vx0; vz0; mass] over time
y0 = [0; 0; vx0; vz0; m0];

% Set integration error tolerances for trajectory precision
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8,'Events', @event_ground_impact);

% Integrate equations of motion as defined in dynamics.m
[t, Y] = ode45(@(t, y) dynamics(t, y, p), p.tspan, y0, options);
end