function [gamma_opt,K_opt,P_opt] = Hinfty_SI(params,flag)

    n = params.n;
    G = params.G;

    A = params.A;
    B = params.B;
    C = params.C;
    D = params.D;

    Bw = params.Bw;
    Dw = params.Dw;

    dimc = size(C,1); % for simplicity it is equal to size(D,1)

    E = generate_Ematrix(n,G);
    % EE = generate_Ematrix_cell(n,G);
    % M = eye(size(E,1)) - E*inv(E'*E)*E';

    % %% dilation
    % A_e = dilation_by_E(A,E);
    % B_e = dilation_by_E(B,E);
    % C_e = C * inv(E'*E) * E';
    % D_e = D * inv(E'*E) * E';
    % Bw_e = E * Bw;
    % % Dw_e = Dw;
    
    % cliques = maximalCliques(adjacency(G)); 

    %%  -------- solve LMI -------- 
    yalmip('clear')

    ops = sdpsettings('solver',params.solver);
    ops.verbose = flag;

    S = [];
    gamma= sdpvar(1,1);
    % gamma = 1.0981;
    
    L = laplacian(G);
    for i = 1:n
        tmp = [];
        for j = 1:n
            if L(i,j) ~= 0
                % tmp = [tmp sdpvar(1,1)];
                tmp = [tmp 1];
            else
                tmp = [tmp 0];
            end
        end
        S = [S;tmp];
    end

    Sbin = S;
    Tbin = Sbin;
    Rbin = generate_SXlessS(Tbin);
    
    Q = [];
    Z = [];

    for i = 1:n
        tmp = [];
        for j = 1:n
            if Rbin(i,j) ~= 0
                if Rbin(j,i) ~= 0 
                    tmp = [tmp sdpvar(1,1)];
                else
                    tmp = [tmp 0];
                end
            else
                tmp = [tmp 0];
            end
        end
        Q = [Q;tmp];
    end

    Q = (Q + Q')/2;

    for i = 1:n
        tmp = [];
        for j = 1:n
            if Tbin(i,j) ~= 0
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

    LMI = [LMI_1 <= -eps * eye(size(LMI_1,1)), Q >= eps*inv(E'*E)];


    optimize(LMI, gamma,ops)
    %%  --------  end LMI  --------


    %% results 
    Z_opt = value(Z);
    Q_opt = value(Q);
    K_opt = Z_opt*inv(Q_opt);
    gamma_opt=value(gamma);
    P_opt = inv(Q_opt);
    % eig(value(LMI_1))

    fprintf('------------------------\n')
    fprintf('----SI relaxation---\n')
    fprintf(' gamma_opt                      : %8.3e \n', gamma_opt);
    fprintf(' min of Ps eigval               : %8.2e \n', min(eig(P_opt)));
    fprintf(' condition number of P          : %8.2e \n', max(eig(P_opt))/min(eig(P_opt)));
    fprintf(' Norm of K                      : %8.2e \n', norm(K_opt)); 
    fprintf(' max of A+BKs eigval (real part): %8.2e \n', max( real(eig( A + B*K_opt )) ));
    fprintf('---------------------\n')

end