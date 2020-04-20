import glob
import cv2

dataPath = "../Data/img/*.jpg"
groundTruthData = "../Data/groundtruth_rect.txt"

topLeftPt=[]
bottomRightPt=[]

with open(groundTruthData) as f:
	for line in f:
		bbData = [int(var) for var in line.split()]
		# bbData format is given as [x,y,w,h]
		topLeftPt.append((bbData[0],bbData[1]))
		bottomRightPt.append((bbData[0]+bbData[2],bbData[1]+bbData[3]))




i=0
for imgPath in sorted(glob.glob(dataPath)):
	inputImg = cv2.imread(imgPath)
	cv2.imshow('Input',inputImg)
	
	color = (255,0,0)
	thickness = 2
	groundTruthImg = inputImg.copy()
	cv2.rectangle(groundTruthImg,topLeftPt[i],bottomRightPt[i],color,thickness)
	cv2.imshow('Ground Truth',groundTruthImg)
	cv2.waitKey(10)
	i=i+1