clc;clear;close all;

%% Input folder
data = @(i) fullfile(sprintf('../input/image.0%d.jpg',i));
video_name = sprintf('../Output/output');

%% Video 
video=VideoWriter(video_name);
video.FrameRate = 30;
open(video);

warning('off');
load('classifier_8x8.mat');
tic;
for i=32640:35500
    frame = imread(data(i));
    img = imgaussfilt(frame,0.2);
    img = imadjust(img,stretchlim(img),[]);
    tempImage=zeros(size(frame,1),size(frame,2),size(frame,3));
    red_bbox={};
    blue_bbox={};
    rc=1;bc=1;
    
    blueRegion = mser_regions(img,"blue");
    
    if size(blueRegion,2)~=0
        bluePatch=crop(frame,blueRegion);  
 
        for x=1:size(bluePatch,1)

            blueFeatures=extractHOGFeatures(im2single(bluePatch{x,1}),'CellSize',[8 8]);
            blueFeatures=reshape(blueFeatures,1,[]);
            [predictedLabels,scoreb]=predict(classifier_8x8, blueFeatures);
            
             k=5;
            for blueLabel={'00035','00038','00045'}
                k=k+1;
               if predictedLabels == blueLabel && (scoreb(k) > -0.08)
                    tempStr=strcat(blueLabel,'.jpg');
                    patchImage=imread(tempStr{1});
                    tempImage=bbox_patch(tempImage, patchImage, blueRegion{x});
                    blue_bbox{bc,1}=blueRegion{x}.BoundingBox;
                    blue_bbox{bc,2}=blueLabel;
                    bc=bc+1;
                    break;
                end
            end
        end
    end
    
    redRegion = mser_regions(img,"red");
    if size(redRegion,2)~=0
        redPatch=crop(frame,redRegion);
        
        for y=1:size(redPatch,1)
            redFeatures=extractHOGFeatures(im2single(redPatch{y,1}),'CellSize',[8 8]);
            redFeatures=reshape(redFeatures,1,[]);
            [predictedLabels,scorec]=predict(classifier_8x8, redFeatures);
            k=0;
            for redLabel={'00001','00014','00017','00019','00021'}
                k=k+1;
                if (predictedLabels == redLabel) && (scorec(k) > -0.04)
                    tempStr=strcat(redLabel,'.jpg');
                    patchImage=imread(tempStr{1});
                    tempImage=bbox_patch(tempImage, patchImage, redRegion{y});
                    red_bbox{rc,1}=redRegion{y}.BoundingBox;
                    red_bbox{rc,2}=redLabel;
                    rc=rc+1;
                    break;
                end
            end
        end     
    end
    
    imageFinal=imadd(frame, uint8(tempImage));
    imshow(imageFinal);hold on;
    for index=1:size(red_bbox,1)
        rectangle('Position',red_bbox{index,1},'EdgeColor','r','linewidth',2);
        text(red_bbox{index,1}(1)-20,...
            red_bbox{index,1}(2)-20,...
            red_bbox{index,2}(1), 'FontSize', 10, 'FontWeight', 'Bold',...
            'Color', 'r');
    end
     for index=1:size(blue_bbox,1)
        rectangle('Position',blue_bbox{index,1},'EdgeColor','b','linewidth',2);
        text(blue_bbox{index,1}(1)-20,...
            blue_bbox{index,1}(2)-20,...
            blue_bbox{index,2}(1), 'FontSize', 10, 'FontWeight', 'Bold',...
            'Color', 'b');
    end
    hold off;
    pause(0.01);
    writeVideo(video,getframe);
end
toc;
  close(video);