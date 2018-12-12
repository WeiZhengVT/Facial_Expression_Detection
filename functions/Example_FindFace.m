function PT=Example_FindFace(im,nose_pt,shapeModel,grayModel)
intrest_pt=findFace(im,shapeModel,grayModel,'visualize',1,'facefinder','click','layout','muct',nose_pt);
PT=[intrest_pt(1:2:end) intrest_pt(2:2:end)];
%close all;
end