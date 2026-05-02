function ris=AccCosAsim(x,par)

    eps=par.eps;
    cv=2;
    cap=2/eps;
    cam=2/(1-eps);

if(x<=eps)          %positive part
    ris.acc=cap;
    ris.vel=cap*x;
    ris.pos=0.5*cap*x^2;
else
    ris.acc=-cam;                %negative part
    ris.vel=cam*(1-x);
    ris.pos=cam*(x-x^2/2 -eps/2);
end

end