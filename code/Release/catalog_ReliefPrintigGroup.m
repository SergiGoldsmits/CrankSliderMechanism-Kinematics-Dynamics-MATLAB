% -------motor-----------------
% mot(1).name='13(B)J';
% mot(1).J=0.0843*10^-4; %brake + resolver [Kg*m^2]
% mot(1).Cn=0.32; %[Nm]
% mot(1).alfa=mot(1).Cn^2/mot(1).J;
% mot(1).wm=3000*2*pi/60; %rpm conversion
% 
mot(2).name='HG-KN 23(B)J';
mot(2).J=0.247*10^-4; %brake + resolver...
mot(2).Cn=0.64;
mot(2).alfa=mot(2).Cn^2/mot(2).J;
mot(2).wm=3000*2*pi/60;
% 
mot(1).name='HG-KN 43(B)J';
mot(1).J=0.375*10^-4; %brake + resolver [Kg*m^2]
mot(1).Cn=0.64;
mot(1).alfa=mot(1).Cn^2/mot(1).J;
mot(1).wm=3000*2*pi/60; %rpm conversion

mot(3).name='HG-KN 52(B)J';
mot(3).J=9.48*10^-4; %brake + resolver...
mot(3).Cn=2.39;
mot(3).alfa=mot(3).Cn^2/mot(3).J;
mot(3).wm=2000*2*pi/60

% mot(3).name='HG-KN 102(B)J';
% mot(3).J=11.6*10^-4; %brake + resolver...
% mot(3).Cn=4.8;
% mot(3).alfa=mot(3).Cn^2/mot(3).J;
% mot(3).wm=2000*2*pi/60;
% 
% mot(1).name='BLS-144';
% mot(1).J=4.59*10^-3; %brake + resolver [Kg*m^2]
% mot(1).Cn=33;
% mot(1).alfa=mot(1).Cn^2/mot(1).J;
% mot(1).wm=6500*2*pi/60;

%-------reducer--------------------------
rid(1).name='CP'; rid(1).tau=1/3;
rid(2).name='CP'; rid(2).tau=1/4;
rid(3).name='CP'; rid(3).tau=1/5;
rid(4).name='CP'; rid(4).tau=1/7;
rid(5).name='CP'; rid(5).tau=1/8;
rid(6).name='CP'; rid(6).tau=1/10;