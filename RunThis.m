clear;
clc;
close;
cd functions;
load svm.mat;
choice = 1; %choice = 1, use our test dataset
                   %choice = 2, use single img to test
if choice == 2
    imgname = 'shenme.tiff'; %input the img name
    img = imread(imgname);
    img = facedetection(img);
end
expression = 7;

%% test our test dataset
if choice ==1
    train_path = 'jaffe' ;
    addpath(genpath(train_path));
    tiffFiles = dir('jaffe/*.tiff'); 
    % get test dataset img
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
    %get test dataset features
    [shapeModel,grayModel]=start_asm();
    for i = 1:testNum 
        temp = facedetection(imread(TesttiffFiles(i).name)); 
        noseposition=getface(temp);
        PT=Example_FindFace(temp,noseposition./size(temp),shapeModel,grayModel);
        PT=PT(16:end,:);
        PTall{1,i}=PT;
        width=20;
        height=20;
        for j=1:length(PT)
            eachfeatureim= uint8(imcrop(temp,[PT(j,1)-width/2,PT(j,2)-height/2,width,height]));
            test{i,j} = eachfeatureim;
        end
    end
    for i = 1:testNum 
        temp = facedetection(imread(TesttiffFiles(i).name)); 
        PT=PTall{1,i};
        width=40;
        height=40;
        for j=1:length(PT)
            eachfeatureim= uint8(imcrop(temp,[PT(j,1)-width/2,PT(j,2)-height/2,width,height]));
            test{i,j} = eachfeatureim;
        end
    end
    featureTest=zeros(testNum,383*length(PT));
    for i=1:testNum
        tempfea=[];
        for j=1:length(PT)
            temp=extractLBPFeatures(test{i,j},'NumNeighbors',20, 'Radius',3);
            tempfea=[tempfea,temp];
        end
        featureTest(i,:)=tempfea;
    end
    %pass test img features to the svm
    for i = 1:expression
        [~, scoreEachTest] = predict(svmall{i}, featureTest);
        scoreTest(i,:) = scoreEachTest(:,2)';
    end
    [~, testcl] = max(scoreTest);
    accuracy = numel(find(testcl==test_gs(1,1:testNum)))/testNum;
    confusion = confusionmat(testcl,test_gs(1,1:testNum));
    % 
    for gp_num=1:7
        indx=find(test_gs==gp_num);
        pre(gp_num)=length(find(testcl(indx)==test_gs(indx)))/length(indx);
    end
    mAP=mean(pre);
    display(accuracy);
    display(confusion);
    display(mAP);
end
%% test single img
if choice == 2
    % get the img features
    [shapeModel,grayModel]=start_asm();
    temp = img;
    noseposition=getface(temp);
    PT=Example_FindFace(temp,noseposition./size(temp),shapeModel,grayModel);
    width=40;
    height=40;
    PT = PT(16:end,:);
     for j=1:length(PT)
        eachfeatureim= uint8(imcrop(temp,[PT(j,1)-width/2,PT(j,2)-height/2,width,height]));
         test{j} = eachfeatureim;
     end
    tempfea=[];
    for j=1:length(PT)
        temp=extractLBPFeatures(test{j},'NumNeighbors',20, 'Radius',3);
        tempfea=[tempfea,temp];
    end
     feature_single_img =tempfea;
 % pass img to the svm
     for i =1:expression
         [~, scoreEachTest] = predict(svmall{i},feature_single_img);
         scoreTest(i,:) = scoreEachTest(:,2)';
     end
     [~, testcl] = max(scoreTest);
     if testcl == 1
         display('The facial expression is angry');
     elseif testcl == 2
         display('The facial expression is disgusting');
     elseif testcl == 3
         display('The facial expression is fear');
     elseif testcl == 4
         display('The facial expression is happy');
     elseif testcl == 5
         display('The facial expression is neutral');
     elseif testcl == 6
         display('The facial expression is sad');
     elseif testcl == 7
         display('The facial expression is surprise');
     end
end
