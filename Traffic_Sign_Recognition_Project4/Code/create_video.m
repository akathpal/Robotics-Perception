%% generating video
clc;clear;close all;


%% Output folder
data = @(i) fullfile(sprintf('../input/image.0%d.jpg',i));
video_name = sprintf('../Output/output');

%% Video 
video=VideoWriter(video_name);
video.FrameRate = 30;
open(video);

for i=32640:35500
frame = imread(data(i));
writeVideo(video,frame);
pause(0.01);
end

close(video);