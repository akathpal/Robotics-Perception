function bbox = mser_regions(img,str)

R = im2double(img(:,:,1));
G = im2double(img(:,:,2));
B = im2double(img(:,:,3));

%Danger and Prohibitory Signals
if str == "red"
red_norm = max(min(R-B,R-G),0);
[~, mserConnComp] = detectMSERFeatures(red_norm, ... 
    'RegionAreaRange',[500 4000],'ThresholdDelta',3);
s = regionprops(mserConnComp, 'BoundingBox');
bbox = cell(1,0);
j = 1;
a = 1;
b = 1; 
for k = 1:length(s)
    temp = s(k).BoundingBox;
    aspectRatio = temp(3)/temp(4);
    if temp(3) > 20 && temp(4) > 20 && aspectRatio < 1.3 && aspectRatio > 0.8
       if (temp(1)-a)>20 && (temp(2)-b)>20
        a = temp(1); b = temp(2);
        bbox{j} = s(k); j = j+1;
       end
    end
end

end

%Mandatory Signals
if str == "blue"
blue_norm = max(0,min(B-R,B-G));

[~, mserConnComp] = detectMSERFeatures(blue_norm, ... 
    'RegionAreaRange',[400 5000],'ThresholdDelta',2);
s = regionprops(mserConnComp, 'BoundingBox');
bbox = cell(1,0);
j = 1;
a = 1;
b = 1; 

for k = 1:length(s)
    temp = s(k).BoundingBox;
    aspectRatio = temp(3)/temp(4);
    if temp(3) > 10 && temp(4) > 10 && aspectRatio < 1.5 && aspectRatio > 0.5
       if (temp(1)-a)>20 && (temp(2)-b)>20
        a = temp(1); b = temp(2);
        bbox{j} = s(k); j = j+1;
       end
    end
end
end

% figure(1); imshow(img); hold on;
% plot(mserRegions,'showPixelList',true,'showEllipses',false);


end

