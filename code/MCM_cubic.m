function ris=MCM_cubic(x,par)

app=par;

ris.acc=6*(1-2*x);
ris.vel=6*x*(1-x);
ris.pos=3*x^2-2*x^3;

end