function G = generate_expgraph(n)
    
    Adj = zeros(n,n); % adjacency matrix

    n_half = n/2; % n must be 2^k.
    log_n_half = log2(n_half);

    for i = 1:n
        for tt = 0:log_n_half
            j_i = i+2^tt;
            if j_i <=n
                Adj(i,j_i) = 1;
                Adj(j_i,i) = 1;
            end
        end
    end
    
    G = graph(Adj);
end