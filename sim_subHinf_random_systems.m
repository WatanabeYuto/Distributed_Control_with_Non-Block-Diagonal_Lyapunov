clear all;

%% define parameters
%%%%%%%%% --------------- start ---------------
parameters

params.gamma = 1000; 
A_set = load("A_matrices_Hinf.mat");
A_set = A_set.A_set;
B_set = load("B_matrices_Hinf.mat");
B_set = B_set.B_set; 
q = 20;
r = 0.05*q;
params.C = [ q * eye(params.n);zeros(params.n,params.n)];
params.D = [ zeros(params.n,params.n); r * eye(params.n)];
% exogenous noises
params.Bw = eye(params.n);
params.Dw = zeros(2*params.n,params.n);


Graph_set = {};
Graph_set{1} = generate_ringgraph(params.n);
Graph_set{2} = generate_wheelgraph(params.n);
Graph_set{3} = generate_graph(params.n,0.2);

% params.solver = 'sdpt3'; 
params.solver = 'mosek';
% params.solver = 'sedumi';

gamma_result = {};
gamma_result{1} = [];
gamma_result{2} = [];
gamma_result{3} = [];

%%%%%%%%% --------------  end  ---------------


gamma_result_hist{1} = zeros(number_of_data,6);
stab_result_hist{1} = zeros(number_of_data,6);
gamma_result_hist{2} = zeros(number_of_data,6);
stab_result_hist{2} = zeros(number_of_data,6);
gamma_result_hist{3} = zeros(number_of_data,6);
stab_result_hist{3} = zeros(number_of_data,6);

success_counter{1} = zeros(5,1);
success_counter{2} = zeros(5,1);
success_counter{3} = zeros(5,1);
%% 

for gr = 1:2

    params.G = Graph_set{gr};

    for kk = 1:number_of_data
        params.A = A_set{kk};
        params.B = B_set{kk};
        
        
        % run 
        test_subHinf
        gamma_result_hist{gr}(kk,:) = gamma_result;
        stab_result_hist{gr}(kk,:) = stab_result_Hinf;

    end
    
    for ll = 1:number_of_data
        if stab_result_hist{gr}(ll,6)<=-1e-10 % centralized control failed
            for lll = 1:5
                if stab_result_hist{gr}(ll,lll)<=-1e-10
                    success_counter{gr}(lll,1) = success_counter{gr}(lll,1) +1;
                end
            end
        end
    end

end


%%

fprintf('----- Number of successful H infinity suboptimal control (/50)-----\n')
disp(['P1:',num2str(success_counter{1}(1)),', P2:',num2str(success_counter{1}(2)),', P3:',num2str(success_counter{1}(3)),', SI:',num2str(success_counter{1}(4)),', diag:',num2str(success_counter{1}(5))])
disp(['P1:',num2str(success_counter{2}(1)),', P2:',num2str(success_counter{2}(2)),', P3:',num2str(success_counter{2}(3)),', SI:',num2str(success_counter{2}(4)),', diag:',num2str(success_counter{2}(5))])
fprintf('-------------------------------------------------------------------\n')