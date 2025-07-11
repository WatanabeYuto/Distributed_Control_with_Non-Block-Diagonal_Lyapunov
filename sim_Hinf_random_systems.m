clear all;

%% define parameters
%%%%%%%%% --------------- start ---------------
parameters

% -- unstable A matrices case -- 
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
%% 

for gr = 1:2

    params.G = Graph_set{gr};

    for kk = 1:number_of_data
        params.A = A_set{kk};
        params.B = B_set{kk};
        
        
        % run 
        test_Hinf
        gamma_result_hist{gr}(kk,:) = gamma_result;
        stab_result_hist{gr}(kk,:) = stab_result_Hinf;

    end
    
    for ll = 1:number_of_data
        if stab_result_hist{gr}(ll,6)>=-1e-10 % centralized control failed
            for lll = 1:5
                gamma_result_hist{gr}(ll,lll) = 10^8; % the simulation itself is not wellconditioned
            end
        else
            for lll = 1:5
                if stab_result_hist{gr}(ll,lll)>=-1e-10
                    gamma_result_hist{gr}(ll,lll) = 10^8; % unstable case
                else
                    gamma_result_hist{gr}(ll,lll) = abs(gamma_result_hist{gr}(ll,lll)-gamma_result_hist{gr}(ll,6)); % |\gamma - \gamma_cen| \gamma_cen: centralized controller
                end
            end
        end
    end

    clf;

    %% 
    ran = 1:number_of_data;
    % semilogy(ran,gamma_result_hist(:,5),'LineStyle','none','MarkerSize',20,'Marker',"pentagram",'MarkerFaceColor','k');
    % hold on

    semilogy(ran,gamma_result_hist{gr}(:,1),'LineStyle','none','MarkerSize',13,'Marker','o','MarkerFaceColor','r');
    hold on
    semilogy(ran,gamma_result_hist{gr}(:,2),'LineStyle','none','MarkerSize',15,'Marker',"pentagram",'MarkerFaceColor','g');
    semilogy(ran,gamma_result_hist{gr}(:,3),'LineStyle','none','MarkerSize',13,'Marker',"^",'MarkerFaceColor','#ffaa00');
    semilogy(ran,gamma_result_hist{gr}(:,4),'LineStyle','none','MarkerSize',12,'Marker','square','MarkerFaceColor','b');
    semilogy(ran,gamma_result_hist{gr}(:,5),'LineStyle','none','MarkerSize',8,'Marker',"diamond",'MarkerFaceColor','c');

    hold off

    xlabel('Sample number')
    ylabel('$|\gamma_*-\gamma_\mathrm{*,cen}|$','Interpreter', 'latex','FontSize',20)


    yticks([0.1 1 10 10^2 10^3 10^4 10^5 10^6 10^8])
    yticklabels({" " "1", "10", "10^2", "10^3", "10^4", "10^5", "10^6","fail"})

    lgd = legend('proposed method 1','proposed method 2','proposed method 3','SI-based relaxation','block-diagonal relaxation','Interpreter', 'latex')
    fontsize(lgd, 12, 'points')
    
    tmp = append('gamma_gr=',num2str(gr),'.fig');
    saveas(gcf,tmp)
end