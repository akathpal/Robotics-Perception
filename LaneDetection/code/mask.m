function masked_image = mask(image)
    x = [550, 180, 1280, 720];
    y = [450, 720, 720, 450];
    img_mask = poly2mask (x,y,720,1280);
    masked_image = uint8(img_mask).*image;  
    H = fspecial('gaussian', 3, 1);
    masked_image = imfilter(masked_image,H);
end