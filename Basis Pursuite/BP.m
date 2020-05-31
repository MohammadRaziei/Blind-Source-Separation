function x = BP(A,b)
A_new = [A, -A];
f = ones(1,size(A_new,2));
lb = zeros(size(f));
%% Solve it
options = optimoptions('linprog','Algorithm','dual-simplex');
% 'dual-simplex' (default)
% 'interior-point-legacy'
% 'interior-point'
% % [x_new,fval,exitflag,output] = linprog(f,[],[],A_new,b,lb,[],options);
x_new = linprog(f,[],[],A_new,b,lb,[],options);
%% Find x from x_new
x = sum(reshape(x_new,size(A,2),2),2);


