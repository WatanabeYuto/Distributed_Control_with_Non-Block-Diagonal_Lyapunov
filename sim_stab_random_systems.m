clear all;

%% define parameters
%%%%%%%%% --------------- start ---------------
parameters

A_set = load("A_matrices_stab.mat");
A_set = A_set.A_set;
B_set = load("B_matrices_stab.mat");
B_set = B_set.B_set; 

Graph_set = {};
Graph_set{1} = generate_ringgraph(params.n);
Graph_set{2} = generate_wheelgraph(params.n);

% plot(params.G); 

stab_result = {};
stab_result{1} = [];
stab_result{2} = [];

%%%%%%%%% --------------  end  ---------------

% params.solver = 'sdpt3';
params.solver = 'mosek';
% params.solver = 'sedumi';

for gr = 1:2
    
    params.G = Graph_set{gr};

    for kk = 1:number_of_data
        params.A = A_set{kk};
        params.B = B_set{kk};
        
        %% run 
        %%%%%%%%% --------------- start ---------------

        % proposed method 1
        [K_opt_proposed1,P_opt_proposed1] = stab_proposed1(params,0);

        %proposed method 2
        [K_opt_proposed2,P_opt_proposed2] = stab_proposed2(params,0);

        % proposed method 3
        [K_opt_proposed3,P_opt_proposed3] = stab_proposed3(params,0);

        %combined method
        [K_opt_c,P_opt_c] = stab_combined(params,0);

        % extended LMI
        [K_opt_ext,P_opt_ext] = stab_ext(params,0);

        % SI
        [K_opt_SI,P_opt_SI] = stab_SI(params,0);

        % block-diagonal relaxation:
        [K_opt_diag,P_opt_diag] = stab_diag(params,0);

        % check_stab(params,K_opt_proposed_0_v2)
        stab_chek_kk = [check_stab(params,K_opt_proposed1),check_stab(params,K_opt_proposed2),check_stab(params,K_opt_proposed3),check_stab(params,K_opt_c),check_stab(params,K_opt_ext),check_stab(params,K_opt_SI),check_stab(params,K_opt_diag)];
        stab_result{gr} = [stab_result{gr}; stab_chek_kk];

    end
end

%% 
result_ring = (sum(stab_result{1},1));
result_wheel = (sum(stab_result{2},1));

fprintf('------------- Number of successful stabilization -------------\n')
disp(['P1:',num2str(result_ring(1)),', P2:',num2str(result_ring(2)),', P3:',num2str(result_ring(3)),', Combined:',num2str(result_ring(4)),', Extended LMI:',num2str(result_ring(5)),', SI:',num2str(result_ring(6)),', diag:',num2str(result_ring(7))])
disp(['P1:',num2str(result_wheel(1)),', P2:',num2str(result_wheel(2)),', P3:',num2str(result_wheel(3)),', Combined:',num2str(result_wheel(4)),', Extended LMI:',num2str(result_wheel(5)),', SI:',num2str(result_wheel(6)),', diag:',num2str(result_wheel(7))])
fprintf('--------------------------------------------------------------\n')
function output = check_stab(params,K)
    tmp =  max(real(eig( params.A+params.B*K )));
    if tmp < - 1e-10
        output =  1;
    else
        output = 0;
    end
end
