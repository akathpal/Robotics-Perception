function frameExtraction()


video=VideoReader('../Input/detectbuoy.avi');

Training_frames = @(i) fullfile(sprintf('../Images/TrainingSet/Frames/%03d.jpg',i));
Test_frames = @(i) fullfile(sprintf('../Images/TestSet/Frames/%03d.jpg',i));
Cropped_red = @(i) fullfile(sprintf('../Images/TrainingSet/CroppedBuoys/R_%03d.jpg',i));
Cropped_yellow = @(i) fullfile(sprintf('../Images/TrainingSet/CroppedBuoys/Y_%03d.jpg',i));
Cropped_green = @(i) fullfile(sprintf('../Images/TrainingSet/CroppedBuoys/G_%03d.jpg',i));


k=1;
while hasFrame(video)
    img=readFrame(video);
    if k>25 && k <= 30
        imshow(img);
        hold on;
        imwrite(img,Training_frames(k));
        title(sprintf('red-%d',k));
        mask = roipoly(img);
        imshow(mask);
        imwrite(mask,Cropped_red(k));
        
        pause;
        title(sprintf('yellow-%d',k));
        mask = roipoly(img);
        imshow(mask);
        imwrite(mask,Cropped_yellow(k));
        pause;
        
        title(sprintf('green-%d',k));
        mask = roipoly(img);
        imshow(mask);
        imwrite(mask,Cropped_green(k));
        pause;
        
    else
        imwrite(img,Test_frames(k-30));
    end
    k = k+1;
end
cd Scripts;
end