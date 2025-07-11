function output = check_stab(params,K)
    tmp =  max(real(eig( params.A+params.B*K )));
    % tmp = min((eig(P)));
    if tmp <= -1e-10
        output =  1; % stable
    else
        output = 0; % unstable
    end
end