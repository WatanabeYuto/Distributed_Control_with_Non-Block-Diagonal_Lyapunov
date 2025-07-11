
A_set = {};
B_set = {};


max_it = 50000; % iterate sufficiently many timez to obtain a stabilizable plant
dd = 1;
nn = 16;
for j = 1:50
    
    for jj = 1:max_it 
        
        eig_A_real = - rand(nn/2,1)/2;
        eig_A_real = [eig_A_real; eig_A_real];
        eig_A_complex = 0.1 * rand(nn/2,1);
        eig_A_complex = [eig_A_complex; - eig_A_complex];
        eig_A = complex(eig_A_real, eig_A_complex);
        
        tmp = rand(nn,nn);
        params.A = tmp - place(tmp,eye(nn), eig_A); 
        tmp = rand(nn,nn);
        A_set{j} = tmp \ params.A * tmp;
        
        B_set{j} = diag([ones(nn-dd,1);zeros(dd,1)]);



        %% stabilizability
        eig_A = eig(A_set{j});
        tmp = 0;
        for ii = 1:nn
            if min(svd([B_set{j}, A_set{j}-eig_A(ii)*eye(nn)])) < 10^(-8) && real(eig_A(ii)) >0
                tmp = 1;
                break
            end
        end

        if tmp == 0
            break
        end
    end

end

save 'stableA_matrices_Hinf.mat' A_set
save 'stableB_matrices_Hinf.mat' B_set