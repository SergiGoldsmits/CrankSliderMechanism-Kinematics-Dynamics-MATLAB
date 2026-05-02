%Cycle parameters

productivity = 200; %parts per min
CompressionTime = 0.06;
TotalCycleTime=60/productivity;
MotionCurve = "MCM_sshape";

% S-shape motion curve parameters
par.v = 0.5;
par.w = 0.5;

% Crank-slider mechanism parameters

a = 0.01;     % [m] crank length
b = 0.15;     % [m] rod length
f = 3.33;                % freq[Hz] → 200 pieces/min
T = 1 / f; 
i=1;
omega=productivity*2*pi/60; %velocity of master angle, 100 rpm --> rad/s //productivity
R=0.01; % period [s]
N = 1000;                % number of points
t = linspace(0, T, N);% time normalized until N-1 because first position is 0
k=1 %direction of rotation
da = 2*pi / T;              % Constant angular speed [rad/s]
dda = 0; % Assume constant speed
M = 4.824+(4*0.165)+(8*0.004)+0.577+0.888+0.7005...
    +0.449+0.031+0.61+0.026+0.2     % Mass of slider [kg]
Fe=1400;%N
Cr= 1400*R; 
J=(932.745+(2*3.978)+4.41+5.64+8.765+3130.486+ ...
  608.69+51.61+317.25+(2*12.46)+2.86+87.51+3.023+0.688)*10^-6; %Rotating Inertia [kg*m^2]    

% Crank angular limits
theta_start_deg = 17.63;    % min angle
theta_end_deg = 61.59;      % max angle
theta_start = deg2rad(theta_start_deg);
theta_end = deg2rad(theta_end_deg);
theta_range = theta_end - theta_start;

% Time durations for each phase
T1 = (TotalCycleTime-CompressionTime)/2; % forward stroke
T2 = CompressionTime; % compression (pause)
T3 = (TotalCycleTime-CompressionTime)/2; % return stroke
T = T1 + T2 + T3;  % total cycle time


% Time discretization
N = 1000;
t = linspace(0, T, N);
theta = zeros(1,N);
omega = zeros(1,N);
alpha = zeros(1,N);
slider_x = zeros(1,N);
slider_v = zeros(1,N);
slider_a = zeros(1,N);
torque = zeros(1, N);

% Number of points per phase
N1 = round(N * T1 / T);
N2 = round(N * T2 / T);
N3 = N - N1 - N2;

% PHASE 1: Forward stroke
x1 = linspace(0, 1, N1);
for i = 1:N1
    if strcmp(MotionCurve, 'MCM_sshape')
        mc = MCM_sshape(x1(i), par);
        
    elseif strcmp(MotionCurve, 'MCM_cubic')
        mc = MCM_cubic(x1(i), par);
       
    end

    th = theta_start + mc.pos * theta_range;
        om = mc.vel * theta_range / T1;
        al = mc.acc * theta_range / T1^2;
    s = sin(th); c = cos(th);
    slider_x(i) = a*c + sqrt(b^2 - (a*s)^2);
    dxdth = -a*s - (a^2 * s * c) / sqrt(b^2 - (a*s)^2);
    d2xdth2 = -a*c - (a^2 * ((c^2 - s^2) * sqrt(b^2 - (a*s)^2) + a^2 * s^2 * c^2)) / ...
              ((b^2 - (a*s)^2)^(3/2));
    slider_v(i) = dxdth * om;
    slider_a(i) = d2xdth2 * om^2 + dxdth * al;

    theta(i) = th;
    omega(i) = om;
    alpha(i) = al;

    torque(i) =J*alpha(i); 
end

% PHASE 2: Compression (θ max)
for i = N1+1:N1+N2
    theta(i) = theta_end;
    omega(i) = 0;
    alpha(i) = 0;

    s = sin(theta_end);
    c = cos(theta_end);
    slider_x(i) = a*c + sqrt(b^2 - (a*s)^2);
    slider_v(i) = 0;
    slider_a(i) = 0;

    dxdth = -a*sin(theta_end) - (a^2 * sin(theta_end) * cos(theta_end)) /...
        sqrt(b^2 - (a*sin(theta_end))^2);
    torque(i) = -1400 * a; 
end

% PHASE 3: Return stroke (from max to min θ)
x3 = linspace(0, 1, N3);

for i = 1:N3
    idx = N1 + N2 + i;
    if strcmp(MotionCurve, 'MCM_sshape')
        mc = MCM_sshape(x3(i), par);
        
    elseif strcmp(MotionCurve, 'MCM_cubic')
        mc = MCM_cubic(x3(i), par);
       
    end
    th = theta_end - mc.pos * theta_range;
    om = -mc.vel * theta_range / T3;
    al = -mc.acc * theta_range / T3^2;

    s = sin(th); c = cos(th);
    slider_x(idx) = a*c + sqrt(b^2 - (a*s)^2);
    dxdth = -a*s - (a^2 * s * c) / sqrt(b^2 - (a*s)^2);
    d2xdth2 = -a*c - (a^2 * ((c^2 - s^2) * sqrt(b^2 - (a*s)^2) + a^2 * s^2 * c^2)) / ...
              ((b^2 - (a*s)^2)^(3/2));
    slider_v(idx) = dxdth * om;
    slider_a(idx) = d2xdth2 * om^2 + dxdth * al;

    theta(idx) = th;
    omega(idx) = om;
    alpha(idx) = al;

    torque(idx) =J*alpha(idx);
end

% PLOTS
theta_deg = rad2deg(theta);

figure;
subplot(3,1,1); plot(theta_deg, slider_x, 'LineWidth', 2);
ylabel('Position [m]'); title('Slider position vs crank angle'); grid on;

subplot(3,1,2); plot(theta_deg, slider_v, 'LineWidth', 2);
ylabel('Velocity [m/s]'); title('Slider velocity vs crank angle'); grid on;

subplot(3,1,3); plot(theta_deg, slider_a, 'LineWidth', 2);
ylabel('Acceleration [m/s^2]'); xlabel('Crank angle [deg]');
title('Slider acceleration vs crank angle'); grid on;

figure;
subplot(3,1,1); plot(t, rad2deg(theta), 'LineWidth', 2);
ylabel('\theta [deg]'); title('Crank angle'); grid on;

subplot(3,1,2); plot(t, omega, 'LineWidth', 2);
ylabel('\omega [rad/s]'); grid on;

subplot(3,1,3); plot(t, alpha, 'LineWidth', 2);
ylabel('\alpha [rad/s^2]'); xlabel('Time [s]'); grid on;

figure;
subplot(3,1,1); plot(t, slider_x, 'LineWidth', 2);
ylabel('x [m]'); title('Slider kinematics'); grid on;

subplot(3,1,2); plot(t, slider_v, 'LineWidth', 2);
ylabel('v [m/s]'); grid on;

subplot(3,1,3); plot(t, slider_a, 'LineWidth', 2);
ylabel('a [m/s^2]'); xlabel('Time [s]'); grid on;

figure;
plot(t, torque, 'LineWidth', 2);
xlabel('time [s]'); ylabel('Torque [Nm]'); title('Crank torque'); grid on;



% ANIMATION
figure(1); clf;
axis equal;
grid on;
axis manual;
axis([-(a*3+b) (a*3+b) -a*3 a*3]);
title('Crank-Slider Mechanism');

ll = line('XData', [0 0 0], ...
          'YData', [0 0 0], ...
          'LineStyle', '-', 'LineWidth', 2, 'Color', 'b', ...
          'Marker', 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

for cycle = 1:10
    for i = 1:10:N
        th = theta(i);
        s = sin(th); c = cos(th);
        A = [a * c, a * s];
        B = [slider_x(i), 0];

        set(ll, 'XData', [0 A(1) B(1)], ...
                'YData', [0 A(2) B(2)]);

        pause(0.01);
    end
end
