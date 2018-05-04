%% generating video
clc;clear;close all;

% Window size
window = 45;
%Downsize factor
factor = 1;

%% Output folder

% data = @(i) fullfile(sprintf('../Output/Grove/frame_w%d_s%d_%02d.png',window,factor,i));
% video_name = sprintf('../Output/Grove/Videos/Window%d_Factor%d',window,factor);

% data = @(i) fullfile(sprintf('../Output/Wooden/frame_w%d_s%d_%02d.png',window,factor,i));
% video_name = sprintf('../Output/Wooden/Videos/Window%d_Factor%d',window,factor);

%data = @(i) fullfile(sprintf('../Output/Wooden/matlab_lk_%02d.png',i));
% data = @(i) fullfile(sprintf('../Output/Wooden/matlab_fb_%02d.png',i));
% data = @(i) fullfile(sprintf('../Output/Wooden/matlab_hs_%02d.png',i));
data = @(i) fullfile(sprintf('../Output/Wooden/matlab_comparison_%02d.png',i));


% video_name = sprintf('../Output/Wooden/Videos/matab_lk');
% video_name = sprintf('../Output/Wooden/Videos/matab_fb');
% video_name = sprintf('../Output/Wooden/Videos/matab_hs');

video_name = sprintf('../Output/Wooden/Videos/matab_comparison');

%% Video 
video=VideoWriter(video_name);
video.FrameRate = 1;
open(video);

for num=1:7
frame = imread(data(num));
writeVideo(video,frame);
pause(0.01);
end

close(video);