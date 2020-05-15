function [y,mdl] = fastICA(x,m)
x = x - mean(x,2);
[z,Whi] = whitening(x'); z = z';
% cov(z')
[n,T] = size(z);
W = normalize(rand(n,m),'norm');
g = @(x) tanh(x);
for p = 1:m
    for it=1:10000
        wp = W(:,p);
        G = g(wp'*z);
        wp = z*G'/T - mean(diff(G))*wp;
        H = W(:,1:p-1);
        wp = wp -(H*H')*wp;
        wp = normalize(wp,'norm');
        if mean((W(:,p)-wp).^2) < 1e-12
            break;
        end
        W(:,p) = wp;
    end
%     it,H
end

B = W'*Whi;
y = W'*z;
mdl.B = B; mdl.RotationMatrix = W'; mdl.WhiteningMatex = Whi;
end