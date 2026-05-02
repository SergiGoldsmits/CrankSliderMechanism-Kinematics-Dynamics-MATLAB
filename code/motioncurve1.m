
clear all
clc
% Parameters
a = 0.01;    % crank length [m]
b = 0.15;    % rod length [m]
f = 3.33;                % freq[Hz] → 200 pieces/min
T = 1 / f; 
i=1;
omega=200*2*pi/60;    %velocity of master angle, 100 rpm --> rad/s //productivity
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
% S_shape parameters
par.v = 0.2;
par.w = 0.8;

% curves inizialization. It creates an empty vector for theta, dtheta and
% ddtheta
theta = zeros(1,N);
dtheta = zeros(1,N);
ddtheta = zeros(1,N);

figure(1); grid;
axis equal;
axis manual;
axis([-(a*3+b) (a*3+b) -a*3 a*3]);
ll=line('XData', [0 0 0], ...
'YData', [0 0 0], ...
'linestyle', '-', 'linewidth',2,'color','b',...
'marker','o','markersize',6,'markerfacecolor','b');

%%Kinematics graphics

for j=0:1:10
    for alpha=deg2rad(360-61.59):deg2rad(1):deg2rad(360-17.63)

        %position
        x=a*cos(alpha)+k*sqrt(b^2-a^2*sin(alpha)^2);
        sb=-a/b*sin(alpha);
        cb=(x-a*cos(alpha))/b;

        %speed
        db=-da*a*cos(alpha)/(b*cb);
        dx=-da*a*(sin(alpha)*cb-cos(alpha)*sb)/cb;

        %acceleration
        ddb=(db^2*b*sb-dda*a*cos(alpha)+da^2*a*sin(alpha))/(b*cb);
        ddx=(-dda*a*(sin(alpha)*cb-cos(alpha)*sb)-...
        da^2*a*(cos(alpha)*cb*sin(alpha)*sb)-db^2*b)/cb;

        A0x=0;
        A0y=0;
        Bx=a*cos(-alpha);
        By=a*sin(-alpha);
        Cx=x;
        Cy=0;
        set(ll,'XData', [A0x Bx Cx], 'YData', [A0y By Cy]);
        figure(1);
    end

    for alpha=deg2rad(360-17.63):deg2rad(-1):deg2rad(360-61.59)

        %position
        x=a*cos(alpha)+k*sqrt(b^2-a^2*sin(alpha)^2);
        sb=-a/b*sin(alpha);
        cb=(x-a*cos(alpha))/b;

        %speed
        db=-da*a*cos(alpha)/(b*cb);
        dx=-da*a*(sin(alpha)*cb-cos(alpha)*sb)/cb;

        %acceleration
        ddb=(db^2*b*sb-dda*a*cos(alpha)+da^2*a*sin(alpha))/(b*cb);
        ddx=(-dda*a*(sin(alpha)*cb-cos(alpha)*sb)-...
        da^2*a*(cos(alpha)*cb*sin(alpha)*sb)-db^2*b)/cb;

        A0x=0;
        A0y=0;
        Bx=a*cos(-alpha);
        By=a*sin(-alpha);
        Cx=x;
        Cy=0;
        set(ll,'XData', [A0x Bx Cx], 'YData', [A0y By Cy]);
        figure(1);

 %dynamics
    if(alpha > deg2rad(300))
        C=(M*ddx*dx + Fe*dx+J*da)/da; %Rod Torque effect neglected
    else
        C=(M*ddx*dx+J*da)/da;
    end

    end
    
   
end

for i = 1:N
        x = t(i)/T;  % normalization [0,1]
        
        if x <= 0.5
           

                % 1st phase: forward (0 → theta_max)
                res = MCM_sshape(2*x, par);
                theta(i) = res.pos;
                dtheta(i) = res.vel * 2 / T;
                ddtheta(i) = res.acc * 4 / T^2;

        else
            
                % 2nd phase: backward (theta_max → 0)
                res = MCM_sshape(2*(1 - x), par);
                theta(i) = res.pos;
                dtheta(i) = -res.vel * 2 / T;
                ddtheta(i) = res.acc * 4 / T^2;
            
        end
end

% real oscillation
theta_max = deg2rad(61.59);  % for a sliding of 5.5 mm
theta = theta_max * theta;
dtheta = theta_max * dtheta;
ddtheta = theta_max * ddtheta;

% slider kinematics
res.x = (a*cos(theta) + sqrt(b^2 - (a^2)*sin(theta).^2))-0.0005;

dx_dtheta = -a*sin(theta) - (a^2 * sin(theta) .* cos(theta)) ./ sqrt(b^2 - (a^2) * sin(theta).^2);

d2x_dtheta2 = ...
    -a*cos(theta) ...
    - (a^2 * cos(2*theta)) ./ sqrt(b^2 - a^2 * sin(theta).^2) ...
    + (a^4 * sin(theta).^2 .* cos(theta).^2) ./ (b^2 - a^2 * sin(theta).^2).^(3/2);

% Velocity and acc of the slider
res.vel = dx_dtheta .* dtheta;
res.acc = d2x_dtheta2 .* dtheta.^2 + dx_dtheta .* ddtheta;

% PLOTS

figure;
subplot(3,1,1);
plot(t, res.x*1000, 'b');
grid on;
ylabel('Pos [mm]');
title('Position');

subplot(3,1,2);
plot(t, res.vel, 'r');
grid on;
ylabel('Vel [m/s]');
title('Velocity');

subplot(3,1,3);
plot(t, res.acc, 'k');
grid on;
ylabel('Acc [m/s^2]');
xlabel('Time [s]');
title('Acceleration');
