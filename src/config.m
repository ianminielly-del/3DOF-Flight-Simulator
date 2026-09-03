function p = config()
% config centralized configuration parapeters for trajectory simulation
% Output:
%   p = structure containing pysical constants, vehicle specs, and initial
%   conditions

% Environment & Physical Constants
p.g0 = 9.80665;         % Standard sea-level gravity acceleration (m/s^2)
p.Re = 6371000;         % Mean Earth radius (m)

% Input Display
disp('==================================================');
disp('   3 DOF Flight Simulator - Configuration Setup   ');
disp('Press Enter to keep the default value shoun in [].');
disp(' ');


% Vehicle Specifications
p.Cd     = get_user_input('Enter Drag Coefficient (Cd) [.35]: ', .35);           % Drag Coefficient (dimensionless)
p.Area   = get_user_input('Enter Cross-sectional Area (m^2) [.08]: ', .08);      % Frontal cross-sectional reference area (m^2)
p.m_dry  = get_user_input('Enter Dry Vehicle Mass (kg) [60]: ', 60);             % Dry vehicle mass without propellant (kg)
p.m_prop = get_user_input('Enter Propellant Mass (kg) [180]: ', 180);            % Initial propellant mass (kg)
p.thrust = get_user_input('Enter Engine Thrust (N) [6500]: ', 6500);             % Engine thrust magnitude (N)
p.Isp    = get_user_input('Enter Engine Specific Impulse Isp (s) [240]: ', 240); % Engine Specific impulse (s)

%Calculate exact propellant depletion time 
mdot_nominal = p.thrust / (p.g0 * p.Isp);
p.burn_time = p.m_prop / mdot_nominal;

%Launch settings % Integration Paramaters
p.v_init = get_user_input('Enter Launch Rail Velocity (m/s) [10]: ',10);   % Initial exit speed off launch rail (m's)
p.v_init_deg = get_user_input('Enter Launch Angle (degrees) [82]: ', 82);  % Initial pitch angle in degrees        
p.angle  = deg2rad(p.v_init_deg);                                          % Initial pitch angle (converted from degrees to radians)
p.tspan  = [0, 10000];                                                     % Time integration window [t_start, t_end] (s), will be cut short by @event_ground_impact in src/solver.m

%Lower Display
disp(' ');
disp('Configuration loaded successfully. Starting simulation...');
disp('---------------------------------------------------------');

end

% Helper function for handling user inputs and default values if there is
% no input
function val = get_user_input(prompt_str, default_val)
    raw_val = input(prompt_str, 's');
    if isempty(raw_val)
        val = default_val;
    else
        val = str2double(raw_val);
        if isnan(val)
            fprintf('Invalid input entered. Using default value: %g\n', default_val);
            val = default_val;
        end
    end
end