
function ris=MC_01(alpha)

h=0.0055;    %total rise
a1=300;    %degrees (to transform in rad)
a2=360;   %degrees (to transform in rad)
in=[0 a1 a2];
% par.v=1/3;
% par.w=2/3;
par.v=0.4;
par.w=0.7;


if (alpha>=in(1) && alpha <in(2))
    
    da=in(2)-in(1);
    alpha_ad=(alpha-in(1))/da;
    %out=MCM_sshape(alpha_ad,par);
    out=MCM_cubic(alpha_ad,par);
    ris.pos=h*out.pos;
    ris.vel=h/deg2rad(da)*out.vel;
    ris.acc=h/(deg2rad(da))^2*out.acc; 

elseif (alpha>=in(2) && alpha <in(3))

        da=in(3)-in(2);
        alpha_ad=(alpha-in(2))/da;
        ris.pos=h;
        ris.vel=0;
        ris.acc=0; 

else

        da=0;
        alpha_ad=0;
        ris.pos=0;
        ris.vel=0;
        ris.acc=0; 

end


end