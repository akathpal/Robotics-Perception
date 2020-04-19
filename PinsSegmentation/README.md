ENPM673 - Perception for Autonomous Robots
ASSIGNMENT 0
NAME: ABHISHEK KATHPAL
TASK: To detect objects on a white background

RUNNING CODE:
For my final code - Run hw0_main.m file in Codes->Method1 folder.


SOLUTION:
1) INITIAL APPROACH METHOD 2:
This is my initial approach when i used hue, saturation and value thresholds for detecting colored objects.
Steps:
1)Fist I create a low pass guassian filter withsigma 0.5 and 3x3 kernel. The code for that is in low_pass_filter.m file
2)I used thresholds for rgb to segregate the colors.
3)For white and transparent I used canny edge detector with threshold set to 0.2. Then I used imclose to make regions from
these objects. I used bwarea open removing small unwanted regions. Then for getting only white and transparent object I 
subtracted the image from what I obtained in 2nd step.

2) FINAL APPROACH METHOD 1:
Files Needed : hw0_main and low_pass_filter.m
As I am unable to distinguish between white and transparent and i dont want to do thresholding as suggested.
I tried a little different approach.
Steps:
1)I used canny filter first and then use region props to find centroids of all the objects.
2)using impixel i found the pixel value at those locations
3)Using those pixel values, i try to distinguish between them and create bounding boxes on every object according to color.
4)Finally All the object counts were printed and image with bounding boxes is displayed. For transparent one, Blackbox is used.

OUTPUT:
No. of objects are = 13
No. of red objects are = 2
No. of green objects are = 4
No. of blue objects are = 2
No. of yellow objects are = 3
No. of white objects are = 1
No. of transparent objects are = 1

REFERENCES:
Matlab Help Documentation