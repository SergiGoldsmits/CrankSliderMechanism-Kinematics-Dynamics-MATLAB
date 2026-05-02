 function crank_dynamics_analysis(mode, s, c, e, F, productivity, J_rotor, gear_ratio)
% mode: 'flat' or 'relief'
% s: restoration stroke [m]
% c: compression distance [m]
% e: offset from dead center for relief printing [m]
% F: force during compression [N]
% productivity: number of prints per minute
% J_rotor: rotor inertia [kg·m^2]
% gear_ratio: gear ratio i (motor -> crank)

%% Parameters
a = 0.01;     % Crank length [m]
b = 0.15;      % Connecting rod length [m]
M = 4.824+(4*0.165)+(8*0.004)+0.577+0.888;    % Mass of slider [kg]
k = 1;
productivity=200;
% Convert productivity to angular velocity [rad/s]
frequency = productivity / 60;         % Hz
T_cycle = 1 / frequency;               % s
if strcmp(mode, 'flat')
    da = 2*pi / T_cycle;              % Constant angular speed [rad/s]
    alpha_range = deg2rad(0):deg2rad(2):deg2rad(360);
elseif strcmp(mode, 'relief')
    % Crank oscillates ±θ_max around 0
    theta_max = acos((a + e) / b);    % based on minimum slider position
    alpha_range = -theta_max:deg2rad(2):theta_max;
    da = 2*theta_max / T_cycle;       % Oscillation angular speed [rad/s]
else
    error('Unknown mode. Use ''flat'' or ''relief''.');
end

dda = 0; % Assume constant speed

% Preallocate
N = length(alpha_range);
s_C = zeros(1,N); s_alpha = zeros(1,N);
s_x = zeros(1,N); s_dx = zeros(1,N); s_ddx = zeros(1,N);
time = zeros(1,N);

%% Loop
i = 1;
for alpha = alpha_range
    % Position
    x = a*cos(alpha) + k*sqrt(b^2 - a^2*sin(alpha)^2);
    sb = -a/b*sin(alpha);
    cb = (x - a*cos(alpha))/b;

    % Speed
    db = -da*a*cos(alpha)/(b*cb);
    dx = -da*a*(sin(alpha)*cb - cos(alpha)*sb)/cb;

    % Acceleration
    ddb = (db^2*b*sb - dda*a*cos(alpha) + da^2*a*sin(alpha)) / (b*cb);
    ddx = (-dda*a*(sin(alpha)*cb - cos(alpha)*sb) - ...
        da^2*a*(cos(alpha)*cb*sin(alpha)*sb) - db^2*b) / cb;

    % Dynamics (force acts only near dead center)
    if strcmp(mode, 'flat') && abs(alpha - pi) < deg2rad(30)
        C = (M*ddx*dx + F*dx)/da;
    elseif strcmp(mode, 'relief') && abs(x - (a + e)) < 0.001
        C = (M*ddx*dx + F*dx)/da;
    else
        C = (M*ddx*dx)/da;
    end

    % Save results
    s_C(i) = C;
    s_alpha(i) = alpha;
    s_x(i) = x; s_dx(i) = dx; s_ddx(i) = ddx;
    time(i) = alpha / da;
    i = i + 1;
end

%% Plots
figure;
subplot(3,1,1); plot(rad2deg(s_alpha), s_x); ylabel('x [m]'); grid on;
title(['Position - ', upper(mode), ' printing']);

subplot(3,1,2); plot(rad2deg(s_alpha), s_dx); ylabel('dx [m/s]'); grid on;
subplot(3,1,3); plot(rad2deg(s_alpha), s_ddx); ylabel('ddx [m/s^2]'); xlabel('\alpha [deg]'); grid on;

figure;
plot(time, s_C); ylabel('Torque [Nm]'); xlabel('Time [s]'); grid on;
title(['Crank Torque vs Time - ', upper(mode), ' printing']);

end
