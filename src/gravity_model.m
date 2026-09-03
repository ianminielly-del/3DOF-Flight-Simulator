function g = gravity_model(z, p)
%gravity_model calculates the altitude dependent gravitational acceleration
% Inputs:
%   z = altitude above sea level (m)
%   p = structure with physical constraints (p.g0 , p.Re)
% Outputs:
%   g = gravitational acceleration at altitude z (m / s^2)

alt = max(z,0);

%Inverse square gravitational model
g = p.g0 * (p.Re / (p.Re + alt))^2;
end