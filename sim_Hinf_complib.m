clear all;


[A,B1,B,C1,C,D11,D12,D21,nx,nw,nu,nz,ny] = COMPleib('DIS1');
% DIS1, DIS3, BDT1

params.n = nx; %% the number of nodes
params.d = 1; %% dimension

B = [B, zeros(nx,nx-nu)];
params.G = generate_wheelgraph(nx);

% plot(params.G)

params.A = A;
params.B = B;
q = 20;
r = q*10;
params.C = [ q * eye(nx);zeros(nx,nx)];
params.D = [ zeros(nx,nx); r * eye(nx)];

params.Bw = [B1,zeros(nx,nx-nw)];
params.Dw = zeros(size(params.C));

params.solver = 'mosek';

test_Hinf

%% closed loop systems
clsys = {};
clsys{1} = ss(A+B*K_opt_proposed1,params.Bw,params.C+params.D*K_opt_proposed1,params.Dw);
clsys{2} = ss(A+B*K_opt_proposed2,params.Bw,params.C+params.D*K_opt_proposed2,params.Dw);
clsys{3} = ss(A+B*K_opt_proposed3,params.Bw,params.C+params.D*K_opt_proposed3,params.Dw);
clsys{4} = ss(A+B*K_opt_diag,params.Bw,params.C+params.D*K_opt_diag,params.Dw);
clsys{5} = ss(A+B*K_opt_SI,params.Bw,params.C+params.D*K_opt_SI,params.Dw);
clsys{6} = ss(A+B*K_opt_cen,params.Bw,params.C+params.D*K_opt_cen,params.Dw);


%%
x_absmax_list = [];

dt = 0.01;
Tmax = 50;
t = 0:dt:Tmax;

x_history = {};

C = eye(nx);
u = [];
% disturbance construction
for j = 1:nx
    u =[u, 0.1*(sin(t))'];
end

for j = 1:3
    [~,t,x_tmp] = lsim(clsys{j},u,t);
    x_history{j} = (C*x_tmp')';
end

% centralized
[~,t,x_tmp] = lsim(clsys{6},u,t);
x_history{4} = (C*x_tmp')';

subplot(5,1,1);

plot(x_history{1},'LineWidth',2)
T_dt= Tmax/dt;

xticks([0,1/5 * T_dt ,2/5 * T_dt, 3/5 * T_dt, 4/5 * T_dt ,Tmax/dt])
xlim([0,T_dt])
% ylim([-0.5,0.5])
xticklabels({'0','10','20','30','40','50'})
% legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$','$x_7$','$x_8$','$x_9$','$x_10$','$x_11$','Centralized','interpreter','latex')
fontsize(12,"points")
title('Proposed method 1')

subplot(5,1,2);


plot(x_history{2},'LineWidth',2)
T_dt= Tmax/dt;
xticks([0,1/5 * T_dt ,2/5 * T_dt, 3/5 * T_dt, 4/5 * T_dt ,Tmax/dt])
xlim([0,T_dt])
% ylim([-0.5,0.5])
xticklabels({'0','10','20','30','40','50'})
legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$','$x_7$','$x_8$','$x_9$','$x_{10}$','$x_{11}$','interpreter','latex')
colororder("gem12")
fontsize(12,"points")
title('Proposed method 2')


subplot(5,1,3);

plot(x_history{3},'LineWidth',2)
T_dt= Tmax/dt;
xticks([0,1/5 * T_dt ,2/5 * T_dt, 3/5 * T_dt, 4/5 * T_dt ,Tmax/dt])
xlim([0,T_dt])
% ylim([-0.5,0.5])
xticklabels({'0','10','20','30','40','50'})
% legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$','$x_7$','$x_8$','$x_9$','$x_10$','$x_11$','Centralized','interpreter','latex')
fontsize(12,"points")
title('Proposed method 3')

subplot(5,1,4);

plot(x_history{4},'LineWidth',2)
T_dt= Tmax/dt;
xticks([0,1/5 * T_dt ,2/5 * T_dt, 3/5 * T_dt, 4/5 * T_dt ,Tmax/dt])
xlim([0,T_dt])
% ylim([-0.5,0.5])
xticklabels({'0','10','20','30','40','50'})
% legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$','$x_7$','$x_8$','$x_9$','$x_{10}$','$x_{11}$','interpreter','latex')
fontsize(12,"points")
title('Centralized control')

subplot(5,1,5);

plot(u,'LineWidth',2,'Color','blue')
T_dt= Tmax/dt;
xticks([0,1/5 * T_dt ,2/5 * T_dt, 3/5 * T_dt, 4/5 * T_dt ,Tmax/dt])
xlim([0,T_dt])
% ylim([0,5])
xticklabels({'0','10','20','30','40','50'})
% legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$','$x_7$','$x_8$','$x_9$','$x_10$','$x_11$','Centralized','interpreter','latex')
fontsize(12,"points")
title('Disturbance')

