function [gamma_opt,K_opt,P_opt] = subHinfty_diag(params,flag)

    n = params.n;
    G = params.G;

    A = params.A;
    B = params.B;
    C = params.C;
    D = params.D;

    dimc = size(C,1);

    Bw = params.Bw;
    Dw = params.Dw;
    

    E = generate_Ematrix(n,G);
    
    %%  -------- solve LMI -------- 
    yalmip('clear')

    ops = sdpsettings('solver',params.solver);
    ops.verbose = flag;

    Z = [];
    Q = diag(sdpvar(n,1));
    gamma= params.gamma;
    % gamma = 1.0981;
    
    L = laplacian(G);
    for i = 1:n
        tmp = [];
        for j = 1:n
            if L(i,j) ~= 0
                tmp = [tmp sdpvar(1,1)];
            else
                tmp = [tmp 0];
            end
        end
        Z = [Z;tmp];
    end
    
    % Objective and constraints
    
    LMI = [];
    
    LMI_1 = A*Q + B*Z;
    
    LMI_1 = [LMI_1 + LMI_1', Bw, Q*C'+ Z'*D';
            Bw', - gamma * eye(n), Dw';
            C*Q + D*Z, Dw, -gamma * eye(dimc)];
    
    eps = 1/10^10;

    LMI = [LMI_1 <= - eps * eye(size(LMI_1,1)), Q >= eps * inv(E'*E)];


    optimize(LMI, [],ops)
    %%  --------  end LMI  --------


    %% results 
    Z_opt = value(Z);
    Q_opt = value(Q);
    K_opt = Z_opt*inv(Q_opt);
    gamma_opt =  hinfnorm(ss(A+B*K_opt,Bw,C+D*K_opt,Dw));
    P_opt = inv(Q_opt);
    % eig(value(LMI_1))

    fprintf('------------------------\n')
    fprintf('----Block-diagonal relaxation---\n')
    fprintf(' gamma_opt                      : %8.3e \n', gamma_opt);
    fprintf(' min of Ps eigval               : %8.2e \n', min(eig(P_opt)));
    fprintf(' condition number of P          : %8.2e \n', max(eig(P_opt))/min(eig(P_opt)));
    fprintf(' Norm of K                      : %8.2e \n', norm(K_opt)); 
    fprintf(' max of A+BKs eigval (real part): %8.2e \n', max( real(eig( A + B*K_opt )) ));
    fprintf('--------------------------------\n')

end