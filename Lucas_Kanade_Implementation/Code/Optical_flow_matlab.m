%% Matlab Different Optical Flow Techniques
% Lucas Kanade
% Farneback
% Horn-Schunck

clc;clear;close all;

%% Dataset Location location
%test_data = @(i) fullfile(sprintf('../Dataset/Grove/frame%02d.png',i));
test_data = @(i) fullfile(sprintf('../Dataset/Wooden/frame%02d.png',i));

%% Output Location
% output_data_lk = @(i) fullfile(sprintf('../Output/Grove/matlab_lk_%02d.png',i));
% output_data_fb = @(i) fullfile(sprintf('../Output/Grove/matlab_fb_%02d.png',i));
% output_data_hs = @(i) fullfile(sprintf('../Output/Grove/matlab_hs_%02d.png',i));
% output_data_comparison = @(i) fullfile(sprintf('../Output/Grove/matlab_comparison_%02d.png',i));

% output_data_lk = @(i) fullfile(sprintf('../Output/Wooden/matlab_lk_%02d.png',i));
% output_data_fb = @(i) fullfile(sprintf('../Output/Wooden/matlab_fb_%02d.png',i));
% output_data_hs = @(i) fullfile(sprintf('../Output/Wooden/matlab_hs_%02d.png',i));

output_data_comparison = @(i) fullfile(sprintf('../Output/Wooden/matlab_comparison_%02d.png',i));

%% Implementation of Lucas-Kanade, Farneback and Horn-Schunck Optical Flow Techniques
opticFlow1 = opticalFlowLK;
opticFlow2 = opticalFlowFarneback;
opticFlow3 = opticalFlowHS;


for num = 1:1:7
    
frame = imread(test_data(num+6));
flow1 = estimateFlow(opticFlow1,frame); 
flow2 = estimateFlow(opticFlow2,frame); 
flow3 = estimateFlow(opticFlow3,frame); 

figure(1);
subplot 221;
imshow(frame);
title('originalFrame');

subplot 222;
imshow(frame);
hold on;
plot(flow1,'DecimationFactor',[10 10],'ScaleFactor',10);
title('opticalFlowLK');
hold off;


subplot 223;
imshow(frame);
hold on;
plot(flow2,'DecimationFactor',[15 15],'ScaleFactor',5);
title('opticalFlowFarneback');
hold off;

subplot 224;
imshow(frame);
hold on;
plot(flow3,'DecimationFactor',[5 5],'ScaleFactor',50);
title('opticalFlowHS');
hold off;

saveas(gcf,output_data_comparison(num));
pause(0.01);
end

