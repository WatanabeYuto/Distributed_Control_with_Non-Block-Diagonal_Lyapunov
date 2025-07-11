function G = generate_diskgraph(n)

    % arguments
    %     prob = 0.3 % probability to generate edges
    % end
    
    Adj = zeros(n,n); % adjacency matrix
    
    for j = 1:500
        r = 0.1;
        x = 5*rand(n,1);
        y = 5*rand(n,1);
    
        for i = 1:n
            for j = 1:n
                if norm([x(i,1)-x(j,1),y(i,1)-y(j,1)]) <= r && i>j
                    Adj(i, j) = 1;
                    Adj(j,i) = 1;
                end
            end
        end
                
        G = graph(Adj);
        test_L = laplacian(G);
        tmp = sort(eig(test_L),'ascend');
        % check the connectivity
        if tmp(2)>= 1e-5
            break
        end
    end

    % plot(G)
    max(mink(eig(test_L),2));

end