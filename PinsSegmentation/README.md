# Pins Segmentation

## Goal
To segment out the objects, count the number of pins of the same color, i.e., green, blue, yellow, red and also count the transparent pins.

## Approach

Two possible approaches are used to accomplish the goal. These are described below -

### Method 1

1) Use canny filter first and then use region props to find centroids of all the objects.
2) Use impixel to found the pixel value at those locations
3) Use those pixel values to distinguish between them and create bounding boxes on every object according to color.
4) Finally All the object counts were printed and image with bounding boxes is displayed. For transparent one, Blackbox is used.

### Method 2

1) Use hue, saturation and value thresholds for detecting colored objects.
2) Create a low pass guassian filter with sigma 0.5 and 3x3 kernel. See low\_pass_filter.m 
3) Used thresholds for rgb to segregate the colors.
4) For white and transparent canny edge detector is used with threshold set to 0.2. Then imclose is used to make regions from
these objects. I used bwarea open removing small unwanted regions. Then for getting only white and transparent object I 
subtracted the image from what I obtained in 3rd step.

## Run 

Method 1 gave better output.
```
cd Code/Method1
matlab hw0_main.m
```

## Output

No. of objects are = 13
No. of red objects are = 2
No. of green objects are = 4
No. of blue objects are = 2
No. of yellow objects are = 3
No. of white objects are = 1
No. of transparent objects are = 1

![Output](/Output/FinalOutput.jpg)

## References
Matlab Help Documentation
