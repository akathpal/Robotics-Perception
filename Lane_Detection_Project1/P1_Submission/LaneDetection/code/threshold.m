function threshold_img = threshold(masked_image)
    
    hsv_frame = rgb2hsv(masked_image);
    hue = hsv_frame(:,:,1);
    sat = hsv_frame(:,:,2);
    val = hsv_frame(:,:,3);
    hsv_frame_yellow=(hue<0.2 & sat>0.4 & val>0.6);
    hsv_frame_white =(hue< 0.2 & val>0.7 & sat<0.1);
    hsv_frame = hsv_frame_yellow | hsv_frame_white;
    hsv_frame = imdilate(hsv_frame,strel('disk',2));
  
    threshold_img = hsv_frame;
   
end