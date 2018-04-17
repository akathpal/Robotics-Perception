%% Saving matched  points sing SURF features
clc;clear;close all;
tic

images_folder = fullfile('D:/Robotics-Perception/Visual_Odometry_Project2/input/Oxford_dataset/stereo/centre');
images = imageDatastore(images_folder,'IncludeSubfolders',true);
model=fullfile('D:/Robotics-Perception/Visual_Odometry_Project2/input/Oxford_dataset/model');
[fx, fy, cx, cy, G_camera_image, LUT]=ReadCameraModel(images_folder,model);
K=[fx 0 cx;0 fy cy;0 0 1];

image1 = readimage(images, 1);
image1 = demosaic(image1,'gbrg');
image1 = UndistortImage(image1,LUT);
image1 = imgaussfilt(image1,0.5);
image1 = rgb2gray(image1);
image1_points = detectSURFFeatures(image1,'MetricThreshold', 1000);
image1_points = selectUniform(image1_points, 500, size(image1));
[image1_features, image1_points] = extractFeatures(image1, image1_points, 'Upright', true);
MatchedSURFPoints = cell(numel(images.Files)-1);

for i=2:numel(images.Files)
    
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
    MatchedSURFPoints{i-1} = {matchedPoints1,matchedPoints2};
    image1 = image2;
    image1_points = image2_points;
    image1_features = image2_features;
    
end
save MatchedSURFPoints
save K