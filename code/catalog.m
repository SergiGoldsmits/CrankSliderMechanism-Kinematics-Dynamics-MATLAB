%-------motor-----------------
mot(1).name='BLS-144';
mot(1).J=4.59*10^-3; %brake + resolver...
mot(1).Cn=33;
mot(1).alfa=mot(1).Cn^2/mot(1).J;
mot(1).wm=6500*2*pi/60;

mot(2).name='BLS-191';
mot(2).J=14.7*10^-3; %brake + resolver...
mot(2).Cn=56;
mot(2).alfa=mot(2).Cn^2/mot(2).J;
mot(2).wm=2800*2*pi/60;

mot(3).name='BLS-192';
mot(3).J=22*10^-3; %brake + resolver...
mot(3).Cn=82;
mot(3).alfa=mot(3).Cn^2/mot(3).J;
mot(3).wm=2800*2*pi/60;

%-------reducer--------------------------
rid(1).name='CP'; rid(1).tau=1/3;
rid(2).name='CP'; rid(2).tau=1/4;
rid(3).name='CP'; rid(3).tau=1/5;
rid(4).name='CP'; rid(4).tau=1/7;
rid(5).name='CP'; rid(5).tau=1/8;
rid(6).name='CP'; rid(6).tau=1/10;