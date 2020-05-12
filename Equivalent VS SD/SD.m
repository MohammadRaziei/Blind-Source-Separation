function B = SD(x, mu)
    [n,nt] = size(x);
    B = eye(n);
    for counter = 1:10000
        y = B * x;
        %% Estimate \psi_y(y):
        m = @(k,i) mean(y(i,:).^k);
        psi = zeros(size(y));
        for i = 1:n
            M = [1 m(1,i) m(2,i) m(3,i);
                m(1,i) m(2,i) m(3,i) m(4,i);
                m(2,i) m(3,i) m(4,i) m(5,i);
                m(3,i) m(4,i) m(5,i) m(6,i)];
            V = [0;1;2*m(1,i);3*m(2,i)];
            theta = M\V;
            psi(i,:) = theta(1) + theta(2)*y(i,:) + theta(3)*y(i,:).^2 + theta(4)*y(i,:).^3;
        end
        %% Calculate D:
        D = zeros(n);
        for i = 1:n
            for j = 1:n
                D(i,j) = mean(psi(i,:) .* x(j,:)) - B(j,i);
            end
        end
        %% Updata B:
        B_new = normalize(B - mu*D ,2,'norm')
        cost = sqrt(mean(mean((B_new - B).^2))) / norm(B,'fro');
        B = B_new;
        if cost < 1e-6
            break
        end
       
    end
end

