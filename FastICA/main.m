clear all; close all; addpath('utils'); rng(41)
%%
numSources = 4; 
m = 4;
s = 2*rand(numSources,100000)-1;
p = 0.2;
A = p*ones(numSources) + (1-p)*eye(numSources);
x = A*s;
[y,mdl] = fastICA(x,m);
% SNR =@(s,y) 10 * log10 (mean(normalize(s,2,'range').^2,2) ./  mean((normalize(s,2,'range')-normalize(y,2,'range')).^2,2));
SNRi =@(s,y) 10 * log10 (mean(normalize(s,'range').^2) ./  mean((normalize(s,'range')-normalize(y,'range')).^2));

% snr = SNR(s,y)
%%
fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.05 0 0.9 1]);
for item = 1:m
    subplot(m,1,item)
    y_item = y(item,:);
    rho = corrcoef(s(item,:),y_item); rho = rho(2);
    y_item = rho*y_item;
    index = 100:300;
    plot(index,normalize(s(item,index),'range'),index,normalize(y_item(index),'range'),'--')
    title(['SNR = ' num2str(SNRi(s(item,:),y_item))])
end
save_figure(gcf,'results.png');