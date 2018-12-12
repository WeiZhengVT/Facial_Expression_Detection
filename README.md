# Facial_Expression_Detection_V1.0

This program is my group's final project of 'COMPUTER VISION 2018 fall' class in Virginia Tech. Becuase of time, the train dataset is still small. Thus, the SVM classifier have trouble adjusting all personal facial feature's weight to zero and focus on expression feature.So please expand the train dataset in 'train.m' for practical usage.


#Usage#

To start, run ‘Train.m’, then run 'RunThis.m'.

To improve the accuracy, please expand the train dataset in 'train.m'. Than test the result in 'RunThis'.
Remenber change your data.


#Algorithm#

(1) Haar like: Cut out a face in your image, than normalize it.

(2) ASM: Get landmarks' positions on the normalized face. For each landmark, cut out a windows.

(3) LBP: Extract LBP features at each window as image feature.

(4) SVM: Use SVM to trains/classifers your LBP feature.


#For more use#

(1) change your label to classifer differnt person's face (from pressionel labex to person label)


#More details#

https://sites.google.com/view/expressiondetection


#References#

(1) Michael J. Lyons, Shigeru Akemastu, Miyuki Kamachi, Jiro Gyoba. Coding Facial Expressions with Gabor Wavelets, 3rd IEEE International Conference on Automatic Face and Gesture Recognition, pp. 200-205 (1998). 

(2) John W. Miller, Active Shape Models for Face Detection, ADVANCED DIGITAL IMAGE PROCESSING, SPRING 2017. 
# Facial_Expression_Detection
