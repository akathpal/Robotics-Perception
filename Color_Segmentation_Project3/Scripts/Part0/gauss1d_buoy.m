clc;
clear;
close all;

test_data = @(i) fullfile(sprintf('../../Images/TestSet/Frames/%03d.jpg',i));
load ColorSamples.mat
[mu_r,sigma_r]=estimate(SamplesR(:,1));
[mu_y,sigma_y]=estimate((SamplesY(:,1)+SamplesY(:,2))./2);
[mu_g,sigma_g]=estimate(SamplesG(:,2));
video=VideoWriter('test');
open(video);
for n = 1:180

I1=imread(test_data(n));
%I=I1;
I=imgaussfilt(imadjust(I1,[0.6 1],[]),5);
%I=rgb2hsv(I);

%imshow(I);


maskR=zeros(size(I,1),size(I,2));
maskY=zeros(size(I,1),size(I,2));
maskG=zeros(size(I,1),size(I,2));

prob_map_R=maskR;
prob_map_Y=maskY;
prob_map_G=maskG;

%%
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
yellow = (red+green)./2;
for i=1:size(I,1)
    for j=1:size(I,2)
        r=double(red(i,j));
        g=double(green(i,j));
        y=double(yellow(i,j));
        
        %% Gaussian distribution function
        prob_map_R(i,j)=normpdf(r,mu_r,sigma_r);
        prob_map_G(i,j)=normpdf(g,mu_g,sigma_g);
        prob_map_Y(i,j)=normpdf(y,mu_y,sigma_y);
    end
end

figure(1);
imshow(I1); hold on;

mask1 = prob_map_R > 3*std2(prob_map_R);
mask2 = prob_map_G < 2*std2(prob_map_G);
mask3 = prob_map_Y < 3*std2(prob_map_Y);
maskR = mask1 & mask2 & mask3;
se = strel('disk',10);
maskR = imdilate(maskR,se);
maskR = imclose(maskR,strel('disk',5));
maskR2=zeros(size(maskR));
maskR=bwareafilt(maskR,[200,3000]);


ccR = bwconncomp(maskR);
S = regionprops(ccR,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        ccR.PixelIdxList{1,i} = [];
        ccR.NumObjects = ccR.NumObjects -1;
    end
end
if ccR.NumObjects>0
numPixelsR = cellfun(@numel,ccR.PixelIdxList);
[biggestR,idxR] = max(numPixelsR);
maskR2(ccR.PixelIdxList{idxR}) = 1;
[bwR,~] = bwboundaries(maskR2,'holes');
plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
end

mask1 = prob_map_Y >  2*std2(prob_map_Y); 
mask2 = prob_map_G > 2*std2(prob_map_G);
maskY = mask1 &mask2;
maskY2=zeros(size(maskY));

% se = strel('disk',5);
% maskY = imdilate(maskY,se);
maskY=bwareafilt(maskY,[300,4500]);
%imshow(maskY);

ccY = bwconncomp(maskY);

S = regionprops(ccY,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        ccY.PixelIdxList{1,i} = [];
        ccY.NumObjects = ccY.NumObjects -1;
    end
end
if ccY.NumObjects>0
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
[bwY,~] = bwboundaries(maskY2,'holes');
plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);
end

if n<23
mask1 = prob_map_G > 2*std2(prob_map_G);
mask2 = prob_map_R < 2*std2(prob_map_R);
maskG = mask1 & ~maskY & ~maskR;

se = strel('disk',10);
maskG = imdilate(maskG,se);
maskG=bwareafilt(maskG,[500,1500]);
%imshow(maskG);
maskG2=zeros(size(maskG));

ccG = bwconncomp(maskG);
S = regionprops(ccG,'Centroid');
for i=1:size(S,1)
    if ~(S(i).Centroid(1,2)>150 && S(i).Centroid(1,2)<400 && S(i).Centroid(1,1)>40 && S(i).Centroid(1,1)<600)
        ccG.PixelIdxList{1,i} = [];
        ccG.NumObjects = ccG.NumObjects -1;
    end
end
if ccG.NumObjects>0
numPixelsG = cellfun(@numel,ccG.PixelIdxList);
[biggestG,idxG] = max(numPixelsG);
maskG2(ccG.PixelIdxList{idxG}) = 1;
[bwG,~] = bwboundaries(maskG2,'holes');
plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
end
end


writeVideo(video,getframe);
pause(0.01);
hold off;
end
close(video);