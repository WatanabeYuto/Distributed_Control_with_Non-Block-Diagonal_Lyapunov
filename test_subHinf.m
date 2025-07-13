%% run 

gamma_result = [];
stab_result_Hinf = [];


%%%%%%%%% --------------- start ---------------

% gamma_opt: computed by hinfnorm()

% % H infty
% proposed method 1:
[gamma_opt_proposed1,K_opt_proposed1,P_opt_proposed1] = subHinfty_proposed1(params,0);

% proposed method 2:
[gamma_opt_proposed2,K_opt_proposed2,P_opt_proposed2] = subHinfty_proposed2(params,0);

% proposed method 3:
[gamma_opt_proposed3,K_opt_proposed3,P_opt_proposed3] = subHinfty_proposed3(params,0);

% SI
[gamma_opt_SI,K_opt_SI,P_opt_SI] = subHinfty_SI(params,0);

% block-diagonal relaxation:
[gamma_opt_diag,K_opt_diag,P_opt_diag] = subHinfty_diag(params,0);

% centralized controllr:
[gamma_opt_cen,K_opt_cen,P_opt_cen] = subHinfty_centralized(params,0);


% results: P1, P2, P3, SI-based relaxation, block-diagonal relaxation, centralized case
gamma_result = [gamma_opt_proposed1,gamma_opt_proposed2,gamma_opt_proposed3,gamma_opt_SI,gamma_opt_diag,gamma_opt_cen];
stab_result_Hinf = [check_stability_A(params,K_opt_proposed1),check_stability_A(params,K_opt_proposed2),check_stability_A(params,K_opt_proposed3),check_stability_A(params,K_opt_SI),check_stability_A(params,K_opt_diag),check_stability_A(params,K_opt_cen)];

function output = check_stability_A(params,K)
    output =  max(real(eig( params.A+params.B*K )));
end