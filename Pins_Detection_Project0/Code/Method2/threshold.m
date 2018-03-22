function [pins_thresh,c,n] = threshold(pins_rgb,minH,maxH,minS,maxS,minV,maxV)
pins_hsv = rgb2hsv(pins_rgb);
hue = pins_hsv(:,:,1);
sat = pins_hsv(:,:,2);
val = pins_hsv(:,:,3);
se = strel('disk',10);
pins_thresh =  (hue>minH & hue<maxH) & (sat>minS & sat<maxS) & (val>minV & val<maxV);
pins_thresh = imclose(pins_thresh,se);
[label,n] = bwlabel(pins_thresh);
c  = regionprops(pins_thresh,'centroid');
end

