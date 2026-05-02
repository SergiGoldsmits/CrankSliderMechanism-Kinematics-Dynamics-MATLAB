%% Parameters
a = 0.01;     % Crank length [m]
b = 0.15;      % Connecting rod length [m]
M = 4.824+(4*0.165)+(8*0.004)+0.577+0.888+0.7005...
    +0.449+0.031+0.61+0.026+0.2     % Mass of slider [kg]
J=932.745+(2*3.978)+4.41+5.64+8.765+3130.486+ ...
    608.69+51.61+317.25+(2*12.46)+2.86+87.51+3.023+0.688; %Rotating Inertia [kg*mm^2] 
Fe=1400; %Force [N]
k = 1;
productivity=200;

% Convert productivity to angular velocity [rad/s]
frequency = productivity / 60;         % Hz
T_cycle = 1 / frequency;               % s
da = 2*pi / T_cycle;              % Constant angular speed [rad/s]
dda = 0; % Assume constant speed

figure(1); grid;
axis equal;
axis manual;
axis([-(a*3+b) (a*3+b) -a*3 a*3]);
ll=line('XData', [0 0 0], ...
'YData', [0 0 0], ...
'linestyle', '-', 'linewidth',2,'color','b',...
'marker','o','markersize',6,'markerfacecolor','b');

i=1;

%%Kinematics
for alpha=deg2rad(0):deg2rad(5):deg2rad(360*10)

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

    %dynamics
    if(alpha > deg2rad(300))
        C=(M*ddx*dx + Fe*dx+J*da)/da; %Rod Torque effect neglected
    else
        C=(M*ddx*dx+J*da)/da;
    end

    A0x=0;
    A0y=0;
    Bx=a*cos(alpha);
    By=a*sin(alpha);
    Cx=x;
    Cy=0;
    set(ll,'XData', [A0x Bx Cx], 'YData', [A0y By Cy]);
    figure(1);

    %save
    s_C(i)=C;

    s_alpha(i)=alpha; s_da(i)=da; s_dda(i)=dda;
    s_beta(i)=atan2(sb,cb); s_db(i)=db; s_ddb(i)=ddb;
    s_x(i)=x; s_dx(i)=dx; s_ddx(i)=ddx;


    time(i)=alpha/da;
    i=i+1;

end

figure;
subplot(2,1,1); plot(s_alpha,s_beta, s_alpha, s_db, s_alpha, s_ddb);grid;
subplot(2,1,2); plot(s_alpha,s_x, s_alpha, s_dx, s_alpha, s_ddx);grid;

figure
plot(time,s_C); grid;





