clc; clear; close all;
addpath('src');

% 1. Load parameters and run solver
p = config();
fprintf('Running 3 DOF Flight Simulation...\n');
[t, Y] = solver(p);

% 2. Extract state variables
x = Y(:, 1) / 1000;  % Downrange distance (km)
z = Y(:, 2) / 1000;  % Altitude (km)
vx = Y(:, 3);
vz = Y(:, 4);
m = Y(:, 5);

speed = sqrt(vx.^2 + vz.^2);

% 3. Calculate Mach Number over Flight
speed_mach = zeros(length(t), 1);
for i = 1:length(t)
    [~, a, ~, ~] = std_atmosphere(Y(i, 2));
    speed_mach(i) = speed(i) / a;
end

% 4. Print summary key metrics
[apogee_km, apogee_idx] = max(z);
fprintf('\n=============== Trajectory Summary ===============\n');
fprintf('Flight Duration: %.2f seconds\n', t(end));
fprintf('Apogee Altitude: %.2f km (at t = %.2f s)\n', apogee_km, t(apogee_idx));
fprintf('Max Speed:       %.2f m/s (mach %.2f)\n', max(speed), max(speed_mach));
fprintf('Impact Distance: %.2f km downrange\n', x(end));

% 5. Plot results
figure('Name', '3 DOF Flight Simulation Results', 'Color', '[.15 .15 .15]');

% Calculate dynamic time step size based on total flight duration
t_final = t(end);
t_step = max(10, round(t_final / 6, -1)); %Rounds to clean intervals

% Calculate dynamic distance step size based on maximum downrange distance
x_final = max(x); 
if x_final > 0
    x_step = max(1, round(x_final / 6, -1));
    if x_step == 0, x_step = max(1, round(x_final / 6));
    end
else
    x_step = 1; %Fall back in case of vertical launch
end

% Plot 1: 2d trajectory Profile
ax1 = subplot(2, 2, 1);
plot(x, z, 'b-', 'LineWidth', 1.5);
xlabel('Downrange Distance (km)'); 
ylabel('Altitude (km)');
title('2D Flight Trajectory');
if x_final > 0
    xticks(ax1, 0:x_step:ceil(x_final));
    xlim(ax1, [0, ceil(x_final)]);
end
ylim(ax1, [0,inf]);
grid on;

% Plot 2: Altitude vs Time
ax2 = subplot(2, 2, 2);
plot(t, z, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Altitude (km)');
title('Altitude Profile');
xticks(ax2, 0:t_step:t_final);
xlim(ax2, [0, t_final]);
ylim(ax2, [0,inf]);
grid on;

% Plot 3: Speed vs Time
ax3 = subplot(2, 2, 3);
plot(t, speed, 'y-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Speed (m/s)');
title('Velocity Magnitude');
xticks(ax3, 0:t_step:t_final);
xlim(ax3, [0, t_final]);
grid on;

% Plot 4: Vehicle Mass Depletion
ax4 = subplot(2, 2, 4);
plot(t, m, 'm-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Mass (kg)');
title('Mass Depletion');
xticks(ax4, 0:t_step:t_final);
xlim(ax4, [0, t_final]);
grid on;