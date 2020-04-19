function threshold_img = combined_threshold(masked_image)
    
    gray_frame = rgb2gray(masked_image);
    edges = edge(gray_frame,'Sobel',0.03,'vertical');
    edges = imclose(edges,strel('disk',8));
    %edges = imopen(edges,strel('disk',2));
    %figure(1);imshow(opened_edges);
    masked_image = uint8(edges).*masked_image;
    
    hsv_frame = rgb2hsv(masked_image);
    
    hue = hsv_frame(:,:,1);
    val = hsv_frame(:,:,3);
    hsv_frame = hue<0.2 & val>0.7;
    hsv_frame = imdilate(hsv_frame,strel('disk',3));
 
    threshold_img = hsv_frame;  
end