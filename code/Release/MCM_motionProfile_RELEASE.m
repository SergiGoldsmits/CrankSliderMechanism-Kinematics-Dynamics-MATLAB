function res = MCM_motionProfile(alpha, a, b, ldp, e, y_low, y_high,...
    alpha_1, alpha_2, alpha_3, alpha_4, alpha_5, omega_master)
   
    h = y_high - y_low; %slider shift
    %sshape parameters 
    par.v = 0.4;
    par.w = 0.7;
    %AccCosAsim parameter
    par.eps = 0.3;
    
    if (alpha >= alpha_1) && (alpha < alpha_2)

        da = alpha_2 - alpha_1;
        alpha_ad = (alpha - alpha_1) / da;   % dimentionless MC
       
        %select motion curve
        out = MCM_cubic(alpha_ad, par);
         %out = MCM_sshape(alpha_ad, par);
          %out = AccCosAsim(alpha_ad,par);
        
        pos = h*(1 - out.pos);
        vel = -h / da * out.vel * omega_master; %[m/s]
        acc = -h / da^2 * out.acc * omega_master^2; %[m/s^2]
        
    elseif (alpha >= alpha_2) && (alpha < alpha_3)
       
        pos = 0;
        vel = 0;
        acc = 0;
        
    elseif (alpha >= alpha_3) && (alpha < alpha_4)
        
        da = alpha_4 - alpha_3;
        alpha_ad = (alpha - alpha_3) / da;  % dimentionless MC

        %select motion curve
        out = MCM_cubic(alpha_ad, par);
         %out = MCM_sshape(alpha_ad, par);
         %out = AccCosAsim(alpha_ad,par);
        
        pos = h * (out.pos);
        vel =  h / da * out.vel * omega_master; %[m/s]
        acc =  h / da^2 * out.acc * omega_master^2; %[m/s^2]
        
    else
        
        pos = h;
        vel = 0;
        acc = 0;
    end
    
    % absolute slider displacement
    x = ldp + e + pos;
  
        % inverse kinematics
    tetha = acos((x^2 + a^2 - b^2) / (2 * a * x));

    st=sin(tetha);
    ct=cos(tetha);
    sb = -a / b * sin(tetha);
    cb = (x - a * cos(tetha)) / b;

    dtetha= -vel/(a*(st*cb-ct*sb)/cb);

    dbeta=-dtetha*a*ct/(b*cb);

    ddtetha= (-acc*cb - (dtetha^2)*a*(ct*cb+st*sb) - (dbeta^2)*b) / ...
        (a*(st*cb-ct*sb));

    ddbeta=(dbeta^2*b*sb-ddtetha*a*ct+dtetha^2*a*st)/(b*cb);
    
    % Output
    res.pos     = x;
    res.vel     = vel;
    res.acc     = acc;
    res.tetha   = tetha;
    res.dtetha  = dtetha;
    res.ddtetha = ddtetha;
    res.dbeta   = dbeta;
    res.ddbeta  = ddbeta;
end


