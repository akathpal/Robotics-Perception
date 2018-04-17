close all;clear;clc;

Training_data = '../../Images/TrainingSet/Frames/';
Cropped_buoys = '../../Images/TrainingSet/CroppedBuoys/';
outputfolder = '../../Output/Part0';
bins = (0:1:255)';
folder = @(i) fullfile(sprintf('../../Output/Part0/%s_hist.jpg',i));
avg_counts_r = zeros(256,1);
avg_counts_g = zeros(256,1);
avg_counts_b = zeros(256,1);
Yavg_counts_r = zeros(256,1);
Yavg_counts_g = zeros(256,1);
Yavg_counts_b = zeros(256,1);
Gavg_counts_r = zeros(256,1);
Gavg_counts_g = zeros(256,1);
Gavg_counts_b = zeros(256,1);
%%
SamplesR = [];
SamplesY = [];
SamplesG = [];
for k=1:20
    
    % Load image
    I = imread(sprintf('%s/%03d.jpg',Training_data,k));
    I= imgaussfilt(I,2);
    % You may consider other color space than RGB
    imshow(I);

    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    
    % Collect Cropped samples
    
    %Red buoy
    maskR = imread(sprintf('%s/R_%03d.jpg',Cropped_buoys,k));
    %imshow(maskR);
    
    imR_R = R(maskR>30);
    imR_G = G(maskR>30);
    imR_B = B(maskR>30);

    foreground_mask = uint8(maskR>30);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [r_c, ~] = imhist(R(R > 0));
    [g_c, ~] = imhist(G(G > 0));
    [b_c, ~] = imhist(B(B > 0));
    for j = 1 : 256
        avg_counts_r(j) = avg_counts_r(j) + r_c(j);
        avg_counts_g(j) = avg_counts_g(j) + g_c(j);
        avg_counts_b(j) = avg_counts_b(j) + b_c(j);
    end
    SamplesR = [SamplesR; [imR_R imR_G imR_B]];
     
    %Yellow buoy
    maskY = imread(sprintf('%s/Y_%03d.jpg',Cropped_buoys,k));
    sample_ind_Y = find(maskY > 30);
    RY = R(sample_ind_Y);
    GY = G(sample_ind_Y);
    BY = B(sample_ind_Y);
    SamplesY = [SamplesY; [RY GY BY]];
    foreground_mask = uint8(maskY>30);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [r_c, ~] = imhist(R(R > 0));
    [g_c, ~] = imhist(G(G > 0));
    [b_c, ~] = imhist(B(B > 0));
    for j = 1 : 256
        Yavg_counts_r(j) = Yavg_counts_r(j) + r_c(j);
        Yavg_counts_g(j) = Yavg_counts_g(j) + g_c(j);
        Yavg_counts_b(j) = Yavg_counts_b(j) + b_c(j);
    end
    
    %Green buoy
    maskG = imread(sprintf('%s/G_%03d.jpg',Cropped_buoys,k));
    sample_ind_G = find(maskG > 30);
    RG = R(sample_ind_G);
    GG = G(sample_ind_G);
    BG = B(sample_ind_G);
    SamplesG = [SamplesG; [RG GG BG]];
    
    foreground_mask = uint8(maskG>30);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [r_c, ~] = imhist(R(R > 0));
    [g_c, ~] = imhist(G(G > 0));
    [b_c, ~] = imhist(B(B > 0));
    for j = 1 : 256
        Gavg_counts_r(j) = Gavg_counts_r(j) + r_c(j);
        Gavg_counts_g(j) = Gavg_counts_g(j) + g_c(j);
        Gavg_counts_b(j) = Gavg_counts_b(j) + b_c(j);
    end
end
%%
% visualize the sample distribution
avg_counts_r = avg_counts_r ./ 20;
avg_counts_g = avg_counts_g ./ 20;
avg_counts_b = avg_counts_b ./ 20;

Yavg_counts_r = Yavg_counts_r ./ 20;
Yavg_counts_g = Yavg_counts_g ./ 20;
Yavg_counts_b = Yavg_counts_b ./ 20;

Gavg_counts_r = Gavg_counts_r ./ 20;
Gavg_counts_g = Gavg_counts_g ./ 20;
Gavg_counts_b = Gavg_counts_b ./ 20;

figure(1);
%X = scatter3(avg_counts_r,avg_counts_g, avg_counts_b);
title('Histogram for Red colured buoy')
%subplot(3,1,1);
area(bins, avg_counts_r, 'FaceColor', 'r')
xlim([0 255])
hold on
area(bins, avg_counts_g, 'FaceColor', 'g')
area(bins, avg_counts_b, 'FaceColor', 'b')
hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'R_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%subplot(3,1,2);
figure(2);
title('Histogram for Yellow colured buoy')

area(bins, Yavg_counts_r, 'FaceColor', 'r')
xlim([0 255])
hold on

area(bins, Yavg_counts_g, 'FaceColor', 'g')

area(bins, Yavg_counts_b, 'FaceColor', 'b')
%xlim([0 256])
hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'Y_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%subplot(3,1,3);
figure(3);
%X = scatter3(avg_counts_r,avg_counts_g, avg_counts_b);
title('Histogram for Green colured buoy')

area(bins, Gavg_counts_r, 'FaceColor', 'r')
xlim([0 255])
hold on

area(bins, Gavg_counts_g, 'FaceColor', 'g')

area(bins, Gavg_counts_b, 'FaceColor', 'b')

hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'G_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
