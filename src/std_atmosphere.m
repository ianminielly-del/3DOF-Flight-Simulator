function [rho, a, T, P] = std_atmosphere(z)
%std_atmosphere US Standard Atmosphere 1976 Model (0 to 86 km), after 86km
%a vaccuum is assumed
% Inputs:
%   z = altitude above see level (m)
%Outputs:
%   rho = air density (kg / m^3)
%   a = speed of sound (m/s)
%   T = Temperature (K)
%   P = Pressure (Pa)

% Base Constants
R = 287.053;    % Specific gas constant of air (J/kg*K)
gamma = 1.4;    % Ratio of specific heats
g0 = 9.80665;   % Sea-Level gravity (m/s^2)

%Standard atmosphere boundaries (m), Lapse rates (K/m), Layers
z_b = [0, 11000, 20000, 32000, 47000, 51000, 71000, 86000];
L = [-.0065, 0 , .001, .0028, 0, -.0028,-.002];

%Cap altitude  0 < z_eval < 86,000 (m)
z_eval = max(0, min(z, 86000));

T_b = zeros(1,8);
P_b = zeros(1,8);
T_b(1) = 288.15;   %Temp at Sea-Level (k)
P_b(1) = 101325;   %Pressure at Sea-Level (Pa)

for i = 1:7
    if L(i) ~= 0
        T_b(i+1) = T_b(i) + L(i) * (z_b(i+1) - z_b(i));
        P_b(i+1) = P_b(i) * (T_b(i+1) / T_b(i))^(-g0 / (L(i)*R));
    else
        T_b(i+1) = T_b(i);
        P_b(i+1) = P_b(i) * exp(-g0 * (z_b(i+1) - z_b(i)) / (R * T_b(i)));

    end

end

%Which layer is z_eval in 
layer = find(z_eval >= z_b(1:end-1) & z_eval<= z_b(2:end), 1, 'last');
if isempty(layer)
    layer = 7;
end

%Calculate properties at z_eval
dz = z_eval - z_b(layer);
if L(layer) ~= 0
    T = T_b(layer) + L(layer) * dz;
    P = P_b(layer) * (T / T_b(layer))^(-g0 / (L(layer) * R));
else
    T = T_b(layer);
    P = P_b(layer) * exp(-g0 * dz / (R * T_b(layer)));
end

%Air density and Speed of Sound
rho = P / (R * T); 
a = sqrt(gamma * R * T);
end