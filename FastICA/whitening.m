function [z,Whi] = whitening(x)
% x = normalize(x);
x = x - mean(x);
% Rx = (x'*x)/length(x);
Rx = cov(x);
[Q,D] = eig(Rx);
Whi = (D^(-0.5))*Q';
z = x*Whi';
end