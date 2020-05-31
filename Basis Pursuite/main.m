clc; clear all; close all; addpath('utils')
%% Define problem
% P1 : min ||x||1   s.t.   Ax = b
n = 100; m = 50;
s = sprand(n,1,0.2)+0;
A = rand(m,n);
b = A*s;
%% Solve it
s_estim = BP(A,b);
snr = 20*log10(norm(s)/norm(s_estim - s))
%%
figure_position([0.2,0.2,0.5,0.5]); hold on;
stem(s); stem(s_estim,'--')
title(['snr = ' num2str(snr)])
% xlabel('sigma'); ylabel('SNR(db)');
legend('s','s_estim')
save_figure(gcf,'results-stem.png')
%% add noise to b
Sigma = linspace(0,1,1000); snr = zeros(size(Sigma));
for i = 1:length(Sigma)
b_n = A*s + Sigma(i)*rand(m,1);
s_estim = BP(A,b_n);
snr(i) = 20*log10(norm(s)/norm(s_estim - s));
end
%%
figure_position([0.2,0.2,0.5,0.5]);
plot(Sigma,snr); xlabel('sigma'); ylabel('SNR(db)');
save_figure(gcf,'results-SNR-sigma-b.png')
%% add noise to s
Sigma = linspace(0,1,1000); snr = zeros(size(Sigma)); snr_n = zeros(size(Sigma));
for i = 1:length(Sigma)
s_n = s + Sigma(i)*rand(n,1);
b = A*s_n;
s_estim = BP(A,b);
snr(i) = 20*log10(norm(s)/norm(s_estim - s));
snr_n(i) = 20*log10(norm(s_n)/norm(s_estim - s_n));
end
%%
figure_position([0.2,0.2,0.5,0.5]);
plot(Sigma,snr,Sigma,snr_n);
xlabel('sigma'); ylabel('SNR(db)');
legend('calc snr with s','calc snr with noisy-s')
save_figure(gcf,'results-SNR-sigma-s.png')