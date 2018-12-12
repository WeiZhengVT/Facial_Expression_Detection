clear;close all;
cd functions;
train_path='jaffe';
addpath(genpath(train_path));
tiffFiles = dir('jaffe/*.tiff'); 

%% prepare
numfiles = length(tiffFiles);
mydata = cell(1, numfiles);
inx=zeros(1, numfiles);

for i=1:(numfiles)
    if ~isempty(strfind(tiffFiles(i).name,'AN'))
        inx(i)=1;
    elseif ~isempty(strfind(tiffFiles(i).name,'DI'))
        inx(i)=2;
    elseif ~isempty(strfind(tiffFiles(i).name,'FE'))
        inx(i)=3;
    elseif ~isempty(strfind(tiffFiles(i).name,'HA'))
        inx(i)=4;
    elseif ~isempty(strfind(tiffFiles(i).name,'NE'))
        inx(i)=5;
    elseif ~isempty(strfind(tiffFiles(i).name,'SA'))
        inx(i)=6;
    elseif ~isempty(strfind(tiffFiles(i).name,'SU'))
        inx(i)=7;     
    end        
end

numtest = 1;
numtrain = 1;
for i = 1:length(inx)-1
    if inx(i+1)-inx(i) ~= 0
        TesttiffFiles(numtest) = tiffFiles(i);
        test_gs(numtest) = inx(i);
        numtest = numtest+1;
    else
        TraintiffFiles(numtrain) = tiffFiles(i);
        train_gs(numtrain,:) = inx(i);
        numtrain = numtrain+1;
    end
end
TesttiffFiles(numtest) = tiffFiles(end);
test_gs(numtest) = inx(end);
testNum = numtest;
trainNum = numtrain-1;
train_gs = train_gs';
test_gs = test_gs';

[shapeModel,grayModel]=start_asm();

for i = 1:trainNum 
  temp = facedetection(imread(TraintiffFiles(i).name)); 
noseposition=getface(temp);
PT=Example_FindFace(temp,noseposition./size(temp),shapeModel,grayModel);
PT=PT(16:end,:);
PTall{1,i}=PT;
width=20;
height=20;
 for j=1:length(PT)
    eachfeatureim= uint8(imcrop(temp,[PT(j,1)-width/2,PT(j,2)-height/2,width,height]));
     train{i,j} = eachfeatureim;
 end
end


for i = 1:trainNum 
  temp = facedetection(imread(TraintiffFiles(i).name)); 
PT=PTall{1,i};
width=40;
height=40;
 for j=1:length(PT)
    eachfeatureim= uint8(imcrop(temp,[PT(j,1)-width/2,PT(j,2)-height/2,width,height]));
     train{i,j} = eachfeatureim;
 end
end


featureTrain=zeros(trainNum,383*length(PT));
for i=1:trainNum
tempfea=[];
for j=1:length(PT)
temp=extractLBPFeatures(train{i,j},'NumNeighbors',20, 'Radius',3);
    tempfea=[tempfea,temp];
end
 featureTrain(i,:)=tempfea;
end

expression = 7;
for i = 1:expression
    cateoselected = train_gs(1,1:trainNum) == i;
    svm = fitcsvm(featureTrain, cateoselected','ClassNames',...
    [false true],'Standardize',true,'KernelFunction','linear');
    svmall{i} = svm;
end
save('svm','svmall');    
