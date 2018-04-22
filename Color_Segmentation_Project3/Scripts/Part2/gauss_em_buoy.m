% clc;
% clear;
% close all;
% 
% test_data = @(i) fullfile(sprintf('../../Images/TestSet/Frames/%03d.jpg',i));
% load RGYSamples.mat
% 
% rN=4;
% gN=4;
% yN=4;
% 
% %% Matlab Implementation
% % GMM_red_buoy = estimate(red_samples,3);
% % GMM_yellow_buoy = estimate(yellow_samples,3);
% % GMM_green_buoy = estimate(green_samples,3);
% % mu_r = GMM_red_buoy.mu;
% % mu_y = GMM_yellow_buoy.mu;
% % mu_g = GMM_green_buoy.mu;
% % sigma_r = GMM_red_buoy.Sigma;
% % sigma_y = GMM_yellow_buoy.Sigma;
% % sigma_g = GMM_green_buoy.Sigma;
% 
% %% My implementation
% [mu_r,sigma_r] = em_implementation(red_samples,rN,3);
% [mu_g,sigma_g] = em_implementation(green_samples,gN,3);
% [mu_y,sigma_y] = em_implementation(yellow_samples,yN,3);

%% Making Video Object with specified frame rate 
video=VideoWriter('test');
video.FrameRate = 10; % set frame rate

%% Reading and processing all test frames
for n = 120:170

    I=imread(test_data(n));
    I1=I;
%     I1 = rgb2hsv(I1);
%     I1 = uint8(255 * mat2gray(I1));
    %I=imgaussfilt(imadjust(I1,[0.6 1],[]),5);

    red=I(:,:,1);
    green=I(:,:,2);
    blue=I(:,:,3);
    
    k=1;
    L =size(I,1);
    W=size(I,2);
    R = reshape(red,L*W,1);
    G = reshape(green,L*W,1);
    B = reshape(blue,L*W,1);
    Intensities = [R G B];
    Intensities = double(Intensities);
    prob_map_R = zeros(L*W,1);
    prob_map_G = zeros(L*W,1);
    prob_map_Y = zeros(L*W,1);

    %% Multivariate Normal distribution function
    for i = 1:size(mu_y,1)
        prob_map_Y = gaussian_nd(Intensities,mu_y(i,:),sigma_y(:,:,i)) + prob_map_Y;
    end
    for i = 1:size(mu_r,1)
        prob_map_R = gaussian_nd(Intensities,mu_r(i,:),sigma_r(:,:,i)) + prob_map_R;
    end
    for i = 1:size(mu_g,1)
        prob_map_G = gaussian_nd(Intensities,mu_g(i,:),sigma_g(:,:,i)) + prob_map_G;
    end
    
    prob_map_R = (prob_map_R./max(prob_map_R))./size(mu_r,1);
    prob_map_G = (prob_map_G./max(prob_map_G))./size(mu_g,1);
    prob_map_Y = (prob_map_Y./max(prob_map_Y))./size(mu_y,1);

    prob_map_R = reshape(prob_map_R,L,W);
    prob_map_G = reshape(prob_map_G,L,W);
    prob_map_Y = reshape(prob_map_Y,L,W);

    figure(1);
    imshow(I1); hold on;

    red_mask = prob_map_R > 20*mean(prob_map_R(:)) & prob_map_Y < 10*mean(prob_map_Y(:));

    %red_mask = prob_map_R > 0.1*max(prob_map_R(:));
    se = strel('disk',5);
    red_mask = imdilate(red_mask,se);
    red_mask = imclose(red_mask,strel('disk',5));
    red_mask2=zeros(size(red_mask));
    red_mask=bwareafilt(red_mask,[700,4000]);
    %imshow(red_mask)

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

    yellow_mask = prob_map_Y > 50*mean(prob_map_Y(:)); 
    se = strel('disk',5);
    yellow_mask = imdilate(yellow_mask,se);
    yellow_mask2=zeros(size(yellow_mask));
    yellow_mask=bwareafilt(yellow_mask,[200,4000]);
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
        green_mask = prob_map_G > 100*mean(prob_map_G(:)); 
        se = strel('disk',5);
        green_mask = imdilate(green_mask,se);
        green_mask=bwareafilt(green_mask,[500,2000]);
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

    open(video);
    writeVideo(video,getframe(gcf));
    pause(0.01);

end
close(video);