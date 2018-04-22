clc;clear;close all;

%% Folder Initialization
Training_data = '../../Images/TrainingSet/Frames/';
Cropped_buoys = '../../Images/TrainingSet/CroppedBuoys/';
outputfolder = '../../Output/Part0';
folder = @(i) fullfile(sprintf('../../Output/Part0/%s_hist.jpg',i));


%% variable Initialization
red_buoy_rc = zeros(256,1);
red_buoy_rg = zeros(256,1);
red_buoy_rb = zeros(256,1);
yellow_buoy_rc = zeros(256,1);
yellow_buoy_rg = zeros(256,1);
yellow_buoy_rb = zeros(256,1);
green_buoy_rc = zeros(256,1);
green_buoy_rg = zeros(256,1);
green_buoy_rb = zeros(256,1);
red_samples = [];
green_samples = [];
yellow_samples = [];
thresh = 30;
numofsamples = 30;


%% Training Data Buoys
for k=1:numofsamples
    
    I = imread(sprintf('%s/%03d.jpg',Training_data,k));
    I = rgb2hsv(I);
    I = uint8(255 * mat2gray(I));
    %I = imgaussfilt(imadjust(I,[0.6 1],[]),5);
    
    red = double(I(:,:,1));
    green = double(I(:,:,2));
    blue = double(I(:,:,3));
    
    %% Red buoy
    maskR = imread(sprintf('%s/R_%03d.jpg',Cropped_buoys,k));
    %imshow(maskR);
    
    imR_R = red(maskR>thresh);
    imR_G = green(maskR>thresh);
    imR_B = blue(maskR>thresh);

    foreground_mask = uint8(maskR>thresh);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    %figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [red_count, ~] = imhist(R(R > 0));
    [green_count, ~] = imhist(G(G > 0));
    [blue_count, ~] = imhist(B(B > 0));
    for j = 1 : 256
        red_buoy_rc(j) = red_buoy_rc(j) + red_count(j);
        red_buoy_rg(j) = red_buoy_rg(j) + green_count(j);
        red_buoy_rb(j) = red_buoy_rb(j) + blue_count(j);
    end
    red_samples = [red_samples; [imR_R imR_G imR_B]];
     
    %% Yellow buoy
    maskY = imread(sprintf('%s/Y_%03d.jpg',Cropped_buoys,k));
    sample_ind_Y = find(maskY > thresh);
    RY = red(sample_ind_Y);
    GY = green(sample_ind_Y);
    BY = blue(sample_ind_Y);
    yellow_samples = [yellow_samples; [RY GY BY]];
    
    foreground_mask = uint8(maskY>thresh);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    %figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [red_count, ~] = imhist(R(R > 0));
    [green_count, ~] = imhist(G(G > 0));
    [blue_count, ~] = imhist(B(B > 0));
    for j = 1 : 256
        yellow_buoy_rc(j) = yellow_buoy_rc(j) + red_count(j);
        yellow_buoy_rg(j) = yellow_buoy_rg(j) + green_count(j);
        yellow_buoy_rb(j) = yellow_buoy_rb(j) + blue_count(j);
    end
    
    %% Green buoy
    maskG = imread(sprintf('%s/G_%03d.jpg',Cropped_buoys,k));
    sample_ind_G = find(maskG > thresh);
    RG = red(sample_ind_G);
    GG = green(sample_ind_G);
    BG = blue(sample_ind_G);
    green_samples = [green_samples; [RG GG BG]];
    
    foreground_mask = uint8(maskG>thresh);
    seg = I.* repmat(foreground_mask, [1,1,3]);
    %figure(2);imshow(seg);
    R = seg(:,:,1);
    G = seg(:,:,2);
    B = seg(:,:,3);
   
    [red_count, ~] = imhist(R(R > 0));
    [green_count, ~] = imhist(G(G > 0));
    [blue_count, ~] = imhist(B(B > 0));
    for j = 1 : 256
        green_buoy_rc(j) = green_buoy_rc(j) + red_count(j);
        green_buoy_rg(j) = green_buoy_rg(j) + green_count(j);
        green_buoy_rb(j) = green_buoy_rb(j) + blue_count(j);
    end
end


%% Histogram Visualization
red_buoy_rc = red_buoy_rc ./ thresh;
red_buoy_rg = red_buoy_rg ./ thresh;
red_buoy_rb = red_buoy_rb ./ thresh;

yellow_buoy_rc = yellow_buoy_rc ./ thresh;
yellow_buoy_rg = yellow_buoy_rg ./ thresh;
yellow_buoy_rb = yellow_buoy_rb ./ thresh;

green_buoy_rc = green_buoy_rc ./ thresh;
green_buoy_rg = green_buoy_rg ./ thresh;
green_buoy_rb = green_buoy_rb ./ thresh;

figure(1);
x = (0:1:255)';
title('Histogram for Red colured buoy')
area(x, red_buoy_rc, 'FaceColor', 'r')
xlim([0 255])
hold on
area(x, red_buoy_rg, 'FaceColor', 'g')
area(x, red_buoy_rb, 'FaceColor', 'b')
hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'R_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');

figure(2);
title('Histogram for Yellow colured buoy')
area(x, yellow_buoy_rc, 'FaceColor', 'r')
xlim([0 255])
hold on
area(x, yellow_buoy_rg, 'FaceColor', 'g')
area(x, yellow_buoy_rb, 'FaceColor', 'b')
hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'Y_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');


figure(3);
title('Histogram for Green colured buoy')
area(x, green_buoy_rc, 'FaceColor', 'r')
xlim([0 255])
hold on
area(x, green_buoy_rg, 'FaceColor', 'g')
area(x, green_buoy_rb, 'FaceColor', 'b')
hold off
pause(0.1)
hgexport(gcf, fullfile(outputfolder, 'G_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');

% figure,
% scatter3(red_samples(:,1),red_samples(:,2),red_samples(:,3),'.');
% saveas(gcf,folder('R_distribution'));
% figure,
% scatter3(yellow_samples(:,1),yellow_samples(:,2),yellow_samples(:,3),'.');
% saveas(gcf,folder('Y_distribution'));
% figure,
% scatter3(green_samples(:,1),green_samples(:,2),green_samples(:,3),'.');
% saveas(gcf,folder('G_distribution'));

save('RGYSamples.mat','red_samples','yellow_samples','green_samples');