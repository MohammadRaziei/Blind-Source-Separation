clc; clear all; close all; addpath('utils');
%% read images as sourse
% s1 = imread(fullfile('images','img_mountains.jpg'));
% s2 = imread(fullfile('images','img_lights.jpg'));
% s1 = imread(fullfile('images','letter-A.png'));
% s2 = imread(fullfile('images','letter-S.png'));
% s1 = imread(fullfile('images','dogs-800x450.jpg'));
% s2 = imread(fullfile('images','butterflies-800x450.jpg'));
s1 = imread(fullfile('images','barbara.jpg'));
s2 = imread(fullfile('images','lena.png'));
%% make them gray
s1 = rgb2gray(s1);
s2 = rgb2gray(s2);
% s1 = reshape(normalize(s1(:),'range'), size(s1,1), size(s1,2));
% s2 = reshape(normalize(s2(:),'range'), size(s2,1), size(s2,2));
% %% read images as sourse
% s1 = imread(fullfile('images','letter-A-small.png'));
% s2 = imread(fullfile('images','letter-S-small.png'));
%% Show images
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
imshow([s1,s2])
title('Source images')
save_figure(gcf, 'results/source images.png')
%% mix sourses
x1 = 0.8*s1+ 0.2*s2; 
x2 = 0.2*s1+ 0.8*s2;
%% show observations
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
imshow([x1,x2])
title('Mixed images')
save_figure(gcf, 'results/mixed images.png')
%% separate mixed-images
[y1,y2]= separate(x1,x2,true);
% [y1,y2]= separate_reportSNR(x1,x2,s1,s2);
% [y1,y2]= separate_stream(x1,x2,true);
% [y1,y2]= separate_expectedB(x1,x2,true);

%% show results
figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
imshow([y1,y2])
title('Result images')
save_figure(gcf, 'results/result images.png')
%% Calculate SNR
SNR =@(s,y) 10 * log10 (mean2(normalize(double(s),'range').^2) ./  mean2((normalize(double(s),'range')-normalize(double(y),'range')).^2));

SNR1= SNR(s1,y1);
SNR2= SNR(s2,y2);