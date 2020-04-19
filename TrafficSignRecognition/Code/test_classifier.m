clc;clear;close all;

cd ../testing;
testSet = imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldername');
num = numel(testSet.Files);

testLabels=testSet.Labels;

cd ../code;
% testFeatures = zeros(num,length(testLabels));
for i=1:num
    img=readimage(testSet,i);
    img=imresize(img,[64 64]);
    testFeatures(i,:) = extractHOGFeatures(img,'CellSize',[8 8]);
end

load('classifier_8x8.mat');
[predictedLabels,score] = predict(classifier_8x8, testFeatures);
confMat = confusionmat(testLabels, predictedLabels);

