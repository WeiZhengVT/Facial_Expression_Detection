% function [mFaceResult,mFaceResultrighteye,mFaceResultlefteye,mFaceResultmouth,mFaceResultnose]= face_segment(mImageSrc)
function [noseposition]= getface(mImageSrc)
%%%%%%%%%%%%%%%%%%%%three channel%%%%%%%%%%%%%%%%%%%%
if(size(mImageSrc,3) == 1)
    mImage2detect(:,:,1) = mImageSrc;
    mImage2detect(:,:,2) = mImageSrc;
    mImage2detect(:,:,3) = mImageSrc;
else
    mImage2detect = mImageSrc;
end

%%%%%%%%%%%%%%%%%%%%face detect%%%%%%%%%%%%%%%%%%%%
FaceDetector               = buildDetector();
[bbox,bbimg,faces,bbfaces] = detectFaceParts(FaceDetector,mImage2detect,2);


if 1 ~= size(mImageSrc,3)
    mImageSrc = rgb2gray(mImageSrc);
    mImageSrc = double(mImageSrc);
elseif 1     == size(mImageSrc,3)
    mImageSrc = double(mImageSrc);
end

recFace.x          = bbox(1,1);
recFace.y          = bbox(1,2);
recFace.width      = bbox(1,3);
recFace.height     = bbox(1,4);

ptFaceCenter.x     = recFace.x + recFace.width / 2;
ptFaceCenter.y     = recFace.y + recFace.height / 2;


recFace.x         = ptFaceCenter.x - recFace.width * 0.4;
recFace.y         = ptFaceCenter.y - recFace.height * 0.35;
recFace.width     = recFace.width * 0.8 ;
recFace.height    = recFace.height * 0.8 ;

mFaceResult       = uint8(imcrop(mImageSrc,[recFace.x,recFace.y,recFace.width,recFace.height]));


Lefteye.x          = bbox(1,5);
Lefteye.y          = bbox(1,6);
Lefteye.width      = bbox(1,7);
Lefteye.height     = bbox(1,8);

% ptFaceCenter.x     = Lefteye.x + Lefteye.width / 2;
% ptFaceCenter.y     = Lefteye.y + Lefteye.height / 2;
% 

% Lefteye.x         = ptFaceCenter.x - Lefteye.width * 0.4;
% Lefteye.y         = ptFaceCenter.y - Lefteye.height * 0.35;
% Lefteye.width     = Lefteye.width * 0.8 ;
% Lefteye.height    = Lefteye.height * 0.8 ;

mFaceResultrighteye       = uint8(imcrop(mImageSrc,[Lefteye.x,Lefteye.y,Lefteye.width,Lefteye.height]));

Righteye.x          = bbox(1,9);
Righteye.y          = bbox(1,10);
Righteye.width      = bbox(1,11);
Righteye.height     = bbox(1,12);
mFaceResultlefteye       = uint8(imcrop(mImageSrc,[Righteye.x,Righteye.y,Righteye.width,Righteye.height]));



Nose.x          = bbox(1,13);
Nose.y          = bbox(1,14);
Nose.width      = bbox(1,15);
Nose.height     = bbox(1,16);
mFaceResultmouth       = uint8(imcrop(mImageSrc,[Nose.x,Nose.y,Nose.width,Nose.height]));


Nose.x          = bbox(1,17);
Nose.y          = bbox(1,18);
Nose.width      = bbox(1,19);
Nose.height     = bbox(1,20);
mFaceResultnose       = uint8(imcrop(mImageSrc,[Nose.x,Nose.y,Nose.width,Nose.height]));

noseposition=[Nose.x+Nose.width/2,Nose.y+Nose.height/2];


end
