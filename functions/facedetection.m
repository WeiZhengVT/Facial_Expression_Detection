function [cc] = facedetection (image)

if(size(image,3) == 1)
    mImage2detect(:,:,1) = image;
    mImage2detect(:,:,2) = image;
    mImage2detect(:,:,3) = image;
else
    mImage2detect = image;
end
detector = buildDetector;
[bbox,bbX,faces,bbfaces] = detectFaceParts(detector,mImage2detect,1);
thr = 40;

newbox = bbox(:, 1: 4)+[-thr -thr 2*thr 2*thr];
cc = imcrop(image,newbox);
cc = imresize(cc, [512,512]);
% figure
% imshow(cc);
% imsave




% function [mFaceResult,mFaceResultrighteye,mFaceResultlefteye,mFaceResultmouth,mFaceResultnose]= face_segment(mImageSrc)
% function [noseposition]= getface(mImageSrc)
%%%%%%%%%%%%%%%%%%%%将灰度图变为三通道图%%%%%%%%%%%%%%%%%%%%
% if(size(mImageSrc,3) == 1)
%     mImage2detect(:,:,1) = mImageSrc;
%     mImage2detect(:,:,2) = mImageSrc;
%     mImage2detect(:,:,3) = mImageSrc;
% else
%     mImage2detect = mImageSrc;
% end
% % 
% %%%%%%%%%%%%%%%%%%%%对图像进行人脸检测%%%%%%%%%%%%%%%%%%%%
% FaceDetector               = buildDetector();
% [bbox,bbimg,faces,bbfaces] = detectFaceParts(FaceDetector,mImage2detect,2);
% 
% %%%%%%%%%%%%%%%%%%%%输入图像灰度化%%%%%%%%%%%%%%%%%%%%
% if 1 ~= size(mImageSrc,3)
%     mImageSrc = rgb2gray(mImageSrc);
%     mImageSrc = double(mImageSrc);
% elseif 1     == size(mImageSrc,3)
%     mImageSrc = double(mImageSrc);
% end
% 
% %%%%%%%%%%%%%%%%%%%%得到人脸区域框的中心点%%%%%%%%%%%%%%%%%%%%
% recFace.x          = bbox(1,1);
% recFace.y          = bbox(1,2);
% recFace.width      = bbox(1,3);
% recFace.height     = bbox(1,4);
% 
% ptFaceCenter.x     = recFace.x + recFace.width / 2;
% ptFaceCenter.y     = recFace.y + recFace.height / 2;
% 
% %%%%%%%%%%%%%%%%%%%%以中心点为基准进行外扩（即对人脸选框进行调整）%%%%%%%%%%%%%%%%%%%%
% recFace.x         = ptFaceCenter.x - recFace.width * 0.4;
% recFace.y         = ptFaceCenter.y - recFace.height * 0.35;
% recFace.width     = recFace.width * 0.8 ;
% recFace.height    = recFace.height * 0.8 ;
% 
% mFaceResult       = uint8(imcrop(mImageSrc,[recFace.x,recFace.y,recFace.width,recFace.height]));





end