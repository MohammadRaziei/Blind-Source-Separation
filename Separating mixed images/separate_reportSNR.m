function [y1,y2]= separate_reportSNR(x1,x2,s1,s2)
    [nx,ny] = size(x1);
    X = double([x1(:)'; x2(:)']);
    X = normalize(X ,2,'zscore');
    S = double([s1(:)'; s2(:)']);
    S = normalize(X ,2,'range');
    Y = zeros(size(X));
    g =@(x) tanh(0.3*x);
    I = eye(2);
    B = I;
    numItration = 1;
    B_save = zeros(4,numItration*length(X)); counter = 0;
    SNR_save = zeros(2,numItration*length(X));
    lambda = 0.0008; rng(4);
    for it = 1:numItration
        randIdx = randperm(nx*ny);
        for t = 1:length(X)
            xt = X(:,randIdx(t));
            %% Calculate yt immediately
            yt = B * xt;
            Y(:,randIdx(t)) = yt;
            %% Calculate D1, D2 and D:
            D1 = (yt*yt' - I) / (1 + lambda*(yt'*yt));
            D2 = (g(xt)*yt' - yt*g(yt)') / (1 + lambda*abs(yt'*g(yt))); 
            D = yt*yt' - I + g(xt)*yt' - yt*g(yt)';
            %% Updata B:
%             B = B - lambda*(D1 + D2)*B;
            B = B - lambda*D*B;
            
            %% Save B:
            counter = counter + 1;
            B_save(:,counter) = B(:);
            
            %% Calculate SNR
            Y = normalize(-B*X,2,'range');
            SNR_save(:,counter) = 10 * log10 (mean(S.^2,2) ./  mean((S-Y).^2,2));

            %% Show process bar
            disp(['process : ' num2str(counter/length(B_save)*100,'%0.3f') '%']);

        end
    end
    index = 1:numItration*length(X);
    figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
        subplot(141); plot(index,B_save(1,:)); title('B(1,1)'); ylim([-2,2])
        subplot(142); plot(index,B_save(2,:)); title('B(1,2)'); ylim([-2,2])
        subplot(143); plot(index,B_save(3,:)); title('B(2,1)'); ylim([-2,2])
        subplot(144); plot(index,B_save(4,:)); title('B(2,2)'); ylim([-2,2])
    figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
        subplot(121); plot(index,SNR_save(1,:)); title('SNR(s1,y1)'); ylim([-1,50])
        subplot(122); plot(index,SNR_save(2,:)); title('SNR(s2,y2)'); ylim([-1,50])
    Y = normalize(-B*X,2,'range');
    y1 = uint8(reshape(Y(1,:), nx,ny) *255);
    y2 = uint8(reshape(Y(2,:), nx,ny) *255);
end