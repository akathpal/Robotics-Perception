%Code by Abhishek Kathpal
%INCLUDE LOW PASS FILTER.m and TESTIMGRESIZED.jpg for running 

clc;
clear all;
close all;

%Reading Input image
pins_rgb = imread('TestImgResized.jpg');

%Denoising image
for k=1:size(pins_rgb,3)
    pins_rgb(:,:,k)=lowpass(pins_rgb(:,:,k), 0.5);
end
figure(1);imshow(pins_rgb);

%Detect all the pins using edges and store the centroid points
pins_gray = rgb2gray(pins_rgb);
edges = edge(pins_gray,'Canny',0.2);
struct_element = strel('disk',10);
I = imclose(edges,struct_element);
I = bwareaopen(I,200);
c  = regionprops(I,'centroid');
bb = regionprops(I,'BoundingBox');
[label,n]=bwlabel(I);

%getting pixel values at the centroid points
pixel = zeros(size(c,1),3);
for i=1:1:size(c,1)
    pixel(i,:) = impixel(pins_rgb,c(i).Centroid(1),c(i).Centroid(2));
end

%Creating bounding box and Counting objects
a = size(pixel,1);
img = pins_rgb;
r_count = 0;
b_count = 0;
g_count = 0;
y_count = 0;
w_count = 0;
t_count = 0;
figure(2);imshow(img);
hold on;
for i= 1:1:a
    r = pixel(i,1);
    g = pixel(i,2);
    b = pixel(i,3);
    if (r>130 && g<50)
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','r','LineWidth',3);
        r_count=r_count+1;
    elseif (r<20 && g>50 && b<100)
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','g','LineWidth',3);
        g_count=g_count+1;
    elseif (r<50 && b>100)
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','b','LineWidth',3);
        b_count=b_count+1;
    elseif (r>130 && g>100 && b<50)
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','y','LineWidth',3);
        y_count=y_count+1;
    elseif (r>130 && b>130 && g>130)
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','k','LineWidth',3);
        t_count=t_count+1;
    else 
        rectangle('Position',bb(i).BoundingBox,'EdgeColor','w','LineWidth',3);
        w_count= w_count+1;
    end
end

%Displaying Output
fprintf('No. of objects are = %d\n', n);
fprintf('No. of red objects are = %d\n', r_count);
fprintf('No. of green objects are = %d\n', g_count);
fprintf('No. of blue objects are = %d\n', b_count);
fprintf('No. of yellow objects are = %d\n', y_count);
fprintf('No. of white objects are = %d\n', w_count);
fprintf('No. of transparent objects are = %d\n', t_count);
