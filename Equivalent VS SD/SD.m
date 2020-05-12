function B = SD(x, mu)
    [n, T] = size(x);
    B = eye(n);
    
	for counter = 1:10000
	    y = B * x;
	    m =@(k,i) mean(y(i,:).^k);
	    %% Estimate \psi_y(y)
	    psi = zeros(size(y));
	    for i = 1:n  
	        E = [1 m(1,i) m(2,i) m(3,i);
	            m(1,i) m(2,i) m(3,i) m(4,i);
	            m(2,i) m(3,i) m(4,i) m(5,i);
	            m(3,i) m(4,i) m(5,i) m(6,i)];
	        M = [0; 1; 2*m(1,i); 3*m(2,i)];
	        theta = E\M;
	        psi(i,:) = theta(1) + theta(2)*y(i,:) + theta(3)*y(i,:).^2+theta(4)*y(i,:).^3;
	    end
	    %% Calculate D:
	    D = (psi *x')/T - inv(B');
	    %% Updata B:
	    B_new = normalize(B - mu*D ,2,'norm');
	    normalized_MSE = mean2((B_new - B).^2) / norm(B,'fro');
	    B = B_new;
	    if normalized_MSE < 1e-12
	        break
	    end
	end
end