%% Author 
%  Abhishek Kathpal
%  UID: 114852373
%  Perception for Autonomous Robots

%% Initialization
clc;
clear;
close all;

test_data = @(i) fullfile(sprintf('../../Images/TestSet/Frames/%03d.jpg',i));
load RGYSamples.mat

%% Estimating mean and sigma 1D gaussian
%--For Yellow buoy - average of red and green channel is used
%--For red buoy - red channel is used
%--For green buoy - green channel is used
[mu_r,sigma_r]=model_parameters(red_samples(:,1));
[mu_y,sigma_y]=model_parameters((yellow_samples(:,1)+yellow_samples(:,2))./2);
[mu_g,sigma_g]=model_parameters(green_samples(:,2));
cd ../../Output/Part0;
video=VideoWriter('test1');
video.FrameRate = 5;
cd ../../Scripts/Part0;
hold off;
open(video);

for n = 1:170

I_original=imread(test_data(n));
I=imgaussfilt(imadjust(I_original,[0.6 1],[]),5);

red=double(I(:,:,1));
green=double(I(:,:,2));
yellow = double((I(:,:,1)+I(:,:,2))./2);

%% Gaussian distribution function
prob_map_R=gaussian_1D(red,mu_r,sigma_r);
prob_map_G=gaussian_1D(green,mu_g,sigma_g);
prob_map_Y=gaussian_1D(yellow,mu_y,sigma_y);

prob_map_R = prob_map_R./max(prob_map_R(:));
prob_map_G = prob_map_G./max(prob_map_G(:));
prob_map_Y = prob_map_Y./max(prob_map_Y(:));



figure(1);
imshow(I_original); hold on;

red_mask = prob_map_R > 0.95;

se = strel('disk',5);
red_mask = imdilate(red_mask,se);
red_mask = imclose(red_mask,strel('disk',5));
red_mask2=zeros(size(red_mask));
red_mask=bwareafilt(red_mask,[200,3000]);


red_comp = bwconncomp(red_mask);
S = regionprops(red_comp,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        red_comp.PixelIdxList{1,i} = [];
        red_comp.NumObjects = red_comp.NumObjects -1;
    end
end

if red_comp.NumObjects>0
    numPixelsR = cellfun(@numel,red_comp.PixelIdxList);
    [biggestR,idxR] = max(numPixelsR);
    red_mask2(red_comp.PixelIdxList{idxR}) = 1;
    [red_boundaries,~] = bwboundaries(red_mask2,'holes');
    plot(red_boundaries{1}(:,2),red_boundaries{1}(:,1),'r', 'LineWidth', 2);
end

yellow_mask = prob_map_Y >  0.95; 
yellow_mask2=zeros(size(yellow_mask));
yellow_mask=bwareafilt(yellow_mask,[200,3000]);
%imshow(yellow_mask);

yellow_comp = bwconncomp(yellow_mask);

S = regionprops(yellow_comp,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        yellow_comp.PixelIdxList{1,i} = [];
        yellow_comp.NumObjects = yellow_comp.NumObjects -1;
    end
end
if yellow_comp.NumObjects>0
numPixelsY = cellfun(@numel,yellow_comp.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
yellow_mask2(yellow_comp.PixelIdxList{idxY}) = 1;
[yellow_boundaries,~] = bwboundaries(yellow_mask2,'holes');
plot(yellow_boundaries{1}(:,2),yellow_boundaries{1}(:,1),'y', 'LineWidth', 2);
end

if n<20


green_mask = prob_map_G > 0.7;
se = strel('disk',5);
green_mask = imdilate(green_mask,se);
green_mask=bwareafilt(green_mask,[500,800]);
%imshow(green_mask);
green_mask2=zeros(size(green_mask));

green_comp = bwconncomp(green_mask);
S = regionprops(green_comp,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        green_comp.PixelIdxList{1,i} = [];
        green_comp.NumObjects = green_comp.NumObjects -1;
    end
end
if green_comp.NumObjects>0
numPixelsG = cellfun(@numel,green_comp.PixelIdxList);
[biggestG,idxG] = max(numPixelsG);
green_mask2(green_comp.PixelIdxList{idxG}) = 1;
[green_boundaries,~] = bwboundaries(green_mask2,'holes');
plot(green_boundaries{1}(:,2),green_boundaries{1}(:,1),'g', 'LineWidth', 2);
end
end


writeVideo(video,getframe(gcf));
pause(0.01);

end
close(video);