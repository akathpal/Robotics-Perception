%% Initialization
clc;clear;close all;
cd ..;
load location_mat;
images_folder = fullfile('input/Oxford_dataset/stereo/centre');
images = imageDatastore(images_folder,'IncludeSubfolders',true);
model=fullfile('input/Oxford_dataset/model');
[fx, fy, cx, cy, G_camera_image, LUT]=ReadCameraModel(images_folder,model);
K=[fx 0 cx;0 fy cy;0 0 1];
cameraParams = cameraParameters('IntrinsicMatrix', K');

image1 = readimage(images, 1);
image1 = demosaic(image1,'gbrg');
image1 = UndistortImage(image1,LUT);
image1 = imgaussfilt(image1,0.5);
image1 = rgb2gray(image1);
image1_points = detectSURFFeatures(image1,'MetricThreshold', 1000);
image1_points = selectUniform(image1_points, 500, size(image1));
[image1_features, image1_points] = extractFeatures(image1, image1_points, 'Upright', true);




R_t = eye(3);
t_t = [0;0;0];
location = [0,0];

R_mat = eye(3);
t_mat = [0;0;0];
%location_mat = [0,0];


N = 800;
l = 300;


tic

for i=19:numel(images.Files)
    
     image2 = readimage(images, i);
    image2 = demosaic(image2,'gbrg');
    image2 = UndistortImage(image2,LUT);
    image2 = imgaussfilt(image2,0.5);
    image2 = rgb2gray(image2);
    image2_points = detectSURFFeatures(image2,'MetricThreshold', 1000);
    image2_points = selectUniform(image2_points, 500, size(image2));
    [image2_features, image2_points] = extractFeatures(image2, image2_points, 'Upright', true);
    
    %% Matching features
    index = matchFeatures(image1_features, image2_features, 'Unique', true);
    matchedPoints1 = image1_points(index(:, 1));
    matchedPoints2 = image2_points(index(:, 2));
   
    
    %% Fundamental Matrix
    [F,inlier_points1,inlier_points2] = get_fundamental_8point_RANSAC1(matchedPoints1,matchedPoints2,N);  
    E=K'*F*K;
    [u,d,v]=svd(E);
    E=u*diag([1,1,0])*v';
    E = E/norm(E);

    [Hset,Rset,Cset] = getting_poses(E);
    [Xset,Xset_new] = linear_triangulation(K,Cset,Rset,inlier_points1.Location,inlier_points2.Location);
    [R, t] = disambiguate_points(Cset,Rset,Xset,Xset_new);

    t_t = t_t + R_t * t;
    R_t = R_t * R;
    location = [location;[t_t(1),t_t(3)]];
%% MATLAB Implementation
% 
%     [F_matlab,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
%         'Method','RANSAC','NumTrials',1000,'DistanceThreshold',1e-4);
%     [relativeOrientation,relativeLocation] = relativeCameraPose(F_matlab,cameraParams,...
%         matchedPoints1.Location(inlierIdx,:),matchedPoints2.Location(inlierIdx,:));
%     R1 = relativeOrientation;
%     t1 = relativeLocation';
%     t_mat = t_mat + R_mat * t1;
%     R_mat = R_mat * R1;
%     location_mat = [location_mat;[t_mat(1),t_mat(3)]];
    
    
    
    %% Plotting Data
%     disp(i)
%   figure(2);
%     axis([-100 1100 -300 1000]);
%     pause(0.01);
%     title('Camera Trajectory');
%   plot(-location(:,1), location(:,2),'b-','LineWidth',4);
%     hold on;
%     plot(-location_mat(:,1), location_mat(:,2),'k-','LineWidth',4);
%     legend('camera','camera-Matlab','Location','northeast');
    
%     cd ..;
%     cd output;
%     cd n20;
%     file = sprintf('image_%d.jpg',i);
%     saveas(figure(1),file);
%     cd ..;
%     cd ..;
%     cd code;
    image1 = image2;
    image1_points = image2_points;
    image1_features = image2_features;
end

drift = get_trajectory_drift(location,location_mat);
title_name = sprintf('Camera-Trajectory-with-N-%d-and-drift-%d.jpg',N,drift);
figure(1);
title(title_name);
plot(-location(:,1), location(:,2),'b-','LineWidth',4);
hold on;
plot(-location_mat(:,1), location_mat(:,2),'k-','LineWidth',4);
hold off
legend('camera','camera-Matlab','Location','northeast');
cd ..;
cd output;
saveas(figure(1),title_name);
display(drift);

toc




