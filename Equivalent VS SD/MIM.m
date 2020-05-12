function B = MIM(x, mu)
    n = size(x,1);
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
    D = zeros(n,n);
    for i = 1:n
        for j = 1:n
            if i==j
                D(i,j) = m(2,i) - 1;
            else
                D(i,j) = mean(psi(i,:) .* y(j,:));
            end
        end
    end
    %% Updata B:
    new_B = B - mu*D*B;
    normalized_MSE = mean2((new_B - B).^2)/ norm(B,'fro');
    B = new_B;
    if normalized_MSE <= 1e-12
        break
    end
end