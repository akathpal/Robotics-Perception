%Include output.m,threshold.m and lowpass.m files in the same folder
%INITIAL APPROACH: ABHISHEK KATHPAL

clc;
clear all;
close all;

%Reading Input image
pins_rgb = imread('TestImgResized.jpg');
%figure(1);imshow(pins_rgb);

%Denoising image
for k=1:size(pins_rgb,3)
    pins_rgb(:,:,k)=lowpass(pins_rgb(:,:,k), 0.5);
end

%Thresholding colors using their HSV values
[r_pins,rc,r] = threshold(pins_rgb,0.8,1,0.6,1,0.4,0.8);
[g_pins,gc,g] = threshold(pins_rgb,0.2,0.5,0.7,1,0.2,0.6);
[b_pins,bc,b] = threshold(pins_rgb,0.5,0.7,0.7,1,0.2,0.6);
[y_pins,yc,y] = threshold(pins_rgb,0.1,0.3,0.8,1,0.6,0.9);

%I consists of regions whih consists of all combined colors
I = r_pins | g_pins | b_pins | y_pins;

%Detecting white and transparent using edges and subtracting the Image I 
I1 = rgb2gray(pins_rgb);
I2 = edge(I1,'Canny',0.2);
c_se = strel('disk',10);
I3 = imclose(I2,c_se);
I3 = bwareaopen(I3,100);


I4 = I3 - I;
o_se = strel('disk',9);
I4 = imopen(I4,o_se);
I4 = bwareaopen(I4,100);
%figure(4);imshow(I4);
[wt_pins,wt] = bwlabel(I4);
wtc = regionprops(I4,'centroid');

%Displaying Output
output(r,g,b,y,wt,rc,gc,bc,yc,wtc);



