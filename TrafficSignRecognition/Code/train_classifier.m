clc;clear;close all;

cd ../training;
trainingSet = imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldername');
num = numel(trainingSet.Files);

trainingLabels=trainingSet.Labels;

cd ../code;

for i=1:num
    img=readimage(trainingSet,i);
    img=imresize(img,[64 64]);
    trainFeatures(i,:) = extractHOGFeatures(img,'CellSize',[8 8]);
end

classifier_8x8 = fitcecoc(trainFeatures,trainingLabels);
save('classifier_8x8.mat', 'classifier_8x8');

