clc;
clear;
close all;

test_data = @(i) fullfile(sprintf('../../Images/TestSet/Frames/%03d.jpg',i));
load RGYSamples.mat
[mu_r,sigma_r]=model_parameters_3d(red_samples);
[mu_y,sigma_y]=model_parameters_3d(yellow_samples);
[mu_g,sigma_g]=model_parameters_3d(green_samples);
cd ../../Output/Part1;
video=VideoWriter('Gaussian_3D');
cd ../../Scripts/Part1
open(video);

for n = 1:180

I1=imread(test_data(n));
I=imgaussfilt(imadjust(I1,[0.6 1],[]),5);

red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
yellow = (red+green)./2;
k=1;
L =size(I,1);
W=size(I,2);
R = reshape(red,L*W,1);
G = reshape(green,L*W,1);
B = reshape(blue,L*W,1);
Intensities = [R G B];
Intensities = double(Intensities);

%% Multivariate Normal distribution function
prob_map_R=gaussian_nd(Intensities,mu_r,sigma_r);
prob_map_G=gaussian_nd(Intensities,mu_g,sigma_g);
prob_map_Y=gaussian_nd(Intensities,mu_y,sigma_y);

prob_map_R = prob_map_R./max(prob_map_R);
prob_map_G = prob_map_G./max(prob_map_G);
prob_map_Y = prob_map_Y./max(prob_map_Y);

prob_map_R = reshape(prob_map_R,L,W);
prob_map_G = reshape(prob_map_G,L,W);
prob_map_Y = reshape(prob_map_Y,L,W);

figure(1);
imshow(I1); hold on;

red_mask = prob_map_R > 0.85 & prob_map_Y<0.8;

se = strel('disk',5);
red_mask = imdilate(red_mask,se);
red_mask = imclose(red_mask,strel('disk',5));
red_mask2=zeros(size(red_mask));
red_mask=bwareafilt(red_mask,[400,3000]);


red_comp = bwconncomp(red_mask);
S = regionprops(red_comp,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        red_comp.PixelIdxList{1,i} = [];
        red_comp.NumObjects = red_comp.NumObjects -1;
    end
end

if red_comp.NumObjects>0
    pixels = cellfun(@numel,red_comp.PixelIdxList);
    [~,index] = max(pixels);
    red_mask2(red_comp.PixelIdxList{index}) = 1;
    [red_boundaries,~] = bwboundaries(red_mask2,'holes');
    plot(red_boundaries{1}(:,2),red_boundaries{1}(:,1),'r', 'LineWidth', 2);
end

yellow_mask = prob_map_Y >  0.75; 
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
    pixels = cellfun(@numel,yellow_comp.PixelIdxList);
    [~,index] = max(pixels);
    yellow_mask2(yellow_comp.PixelIdxList{index}) = 1;
    [yellow_boundaries,~] = bwboundaries(yellow_mask2,'holes');
    plot(yellow_boundaries{1}(:,2),yellow_boundaries{1}(:,1),'y', 'LineWidth', 2);
end

if n<10
    green_mask = prob_map_G > 0.9;
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
        pixels = cellfun(@numel,green_comp.PixelIdxList);
        [~,index] = max(pixels);
        green_mask2(green_comp.PixelIdxList{index}) = 1;
        [green_boundaries,~] = bwboundaries(green_mask2,'holes');
        plot(green_boundaries{1}(:,2),green_boundaries{1}(:,1),'g', 'LineWidth', 2);
    end
end


writeVideo(video,getframe(gcf));
pause(0.01);

end
close(video);