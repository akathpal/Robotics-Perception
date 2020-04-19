function img = bbox_patch(img,patch,bbox)

patch=imresize(patch,[bbox.BoundingBox(4)+1 bbox.BoundingBox(3)+1]);

y1 = abs(int32(bbox.BoundingBox(1)-bbox.BoundingBox(3)));
x1 = abs(int32(bbox.BoundingBox(2)));
y2 = abs(int32(bbox.BoundingBox(1)));
x2 = abs(int32(bbox.BoundingBox(2)+bbox.BoundingBox(4)));

if y1-bbox.BoundingBox(3)>0 && x1+bbox.BoundingBox(4)<1236
    
    img(x1:x2, y1:y2,1)= patch(1:size(patch,1), 1:size(patch,2),1);
    img(x1:x2, y1:y2,2)= patch(1:size(patch,1), 1:size(patch,2),2);
    img(x1:x2, y1:y2,3)= patch(1:size(patch,1), 1:size(patch,2),3);
    
else
    
    y1 = abs(int32(bbox.BoundingBox(1)+bbox.BoundingBox(3)));
    x1 = abs(int32(bbox.BoundingBox(2)));
    y2 = abs(int32(bbox.BoundingBox(1)));
    x2 = abs(int32(bbox.BoundingBox(2)+bbox.BoundingBox(4)));

end
end