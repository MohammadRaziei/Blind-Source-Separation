clc; clear all; close all;
%% Generate independent sourses
rng(8);
num = 2;
s = 1.7*(2*rand(2,1000) - 1);
%% Mix sourses and generate observations
p = 0.5; % 0<p<1
A = p*ones(num) + (1-p)*eye(num);
% A = [1 0.5; 0.5 1];
x = A*s;
%% Alg 1: Calculate B from observation via MIM  
clc; disp('Calculating B from observation via MIM.');
B = MIM(x,0.1); % Equivalent
y = B*x;

% SNR_1 = 10 * log10 (mean(s(1,:).^2) /  mean( (s(1,:)-y(1,:)).^2 ) );
% SNR_2 = 10 * log10 (mean(s(2,:).^2) /  mean( (s(2,:)-y(2,:)).^2 ) );
S = normalize(s ,2,'range');
y = normalize(y ,2,'range');
SNR_MIM= 10 * log10 (mean(S.^2,2) ./  mean((S-y).^2 , 2));
%% Alg 2: Calculate B from observation via SD  
clc; disp('Calculating B from observation via SD.');
B = SD(x,0.1);
y = B*x;

S = normalize(s ,2,'range');
y = normalize(y ,2,'range');
SNR_SD= 10 * log10 (mean(S.^2, 2) ./  mean((S-y).^2 , 2));
% 
% % inv(A) = 
% %     1.3333   -0.6667
% %    -0.6667    1.3333