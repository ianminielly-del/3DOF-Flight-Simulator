function [value, isterminal, direction] = event_ground_impact(~, y, ~)
%event_ground_impact detects when rocket altitude z drops to 0 meters,
%impacting the ground. 
% Inputs:
%   t             - Time (s)
%   y             - State Vector [x; z; vx; vz; mass]
%   p             - config struct
% Outputs:
%   value         - Target value to trigger event (Altitude z = 0)
%   isterminal    - 1 stops integration imediately, 0 continues
%   direction     - -1 detects downward zero-crossing only (ignore launch)

value       = y(2); %Altitude z in meters
isterminal  = 1;    %Stop integration on impact
direction   = -1;   %Downward direction only
end